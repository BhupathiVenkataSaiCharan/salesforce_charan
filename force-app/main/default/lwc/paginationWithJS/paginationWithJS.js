import { LightningElement, wire } from 'lwc';
import getAccountRecords from '@salesforce/apex/paginationWithJS.getAccountRecords';


const colums = [
    {label:'Id', fieldName:'Id'},
    {label:'Name', fieldName:'Name'},
    {label:'Industry', fieldName:'Industry'},
];


export default class PaginationWithJS extends LightningElement {
    
    searchKey = '';         //search value for wire
    columns = colums;       //create colums from JS
    
    accounts;               // store accounts from wire
    error;                  // store error from wire

    totalRecords = 0;       //to store total no.of records count
    currentPage = 1;        //current Page number
    pageSize = 10;          //to show 10 records per page
    totalPages;             //Total no.of pages
    offSet;                 

    currentPageAccounts;    //new list to pass in data table after slice
    

    @wire(getAccountRecords,{searchValue : "$searchKey"})
    getRecords({data,error}){
        if(data){
            this.accounts = data;
            this.totalRecords = data.length;
            console.log('count ::', this.accountsCount);
            this.getCurrentPageRecords();
        }else{
            this.error = error;
        }
    }

    // handle onchange event for search
    handleSearch(event){
        this.searchKey = event.target.value;
        this.currentPage = 1;
    }


    get bDisableFirst() {
        return this.currentPage == 1;
    }
    get bDisableLast() {
        return this.currentPage == this.totalPages;
    }

    
    previousPage(){
        this.currentPage -= 1;
        this.getCurrentPageRecords();
    }
    
    nextPage(){
        this.currentPage += 1;
        this.getCurrentPageRecords();
    }
    
    // firstPage(){
    //     this.currentPage = 1;
    // }

    // lastPage(){
    //     this.currentPage = this.totalPages;
    // }

    getCurrentPageRecords(){
        this.totalPages = this.totalRecords!=0 ? Math.ceil(this.totalRecords / this.pageSize) : 1;
        this.offSet = (this.currentPage - 1) * this.pageSize;
        console.log('offset::', this.offSet);
        console.log('currentPage::', this.currentPage);
        console.log('pageSize::', this.pageSize);
        this.currentPageAccounts = this.accounts?.slice(this.offSet,(this.currentPage)*this.pageSize);
        console.log('slice::',JSON.stringify(this.accounts));
    }

}