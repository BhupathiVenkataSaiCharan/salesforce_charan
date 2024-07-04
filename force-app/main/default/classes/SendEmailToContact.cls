/* 
* Apex class to send email to contact email when clicking button on LWC component
* used in LWC component : "sendEmailToContact"
* Email template name : Send_Email_To_Contacts

* created date : 26-06-2024
* as part of practice for sending email to user from LWC for ABSA 

*/

public class SendEmailToContact {
    @AuraEnabled
    public static void sendEmail(String contactId) {
        Contact contact = [SELECT Id, Name, Email, Phone FROM Contact WHERE Id = :contactId LIMIT 1];
        system.debug('Email :::' +contact.Email);
        if (contact.Email != null) {
            // Define the email template
            String templateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Send_Email_To_Contacts' LIMIT 1].Id;
            system.debug('templateId :::' +templateId);
            // Create an instance of SingleEmailMessage
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Set the target object id (the contact id)
            mail.setTargetObjectId(contact.Id);
            
            // Use the template
            mail.setTemplateId(templateId);
            
            // Ensure that the email is sent even if the target object is a user
             //mail.setWhatId(contact.Id);
            
            // Specify to send email based on the contact's email address
            mail.setSaveAsActivity(false);
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}