import { api, LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactToOpportunityCreatorController.getContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { CloseActionScreenEvent } from 'lightning/actions';         //to close button actions
import {RefreshEvent} from 'lightning/refresh';                     //to refresh component

export default class ContactToOpportunityCreator extends LightningElement {
    @api recordId;
    contacts=[];
    columns = [
        {label : 'Name', fieldName : 'Name'},
        {label : 'Phone', fieldName : 'Phone'},
        {label : 'Email', fieldName : 'Email'}
    ];

    conList = [];

    isCons = true;
    isOpps = false;


    @wire(getContacts,{accId : '$recordId'})
    wiredData({data,error}){
        if(data){
            this.contacts = data;
        }else{
            console.error('Error loading contacts', JSON.stringify(error));
        }      
    }

    handleRowSelection(event){
        console.log('event', JSON.stringify(event.detail.selectedRows));
        this.conList = event.detail.selectedRows;
        console.log('conList', this.conList);

    }

    openOpps(){
        if(this.conList.length > 0){
            this.isOpps = true;
            this.isCons = false;
        }
        else{
            this.showToast('ERROR', 'Please select at least one contact to create Opportunities', 'error');
        }
    }

    createGroup(e){
        e.preventDefault();

        // Validate CloseDate fields
        let isValid = true;
        this.template.querySelectorAll('lightning-input-field').forEach(inputField => {
            if (inputField.fieldName === 'CloseDate') {
                const closeDateValue = inputField.value;
                if (!closeDateValue) {
                    isValid = false;
                }
            }
        });

        if (!isValid) {
            this.showToast('ERROR', 'Please enter a Close Date for each Opportunity.', 'error');
            return;
        }

        this.template.querySelectorAll('lightning-record-edit-form').forEach(form => {
            form.submit();
        });
        this.showToast('SUCCESS','Opportunities Created', 'success');

        this.closeAction();
        this.dispatchEvent(new RefreshEvent());        
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
      }

    showToast(title,message,variant){
        const event = new ShowToastEvent({
            title: title,
            message:message,
            variant:variant
        })
        this.dispatchEvent(event);
    }
}