import { LightningElement, api } from 'lwc';
import sendEmail from '@salesforce/apex/SendEmailToContact.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SendEmailToContact extends LightningElement {
    @api recordId;

    handleSendEmail(){
        sendEmail({contactId : this.recordId})
            .then(()=>{
                this.showToast('SUCCESS','Email Sent Successfully', 'success');
            })
            .catch(e=>{
                this.showToast('FAILED','Failed To Send Email', 'error');
            })
    }

    showToast(title,message,variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}