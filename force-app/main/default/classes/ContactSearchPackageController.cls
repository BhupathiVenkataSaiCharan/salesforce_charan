public class ContactSearchPackageController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String contactName){
        try {
            String key = '%' + contactName + '%';
            List<Contact> conList = [SELECT Id, Name, Account.Name FROM Contact WHERE Name LIKE :key];
            System.debug('Contacts List ===> ' +conList);
            return conList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}