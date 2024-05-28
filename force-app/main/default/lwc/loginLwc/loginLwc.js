import { LightningElement, track } from 'lwc';

export default class LoginLwc extends LightningElement {
    
    inputValues = {};

    handleChange(event){
       const {name,value}=event.target;

       this.inputValues={...this.inputValues, [name]:value};
    }
    // handleClick(event){

    //     const {userName,password} = this.inputValues;

    //    console.log(`User name is ${userName} Password is ${password}`);

    //    this.clearInputs();
    // }

    
    clearInputs() {
        this.inputValues = {};

        // Reset the input fields in the DOM
        this.template.querySelectorAll('lightning-input').forEach(input => {
            input.value = null;
        });
    }
}