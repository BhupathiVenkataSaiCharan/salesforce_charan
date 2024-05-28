import { LightningElement } from 'lwc';
import CreateOpportunity from '@salesforce/apex/OpportunityRecordHandler.CreateOpportunity';

export default class opportunityRecordLwc extends LightningElement {
    formValues = {}
    isLoading = false
    stageOptions = [
        { label: 'Prospecting', value: 'Prospecting' },
        { label: 'Qualification', value: 'Qualification' },
        { label: 'Needs Analysis', value: 'Needs Analysis' },
        { label: 'Value Proposition', value: 'Value Proposition' },
        { label: 'Id. Decision Makers', value: 'Id. Decision Makers' },
        { label: 'Perception Analysis', value: 'Perception Analysis' },
        { label: 'Proposal/Price Quote', value: 'Proposal/Price Quote' },
        { label: 'Negotiation/Review', value: 'Negotiation/Review' },
        { label: 'Closed Won', value: 'Closed Won' },
        { label: 'Closed Lost', value: 'Closed Lost' }
    ];
    apiResult

    handleValueChange(event) {
        // const field = event.target.label.toLowerCase
        // const value = event.detail.value
        console.log('event: ',event);
        const name = event.target.name
        const value = event.detail.value
        console.log('name: ',name);
        console.log('value: ',value);
        if (name == 'closeDate') {
            const date = new Date(value)
            const formattedDate = date.toLocaleDateString('en-GB')
            console.log('formattedDate: ',formattedDate);
            this.formValues = { ...this.formValues, [name]: formattedDate }
        } else {
            this.formValues = { ...this.formValues, [name]: value }
        }
    }

    submit() {
        this.isLoading = true;
        console.log('formData: ', this.formValues.name);
        CreateOpportunity({name:this.formValues.name, stageName:this.formValues.stageName, closeDate:this.formValues.closeDate})
            .then((result) => {
                console.log('result: ', result);
                this.apiResult = result
                this.isLoading = false;
            })
            .catch((error) => {
                console.log('error: ', error);
                this.apiResult = error
                this.isLoading = false;
            });
    }
}