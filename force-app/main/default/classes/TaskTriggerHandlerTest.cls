@isTest
private class TaskTriggerHandlerTest {

    @isTest
    static void testAssignCustomField() {
        // Create test records and insert them
        // Create Account
        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;

        // Create Contacts and Leads
        Contact con1 = new Contact(
            LastName = 'Contact One',
            AccountId = acc.Id
        );
        insert con1;

        Lead lead1 = new Lead(
            LastName = 'Lead One',
            Company = 'Test Company'
        );
        insert lead1;

        // Create Tasks with the Contact and Lead as WhoId
        Task task1 = new Task(
            Subject = 'Follow-up with Contact',
            WhoId = con1.Id,
            Status = 'Not Started',
            Priority = 'Normal'
        );

        Task task2 = new Task(
            Subject = 'Follow-up with Lead',
            WhoId = lead1.Id,
            Status = 'Not Started',
            Priority = 'Normal'
        );

        insert new List<Task>{task1, task2};

        // Call the method to be tested
        Test.startTest();
        TaskTriggerHandler.assignCustomField(new List<Task>{task1, task2});
        Test.stopTest();

        // Query Tasks to verify the custom field is populated correctly
        Task insertedTask1 = [SELECT Id, test__c FROM Task WHERE Id = :task1.Id];
        Task insertedTask2 = [SELECT Id, test__c FROM Task WHERE Id = :task2.Id];

        // Assert that the custom field was populated correctly
        Assert.areEqual(acc.Name, insertedTask1.test__c, 'The custom field test__c should be populated with the Account Name for the Contact.');
        Assert.areEqual(lead1.Company, insertedTask2.test__c, 'The custom field test__c should be populated with the Company for the Lead.');


        // Update the Tasks to test the before update trigger
        task1.Subject = 'Updated Follow-up with Contact';
        task2.Subject = 'Updated Follow-up with Lead';

        update new List<Task>{task1, task2};

        // Query Tasks to verify the custom field is populated correctly after update
        Task updatedTask1 = [SELECT Id, test__c FROM Task WHERE Id = :task1.Id];
        Task updatedTask2 = [SELECT Id, test__c FROM Task WHERE Id = :task2.Id];

        // Assert that the custom field was populated correctly after update
        Assert.areEqual(acc.Name, updatedTask1.test__c, 'The custom field test__c should be populated with the Account Name for the Contact after update.');
        Assert.areEqual(lead1.Company, updatedTask2.test__c, 'The custom field test__c should be populated with the Company for the Lead after update.');
    }
}
