import { LightningElement, wire } from 'lwc';
import conCount from '@salesforce/apex/AccRelatedConCountController.conCount';

export default class AccRelatedConCount extends LightningElement {

    data = [];
    error;
    headers = [
        {
            label : 'Account Name', 
            fieldName : 'accountUrl', 
            type : 'url',
            typeAttributes:{
                label : {fieldName : 'Name'},
                target : '_self'
            }
        },
        {label : 'Number of Contacts', fieldName : 'cnt'}
    ];

    @wire(conCount)
    wiredCount({data,error}){
        if(data){
            // this.data = data;
            this.data = data.map(row => {
                return {
                    ...row,
                    accountUrl: `/${row.AccountId}` // Construct Account URL  
                };
            });
            console.log('wire data ', JSON.stringify(this.data));
        }else{
            this.error = error;
        }
    }
}