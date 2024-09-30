import { LightningElement } from 'lwc';
import getContacts from '@salesforce/apex/ContactSearchPackageController.getContacts';

export default class ContactSearchPackage extends LightningElement {

    searchValue = '';
    data = [];
    error;
    columns = [
        {label : 'Name', fieldName : 'contactUrl', type : 'url', typeAttributes : {label : {fieldName : 'Name'}, target : '_self'}},
        {label : 'AccountName', fieldName : 'AccountName'}
    ];

    searchContacts(){
        getContacts({contactName : this.searchValue})
        .then(result=>{
            this.data = result.map(contact=>({
                ...contact,
                AccountName : contact.Account != null ? contact.Account.Name : '',
                contactUrl : `/${contact.Id}`
            }));
            console.log('Contacts List ===> ', JSON.stringify(this.data));
        })
        .catch(error=>{
            this.error = error;
            console.log('Error ===> ', JSON.stringify(this.error)); 
        })
    }

    handleChange(event){
        this.searchValue = event.target.value;
    }

    handleClick(){
        console.log('Search term ===> ', this.searchValue);
        this.searchContacts();
    }


}