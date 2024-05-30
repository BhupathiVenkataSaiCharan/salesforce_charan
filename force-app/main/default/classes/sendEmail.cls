public with sharing class sendEmail {
    @AuraEnabled
    public static void registeredEmail(String toAddress, String subject, String body) {
        // Create a new SingleEmailMessage object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Set the recipient's email address
        mail.setToAddresses(new List<String>{ toAddress });

        // Set the email subject
        mail.setSubject(subject);

        // Set the email body (HTML content)
        mail.setHtmlBody(body);

        // Send the email using the Messaging.sendEmail method
        Messaging.sendEmail(new List<Messaging.Email> { mail });
    }

}