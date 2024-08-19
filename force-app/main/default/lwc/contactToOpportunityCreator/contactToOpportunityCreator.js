import { api, LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactToOpportunityCreatorController.getContacts';
import createOpportunities from '@salesforce/apex/ContactToOpportunityCreatorController.createOpportunities';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';

import { CloseActionScreenEvent } from 'lightning/actions';         //to close button actions
import {RefreshEvent} from 'lightning/refresh';                     //to refresh component

export default class ContactToOpportunityCreator extends NavigationMixin(LightningElement) {
    
    @api recordId;
    contacts=[];
    conList = [];
    draftValues = [];
    isCons = true;
    isOpps = false;

    columns = [
        {label : 'Name', fieldName : 'Name'},
        {label : 'Phone', fieldName : 'Phone'},
        {label : 'Email', fieldName : 'Email'}
    ];

    oppColumns = [
        {label : 'Opportunity Name', fieldName : 'Name', editable : false},
        {label : 'Contact', fieldName : 'Contact__c'},  
        {label : 'Stage', fieldName : 'StageName', editable : false},
        {label : 'Close Date', fieldName : 'CloseDate', type :'date-local',editable : true},
    ];


    @wire(getContacts,{accId : '$recordId'})
    wiredData({data,error}){
        if(data){
            this.contacts = data;
        }else{
            console.error('Error loading contacts', JSON.stringify(error));
        }      
    }

    handleRowSelection(event) {
        this.conList = event.detail.selectedRows.map(contact => ({
            Id: contact.Id, // Ensure ID is set correctly
            Name: `${contact.Name} Opportunity`,
            Contact__c: contact.Id, // Set Contact__c to the contact ID
            CloseDate: '', // Initialize CloseDate as empty
            StageName: 'Prospecting'
        }));
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

    handleSave(event) {
        const draftValues = this.template.querySelector('lightning-datatable').draftValues;
        const invalidOpportunities = draftValues.filter(draft => !draft.CloseDate);
 
        if (invalidOpportunities.length > 0) {
            this.showToast('ERROR', 'Please enter a Close Date for each Opportunity.', 'error');
            return;
        }
 
        this.conList = draftValues.map(draft => {
            const contact = this.conList.find(con => con.Id === draft.Id);
            return {
 
                Name: draft.Name || contact.Name,
                StageName: draft.StageName||'Prospecting',
                CloseDate: draft.CloseDate||'',
                Contact__c: draft.Id
            };
        });

        createOpportunities({ oppList: this.conList })
            .then(() => {
                this.showToast('Success', 'Opportunities created successfully', 'success');
                this.navigateToOpportunityHome();
            })
            .catch(error => {
                console.error('Error creating opportunities:', JSON.stringify(error));
                this.showToast('Error', 'Opportunity creation failed', 'error');
            });
    }

    navigateToOpportunityHome() {
        // Use NavigationMixin to navigate to the Opportunity object home page
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'home'
            }
        });
    }

    // createGroup(e){
    //     e.preventDefault();

    //     // Validate CloseDate fields
    //     let isValid = true;
    //     this.template.querySelectorAll('lightning-input-field').forEach(inputField => {
    //         if (inputField.fieldName === 'CloseDate') {
    //             const closeDateValue = inputField.value;
    //             if (!closeDateValue) {
    //                 isValid = false;
    //             }
    //         }
    //     });

    //     if (!isValid) {
    //         this.showToast('ERROR', 'Please enter a Close Date for each Opportunity.', 'error');
    //         return;
    //     }

    //     this.template.querySelectorAll('lightning-record-edit-form').forEach(form => {
    //         form.submit();
    //     });

    //     this.showToast('SUCCESS','Opportunities Created', 'success');
    //     this.closeAction();
    //     this.dispatchEvent(new RefreshEvent());        
    // }

    // closeAction(){
    //     this.dispatchEvent(new CloseActionScreenEvent());
    //   }

    showToast(title,message,variant){
        const event = new ShowToastEvent({
            title: title,
            message:message,
            variant:variant
        })
        this.dispatchEvent(event);
    }
}