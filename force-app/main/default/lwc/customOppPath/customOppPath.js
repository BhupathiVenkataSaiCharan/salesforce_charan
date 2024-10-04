/* eslint-disable no-console */
// Import LightningElement and api classes from lwc module
import { LightningElement, api, wire, track } from 'lwc';
// import getPicklistValues method from lightning/uiObjectInfoApi
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
// import getObjectInfo method from lightning/uiObjectInfoApi
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
// Import lead object APi from schema
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
// import Opportunity Stage field from schema
import PICKLIST_FIELD from '@salesforce/schema/Opportunity.StageName';
// import record ui service to use crud services
import { getRecord } from 'lightning/uiRecordApi';
// import show toast
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import update record api
import { updateRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Opportunity.Id',
    'Opportunity.StageName'
];

export default class CustomPath extends LightningElement {

    @track selectedValue;
    @api recordId;
    @track showSpinner = false;

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: PICKLIST_FIELD })
    picklistFieldValues;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    record;


    get picklistValues() {
        let itemsList = [];
        console.log(JSON.stringify(this.record));
        if (this.record.data) {
            if (!this.selectedValue && this.record.data.fields.StageName.value) {
                this.selectedValue = this.record.data.fields.StageName.value + '';
            }
            if (this.picklistFieldValues && this.picklistFieldValues.data && this.picklistFieldValues.data.values) {
                console.log('got picklist field data');
                let selectedUpTo = 0;
                for (let item in this.picklistFieldValues.data.values) {

                    if (Object.prototype.hasOwnProperty.call(this.picklistFieldValues.data.values, item)) {
                        let classList;
                        if (this.picklistFieldValues.data.values[item].value === this.selectedValue) {
                            classList = 'slds-path__item slds-is-current slds-is-active';
                            selectedUpTo++;
                        } else {
                            classList = 'slds-path__item slds-is-incomplete';
                        }

                        console.log(classList);

                        itemsList.push({
                            pItem: this.picklistFieldValues.data.values[item],
                            classList: classList
                        })
                    }
                }

                if (selectedUpTo > 0) {
                    for (let item = 0; item < selectedUpTo; item++) {
                        itemsList[item].classList = 'slds-path__item slds-is-complete';
                    }
                }
                console.log('im here = ' + this.selectedValue);
                return itemsList;
            }
        }
        return null;
    }

    handleSelect(event) {
        console.log('in the function', event.currentTarget.dataset.value);
        this.selectedValue = event.currentTarget.dataset.value;
    }

    handleMarkAsSelected() {
        this.showSpinner = true;
        const fields = {};
        fields.Id = this.recordId;
        fields.StageName = this.selectedValue;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Stage Updated!',
                        variant: 'success'
                    })
                );
                console.log('success!');
            })
            .catch(
                error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error updating Stage!',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                    console.log('failure => ' + error.body.message);
                }
            );
        this.showSpinner = false;
    }
}