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
    public static Map<String, Object> deleteRecord(String recordId) {

        Map<String, Object> result = new Map<String, Object>();
        try {
            Database.DeleteResult dr = Database.delete(recordId);
            System.debug('delete result:' +dr.getErrors());
            if (dr.isSuccess()) {
                result.put('STATUS',true);
                result.put('MESSAGE' ,'ACCOUNT DELETED FOR ID : '+recordId);

                System.debug('Successfully deleted account with ID: ' + dr.getId());
            }
        } catch (StringException se) {
            result.put('STATUS',false);
            result.put('ERROR','INVALID ID');
        } catch (ListException le) {
            result.put('STATUS',false);
            result.put('ERROR','ID IS NULL');
        } catch (Exception e) {
            result.put('STATUS',false);
            result.put('ERROR',e);
        }
        

        return result;
    }
}