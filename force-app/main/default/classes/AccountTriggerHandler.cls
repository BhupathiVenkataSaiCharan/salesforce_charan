public class AccountTriggerHandler {
    
    //Contact Related Account
    public static void accountRelatedContact(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        for(Account acc : accList){
            Contact con = new Contact(
                LastName = acc.Name + 'Associated Contact',
                AccountId = acc.Id
            );
            conList.add(con);
        }
        insert conList;
    }

    //Dont delete account if Active picklist is YES
    public static void preventDeletionIfActive(List<Account> accList){
        for(Account acc : accList){
            if(acc.Active__c == 'Yes'){
                acc.addError('Cannot Delete Accounts which are Active');
            }
        }
    }

    //update phone in contact when updated in account
    public static void updatePhoneInContact(List<Account> accList){
        
        Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : accList) {
            Account oldMap = (Account)Trigger.oldMap.get(acc.Id);
            if(acc.Phone != oldMap.Phone){
                accMap.put(acc.Id, acc);
            }
        }

        List<Contact> conList = new List<Contact>();
        for(Contact con : [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN :accMap.keySet()]){
            Account acc = accMap.get(con.AccountId);
            con.Phone = acc.Phone;
            conList.add(con);
        }
        if(!conList.isEmpty()){
            update conList;
        }
    }


    // Create contact if checked, opportunity if checked and active is yes when creating account
    public static void CreateAccountRelatedConAndOpp(List<Account> accList){
        
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        for (Account acc : accList) {
            if(acc.Create_Contact__c == true){
                Contact con = new Contact(
                    LastName = acc.Name + 'On Checked Contact',
                    AccountId = acc.Id
                );
                conList.add(con);
            }
            if(acc.Create_Opportunity__c == true && acc.Active__c == 'Yes'){
                Opportunity opp = new Opportunity(
                    Name = acc.Name + 'On Checked Opportunity',
                    StageName = 'Prospecting',
                    CloseDate = Date.today(),
                    AccountId = acc.Id
                );
                oppList.add(opp);
            }
        }
        if(!conList.isEmpty()){
            insert conList;
        }
        if(!oppList.isEmpty()){
            insert oppList;
        }
    }


    //prevent account editing if created 7 days ago
    public static void preventAccountEditIfCreated7DaysAgo(List<Account> accList){
        
        Set<Id> accIds = new Set<Id>();
        for(Account acc : [SELECT Id FROM Account WHERE CreatedDate < LAST_N_DAYS : 7]){
            accIds.add(acc.Id);
        }
        for(Account acc : accList){
            if(accIds.contains(acc.Id)){
                acc.addError('Accounts Created before 7 Days cannot be edited');
            }
        }
    }


    //copy billing address to shipping address on creation or updation
    public static void copyAddress(List<Account> accList){
        for (Account acc : accList) {
            if(acc.BillingStreet != null || acc.BillingCity != null || acc.BillingPostalCode != null 
                || acc.BillingState != null || acc.BillingCountry != null){
                    acc.ShippingStreet = acc.BillingStreet;
                    acc.ShippingCity = acc.BillingCity;
                    acc.ShippingPostalCode = acc.BillingPostalCode;
                    acc.ShippingState = acc.BillingState;
                    acc.ShippingCountry = acc.BillingCountry;
                }
        }
    }



 
    //when an account is updated with industry as banking create a contact
    public static void createContactWhenAccountisUpdated(List<Account> accList, Map<Id, Account> oldaccountMap){
        system.debug('createContactWhenAccountisUpdated');
        try{
            List<Contact> conList=new List<Contact>();
            for(Account acc:accList){
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
                    // createContactsWhenAccountisCreated((Integer)acc.NumberofLocations__c,acc);
                }
            }
            upsert conList;
        }catch(Exception e){
            system.debug('error'+e);
        }
        
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

    //populate account description with old and new mobile value
    public static void updateDescription(List<Account> accList){

        for(Account acc : accList){
            Account oldMap = (Account)Trigger.oldMap.get(acc.Id);
            if(acc.Phone != oldMap.Phone){
                acc.Description = 'Phone number is Updated from ' + oldMap.Phone + ' to ' + acc.Phone ;
            }
        }
    }

 
    //if account phone updated, update related contact phone field  (Using newMap directly get the new map instead of comparing old and new value)
    public static void updateRelatedContactPhone(Map<Id,Account> accMap){

        List<Contact> conList = new List<Contact>();
        for(Contact con : [SELECT Id,AccountId FROM Contact WHERE AccountId IN :accMap.keySet()]){
            con.Phone = accMap.get(con.AccountId).Phone;
            conList.add(con);
        }
        if(!conList.isEmpty()){
            update conList;
        }
    }

 
    //update contact mailing address when account billing address is changed
    public static void updateConMailing(Map<Id, Account> accMap){
        
        List<Contact> conList = new List<Contact>();
        for(Contact con : [SELECT Id,AccountId FROM Contact WHERE AccountId IN :accMap.keySet()]){
            con.MailingCity = accMap.get(con.AccountId).BillingCity;
            con.MailingCountry = accMap.get(con.AccountId).BillingCountry;
            con.MailingState = accMap.get(con.AccountId).BillingState;
            con.MailingStreet = accMap.get(con.AccountId).BillingStreet;
            con.MailingPostalCode = accMap.get(con.AccountId).BillingPostalCode;
            conList.add(con);
        }
        if(!conList.isEmpty()){
            update conList;
        }
    }


    //account can be deleted only if user is system admin
    public static void preventAccDelete(List<Account> accList){
        
        Set<Id> adminIds = new Set<Id>();
        for(Profile pr : [SELECT Id FROM Profile WHERE Name = 'System Administrator']){
            adminIds.add(pr.Id);
        }

        for(Account acc : accList){
            if(adminIds.contains(UserInfo.getProfileId())){
                acc.addError('Only Admins has the access to delete account records');
            }
        }
    }


    //prevent account deletion if opps are assoicated
    public static void stopDeleteIfHavingOpps(List<Account> accList){

        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : [SELECT Id,AccountId FROM Opportunity WHERE AccountId != null]){
            accIds.add(opp.AccountId)
        }

        for(Account acc : accList){
            if(accIds.contains(acc.Id)){
                acc.addError('Account has Opportunities, so cannot be delete');
            }
        }

    }





    //create account related contact and opportunity
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

    public static void ifNumberChanged(List<Account> accList){

        List<Account> accNewList = new List<Account>();
        
        for(Account acc: accList){
            Account oldMap = (Account)Trigger.oldMap.get(acc.Id);
            if(acc.Phone !=null && oldMap.Phone != acc.Phone){
                acc.Description = 'Phone number is Updated';
            }
            accNewList.add(acc);
        }
        update accNewList;
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
    public static void accRating(List<Account> accList){

        for(Account acc:accList){
            if(acc.Industry == 'Banking'){
                acc.Rating = 'Hot';
            }else{
                acc.Rating = 'Warm';
            }
        }
    }

    //check for same accounts if name matching account present add new account as assoictaed account for old acc contacts
    //longer version by aman
    //  public static void associateContactsWithExistingAccount( Map<Id, Account> newAccMap) {
    //     Map<String, String> accMap = new Map<String, String>();
        
    //     for (Account acc : newAccMap.values()) {
    //         accMap.put(acc.Name, acc.Id);
    //     }
        
    //     List<Account> existingAccounts = [SELECT Id, Name FROM Account WHERE Name IN :accMap.keyset() AND Id Not In: newAccMap.keyset()];
    //     Map<String, String> existingAccountsMap = new Map<String, String>();
    //     for (Account existingAccount : existingAccounts) {
    //         String name = existingAccount.Name;
    //         String newAccId = accMap.get(name);
    //         existingAccountsMap.put(newAccId, existingAccount.Id);
    //     }

    //     List<Contact> contactsToUpdate = [SELECT Id, AccountId,Account.Name FROM Contact WHERE AccountId IN :existingAccountsMap.values()];
        
    //     for (Contact con : contactsToUpdate) {
    //         String name = con.Account.Name;
    //         String newAccId = accMap.get(name);
    //         con.AccountId = newAccId;
    //     }
    //     update contactsToUpdate;
    // }
    public static void changeRelatedAccount(List<Account> accList){
        // set<String> accountNames = new set<String>();
            Map<String,Id> accountNameIdMap = new Map<String,Id>();
            for(Account accountRecord: accList){
                // accountNames.add(accountRecord.Name);
                accountNameIdMap.put(accountRecord.Name,accountRecord.Id);
            }
            List<Contact> contactList = [SELECT Id,AccountId,Account.Name FROM Contact WHERE Account.Name IN: accountNameIdMap.keySet()];
            
            for(Contact contactRecord: contactList){
                Id newAccountId = accountNameIdMap.get(contactRecord.Account.Name);
                contactRecord.AccountId = newAccountId;
            }
            update contactList;
    }


    //update contact mailing address when account billing address is changed
    public static void updateConAddrWhenAccAddrUpdated(List<Account> accList) {

        Map<Id, Account> updatedAccData = new Map<Id, Account>();
        for(Account acc : accList){
            Account oldAccData = (Account)Trigger.oldMap.get(acc.Id);
            if(acc.BillingCountry != oldAccData.BillingCountry || acc.BillingCity != oldAccData.BillingCity ||
                acc.BillingStreet != oldAccData.BillingStreet || acc.BillingPostalCode != oldAccData.BillingPostalCode ||
                acc.BillingState != oldAccData.BillingState){
                    updatedAccData.put(acc.Id,acc);
                }
        }

        List<Contact> conList = new List<Contact>();

        for(Contact con : [SELECT Id,AccountId,MailingCountry,MailingCity,MailingState,MailingStreet,MailingPostalCode 
                            FROM Contact WHERE AccountId IN :updatedAccData.keySet()]){
                                  Account acc = updatedAccData.get(con.AccountId);
                                  con.MailingCountry = acc.BillingCountry;
                                  con.MailingCity = acc.BillingCity;
                                  con.MailingState = acc.BillingState;
                                  con.MailingStreet = acc.BillingStreet;
                                  con.MailingPostalCode = acc.BillingPostalCode;
                                  conList.add(con);
                            }
                            update conList;
    }

    //prevent account from deletion if contacts are associated
    public static void preventAccountdeletion(List<Account> accList){
        
        Set<Id> accIds = new Set<Id>();

        for(Contact con : [SELECT Id,AccountId FROM Contact WHERE AccountId != null]){
            accIds.add(con.AccountId);
        }

        for(Account acc : accList){
            if(accIds.contains(acc.Id)){
                acc.addError('Account has related contacts');
            }
        }
    }


    //Create Contacts equal to number of contacts field
    public static void createContacts(List<Account> accList){
        
        List<Contact> conList = new List<Contact>();

        for(Account acc : accList){
            if(acc.Number_of_Contacts__c != null){
                Integer count = (Integer)acc.Number_of_Contacts__c; 
                for(Integer i=0; i<count; i++){
                    Contact con = new Contact(
                        LastName = acc.Name + i,
                        AccountId = acc.Id
                    );
                    conList.add(con);
                }
            }
        }
        insert conList;
    }

    //update contact count if count increased
    public static void updateContacts(List<Account> accList){

        Integer newCount;
        List<Contact> conList = new List<Contact>();
        List<Contact> conDelList = new List<Contact>();

        for(Account acc : accList){
            Account oldCount = (Account)Trigger.oldMap.get(acc.Id);
            Integer oldNumber = (Integer)oldCount.Number_of_Contacts__c == null ? 0 : (Integer)oldCount.Number_of_Contacts__c;
            Integer newNumber = acc.Number_of_Contacts__c == null ? 0 : (Integer)acc.Number_of_Contacts__c;

            if(newNumber != oldNumber && newNumber > oldNumber){
                newCount = (Integer)(newNumber - oldNumber);
                for(Integer i=0;i<newCount;i++){
                    Contact con = new Contact(
                        LastName = acc.Name + i,
                        AccountId = acc.Id
                    );
                    conList.add(con);
                }
            }else if(newNumber != oldNumber && newNumber < oldNumber){
                newCount = (Integer)(oldNumber - newNumber);
                conDelList.addAll([SELECT Id,AccountId FROM Contact WHERE AccountId = :acc.Id ORDER BY CreatedDate DESC LIMIT :newCount]);
                /*for(Contact con : extraCons){
                    conDelList.add(con);
                }*/
            }
        }
        insert conList;
        delete conDelList;
    }

    //populate the sales rep text field with the name of account owner 
    public static void ownerAsSalesRep(List<Account> accList){

        Set<String> ownerIds = new Set<String>();
        for(Account acc : accList){
            ownerIds.add(acc.OwnerId);
        }

        Map<Id, String> ownerNames = new Map<Id, String>();
        for(User u : [SELECT Id,Name FROM User WHERE Id IN :ownerIds]){
            ownerNames.put(u.Id, u.Name);
        }

        for(Account acc : accList){
            if(ownerNames.containsKey(acc.OwnerId)){
                acc.Sales_Rep__c = ownerNames.get(acc.OwnerId);
            }
        }
    }


}