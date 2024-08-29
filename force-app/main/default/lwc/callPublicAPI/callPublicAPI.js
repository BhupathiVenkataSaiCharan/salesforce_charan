import { LightningElement } from 'lwc';
import getData from '@salesforce/apex/CallPublicAPIController.getData';

export default class CallPublicAPI extends LightningElement {
    data=[];

    handleClick(){
        getData()
        .then(result=>{
            this.data = result;
        })
        .catch(error=>{

        })
    }
}