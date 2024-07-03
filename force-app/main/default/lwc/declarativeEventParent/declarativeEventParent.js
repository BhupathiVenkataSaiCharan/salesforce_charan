import { LightningElement } from 'lwc';

export default class DeclarativeEventParent extends LightningElement {
    
    employeeName;
    employeeEmail;
    employeePhone;

    showData(event){
        this.employeeName = event.detail.nm;
        this.employeeEmail = event.detail.em;
        this.employeePhone = event.detail.ph;
    }
}