public class caseTriggerHandler {
    
    //when case origin is email set status as new and priority as medium
    public static void originBasedStatusPriority(List<Case> csList){
        for(Case cs : csList){
            if(cs.Origin == 'Email'){
                cs.Status = 'New';
                cs.Priority = 'Medium';
            }
        }
    }

    //corrected version for populating latest case number on associated account
    public static void latestCaseNumberOnAccount(List<Case> csList){

        Set<Id> accountIds = new Set<Id>();
        for(Case cs : csList){
            if(cs.AccountId != null){
                accountIds.add(cs.AccountId);
            }
        }

        List<Account> accList = new List<Account>();
        for(Id accId : accountIds){
            Case latestCase = [SELECT CaseNumber FROM Case WHERE AccountId = :accId ORDER BY CaseNumber DESC LIMIT 1];

            Account acc = new Account(
                Id = accId,
                Latest_Case_Number__c = latestCase.CaseNumber
            );
            accList.add(acc);
        }
        if(!accList.isEmpty()){
            update accList;
        }
    }
}
