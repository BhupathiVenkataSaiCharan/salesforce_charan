import { api, LightningElement } from 'lwc';

export default class GeneratePDF extends LightningElement {
    @api recordId;

    generatePDF(){
        console.log('Generate PDF for Contact ID :::', this.recordId);
    }
}