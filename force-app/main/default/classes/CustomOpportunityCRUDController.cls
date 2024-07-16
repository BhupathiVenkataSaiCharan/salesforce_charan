public class CustomOpportunityCRUDController {
    
    @AuraEnabled(cacheable=true)
    public static List<Custom_Opportunity__c> getRecords(){
        return [
            SELECT id,Name 
            FROM Custom_Opportunity__c
            ORDER BY CreatedDate ASC
            ];
    }
    @AuraEnabled
    public static string deleteRecords(List<String> recordIds){
        try {
            Database.delete(recordIds);
            return 'deleted';
        } catch (Exception e) {
            system.debug('exception' +e);
            return 'error'+e.getMessage();
        }
    }
    @AuraEnabled
    public static string saveRecords(List<Custom_Opportunity__c> records){
        try {
            system.debug('List or upsert:::' +records);
            upsert records;
            return 'recrods saved successfully';
        } catch (Exception e) {
            system.debug('exception' +e);
            return 'error'+e.getMessage();
        }
    }
}