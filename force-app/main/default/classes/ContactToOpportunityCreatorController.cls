public class ContactToOpportunityCreatorController {
    @AuraEnabled(cacheable=true)
    // public static List<Contact> getContacts(String accId){
    public static List<Contact> getContacts(String accId){
        try {
            return [
                SELECT Id,Name,Phone,Email,AccountId
                FROM Contact
                WHERE AccountId = :accId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}