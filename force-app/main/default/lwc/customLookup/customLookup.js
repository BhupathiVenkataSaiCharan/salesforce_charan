import { LightningElement,api,track } from 'lwc';
import fetchRecords from '@salesforce/apex/CustomLookupController.fetchRecords';
const DELAY = 500;
export default class CustomLookup extends LightningElement {
    @api helpText;
    @api label;
    @api required;
    @api selectedIconName = "standard:account";
    @api objectLabel;
    @api rowIndex;
    @api createRecord = false;
    @api disabled = false;
    @api bubbles =false;
    @track hideLabel =false;
    openCreateForm = false;
    recordsList = [];
    selectedRecordName;

    @api objectApiName;
    @api fieldApiName;
    @api otherFieldApiName;
    @api searchString = "";
    @api selectedRecordId = "";
    @api parentRecordId;
    @api parentFieldApiName;
    @api filterCriteria
    @track noRecords = false;
    preventClosingOfSerachPanel = false;

    get methodInput() {
        return {
            objectApiName: this.objectApiName,
            fieldApiName: this.fieldApiName,
            otherFieldApiName: this.otherFieldApiName,
            searchString: this.searchString,
            selectedRecordId: this.selectedRecordId,
            parentRecordId: this.parentRecordId,
            parentFieldApiName: this.parentFieldApiName,
            filterCriteria: this.filterCriteria
        };
    }

    get showRecentRecords() {
        if (!this.recordsList) {
            if(this.openCreateForm){
                return true;
            }
            else{
                return false;
            }
        }
        else if(this.recordsList.length > 0 || this.openCreateForm || this.noRecords) {
            return true;
        }
        else{
            return false;
        }
    }
    //getting the default selected record
    connectedCallback() {
        if (this.selectedRecordId) {
            this.fetchSobjectRecords(true);
        }
        if(this.label){
            this.hideLabel=false;
        }
        else{
            this.hideLabel=true;
        }
    }

    //call the apex method
    fetchSobjectRecords(loadEvent) {
        fetchRecords({
            inputWrapper: this.methodInput
        }).then(result => {
            if(result.length==0){
                this.noRecords = true;
            }
            else{
                this.noRecords = false;
            }
            if (loadEvent && result) {
                this.selectedRecordName = result[0].mainField;
                let selectedRecord = {
                    mainField: result[0].mainField,
                    subField: result[0].subfield,
                    id: result[0].id
                };
                if(this.bubbles){
                    const selectedEvent = new CustomEvent('valueselected', {
                        detail: {selectedRecord},
                        bubbles: true,
                        composed: true,
                        cancelable: true
                    });
                    //dispatching the custom event
                    this.dispatchEvent(selectedEvent);
                }
                else{
                    const selectedEvent = new CustomEvent('valueselected', {
                        detail: selectedRecord
                    });
                    //dispatching the custom event
                    this.dispatchEvent(selectedEvent);
                }
            } else if (result) {
                this.recordsList = JSON.parse(JSON.stringify(result));
            } else {
                this.recordsList = [];
            }
        }).catch(error => {
            console.log(error);
        })
    }

    get isValueSelected() {
        return this.selectedRecordId;
    }

    //handler for calling apex when user change the value in lookup
    handleChange(event) {
        this.searchString = event.target.value;
        this.fetchSobjectRecords(false);
        if(this.createRecord){
            this.openCreateForm = true;
        }
    }

    //handler for clicking outside the selection panel
    handleBlur() {
        this.recordsList = [];
        this.preventClosingOfSerachPanel = false;
        this.noRecords = false;
    }

    //handle the click inside the search panel to prevent it getting closed
    handleDivClick() {
        this.preventClosingOfSerachPanel = true;
    }

    //handler for deselection of the selected item
    handleCommit() {
        this.selectedRecordId = "";
        this.selectedRecordName = "";
        const closeEvent = new CustomEvent('closeevent', {
            detail: 'close'
        });
        this.dispatchEvent(closeEvent);
    }

    //handler for selection of records from lookup result list
    handleSelect(event) {
        let selectedRecord = {
            mainField: event.currentTarget.dataset.mainfield,
            subField: event.currentTarget.dataset.subfield,
            id: event.currentTarget.dataset.id,
            rowIndex:this.rowIndex
        };
        this.selectedRecordId = selectedRecord.id;
        this.selectedRecordName = selectedRecord.mainField;
        this.recordsList = [];
        this.noRecords=false;
        // Creates the event
        if(this.bubbles){
            const selectedEvent = new CustomEvent('valueselected', {
                detail: {selectedRecord},
                bubbles: true,
                composed: true,
                cancelable: true
            });
            //dispatching the custom event
            this.dispatchEvent(selectedEvent);
        }
        else{
            const selectedEvent = new CustomEvent('valueselected', {
                detail: selectedRecord
            });
            //dispatching the custom event
            this.dispatchEvent(selectedEvent);
        }
        
    }
    
    //to close the search panel when clicked outside of search input
    handleInputBlur(event) {
        // Debouncing this method: Do not actually invoke the Apex call as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            if (!this.preventClosingOfSerachPanel) {
                this.recordsList = [];
            }
            this.preventClosingOfSerachPanel = false;
            this.openCreateForm = false;
            this.noRecords = false;
        }, DELAY);
    }
    handleNewRecord(event){
        const newEvent = new CustomEvent('newrecordevent', {
            detail: true
        });
        //dispatching the custom event
        this.dispatchEvent(newEvent);
    }
    @api handleAutoSelect(recordId){
        this.selectedRecordId = recordId;
        this.fetchSobjectRecords(true);
        this.recordsList = [];
    }
}