public class compEventClass {
    
    @AuraEnabled
    public static String createAcc(Account A) {
        String result;
        try {
            insert A;
            result = A.Id;
        } catch (Exception e) {
            result = 'Error';
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static List<Account> displayAcc() {
        try {
            return [SELECT Name, Phone, Industry FROM Account ORDER BY Name ASC];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}