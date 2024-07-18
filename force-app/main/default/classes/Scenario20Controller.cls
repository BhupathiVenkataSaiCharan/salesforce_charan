public class Scenario20Controller {
    
    @AuraEnabled(cacheable=true)
    public static Account getAccountRecord(String accId){
        return [
            SELECT Id,Name,Industry 
            FROM Account WHERE Id = :accId
            LIMIT 1
            ];
    }
}