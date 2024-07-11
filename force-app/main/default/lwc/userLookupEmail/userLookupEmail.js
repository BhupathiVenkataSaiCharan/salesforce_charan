import { LightningElement, wire, track } from 'lwc';
import getUsers from '@salesforce/apex/UserLookupEmailController.getUsers';
import sendEmailToUser from '@salesforce/apex/UserLookupEmailController.sendEmailToUser';

export default class UserLookupEmail extends LightningElement {
    searchedUser = '';
    users;
    error;
    @track selectedUser;

    handleSearchUser(event){
        this.searchedUser = event.target.value;
    }

    sendEmail(){
        console.log('Search Value ::', this.searchedUser);
        console.log('Selected User Id :: ', this.selectedUser);

        // Call Apex method to send email
        sendEmailToUser({ userId: this.selectedUser })
            .then(result => {
                // Handle success or show a confirmation
                console.log('Email sent successfully:', result);
            })
            .catch(error => {
                // Handle error
                console.error('Error sending email:', error);
            });

    }

    @wire(getUsers,{searchKey : '$searchedUser'})
    userData({data,error}){
        if(data){
            this.users = data;
        }else{
            this.error = error;
        }
    }

    handleUserSelect(event){
        this.selectedUser = event.currentTarget.dataset.id;
        this.searchedUser = event.currentTarget.dataset.name;
        this.users = null; // clear the dropdown after selection
    }


    get isActive(){
        return this.searchedUser ? true : false; 
    }
}