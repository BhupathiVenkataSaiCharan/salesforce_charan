@isTest
private class CreateAccountRelatedContactTest {


    static string testData(){
        Account acc = new Account(
            Name = 'Dummy',
            Industry = 'Banking'
        );
        insert acc;
        return acc.Id;
    }

    @isTest
    private static void TestCreateContactValid(){
        String accId = testData(); 
        Test.startTest();
        String newContact = CreateAccountRelatedContact.createContact(accId,'FName','LName','Dummy@email.com');
        Map<String, Object> auraResult =(Map<String, Object>) JSON.deserializeUntyped(newContact);
        Test.stopTest();

        system.debug('valid data ::: ' +auraResult.get('STATUS') );

        Assert.areEqual(true,auraResult.get('STATUS'));
    }
    @isTest
    private static void TestCreateContactRequiredFieldNotProvided(){
        String accId = testData();
        Test.startTest();
        String newContact = CreateAccountRelatedContact.createContact(accId,'FName',null,'Dummy@email.com');
        Map<String, Object> auraResult =(Map<String, Object>) JSON.deserializeUntyped(newContact);
        Test.stopTest();

        system.debug('required field missing ::: ' +auraResult.get('STATUS') );
        
        Assert.areEqual(false,auraResult.get('STATUS'));
    }
    @isTest
    private static void TestCreateContactInvalidAccId(){
        Test.startTest();
        String newContact = CreateAccountRelatedContact.createContact('wertyui','FName','LName','Dummy@email.com');
        Map<String, Object> auraResult =(Map<String, Object>) JSON.deserializeUntyped(newContact);
        Test.stopTest();

        system.debug('invalid accid ::: ' +auraResult.get('STATUS') );

        Assert.areEqual(false,auraResult.get('STATUS'));
    }
}