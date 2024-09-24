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

        Map<Id, Id> idsMap = new Map<Id, Id>();
        for(Opportunity opp : [SELECT Id,AccountId FROM Opportunity WHERE Id IN :oppIds]){
            idsMap.put(opp.Id, opp.AccountId);
        }

        Map<Id, Integer> arCountMap = new Map<Id, Integer>();
        for(AggregateResult ar : [SELECT OpportunityId,COUNT(Id)lineItemsCount FROM OpportunityLineItem WHERE ListPrice > 50000 AND OpportunityId IN :oppIds GROUP BY OpportunityId]){
            arCountMap.put((Id)ar.get('OpportunityId'), (Integer)ar.get('lineItemsCount'));
        }

        Map<Id, Integer> accMap = new Map<Id, Integer>();
        List<Account> accList = new List<Account>();

        for(Id oppId : arCountMap.keySet()){
            Id accountId = idsMap.get(oppId);
            Integer count = arCountMap.get(oppId);

            if(accMap.containsKey(accountId)){
                accMap.put(accountId,accMap.get(accountId)+count);
            }else{
                accMap.put(accountId,count);
            }

            Account acc = new Account(
                Id = accountId,
                OLI_Count__c = accMap.get(accountId)
            );
            accList.add(acc);
        }

        if(!accList.isEmpty()){
            update accList;
        }

    }

}