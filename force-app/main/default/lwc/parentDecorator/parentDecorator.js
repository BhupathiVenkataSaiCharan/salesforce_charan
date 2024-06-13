import { LightningElement } from 'lwc';

export default class ParentDecorator extends LightningElement {
    parentMessage = '';

    handleInputChange(event){
        this.parentMessage = event.target.value;
    }

    handleSubmit(){
        const childComponent = this.template.querySelector("c-child-decorator");

        if(childComponent){
            childComponent.receivedMessage = this.parentMessage;
        }
    }
}