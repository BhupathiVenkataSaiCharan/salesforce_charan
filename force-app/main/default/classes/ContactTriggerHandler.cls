public class ContactTriggerHandler {
    //check for duplicate email on contact - used in before insert and before update
    public static void checkForDuplicate(List<Contact> conList){

        Set<String> emails = new Set<String>();
        
        for(Contact con : [SELECT Id,Email FROM Contact WHERE Email != null]){
            emails.add(con.Email);
        }

        for(Contact con : conList){
            if(emails.contains(con.Email)){
                con.Email.addError('Email is already taken');
            }
        }
    }


    // check number of contacts for account and upadte account picklist to bronze,silver or gold
    public static void updateAccountStatus(List<Contact> conList){
        
        Set<Id> accIds = new Set<Id>();
        for(Contact con : conList){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }

        List<Account> accList = new List<Account>();
        for(AggregateResult aggr : [SELECT AccountId, COUNT(Id) cnt FROM Contact WHERE AccountId IN :accIds GROUP BY AccountId]){
            Integer count = (Integer)aggr.get('cnt');
            String status = 'Gold';

            if(count <= 5){
                status = 'Bronze';
            }
            else if(count > 5 && count <=10){
                status = 'Silver';
            }
            accList.add(new Account(
                Id = (Id)aggr.get('AccountId'),
                Contact_Status__c = status
            ));
        }
        update accList;
    }


    // use custom label if email field is empty in trigger
    public static void ifEmailNull(List<Contact> conList){
        for(Contact con : conList){
            if(con.Email == null){
                con.Email.addError(label.If_Email_Field_is_Empty);
            }
        }
    }
}