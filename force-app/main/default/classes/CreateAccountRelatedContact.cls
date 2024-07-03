/*

*used to create a contact 
*used in createAccountRelatedContact lwc component

*/

public class CreateAccountRelatedContact {
    
    @AuraEnabled
    public static String createContact(String accId, String accFName, String accLName, String accEmail){
        Map<String, Object> auraResult = new Map<String, Object>();
        try {
            Contact Con = new Contact(
                AccountId = accId,
                FirstName = accFName,
                LastName = accLName,
                Email = accEmail
            );
            insert Con;
            auraResult.put('STATUS', true);
            auraResult.put('MESSAGE', 'Contact Created Successfully');
        } catch (DmlException de) {
            auraResult.put('STATUS', false);
            auraResult.put('ERROR', de.getMessage());
            system.debug('error:::' +de);
        } catch (StringException se) {
            auraResult.put('STATUS', false);
            auraResult.put('ERROR', se.getMessage());
            system.debug('error:::' +se);
        }
        return JSON.serialize(auraResult);
    }
}