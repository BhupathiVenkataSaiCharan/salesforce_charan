public class GeneratePDFController {
    
    @AuraEnabled
    public static List<Contact> getContactInformation(){
        try {
            String key = '%' + contactId + '%';
            return [
                SELECT Id,Name,Email 
                FROM Contact
                WHERE Id = :key
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}