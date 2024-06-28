/*

*used to create a contact 
*used in createAccountRelatedContact lwc component

*/

public class CreateAccountRelatedContact {
    
    @AuraEnabled
    public static Contact createContact(String accId, String accFName, String accLName, String accEmail){
        try {
            Contact Con = new Contact(
                AccountId = accId,
                FirstName = accFName,
                LastName = accLName,
                Email = accEmail
            );
            insert Con;
            return Con;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}