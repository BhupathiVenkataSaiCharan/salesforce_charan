@isTest
public class webServiceControllerTest {
    // Helper method to create a test user
    private static User createTestUser(String userName, Boolean isActive) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testUser = new User(
            Username = userName,
            Email = 'testuser@testorg.com',
            LastName = 'Test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US',
            isActive = isActive
        );
        insert testUser;
        return testUser;
    }

    @isTest
    static void testDeactivateUserSuccess() {
        // Create a test user
        User testUser = createTestUser('testuser@testorg.com', true);
        
        // Set up the mock request
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/deactivateUser';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"userName":"testuser@testorg.com"}');
        RestContext.request = req;
        
        // Set up the mock response
        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the web service
        webServiceController.doPost();

        // Verify the response
        System.assertEquals(200, res.statusCode);
        String responseBody = res.responseBody.toString();
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.assertEquals(true, jsonResponse.get('status'));
        System.assertEquals('User deactivated successfully.', jsonResponse.get('message'));
        System.assertEquals(testUser.Id, jsonResponse.get('ID'));
        
        // Verify the user is deactivated
        User deactivatedUser = [SELECT isActive FROM User WHERE Id = :testUser.Id];
        System.assertEquals(false, deactivatedUser.isActive);
    }

    @isTest
    static void testDeactivateUserInvalidInput() {
        // Set up the mock request with empty userName
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/deactivateUser';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"userName":""}');
        RestContext.request = req;

        // Set up the mock response
        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the web service
        webServiceController.doPost();

        // Verify the response
        System.assertEquals(400, res.statusCode);
        String responseBody = res.responseBody.toString();
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.assertEquals(false, jsonResponse.get('status'));
        System.assertEquals('Invalid input: Email is required.', jsonResponse.get('ERROR'));
    }

    @isTest
    static void testDeactivateUserNotFound() {
        // Set up the mock request with non-existent user
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/deactivateUser';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"userName":"nonexistent@testorg.com"}');
        RestContext.request = req;

        // Set up the mock response
        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Call the web service
        webServiceController.doPost();

        // Verify the response
        System.assertEquals(404, res.statusCode);
        String responseBody = res.responseBody.toString();
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        System.assertEquals(false, jsonResponse.get('status'));
        System.assertEquals('User not found.', jsonResponse.get('ERROR'));
    }

    @isTest
    static void testDeactivateUserExceptionHandling() {
        // Create a test user
        User testUser = createTestUser('testuser2@testorg.com', true);
        
        // Set up the mock request with valid user
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/deactivateUser';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"userName":"testuser2@testorg.com"}');
        RestContext.request = req;

        // Set up the mock response
        RestResponse res = new RestResponse();
        RestContext.response = res;

        // Create a mock exception by manipulating the user record
        Test.startTest();
        try {
            // Simulate an exception
            User mockUser = [SELECT Id FROM User WHERE Username = 'testuser2@testorg.com'];
            mockUser.UserName = null; // This will cause an exception on update
            update mockUser;
        } catch (Exception e) {
            // Call the web service in the catch block to ensure exception is thrown
            webServiceController.doPost();
            
            // Verify the response
            System.assertEquals(500, res.statusCode);
            String responseBody = res.responseBody.toString();
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            System.assertEquals(false, jsonResponse.get('status'));
            // System.assert(jsonResponse.get('ERROR').contains('Error deactivating user:'));
        }
        Test.stopTest();
    }
}
