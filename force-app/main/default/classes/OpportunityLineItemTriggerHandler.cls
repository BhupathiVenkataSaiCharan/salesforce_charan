public class OpportunityLineItemTriggerHandler {
    public static void updateOLICountOnAccount(List<OpportunityLineItem> newList){

        Set<Id> oppIds = new Set<Id>();

        for(OpportunityLineItem oli : newList){
            oppIds.add(oli.OpportunityId);
        }

        if(!oppIds.isEmpty()){
            List<Opportunity> opportunities = [SELECT Id,AccountId, (SELECT Id, ListPrice FROM OpportunityLineItems WHERE ListPrice > 50000) FROM Opportunity WHERE Id IN :oppIds AND AccountId != null];
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


    //Update the account with the count of opportunity line items whose listprice is greater than 50000

    public static void updateOliCntOnAccWithMultipleOpps(List<OpportunityLineItem> oliList){

        Set<Id> oppIds = new Set<Id>();
        for(OpportunityLineItem oli : oliList){
            oppIds.add(oli.OpportunityId);
        }

        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : [SELECT Id,AccountId FROM Opportunity WHERE Id IN :oppIds]){
            accIds.add(opp.AccountId);
        }

        Map<Id, Integer> countMap = new Map<Id, Integer>();
        for(AggregateResult ar : [SELECT COUNT(Id) cnt, Opportunity.AccountId accId FROM OpportunityLineItem WHERE Opportunity.AccountId IN :accIds AND ListPrice > 50000 GROUP BY Opportunity.AccountId]){
            
            Id accountId = (Id)ar.get('accId');
            Integer count = (Integer)ar.get('cnt');

            if(countMap.containsKey(accountId)){
                countMap.put(accountId, countMap.get(accountId)+count);
            }else{
                countMap.put(accountId,count);
            }
        }

        List<Account> accList = new List<Account>();
        for(Id accId : countMap.keySet()){
            Account acc = new Account(
                Id = accId,
                Oli_Count__c = countMap.get(accId)
            );
            accList.add(acc);
        }

        if(!accList.isEmpty()){
            update accList;
        }

    }

}