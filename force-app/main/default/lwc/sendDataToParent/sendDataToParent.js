import { LightningElement } from 'lwc';

export default class SendDataToParent extends LightningElement {
    userName;
    userEmail;
    userPhone;

    handleInput(event){
        const name = event.target.name;
        if(name === 'UserName'){
            this.userName = event.target.value;
        }
        if(name === 'UserEmail'){
            this.userEmail = event.target.value;
        }
        if(name === 'UserPhone'){
            this.userPhone = event.target.value;
        }
    }

    sendData(event){
        console.log('UserName ::: ', this.userName);
        console.log('UserEmail ::: ', this.userEmail);
        console.log('UserPhone ::: ', this.userPhone);

        this.dispatchEvent(new CustomEvent('userdata',{
            detail : {
                name : this.userName,
                email : this.userEmail,
                phone : this.userPhone
            }
        }));
    }
}