import { LightningElement, api, wire, track } from 'lwc';
import getOpportunityLineItems from '@salesforce/apex/ProductController.getOpportunityLineItems';


export default class OpportunityProducts extends LightningElement {
    @api recordId;
    opportunityLineItems= [];
    linkRefRelatedOppLineItems;
    linkRefOppLineItem;
    itemVisiable = 3;
    numberOfItem;
 
    @wire(getOpportunityLineItems, { opportunityId: '$recordId' })
    wiredOpportunityLineItems({ error, data }) {
        if (data) {
            if(data?.length <= this.itemVisiable){
                this.numberOfItem =  data?.length;
            }else{
                this.numberOfItem =  "3+";
            }
            this.opportunityLineItems = data?.slice(0, this.itemVisiable);
        } else if (error) {
            console.error('Error fetching opportunity line items:', error);
        }
    }
    connectedCallback(){
        this.linkRefRelatedOppLineItems = `/lightning/r/Opportunity/${this.recordId}/related/OpportunityLineItems/view`
    }
    openOppLineItemRecordPage(event){
        let id = event.currentTarget.dataset.id;
        this.linkRefOppLineItem = `/${id}`
        console.log('OUTPUT : id',id);
    }
}
