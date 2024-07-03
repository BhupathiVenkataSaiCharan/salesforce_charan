import { LightningElement } from 'lwc';

export default class DeclarativeEventChild extends LightningElement {

    empName;
    empEmail;
    empPhone;

    handleChange(event){
        const field = event.target.name;
        if(field === 'Name'){
            this.empName = event.target.value;
        }
        if(field === 'Email'){
            this.empEmail = event.target.value;
        }
        if(field === 'Phone'){
            this.empPhone = event.target.value;
        }
    }

    handleSubmit(event){
        this.dispatchEvent(new CustomEvent('empdetails',{
            detail : {
                nm:this.empName,
                em:this.empEmail,
                ph:this.empPhone
            }
        }))
    }
}