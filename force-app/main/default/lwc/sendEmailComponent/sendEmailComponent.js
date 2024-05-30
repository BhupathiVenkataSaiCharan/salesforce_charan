import { LightningElement, track, wire } from 'lwc';
import sendEmail from '@salesforce/apex/sendEmailController.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SendEmailComponent extends LightningElement {
    @track toEmail = '';
    @track subject = '';
    @track message = '';
    
    // Handler for changes in the recipient's email address
    handleToEmailChange(event) {
        this.toEmail = event.target.value;
    }

    // Handler for changes in the subject
    handleSubjectChange(event) {
        this.subject = event.target.value;
    }

    // Handler for changes in the message
    handleMessageChange(event) {
        this.message = event.target.value;
    }

    // Function to send the email
    sendEmail() {
        sendEmail({ toAddress: this.toEmail, subject: this.subject, body: this.message })
            .then(() => {
                // Show success toast notification
                this.showToast('Success', 'Email sent successfully', 'success');
                // Clear input fields
                this.clearFields();
            })
            .catch(error => {
                // Show error toast notification
                this.showToast('Error', 'Failed to send email', 'error');
                console.error(error);
            });
    }

    // Function to show toast notifications
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    // Function to clear input fields
    clearFields() {
        this.toEmail = '';
        this.subject = '';
        this.message = '';
    }
}