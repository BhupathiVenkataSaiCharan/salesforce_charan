import { api, LightningElement } from 'lwc';

export default class ChildMethod extends LightningElement {
    name;
    phone;
    email;

    @api
    addDetails(){
        this.name = 'user';
        this.phone = 'phone';
        this.email = 'email';
    }
    @api
    removeDetails(){
        this.name = '';
        this.phone = '';
        this.email = '';
    }
}