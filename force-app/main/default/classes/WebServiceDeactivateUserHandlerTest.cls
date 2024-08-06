@isTest
public class WebServiceDeactivateUserHandlerTest {
    
    // Helper method to create a mock RestRequest for deactivateUsers
    private static RestRequest createMockRequestForDeactivateUsers(List<String> federationIdentifiers){
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('fedIds', federationIdentifiers);

        String jsonString = JSON.serialize(requestBody);
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(jsonString);
        return req;
    }

    // Helper method to create a test user
    private static User createTestUser(String federationId, Boolean isActive) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User testUser = new User(
            Username = federationId + '@test.org',
            Email = 'testuser@test.org',
            LastName = 'Test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US',
            FederationIdentifier = federationId,
            isActive = isActive
        );
        insert testUser;
        return testUser;
    }

    @isTest
    static void testDeactivateUsersSuccess(){
        // Create active test user
        User u = createTestUser('fedId1', true);

        // Prepare request with valid federation identifier
        RestRequest req = createMockRequestForDeactivateUsers(new List<String>{u.FederationIdentifier});

        Test.startTest();
        // Call the method
        Map<String, Object> response = WebServiceDeactivateUserHandler.deactivateUsers(req);
        Test.stopTest();

        // Assert the expected response
        System.assertEquals(true, response.get('STATUS'));
        System.assertEquals('Users deactivated successfully.', response.get('message'));
        System.assert(response.containsKey('deactivatedUsers'));
    }

    @isTest
    static void testDeactivateUsersNoFedIdProvided(){
        // Prepare request with no federation identifier
        RestRequest req = createMockRequestForDeactivateUsers(new List<String>{});

        Test.startTest();
        // Call the method
        Map<String, Object> response = WebServiceDeactivateUserHandler.deactivateUsers(req);
        Test.stopTest();

        // Assert the expected response
        System.assertEquals(false, response.get('STATUS'));
        System.assertEquals('Invalid Input: Aleast one Federation Identifier is required', response.get('ERROR'));
    }

    @isTest
    static void testDeactivateUsersAlreadyDeactivated(){
        // Create inactive test user
        User u = createTestUser('fedId2', false);

        // Prepare request with valid federation identifier
        RestRequest req = createMockRequestForDeactivateUsers(new List<String>{u.FederationIdentifier});

        Test.startTest();
        // Call the method
        Map<String, Object> response = WebServiceDeactivateUserHandler.deactivateUsers(req);
        Test.stopTest();

        // Assert the expected response
        System.assertEquals(false, response.get('STATUS'));
        System.assertEquals('No users found or all users are already deactivated.', response.get('ERROR'));
    }
}
