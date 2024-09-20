import { LightningElement, wire, api } from 'lwc';
import getMetaData from '@salesforce/apex/MetaDataOppValues.getMetaData';
import updateOppRecords from '@salesforce/apex/MetaDataOppValues.updateOppRecords';
import getOpportunityJson from '@salesforce/apex/MetaDataOppValues.getOpportunityJson';

export default class DisplayMetaData extends LightningElement {
    
    data = [];
    error;
    selectedData = [];

    @api recordId;

    savedData = [];
    savedError;

    @wire(getMetaData)
    wiredData({data,error}){
        if(data){
            this.data = data;
            console.log('Data ==> ', this.data);
        }else{
            this.error = error;
            console.log('Error ==>', this.error);
        }
    }


    @wire(getOpportunityJson,{oppId : '$recordId'})
    wiredJson({data,error}){
        if(data){
            this.savedData = JSON.parse(data);
            this.preselectCheckbox();
            console.log('savedData==>', this.savedData);
        }else{
            this.savedError = error;
            console.log('error==>', this.savedError);
        }
    }

    preselectCheckbox(){
        const inputs = this.template.querySelectorAll('lightning-input');
        inputs.forEach(input=>{
            const ifSelected = this.savedData.find(item => item.Id === input.dataset.id);
            if(ifSelected){
                input.checked = true;
                this.selectedData.push(ifSelected);
            }
        })
    }

 
    handleCheck(event){

        console.log('metadata Id ==> ', event.target.dataset.id) ;
        console.log('metadata Label ==> ', event.target.dataset.label) ;

        const mId = event.target.dataset.id;
        const mLabel = event.target.dataset.label;

        if(event.target.checked){
            this.selectedData.push({
                Id : mId,
                Label : mLabel
            });
        }else{
            this.selectedData = this.selectedData.filter(item => item.Id !== mId);
        }
    }


    handleSave(){
        console.log('Selected List of Meta Data Values ==> ', JSON.stringify(this.selectedData));
        console.log('recordId ==> ', this.recordId);

        updateOppRecords({oppId : this.recordId, jsonData : JSON.stringify(this.selectedData)})
        .then(()=>{
            alert('Successfully Updated Opportunity')
        })
        .catch((error)=>{
            alert('Failed to Update');
        })
        
    }
    
}