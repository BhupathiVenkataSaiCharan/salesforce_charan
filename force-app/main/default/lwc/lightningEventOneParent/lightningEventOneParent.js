import { LightningElement } from 'lwc';

export default class LightningEventOneParent extends LightningElement {
    count = 0;

    incCount(event){
        if(this.count>=0 && this.count<10){
            this.count++;
        }
    }

    decCount(event){
        if(this.count>0 && this.count<=10){
            this.count--;
        }
    }
}