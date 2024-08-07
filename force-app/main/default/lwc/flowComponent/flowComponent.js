import { LightningElement, api, track } from 'lwc';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

export default class FlowComponent extends LightningElement {
    @api
    availableActions = [];

    @api
    get todos() {
        return this._todos;
    }

    set todos(todos = []) {
        this._todos = [...todos];
    }

    @track _todos = [];

    get todosList() {
        return this._todos.map((todo) => {
            return { text: todo, id: Date.now().toString() };
        });
    }

    get hasTodos() {
        return this._todos && this._todos.length > 0;
    }

    handleUpdatedText(event) {
        this._text = event.detail.value;
    }

    handleAddTodo() {
        this._todos.push(this._text);
        // notify the flow of the new todo list
        // const attributeChangeEvent = new FlowAttributeChangeEvent(
        //     'todos',
        //     this._todos
        // );
        // this.dispatchEvent(attributeChangeEvent);
    }
    onDelete(event) {
        console.log('ondelete event',event.target.dataset);
        this._todos.splice(event.target.dataset.id,1);
        // const attributeChangeEvent = new FlowAttributeChangeEvent(
        //     'todos',
        //     this._todos
        // );
        // this.dispatchEvent(attributeChangeEvent);
    }

    handleGoNext() {
        // check if NEXT is allowed on this screen
        if (this.availableActions.find((action) => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    } 
}