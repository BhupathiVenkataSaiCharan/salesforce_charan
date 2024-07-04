@isTest
public class SendEmailToContactTest {
    @isTest
    static void testSendEmail() {
        // Create a test contact
        Contact testContact = new Contact(
            LastName = 'Test',
            Email = 'test@example.com',
            Phone = '1234567890'
        );
        insert testContact;

        // Create a test email template
        EmailTemplate testTemplate = new EmailTemplate(
            Name = 'Test Template',
            DeveloperName = 'Send_Email_To_Contacts',
            Subject = 'Test Email',
            HtmlValue = '<html><body>Test Email</body></html>',
            Body = 'Test Email'
        );
        insert testTemplate;

        // Call the method to send email
        Test.startTest();
        SendEmailToContact.sendEmail(testContact.Id);
        Test.stopTest();

        // Verify that an email was sent
        List<EmailMessage> emails = [SELECT Id FROM EmailMessage WHERE ToAddress = :testContact.Email];
        System.assertEquals(1, emails.size(), 'An email should have been sent to the contact.');
    }

    @isTest
    static void testSendEmailNoEmail() {
        // Create a test contact with no email
        Contact testContact = new Contact(
            LastName = 'Test No Email',
            Phone = '1234567890'
        );
        insert testContact;

        // Call the method to send email
        Test.startTest();
        SendEmailToContact.sendEmail(testContact.Id);
        Test.stopTest();

        // Verify that no email was sent
        List<EmailMessage> emails = [SELECT Id FROM EmailMessage WHERE ToAddress = :testContact.Email];
        System.assertEquals(0, emails.size(), 'No email should have been sent to the contact with no email.');
    }

    @isTest
    static void testSendEmailNoTemplate() {
        // Create a test contact
        Contact testContact = new Contact(
            LastName = 'Test No Template',
            Email = 'testnotemplate@example.com',
            Phone = '1234567890'
        );
        insert testContact;

        // Ensure no email templates exist with the specified DeveloperName
        List<EmailTemplate> templates = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Send_Email_To_Contacts'];
        delete templates;

        // Call the method to send email
        Test.startTest();
        try {
            SendEmailToContact.sendEmail(testContact.Id);
            System.assert(false, 'Exception should have been thrown due to missing template.');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('No rows to assign'), 'Expected exception due to missing template.');
        }
        Test.stopTest();
    }
}