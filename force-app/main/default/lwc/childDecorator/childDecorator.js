import { LightningElement, api } from 'lwc';

export default class ChildDecorator extends LightningElement {
    @api
    receivedMessage = 'Default Child Message';
}