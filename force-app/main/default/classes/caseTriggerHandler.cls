public class caseTriggerHandler {
    
    //when case origin=email set status = new and priority = medium
    public static void onCaseOrigin(List<Case> csList){
        for(Case cs:csList){
            if(cs.Origin == 'email'){
                cs.Status='new';
                cs.Priority='medium';
            }
        }
    }

    //when a case is created on any account put the latest case number on account in 'latest case number' field
    public static void sendLatestCaseNumber(List<Case> csList){
        List<Account> accList= new List<Account>(); 
        for(Case cs:csList){

            if(cs.AccountId != null){
                system.debug('case number' +cs.CaseNumber);
                Account acc=new Account(Id=cs.AccountId,Latest_Case_Number__c = cs.CaseNumber);
                accList.add(acc);
            }    
        }
        update accList;
    }   
}