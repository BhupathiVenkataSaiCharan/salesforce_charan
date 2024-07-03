import { LightningElement } from 'lwc';

export default class LightningEventOne extends LightningElement {

    incme(event){

        //step 1 create an event
        const inc = new CustomEvent('evtinc');
        //step 2 dispach event
        this.dispatchEvent(inc);
    }

    decme(event){

        //step 1 + step 2 create and dispatch event together
        this.dispatchEvent(new CustomEvent('evtdec'));
    }
}