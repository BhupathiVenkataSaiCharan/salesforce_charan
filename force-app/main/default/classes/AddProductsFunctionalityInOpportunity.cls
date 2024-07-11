public with sharing class AddProductsFunctionalityInOpportunity {

    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> getProductsRecords() {
        List<ProductWrapper> products = new List<ProductWrapper>();
        Set<Id> productIds = new Set<Id>();

        // Query active Pricebook Entries
        List<PricebookEntry> pricebookEntries = [
            SELECT Product2Id, Product2.Name, Product2.ProductCode, UnitPrice
            FROM PricebookEntry
            WHERE IsActive = true
            ORDER BY Product2.Name ASC
        ];

        // Add unique Product2Id to set
        for (PricebookEntry entry : pricebookEntries) {
            if (!productIds.contains(entry.Product2Id)) {
                products.add(new ProductWrapper(entry.Product2Id, entry.Product2.Name, entry.Product2.ProductCode, entry.UnitPrice));
                productIds.add(entry.Product2Id);
            }
        }

        return products;
    }

    @AuraEnabled
    public static void saveOpportunityProducts(String opportunityId, List<ProductRequest> products) {
        system.debug('Opportunity Id received: ' + opportunityId);
        system.debug('List of products: ' + products);

        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        Map<Id, PricebookEntry> productIdToEntryMap = new Map<Id, PricebookEntry>();

        // Fetch all necessary PricebookEntry records at once for efficient querying
        List<Id> productIds = new List<Id>();
        for (ProductRequest product : products) {
            productIds.add(product.productId);
        }
        List<PricebookEntry> pricebookEntries = [
            SELECT Id, Product2Id, UnitPrice
            FROM PricebookEntry
            WHERE Product2Id IN :productIds AND IsActive = true
        ];
        for (PricebookEntry entry : pricebookEntries) {
            productIdToEntryMap.put(entry.Product2Id, entry);
        }

        // Loop through each product and create Opportunity Line Item
        for (ProductRequest product : products) {
            if (productIdToEntryMap.containsKey(product.productId)) {
                PricebookEntry entry = productIdToEntryMap.get(product.productId);
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityId = opportunityId; // Ensure opportunityId is converted to Id type
                oli.PricebookEntryId = entry.Id;
                oli.Quantity = product.quantity;
                oli.UnitPrice = entry.UnitPrice;
                oliList.add(oli);
            } else {
                // Handle case where PricebookEntry is not found for productId (shouldn't happen in ideal scenarios)
                system.debug('PricebookEntry not found for productId: ' + product.productId);
            }
        }

        if (!oliList.isEmpty()) {
            // Insert all Opportunity Line Items
            insert oliList;
        } else {
            system.debug('No Opportunity Line Items to insert.');
        }
    }

    // Wrapper class for Product information
    public class ProductWrapper {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String ProductCode { get; set; }
        @AuraEnabled public Decimal UnitPrice { get; set; }

        public ProductWrapper(Id id, String name, String productCode, Decimal unitPrice) {
            this.Id = id;
            this.Name = name;
            this.ProductCode = productCode;
            this.UnitPrice = unitPrice;
        }
    }

    // Inner class to handle product requests
    public class ProductRequest {
        @AuraEnabled public Id productId { get; set; }
        @AuraEnabled public Integer quantity { get; set; }

        public ProductRequest(Id productId, Integer quantity) {
            this.productId = productId;
            this.quantity = quantity;
        }
    }
}
