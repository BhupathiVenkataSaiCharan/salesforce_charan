import { LightningElement } from 'lwc';
import sendEmailToUser from '@salesforce/apex/UserLookupEmail2Controller.sendEmailToUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UserLookupEmail2 extends LightningElement {

    filter = {
        criteria: [
            {
                fieldPath: 'IsActive',
                operator: 'eq',
                value: true,
            }
        ],
    };
    
    selectedUserId = '';

    handleUserSelect(event) {
        console.log('events:::', JSON.stringify(event.detail.recordId));
        this.selectedUserId = event.detail.recordId;
    }

    sendEmail() {
        console.log('recordid====> ', this.selectedUserId);
        if (this.selectedUserId) {
            sendEmailToUser({ userId: this.selectedUserId })
                .then(() => {
                    this.showToast('SUCCESS', 'Email Sent Successfully', 'success');
                })
                .catch(error => {
                    console.error('Error sending email:', error);
                    this.showToast('ERROR', 'Failed to send email', 'error');
                });
        } else {
            this.showToast('ERROR', 'Please select a user first', 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}