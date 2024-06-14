public class getObjectRecords {

    @AuraEnabled(cacheable=true)
    public static Integer getAccountsCount(String accName) {
        try {
            if (String.isNotBlank(accName)) {
                return [SELECT COUNT() FROM Account WHERE Name LIKE :('%' + accName + '%')];
            } else {
                return [SELECT COUNT() FROM Account];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String accName, Integer pageNumber, Integer pageSize) {
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            List<Account> accList;
            
            if (String.isNotBlank(accName)) {
                accList = [SELECT Id, Name, Industry FROM Account WHERE Name LIKE :('%' + accName + '%') LIMIT :pageSize OFFSET :offset];
            } else {
                accList = [SELECT Id, Name, Industry FROM Account LIMIT :pageSize OFFSET :offset];
            }
            
            return accList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteRecord(String recordId) {
        try {
            Account acc = [SELECT Id FROM Account WHERE Id = :recordId LIMIT 1];
            delete acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
