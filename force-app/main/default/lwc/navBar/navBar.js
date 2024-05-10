import { LightningElement } from 'lwc';

export default class NavBar extends LightningElement {
    userName;
    userEmail;

    handleUser(event){
        this.userName=event.target.value;
    }
    handleEmail(event){
        this.userEmail=event.target.value;
    }

    handleSubmit(){
        alert('Username is ::: ' +this.userName +'userEmail is::: ' +this.userEmail);
    }
}