public class paginationWithJS {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountRecords(String searchValue){
        try {
            String key = '%' + searchValue + '%';
            List<Account> accList = [SELECT Id,Name,Industry FROM Account WHERE Name LIKE :key];
            system.debug('Account List :::' +accList);
            return accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } 
}