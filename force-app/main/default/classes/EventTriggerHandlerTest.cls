@isTest
public class EventTriggerHandlerTest {
    
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

        // Create Events with the Contact and Lead as WhoId
        Event event1 = new Event(
            Subject = 'Follow-up with Contact',
            WhoId = con1.Id,
            DurationInMinutes = 30,  // Required field
            StartDateTime = System.now()  // Required field
        );

        Event event2 = new Event(
            Subject = 'Follow-up with Lead',
            WhoId = lead1.Id,
            DurationInMinutes = 30,  // Required field
            StartDateTime = System.now()  // Required field
        );

        insert new List<Event>{event1, event2};

        // Call the method to be tested
        Test.startTest();
        EventTriggerHandler.assignCustomField(new List<Event>{event1, event2});
        Test.stopTest();

        // Query Events to verify the custom field is populated correctly
        Event insertedEvent1 = [SELECT Id, test__c FROM Event WHERE Id = :event1.Id];
        Event insertedEvent2 = [SELECT Id, test__c FROM Event WHERE Id = :event2.Id];

        // Assert that the custom field was populated correctly
        Assert.areEqual(acc.Name, insertedEvent1.test__c, 'The custom field test__c should be populated with the Account Name for the Contact.');
        Assert.areEqual(lead1.Company, insertedEvent2.test__c, 'The custom field test__c should be populated with the Company for the Lead.');



        // Update the Events to test the before update trigger
        event1.Subject = 'Updated Follow-up with Contact';
        event2.Subject = 'Updated Follow-up with Lead';

        update new List<Event>{event1, event2};

        // Query Events to verify the custom field is populated correctly after update
        Event updatedEvent1 = [SELECT Id, test__c FROM Event WHERE Id = :event1.Id];
        Event updatedEvent2 = [SELECT Id, test__c FROM Event WHERE Id = :event2.Id];

        // Assert that the custom field was populated correctly after update
        Assert.areEqual(acc.Name, updatedEvent1.test__c, 'The custom field test__c should be populated with the Account Name for the Contact after update.');
        Assert.areEqual(lead1.Company, updatedEvent2.test__c, 'The custom field test__c should be populated with the Company for the Lead after update.');
    }
}