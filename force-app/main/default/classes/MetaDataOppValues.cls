public class MetaDataOppValues {
    
    @AuraEnabled(cacheable=true)
    public static List<Opp_value__mdt> getMetaData(){
        try {
            List<Opp_value__mdt> mdList = [SELECT Id,MasterLabel,Test_value__c FROM Opp_value__mdt];

            System.debug('MetaData Values ==>' +mdList);
            return mdList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateOppRecords(String oppId, String jsonData){
        try {
            Opportunity opp = [SELECT Id,JSON_Metadata__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
            opp.JSON_MetaData__c = jsonData;
            update opp;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
