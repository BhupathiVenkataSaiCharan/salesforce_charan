import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/getObjectRecords.getAccounts';
import getAccountsCount from '@salesforce/apex/getObjectRecords.getAccountsCount';

const columns = [
    { label: 'Index', fieldName: 'serialNumber', type: 'number' }, // New column for serial number
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name' },
    { label: 'Industry', fieldName: 'Industry' }
];

export default class DisplayObjectRecords extends LightningElement {
    @track data;
    columns = columns;
    searchName = '';
    @track currentPage = 1;
    @track totalRecords = 0;
    pageSize = 10;

    handleName(event) {
        this.searchName = event.target.value;
        this.currentPage = 1;
        this.loadAccounts();
    }

    loadAccounts() {
        getAccountsCount({ accName: this.searchName })
            .then(result => {
                this.totalRecords = result;
                return getAccounts({ accName: this.searchName, pageNumber: this.currentPage, pageSize: this.pageSize });
            })
            .then(result => {
                // Add serial number to each record
                this.data = result.map((item, index) => ({
                    ...item,
                    serialNumber: (this.currentPage - 1) * this.pageSize + index + 1
                }));
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
            this.loadAccounts();
        }
    }

    handleNext() {
        if (this.currentPage < Math.ceil(this.totalRecords / this.pageSize)) {
            this.currentPage += 1;
            this.loadAccounts();
        }
    }

    connectedCallback() {
        this.loadAccounts();
    }

    get isPreviousDisabled() {
        return this.currentPage <= 1;
    }

    get isNextDisabled() {
        return this.currentPage >= Math.ceil(this.totalRecords / this.pageSize);
    }
}
