import { LightningElement, track } from 'lwc';

export default class TaskListComponent extends LightningElement {
    // @track 
    tasks = ['test1']; // Tracked property to hold the list of tasks

    newTask = ''; // Temporary property to hold the new task input

    handleInputChange(event) {
        this.newTask = event.target.value; // Update newTask with the input value
    }

    handleAddTask() {
        if (this.newTask) {
            this.tasks = [...this.tasks,this.newTask]; // Add the new task to the tasks array
            this.newTask = ''; // Clear the newTask input
        }
    }
    
}