public class getObjectRecords {

    @AuraEnabled
    public static List<Account> getAccounts(String accName, Integer pageNumber, Integer pageSize){
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            List<Account> accList = [SELECT Id,Name, Industry 
                                        FROM Account 
                                        WHERE Name 
                                        LIKE :('%' + accName + '%')
                                        LIMIT :pageSize
                                        OFFSET :offset];
            return accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static integer getAccountsCount(string accName){
        try {
            return [SELECT COUNT() FROM Account WHERE Name LIKE :('%' + accName + '%')];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // @AuraEnabled(cacheable=true)
    // public static List<Account> getAccounts(string accName) {
    //     try {
    //         List<Account> accList = [SELECT Id, Name, Industry FROM Account WHERE Name LIKE :('%' + accName + '%')];
    //         system.debug('List of accounts' + accList.size());
    //         return accList;
    //     } catch (Exception e) {
    //         throw new AuraHandledException(e.getMessage());
    //     }
    // }
}