public class getObjectRecords {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer limitSize, Integer offset) {
        try {
            List<Account> accList = [SELECT Id, Name FROM Account LIMIT :limitSize OFFSET :offset];
            system.debug('List of accounts' + accList.size());
            return accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalAccountCount() {
        return [SELECT count() FROM Account];
    }
}
