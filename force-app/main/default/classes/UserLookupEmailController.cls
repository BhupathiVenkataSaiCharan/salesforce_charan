public class UserLookupEmailController {
    
    @AuraEnabled(cacheable=true)
    public static List<User> getUsers(String searchKey){
        String key = '%' + searchKey + '%';
        List<User> userList = [SELECT Id, Name, Email FROM User WHERE Name LIKE :key];
        return userList;
    }
    
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
        mail.setPlainTextBody('Sending Email to the selected user from org using lookup field');
        
        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        // Handle any errors if needed
        if (results[0].isSuccess()) {
            system.debug('Email sent successfully.');
        } else {
            system.debug('Error sending email: ' + results[0].getErrors()[0].getMessage());
            throw new AuraHandledException('Failed to send email.');
        }
    }
}
