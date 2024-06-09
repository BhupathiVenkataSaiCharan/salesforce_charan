import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/getObjectRecords.getAccounts';
import getTotalAccountCount from '@salesforce/apex/getObjectRecords.getTotalAccountCount';

const columns = [
    { label: 'Index', fieldName: 'index' },
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name' }
];

export default class DisplayObjectRecords extends LightningElement {
    data;
    columns = columns;
    error;
    pageSize = 10;
    currentPage = 1;
    totalRecords;
    totalPages;
    isPrevDisabled = true;
    isNextDisabled = false;

    @wire(getTotalAccountCount)
    wiredTotal({ error, data }) {
        if (data) {
            this.totalRecords = data;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.updateButtonStatus();
        } else{
            this.error = error;
        }
    }

    @wire(getAccounts,{limitSize: `$pageSize`, offset: `{($currentPage - 1) * $pageSize}`})
    wiredAccounts({error,data}){
        if (data) {
            this.data = result.map((account, index) => {
                return { 
                    ...account, 
                    index: (this.currentPage - 1) * this.pageSize + index + 1 
                };
            });
            this.error = undefined;
            this.updateButtonStatus();
        } else{
            this.error = error;
            this.data = undefined;
        }
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage += 1;

        }
    }

    handlePrev() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
        }
    }

    updateButtonStatus() {
        this.isPrevDisabled = (this.currentPage <= 1);
        this.isNextDisabled = (this.currentPage >= this.totalPages);
    }
}
