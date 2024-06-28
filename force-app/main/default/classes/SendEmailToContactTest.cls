@isTest
public class SendEmailToContactTest {
    
    @isTest
    static void testSendEmail() {
        // Create a test User to run as
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User']; // Replace with your profile name
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com',
            Alias = 'tuser',
            ProfileId = testProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        // Assign the test user to the current context
        System.runAs(testUser) {
            // Create a test Contact
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Email = 'test@example.com',
                Phone = '1234567890'
            );
            insert testContact;
            
            // Create an EmailTemplate record for testing
            EmailTemplate testTemplate = new EmailTemplate(
                DeveloperName = 'Send_Email_To_Contacts',
                Subject = 'Test Email',
                HtmlValue = '<html><body>This is a test email.</body></html>', // Example HTML content
                Body = 'This is a test email.' // Example plain text content
                // Add other required fields
            );
            insert testTemplate;
            
            Test.startTest();
            // Call the method under test
            SendEmailToContact.sendEmail(testContact.Id);
            Test.stopTest();
            
            // Verify if the email was sent (example assertion)
            List<Messaging.SingleEmailMessage> sentEmails = [SELECT Id FROM Messaging.SingleEmailMessage];
            System.assertEquals(1, sentEmails.size(), 'Expected one email to be sent.');
        }
    }
}
