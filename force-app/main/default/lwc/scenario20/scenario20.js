import { api, LightningElement, wire } from 'lwc';
import getAccountRecord from "@salesforce/apex/Scenario20Controller.getAccountRecord";
import { RefreshEvent } from 'lightning/refresh';
import {refreshApex} from '@salesforce/apex'

export default class Scenario20 extends LightningElement {
    @api recordId;
    data;
    error;
    updatedData;

    connectedCallbacking(){
        refreshApex(this.updatedData);
    }

    @wire(getAccountRecord,{accId : '$recordId'})
    wiredData(result){
        this.updatedData = result;
        const {data,error} = result;
        if(data){
            this.data = data;
        }else{
            this.error = error;
        }
    }
}