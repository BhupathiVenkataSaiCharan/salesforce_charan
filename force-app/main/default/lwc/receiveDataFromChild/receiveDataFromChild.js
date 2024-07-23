import { LightningElement } from 'lwc';

export default class ReceiveDataFromChild extends LightningElement {
    
    data = [];
    columns = [
        {label : 'Name', fieldName : 'name'},
        {label : 'Email', fieldName : 'email'},
        {label : 'Phone', fieldName : 'phone'},
    ];

    handleData(event){
        const newRow = {
            id : this.data.length + 1,
            name : event.detail.name,
            email : event.detail.email,
            phone : event.detail.phone,
        }
        this.data = [...this.data, newRow];
    }
}