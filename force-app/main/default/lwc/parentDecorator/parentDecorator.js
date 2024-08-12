import { LightningElement } from 'lwc';

export default class ParentDecorator extends LightningElement {
    parentMessage = '';

    handleInputChange(event){
        this.parentMessage = event.target.value;
    }

    handleSubmit(){
        this.template.querySelector("c-child-decorator").receivedMessage = this.parentMessage;
    }
}