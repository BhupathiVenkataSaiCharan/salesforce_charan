public class AddProductController {
    
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getCustomProducts() {
        return [SELECT id,Name FROM Account LIMIT 100 ];
    }
    
   /* @AuraEnabled
    public static void createOpportunityLineItems(String lineItems) {
        List<Opportunity_Line_Items__c> oppLineitemList = (List<Opportunity_Line_Items__c>) JSON.deserialize(lineItems, List<Opportunity_Line_Items__c>.class);
        System.debug('oppLineitemList'+oppLineitemList);
        try {
            insert oppLineitemList;
        } catch (Exception e) {
            System.debug('Error Message:'+e.getStackTraceString());
        }
    }*/
    
    
    /*@AuraEnabled(cacheable=true)
    public static List<Product__c> getCustomProducts() {
        return [SELECT id,Name, Price__c, SKU__c  FROM Product__c LIMIT 100 ];
    }
    
    @AuraEnabled
    public static void createOpportunityLineItems(String lineItems) {
        List<Opportunity_Line_Items__c> oppLineitemList = (List<Opportunity_Line_Items__c>) JSON.deserialize(lineItems, List<Opportunity_Line_Items__c>.class);
        System.debug('oppLineitemList'+oppLineitemList);
        try {
            insert oppLineitemList;
        } catch (Exception e) {
            System.debug('Error Message:'+e.getStackTraceString());
        }
    }*/
}