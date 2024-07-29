import { LightningElement } from 'lwc';

export default class ParentMethod extends LightningElement {
    
    handleAdd(){
        this.template.querySelector('c-child-method').addDetails();
    }
    handleRemove(){
        this.template.querySelector('c-child-method').removeDetails();
    }
}