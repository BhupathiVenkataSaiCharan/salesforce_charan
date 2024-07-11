import { LightningElement, wire, api, track } from 'lwc';
import getProductsRecords from '@salesforce/apex/AddProductsFunctionalityInOpportunity.getProductsRecords';
import saveOpportunityProducts from '@salesforce/apex/AddProductsFunctionalityInOpportunity.saveOpportunityProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddProductsFunctionalityInOpportunity extends LightningElement {
    @api opportunityId;
    @track showAdd = false;
    @track showEdit = false;
    @track data;
    @track error;
    @track selectedRows = [];
    @track editList = [];

    columns = [
        { label: 'Product Name', fieldName: 'Name' },
        { label: 'Product Code', fieldName: 'ProductCode' },
        { label: 'List Price', fieldName: 'UnitPrice' },
    ];

    @wire(getProductsRecords)
    recievedProducts({ data, error }) {
        if (data) {
            this.data = data.map(product => ({ ...product, Quantity: 1, TotalPrice: product.UnitPrice }));
        } else {
            this.error = error;
        }
    }

    handleRowSelection(event) {
        this.selectedRows = event.detail.selectedRows;
        this.editList = this.selectedRows.map(row => ({
            ...row,
            Quantity: 1,
            TotalPrice: row.UnitPrice
        }));
    }

    handleQuantityChange(event) {
        const productId = event.target.dataset.id;
        const quantity = event.target.value;
        const productIndex = this.editList.findIndex(item => item.Id === productId);
        if (productIndex !== -1) {
            this.editList[productIndex].Quantity = quantity;
            this.editList[productIndex].TotalPrice = this.editList[productIndex].UnitPrice * quantity;
        }
        this.editList = [...this.editList]; // Ensure reactivity
    }

    closeModal() {
        this.showAdd = false;
        this.showEdit = false;
    }

    showAddProducts() {
        this.showAdd = true;
    }

    goToEditProducts() {
        this.showAdd = false;
        this.showEdit = true;
    }

    goToAddProducts() {
        this.showAdd = true;
        this.showEdit = false;
    }

    saveProductsList() {
        const products = this.editList.map(product => ({
            productId: product.Id,
            quantity: product.Quantity
        }));
    
        console.log('Products to save:', JSON.stringify(products)); // Log products before sending to Apex
    
        this.showToast('Success', 'Products Added successfully', 'success');
        this.closeModal();
            
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}
