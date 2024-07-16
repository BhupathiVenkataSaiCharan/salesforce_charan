import { LightningElement, track, wire } from 'lwc';
import getRecords from '@salesforce/apex/CustomOpportunityCRUDController.getRecords';
import saveRecords from '@salesforce/apex/CustomOpportunityCRUDController.saveRecords';
import deleteRecords from '@salesforce/apex/CustomOpportunityCRUDController.deleteRecords';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomOpportunityCRUD extends LightningElement {
    @track rows=[];
    deletedRowIds = [];

    handleAddRow(){
        const newRow = {
            index : this.rows.length + 1,
            Name : ''
        }
        this.rows = [...this.rows,newRow];
    }

    handleRemove(event){
        try {
            const rowIndex = parseInt(event.target.dataset.id,10);

            this.rows = this.rows.map((row, index) => {
                if(row.index != rowIndex){
                    return row;
                }else{
                    const rowId = row?.Id;
                    if(rowId != undefined){
                        this.deletedRowIds = [...this.deletedRowIds,rowId];
                    }
                }
                return null;
            }).filter(row => row !== null); // Filter out the null values if you intend to remove the rows
            
        } catch (error) {
            console.error('error: ', JSON.stringify(error));
        }
    }

    handleNameChange(event){
        const rowId = event.target.dataset.id;
        const updatedName = event.target.value;

        this.rows = this.rows.map(row=>{
            if(row.index == rowId){
                return {...row, Name: updatedName};
            }
            return row;
        })
    }

    handleSave(){

        if(this.deletedRowIds){
            deleteRecords({recordIds : this.deletedRowIds})
                .then((result)=>{
                    console.log(' delete result :::', result);
                    this.dispatchEvent(new RefreshEvent());
                })
                .catch(error=>{})
        }
        console.log('rows:::', JSON.stringify(this.rows));
        saveRecords({records : this.rows})
        .then((result)=>{
            console.log('save result :::', result);
            this.dispatchEvent(new RefreshEvent());
            this.showToast('SUCCESS','Records saved successfully','success');   
        })
        .catch(error=>{})
    }


    @wire(getRecords)
    wiredRecords({data,error}){

        if(data){
            this.rows = data.map((row, index) => ({
                Id: row.Id,
                index: index + 1,
                Name: row.Name
            }));
        }else{
            console.error('Error loading records', error);
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

}