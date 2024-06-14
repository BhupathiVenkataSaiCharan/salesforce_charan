// Import necessary modules
import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/getObjectRecords.getAccounts';
import getAccountsCount from '@salesforce/apex/getObjectRecords.getAccountsCount';
import deleteRecord from '@salesforce/apex/getObjectRecords.deleteRecord';

import {refreshApex} from '@salesforce/apex';


// Define actions for row actions column
const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

// Define columns for the datatable
const columns = [
    { label: 'Index', fieldName: 'serialNumber', type: 'number' },
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name', editable: true },
    { label: 'Industry', fieldName: 'Industry', editable: true },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];
export default class DisplayObjectRecords extends LightningElement {
    @track data;
    columns = columns;
    searchName = '';
    @track currentPage = 1;
    @track totalRecords = 0;
    pageSize = 10;

    showEdit = false;
    showDelete = false;
    selectedRecordId = '';
    refreshedData;

    // Wire method to fetch total count of accounts
    @wire(getAccountsCount, { accName: '$searchName' })
    wiredAccountCount({ error, data }) {
        if (data) {
            this.totalRecords = data;
        } else if (error) {
            console.error('Error fetching account count:', error);
        }
    }

    // Wire method to fetch accounts based on search and pagination
    @wire(getAccounts, { accName: '$searchName', pageNumber: '$currentPage', pageSize: '$pageSize' })
    wiredAccounts(result) {
        this.refreshedData = result;
        if (result.data) {
            this.data = result.data.map((item, index) => ({
                ...item,
                serialNumber: (this.currentPage - 1) * this.pageSize + index + 1
            }));
        } else if (result.error) {
            console.error('Error fetching accounts:', result.error);
        }
    }

    // Handle search input change
    handleName(event) {
        this.searchName = event.target.value;
        this.currentPage = 1; // Reset to first page when searching
    }

    // Handle previous page navigation
    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
        }
    }

    // Handle next page navigation
    handleNext() {
        if (this.currentPage < Math.ceil(this.totalRecords / this.pageSize)) {
            this.currentPage += 1;
        }
    }

    // Determine if previous button should be disabled
    get isPreviousDisabled() {
        return this.currentPage <= 1;
    }

    // Determine if next button should be disabled
    get isNextDisabled() {
        return this.currentPage >= Math.ceil(this.totalRecords / this.pageSize);
    }  

    // Handle row action (edit or delete)
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'edit':
                this.showEdit = true;
                this.selectedRecordId = row.Id;
                break;
            case 'delete':
                this.showDelete = true;
                this.selectedRecordId = row.Id;
                break;
            default:
        }
    }

    // Confirm delete operation
    confirmDelete() {
        deleteRecord({ recordId: this.selectedRecordId })
            .then(() => {
                console.log('Record deleted successfully');
                this.closeDelete();
                refreshApex(this.refreshedData);
            })
            .catch(error => {
                console.error('Error deleting record:', error);
                this.closeDelete();
            });
    }

    // Close delete modal
    closeDelete() {
        this.showDelete = false;
        this.selectedRecordId = '';
    }

    updateRecord(){
        this.showEdit = false;
        refreshApex(this.refreshedData);
    }
}
