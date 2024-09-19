import { LightningElement, api } from 'lwc';

export default class LifeCycleHooks extends LightningElement {
    @api recordId;

    connectedCallback(){
        alert('Record Id::' +this.recordId);
    }
    
}