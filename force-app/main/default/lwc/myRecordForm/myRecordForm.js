import { LightningElement, api, track } from 'lwc';

export default class MyRecordForm extends LightningElement {
    //@api recordId; // Record Id to be used in form

    fields = ['Name', 'Industry', 'Phone']; // Fields to display in the form

    handleSuccess(event) {
        // Handle the success event
        const updatedRecordId = event.detail.id;
        console.log('Record updated successfully with Id:', updatedRecordId);
    }

    handleLoad(event) {
        // Handle the form load event
    }

    handleError(event) {
        console.error('Error:', event.detail);
    }
}
