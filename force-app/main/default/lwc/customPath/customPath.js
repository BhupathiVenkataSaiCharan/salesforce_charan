import { LightningElement, track, wire } from 'lwc';
import getOpportunityStages from '@salesforce/apex/CustomPathController.getOpportunityStages';


export default class CustomPath extends LightningElement {
    @track stages = [];
    @track currentStage = 'Qualification'; // Set this to the current stage of your opportunity

    @wire(getOpportunityStages)
    wiredStages({ error, data }) {
        if (data) {
            this.stages = data;
        } else if (error) {
            console.error(error);
        }
    }

    handleStageClick(event) {
        const clickedStage = event.currentTarget.dataset.value;
        this.currentStage = clickedStage;
    }

    stageClasses(stageValue) {
        let classes = 'slds-path__item';
        if (this.currentStage === stageValue) {
            classes += ' slds-is-current slds-is-active';
        } else if (this.isStageComplete(stageValue)) {
            classes += ' slds-is-complete';
        }
        return classes;
    }

    isStageComplete(stageValue) {
        const stageIndex = this.stages.findIndex(stage => stage.value === stageValue);
        const currentIndex = this.stages.findIndex(stage => stage.value === this.currentStage);
        return stageIndex < currentIndex;
    }
}