public class TaskTriggerHandler {
    
    public static void assignCustomField(List<Task> tasks) {
        
        // create set to store contact and lead WhoIds
        Set<Id> contactIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();

        // check the WhoId field and get the prefix of the selected Contact or Lead and add it to the set created
        for(Task tsk : tasks){
            if(tsk.WhoId != null){
                string keyPrefix = String.valueOf(tsk.WhoId).substring(0,3);
                if(Schema.SObjectType.Contact.getKeyPrefix().equals(keyPrefix)){
                    contactIds.add(tsk.WhoId);
                }
                else if(Schema.SObjectType.Lead.getKeyPrefix().equals(keyPrefix)){
                    leadIds.add(tsk.WhoId);
                }
            }
        }

        // Create Maps to store data of Contact and Lead from Query
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        Map<Id, Lead> leadMap = new Map<Id, Lead>();

        // Query and get the Contact Or Lead Id with the WhoId
        if(!contactIds.isEmpty()){
            contactMap = new Map<Id, Contact>([
                SELECT Id, Account.Name FROM Contact WHERE Id IN :contactIds
            ]);
        }
        if(!leadIds.isEmpty()){
            leadMap = new Map<Id, Lead>([
                SELECT Id, Company FROM Lead WHERE Id IN :leadIds
            ]);
        }

        // check the set fo contact and lead and assign the custom text field value with respective data
        for(Task tsk : tasks){
            if(tsk.WhoId != null){
                if(contactMap.containsKey(tsk.WhoId)){
                    tsk.test__c = contactMap.get(tsk.WhoId).Account.Name;
                }else if(leadMap.containskey(tsk.WhoId)){
                    tsk.test__c = leadMap.get(tsk.WhoId).Company;
                }
            }
        }
    }
}