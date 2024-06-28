import { LightningElement, api } from 'lwc';
import createContact from '@salesforce/apex/CreateAccountRelatedContact.createContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';

export default class CreateAccountRelatedContact extends LightningElement {
    
    @api recordId;
    firstName = '';
    lastName = '';
    email = '';

    handleInputChange(event){
        const field = event.target.name;
        if(field === 'firstName'){
            this.firstName = event.target.value;
        }
        if(field === 'lastName'){
            this.lastName = event.target.value;
        }
        if(field === 'email'){
            this.email = event.target.value;
        }
    }

    handleCreateContact(){
        createContact({
            accId : this.recordId,
            accFName : this.firstName,
            accLName : this.lastName,
            accEmail : this.email
        })
        .then(result=>{
            this.showToast('SUCCESS','Contact Created Successfully', 'success');
            // Refresh the contacts related list
            this.dispatchEvent(new RefreshEvent());
        })
        .catch(error=>{
            this.showToast('FAILED','Failed To Create Contact', 'error');
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