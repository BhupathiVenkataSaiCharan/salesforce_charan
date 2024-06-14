import { createRecord } from 'lightning/uiRecordApi';
import { LightningElement } from 'lwc';

export default class ProgramBasedLDS extends LightningElement {
    accName;
    accPhone;

    handleName(event){
        this.accName = event.target.value;
    }
    handlePhone(event){
        this.accPhone = event.target.value;
    }

    createAcc(){

        const fields = {'Name':this.accName, 'Phone':this.accPhone};

        const recordData = {apiName:'Account',fields};

        createRecord(recordData)
        .then(response=>{
            alert('Success');
        })
        .catch(error=>{
            alert('Error');
        })
    }
}