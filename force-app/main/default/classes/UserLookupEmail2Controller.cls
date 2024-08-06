public class UserLookupEmail2Controller {
    
    @AuraEnabled
    public static void sendEmailToUser(String userId){
        // Retrieve user's email based on userId
        User selectedUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId LIMIT 1];
        String userEmail = selectedUser.Email;
        
        // Logic to send email using Messaging.SingleEmailMessage
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { userEmail };
        mail.setToAddresses(toAddresses);
        mail.setSubject('Subject of the Email');
        mail.setPlainTextBody('Sending Email to the selected user from org using lookup');
        
        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        // Handle any errors if needed
        if (results[0].isSuccess()) {
            System.debug('Email sent successfully.');
        } else {
            System.debug('Error sending email: ' + results[0].getErrors()[0].getMessage());
            throw new AuraHandledException('Failed to send email.');
        }
    }
}
