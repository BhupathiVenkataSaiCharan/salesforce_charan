import { LightningElement } from 'lwc';

export default class NavBar extends LightningElement {
    userName;

    handleChange(event){
        this.userName=event.target.value;
    }

    handleClick(){
        alert('Username is :::' +this.userName);
    }
}