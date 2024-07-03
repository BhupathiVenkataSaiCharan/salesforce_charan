/**
 * custom path similar to opportuntiy stage path used in customPath lwc component
 */


public class CustomPathController {
        @AuraEnabled(cacheable=true)
        public static List<OpportunityStageWrapper> getOpportunityStages() {
                List<OpportunityStageWrapper> stages = new List<OpportunityStageWrapper>();
                
                system.debug('stages' +stages);
                // Fetch Opportunity StageName picklist values
                Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
                List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
                system.debug('fieldresult' +fieldResult);
                system.debug('picklistValues' +picklistValues);
                
                for (Schema.PicklistEntry picklistValue : picklistValues) {
                    stages.add(new OpportunityStageWrapper(picklistValue.getLabel(), picklistValue.getValue()));
                }
                
                return stages;
            }
        
        public class OpportunityStageWrapper {
            @AuraEnabled public String label { get; set; }
            @AuraEnabled public String value { get; set; }
            
            public OpportunityStageWrapper(String label, String value) {
                this.label = label;
                this.value = value;
            }
        }
}