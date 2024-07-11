/**
* @description: Controller class for the LWC component: CustomLookup
* @author Shubham Matre
* @createddate 22/02/2024
* @testClass: CustomLookupControllerTest
*/
public with sharing class CustomLookupController {

    /**
    * @description: Method fetches the records based on the values in the wrapper
    * @params: SearchWrapper inputWrapper
    * @returns: List<ResultWrapper> returnWrapperList
    */
    @AuraEnabled
    public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {
        try {
            if(inputWrapper != null){
                String fieldsToQuery = 'SELECT Id, ';
                if(string.isNotBlank(inputWrapper.fieldApiName)){
                    fieldsToQuery = fieldsToQuery + inputWrapper.fieldApiName;
                }
                if(string.isNotBlank(inputWrapper.otherFieldApiName) && inputWrapper.otherFieldApiName != null){
                    fieldsToQuery = fieldsToQuery + ', ' + inputWrapper.otherFieldApiName;
                }
                String query = fieldsToQuery + ' FROM '+ inputWrapper.objectApiName;
                String searchCriteria = '';
                if(String.isNotBlank(inputWrapper.filterCriteria)){
                    searchCriteria = inputWrapper.filterCriteria + ' AND '+inputWrapper.fieldApiName + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                }
                else{
                    searchCriteria = inputWrapper.fieldApiName + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' LIMIT 10';
                }
                
                if(String.isNotBlank(inputWrapper.selectedRecordId)) {
                    query += ' WHERE Id = \''+ inputWrapper.selectedRecordId + '\'';
                }else if(String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)){
                    query += ' WHERE '+ inputWrapper.parentFieldApiName+ ' = \''+ inputWrapper.parentRecordId + '\'';
                    query += ' AND ' + searchCriteria;
                } 
                else {
                    query += ' WHERE '+ searchCriteria;
                }
                List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
                system.debug('RRR query '+query);
                for(SObject s : Database.query(query)) {
                    ResultWrapper wrap = new ResultWrapper();
                    wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
                    if(string.isNotBlank(inputWrapper.otherFieldApiName) && inputWrapper.otherFieldApiName != null){
                        Object otherFieldValue = s.get(inputWrapper.otherFieldApiName);
                        if (otherFieldValue instanceOf Date) {
                            Date dateValue = (Date) otherFieldValue;
                            wrap.subField = dateValue.format(); 
                        }
                        else if (otherFieldValue instanceOf DateTime) {
                            DateTime dateTimeValue = (DateTime) otherFieldValue;
                            Date dateValue = dateTimeValue.date();
                            wrap.subField = dateValue.format(); 
                        }
                        else{
                            wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
                        }
                        
                    }
                    wrap.id = (String)s.get('id');
                    returnWrapperList.add(wrap);
                }
                return returnWrapperList;
            }
            return null;
        } catch (Exception err) {
            throw new AuraHandledException(err.getMessage());
        }
    }

    /**
    * @description: Wrapper class used to send the output back to LWC.
    */
    public class ResultWrapper{
        @AuraEnabled public String mainField{get;set;}
        @AuraEnabled public String subField{get;set;}
        @AuraEnabled public String id{get;set;}
    }

    /**
    * @description: Wrapper class used to get the input details from LWC.
    */
    public class SearchWrapper {
        @AuraEnabled public String objectApiName{get;set;}
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String otherFieldApiName{get;set;}
        @AuraEnabled public String searchString{get;set;}
        @AuraEnabled public String selectedRecordId{get;set;}
        @AuraEnabled public String parentRecordId{get;set;}
        @AuraEnabled public String parentFieldApiName{get;set;}
        @AuraEnabled public String filterCriteria{get;set;}
    }
}
if(Trigger.isInsert && Trigger.isBefore){
    Set<Id> accountIds = new Set<Id>();
    for(Contact contactRecord: Trigger.new){
        if(contactRecord.AccounTId != null){
            accountIds.add(contactRecord.AccountId);
        }
    }
    if(!accountIds.isEmpty()){
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id,OwnerId FROM Account Where Id IN: accountIds]);
        for(Contact contactRecord : Trigger.new){
            if(contactRecord.AccountId != null){
                contactRecord.OwnerId = accountMap.get(contactRecord.AccountId).OwnerId;
            }
        }
    }
}

if(Trigger.isInsert && Trigger.isAfter){
    Map<Id,Account> accountMap = new Map<Id,Account>();
    for(Contact contactRecord: Trigger.new){
        if(contactRecord.AccountId != null){
            Account accountRecord = new Account(Id = contactRecord.AccountId,Phone=contactRecord.Phone);
            accountMap.put(accountRecord.Id,accountRecord);
        }
    }
    if(!accountMap.isEmpty()){
        update accountMap.values();
    }
}
if(Trigger.isUdpate && Trigger.isAfter){
    Map<Id,Account> accountMap = new Map<Id,Account>();
    for(Contact conRecord : Trigger.new){
        if(conRecord.AccountId != null && conRecord.Phone != Trigger.oldMap.get(conRecord.Id).Phone){
            Account accountRecord = new Account(Id=conRecord.AccountId,Phone = conRecord.Phone);
            accountMap.put(accountRecord.Id,accountRecord);
        }
    }
    if(!accountMap.isEmpty()){
        update accountMap.values();
    }
}

if(Trigger.isInsert && Trigger.isAfter){
    Set<Id> opportunityIds = new Set<Id>();
    for(OpportunityLineItem oppLineItem :Trigger.new){
        if(oppLineItem.OpportunityId != null){
            opportunityIds.add(oppLineItem.OpportunityId);
        }
    }
    if(!opportunityIds.isEmpty()){
        Map<Id,Account> accountMap = new Map<Id,Account>();
        List<Opportunity> opportunityList = [SELECT Id,AccountId,(SELECT Id FROM OpportunityLineItems)
                                             FROM Opportunity WHERE Id IN:opportunityIds ];
        for(Opportunity opportunityRecord : opportunityList){
            if(!accountMap.keySet().contains(opportunityRecord.AccountId)){
                Account accountRecord = new Account(Id = opportunityRecord.AccountId,TotalOpportunityLineItem__c = 0);
                accountMap.put(accountRecord.Id,accountRecord);
            }
            Account accountRecord = accountMap.get(opportunityRecord.AccountId);
            accountRecord.TotalOpportunityLineItem__c += opportunityRecord.OpportunityLineItems.size();
            accountMap.put(accountRecord.Id,accountRecord);
        }
        if(!accountMap.isEmpty()){
            update accountMap.values();
        }
    }
    

}