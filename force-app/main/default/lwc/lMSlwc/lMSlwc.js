import { LightningElement } from 'lwc';
import MC from '@salesforce/messageChannel/customMsgChannel__c';
import { publish, subscribe, unsubscribe, createMessageContext, releaseMessageContext } from 'lightning/messageService';

export default class LMSlwc extends LightningElement {
    receivedMessage = '';
    subscription = null;
    myMessage = '';
    context = createMessageContext();

    constructor(){
        super();
    }

    handleMsg(event){
        this.myMessage = event.target.value;
    }

    publishMC(event){
        const message = {
            UserName : this.myMessage,
            PhoneNumber : '0987654321'
        };
        publish(this.context, MC, message);
    }

    subscribeMC(event){
        if(this.subscription){
            return;
        }
        this.subscription = subscribe(this.context, MC, (message)=>{
            this.displayMessage(message);
        });
    }

    displayMessage(message){
        this.receivedMessage = message ? JSON.stringify(message, null, '\t') : 'no message payload';
    }

    unsubscribeMC(event){
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback(){
        releaseMessageContext(this.context);
    }
}