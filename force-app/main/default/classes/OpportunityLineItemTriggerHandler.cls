public class OpportunityLineItemTriggerHandler {
    public static void updateOLICountOnAccount(List<OpportunityLineItem> newList){

        Set<Id> oppIds = new Set<Id>();

        for(OpportunityLineItem oli : newList){
            if(oli.OpportunityId !=null){
                oppIds.add(oli.OpportunityId);
            }
        }

        if(!oppIds.isEmpty()){
            List<Opportunity> opportunities = [SELECT Id,AccountId, (SELECT Id, ListPrice FROM OpportunityLineItems WHERE ListPrice > 50000) 
                                                FROM Opportunity WHERE Id IN :oppIds AND AccountId != null];

            
            List<Account> accList = new List<Account>();

            for(Opportunity opp : opportunities){
                Integer oliCount = opp.OpportunityLineItems.size();
                Account acc = new Account(
                    Id = opp.AccountId,
                    OLI_Count__c = oliCount
                );
                accList.add(acc);
            }

            if(!accList.isEmpty()){
                update accList;
            }
            
        }
    }
}