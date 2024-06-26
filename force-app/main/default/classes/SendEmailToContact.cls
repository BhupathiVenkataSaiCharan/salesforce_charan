/* 
* Apex class to send email to contact email when clicking button on LWC component
* used in LWC component : "sendEmailToContact"
* Email template name : Send_Email_To_Contacts
*/

public class SendEmailToContact {
    @AuraEnabled
    public static void sendEmail(String contactId) {
        Contact contact = [SELECT Id, Name, Email, Phone FROM Contact WHERE Id = :contactId LIMIT 1];
        
        if (contact != null && contact.Email != null) {
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Set recipient
            mail.setToAddresses(new String[] { contact.Email });
            
            // Set subject
            mail.setSubject('Contact Details');
            
            // Construct email body
            String body = 'Dear ' + contact.Name + ',<br/><br/>Here are the contact details:<br/>'
                        + 'Name: ' + contact.Name + '<br/>'
                        + 'Email: ' + contact.Email + '<br/>'
                        + 'Phone: ' + contact.Phone + '<br/><br/>Thank you!';
            mail.setHtmlBody(body);
            
            // Add email to the list
            emails.add(mail);
            
            // Send email
            Messaging.sendEmail(emails);
        }
    }
}




