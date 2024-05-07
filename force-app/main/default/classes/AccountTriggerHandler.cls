public class AccountTriggerHandler {
 
 public static void associateAccountwithContact(List<Account> accRecords){
    try{
        List<Contact> conList=new List<Contact>();
     for(Account acc:accRecords){
         Contact con = new Contact(LastName=acc.Name+'assosiated', AccountId= acc.Id);
         conList.add(con);
     }
     insert conList;
    }catch(DmlException e){
        system.debug('error' +e);
    }
 }
 
 //when an account is updated with industry as banking create a contact
 public static void createContactWhenAccountisUpdated(List<Account> newAccounts, Map<Id, Account> oldaccountMap){
     system.debug('createContactWhenAccountisUpdated');
     try{
         List<Contact> conList=new List<Contact>();
         for(Account acc:newAccounts){
             //get the old value of industry field of current from trriger Old
             String tempIndustaryOldValue = oldaccountMap.get(acc.Id).Industry;
             String tempIndustaryNewValue = acc.Industry;
             
             system.debug('createContactWhenAccountisUpdated: tempIndustaryOldValue ' +tempIndustaryOldValue);
             system.debug('createContactWhenAccountisUpdated: tempIndustaryNewValue ' +tempIndustaryNewValue);
             if(acc.Industry.equals('Banking') && !tempIndustaryOldValue.equals(tempIndustaryNewValue)){
                 Contact con= new Contact(LastName=acc.Name+'banking updated', Phone=acc.Phone);
                 conList.add(con);
             }
         }
         insert conList;
     }catch(Exception e){
         system.debug('error'+e);
     }
     
 }
 //when an account is created with industry as banking create a contact
 public static void createContactWhenAccountisCreated(List<Account> triggerNew){
     try{
         List<Contact> conList=new List<Contact>();
         for(Account acc:triggerNew){
             
             if(acc.Industry.equals('Banking')){
                 Contact con = new Contact(LastName=acc.Name+'banking created', Phone=acc.Phone);
                 conList.add(con);
             }
             if(acc.NumberofLocations__c > 0){
                 createContactsWhenAccountisCreated((Integer)acc.NumberofLocations__c,acc);
             }
         }
         upsert conList;
     }catch(Exception e){
         system.debug('error'+e);
     }
     
 }
 
 //create n number of contacts when account is created
 private static void createContactsWhenAccountisCreated(Integer counter, Account acc){
     List<Contact> conList=new List<Contact>();
     system.debug('counter: '+counter);
     for(Integer i=0 ; i<counter ; i++){
         Contact con=new Contact();
         system.debug('account id'+acc.Id);
         con.AccountId=acc.Id;
         con.LastName=acc.Name + (i+1);
         conList.add(con);
     }
     system.debug('Contacts List: ' +conList);
     insert conList;
 }
 
 //create contact on account delete
 public static void onAccountDelete(List<Account> accList){
     system.debug('delete');
     try{
         List<Contact> conList=new List<Contact>();
         for(Account acc:accList){
            Contact con=new Contact(LastName=acc.Name+'deleted'); 
            conList.add(con);
         }
         insert conList;
     }catch(Exception e){
         system.debug('error'+e);
     }
 }
 
 //when account industry is media poplate rating as hot
 public static void updateIndustryRating(List<Account> accList){
     for(Account acc:accList){
         if(acc.Industry != null && acc.Industry.equals('Media')){
             acc.Rating='Hot';
         }    
     }
 }
 //error delelting record when account rating is hot
 public static void stopDelete(List<Account> accList){
     system.debug('delete if hot');

     List<Profile> adminProfileIDs= [SELECT Name, Id FROM Profile where Name='System Administrator' AND Id=:UserInfo.getProfileId()];

     for(Account acc:accList){
         if (adminProfileIDs.size() != 0) { // current user is not admin
             if(acc.Rating.equals('Hot')){
                 acc.addError('you can not perform this operation, ask your admin for help.');
             } 
         }
     }
 }

 //copy account billing address to shipping address when account created
 public static void copyBillingToShipping(List<Account> accList){
    for(Account acc:accList){
        if(acc.CopyBillingToShippiing__c == true){
            acc.ShippingCountry=acc.BillingCountry;
            acc.ShippingStreet=acc.BillingStreet;
            acc.ShippingCity=acc.BillingCity;
            acc.ShippingState=acc.BillingState;
            acc.ShippingPostalCode=acc.BillingPostalCode;
        }
    }
 }
 public static void createContactOpportunity(List<Account> accList){

    List<Contact> conList=new List<Contact>();
    List<Opportunity> oppList=new List<Opportunity>();

    for(Account acc:accList){

        if(acc.Create_Contact__c == true){
            Contact con=new Contact(LastName=acc.Name,AccountId=acc.Id);
            conList.add(con);
        }
        if(acc.Create_Opportunity__c == true && acc.Active__c == 'yes'){
            Opportunity opp=new opportunity(Name=acc.Name,StageName='Prospecting',CloseDate=Date.today(),AccountId=acc.Id);
            oppList.add(opp);
        }
    }
    insert conList;
    insert oppList;
 }

 //update description if number is changed
 public static void updateDescription(List<Account> accNewList, List<Account> accOldList){

    List<Account> accList = new List<Account>();

    for(Account acc:accNewList){
        
        String newPhone=acc.Phone;
        Integer index=accNewList.indexOf(acc);
        String oldPhone=accOldList.get(index).Phone;

        if(newPhone != oldPhone){
            Account accc=new Account();
            accc.id=acc.id;
            accc.Description='Phone is Updated! Old Phone:'+ oldPhone + 'New Phone:' + newPhone; 
            accList.add(accc);
        }
    }
    update accList;
 }

 //update phone in contact when phone in account updated
 //accList is immutable-cannot be changed after creation
 public static void updatePhone(List<Account> accList){

    Map<String,String> accMap = new Map<String,String>();
    for(Account acc:accList){
        accMap.put(acc.Id,acc.Phone);
    }
    // List<String> accIds = new List<String>(accMap.keyset());
    // relatedContacts is mutable list so it can be changed directly
    List<Contact> relatedContacts =[SELECT id,Phone,AccountId from Contact where AccountId IN :accMap.keyset()];

    // List<Contact> updateConList = new List<Contact>();

    for(Contact con:relatedContacts){
        con.Phone=accMap.get(con.AccountId);
        // updateConList.add(con);
    }
    // update updateConList;
    update relatedContacts;
 }
 //update address of account in contact using map
 public static void updateAddress(){}

 //if active field is changed to yes then update related opps stage to closed lost if stage is not closed won
 public static void updateRelatedOpportunity(List<Account> accList){

    Map<String, String> accMap=new Map<String,String>();
    for(Account acc: accList){
        accMap.put(acc.id,acc.Active__c);
    }
    //use list from updatePhone method above
 }

 //prevent records in account from editing if the record is created 7 days back

 public static void cannotUpdate(List<Account> accList){

    for(Account acc:accList){
        
        if(acc.createdDate.date().daysBetween(Date.today()) <= 7){
            acc.addError('You cannot edit the records craeted 7 days ago');
        }
    }
 }


 //account records should not be deleted if active field value is yes
 public static void cannotDelete(List<Account> accList){
    for(Account acc:accList){
        if(acc.Active__c == 'yes'){
            acc.addError('cannot delete active records');
        }
    }
 }

 //allow only admin to delete the records
 public static void allowDeletion(List<Account> accList){
    Set<Id> loggedUser=new Set<Id>();
    for(Profile prof:[SELECT id FROM Profile WHERE Name='system administrator']){
        loggedUser.add(prof.Id);
    }

    if(!loggedUser.contains(UserInfo.getProfileId())){
        for(Account acc: accList){
            acc.addError('admin cannot delete records');
        }
    }
 }
 //stop admins to delete records
 public static void stopDeletion(List<Account> accList){

    Set<ID> loggedUser = new Set<ID>();
    for(Profile prof:[SELECT id FROM Profile where Name='System Administrator']){
        loggedUser.add(prof.id);
    }
    if(loggedUser.contains(UserInfo.getProfileId())){
        for (Account acc : accList) {
            acc.addError('system admin cannot delete the records');
        }
    }
 }

}