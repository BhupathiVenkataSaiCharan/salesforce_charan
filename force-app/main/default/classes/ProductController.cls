public class ProductController {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityLineItems(Id opportunityId) {
        return [SELECT Id, OpportunityId, Product2.Name, Quantity, TotalPrice, UnitPrice
                FROM OpportunityLineItem 
                WHERE OpportunityId = :opportunityId];
    }
}
