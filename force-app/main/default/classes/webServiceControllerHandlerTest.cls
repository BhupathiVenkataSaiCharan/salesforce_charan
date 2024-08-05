@isTest
public class webServiceControllerHandlerTest {
    private static RestRequest createMockRequestForDeactivateUser(String userName){
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('userName', userName);

        String jsonString = JSON.serialize(requestBody);
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(jsonString);
        return req;
    }

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
    static void testDeactivateUserSuccess(){
        User u = createTestUser('aman@test.in',true);
        Test.startTest();
        Map<String, Object> response = webServiceControllerHandler.deactivateUser(createMockRequestForDeactivateUser(u.UserName));
        Test.stopTest();

        Assert.areEqual(true,(Boolean)response.get('STATUS'));
    }
    @isTest
    static void testDeactivateUserNoUserNameProvided(){
        User u = createTestUser('aman@test.in',true);
        Test.startTest();
        Map<String, Object> response = webServiceControllerHandler.deactivateUser(createMockRequestForDeactivateUser(''));
        Test.stopTest();

        Assert.areEqual(false,(Boolean)response.get('STATUS'));
    }
    @isTest
    static void testDeactivateUserAlreadyDeactivated(){
        User u = createTestUser('aman@test.in',false);
        Test.startTest();
        Map<String, Object> response = webServiceControllerHandler.deactivateUser(createMockRequestForDeactivateUser(u.UserName));
        Test.stopTest();

        Assert.areEqual(false,(Boolean)response.get('STATUS'));
    }
}