import { LightningElement, wire, track } from 'lwc';
import getUsers from '@salesforce/apex/UserLookupEmailController.getUsers';
import sendEmailToUser from '@salesforce/apex/UserLookupEmailController.sendEmailToUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UserLookupEmail extends LightningElement {
    @track userName = '';
    @track users;
    @track selectedUser;
    @track error;

    toggleActive = false;


    handleSearchUser(event) {
        this.userName = event.target.value;
        if(this.userName != ''){
            this.toggleActive = true;
        }else{
            this.toggleActive =false;
        }
    }

    @wire(getUsers, { searchKey: '$userName' })
    userData({ error, data }) {
        if (data) {
            this.users = data;
        } else {
            this.error = error;
        }
    }

    handleUserSelect(event) {
        this.selectedUser = event.target.dataset.value;
        this.userName = event.target.dataset.label;
        this.toggleActive = false;
        console.log('userName :: ', this.userName);
        console.log('Searched :: ', this.selectedUser);
    }

    sendEmail() {
        console.log('Search Value ::', this.userName);
        console.log('Selected User Id :: ', this.selectedUser);
        this.userName = '';
        this.showToast('SUCCESS', 'Email Sent Successfully','success');

        sendEmailToUser({ userId: this.selectedUser })
            .then(result => {
                console.log('Email sent successfully:', result);
            })
            .catch(error => {
                console.error('Error sending email:', error);
            });
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
