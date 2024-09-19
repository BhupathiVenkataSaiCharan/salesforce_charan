import { LightningElement, wire, api } from 'lwc';
import getOppValues from '@salesforce/apex/MetaDataOppValues.getOppValues';

export default class DisplayMetaData extends LightningElement {
    
    @api recordId;

    data = [];
    selectedValues = [];

    @wire(getOppValues)
    wiredMetaData({data,error}){
        if(data){
            this.data = data;
            console.log('Data ==> ', this.data);   
            alert('recordId ==> ', this.recordId);
        }else{
            console.log('Error');
        }
    }

    handleCheck(event){
        
        console.log('event ==> ', event.target.dataset.id);
        console.log('event ==> ', event.target.dataset.label);

        const mId = event.target.dataset.id;
        const mLabel = event.target.dataset.label;

        if(event.target.checked){
            this.selectedValues.push({
                Id : mId,
                Label : mLabel,
                recId : this.recordId
            });
        }else{
           this.selectedValues = this.selectedValues.filter(item => item.Id !== mId);
        }
    }

    handleSave(){
        console.log('Selected Values ==> ', JSON.stringify(this.selectedValues));
        console.log('recordId ==> ', this.recordId);
    }
}