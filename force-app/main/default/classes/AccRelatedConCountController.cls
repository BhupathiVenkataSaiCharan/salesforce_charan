public class AccRelatedConCountController {
    
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> conCount(){
        try {
            List<AggregateResult> conList = [SELECT COUNT(Id)cnt, Account.Name, Account.Id AccountId FROM Contact WHERE Account.Name != null GROUP BY Account.Name, Account.Id ORDER BY COUNT(Id) DESC,Account.Name ASC];
            System.debug('BVSC conList ' +conList);
            return conList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}