({
    getAccList : function(component, event, helper) {
        var action = component.get('c.accListData');
        var pageSize = component.get("v.pageSize");
        var currentPage = component.get("v.currentPage");
        var searchKeyword = component.get('v.searchKeyword');
        action.setParams({
            "pageSize": pageSize,
            "pageNumber": currentPage,
            "searchKeyword":searchKeyword
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var accounts = result.accounts;

                // Calculate the starting index based on current page and page size
                var startingIndex = (currentPage - 1) * pageSize + 1;

                // Add index to each account record
                accounts.forEach(function(account, index) {
                    account.index = startingIndex + index;
                });

                component.set('v.account', accounts);
                component.set('v.totalPages', Math.ceil(result.totalCount / pageSize));
                console.log('total pages:', Math.ceil(result.totalCount / pageSize));
            } else {
                console.error("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    getAccField : function(component, event, helper) {

        const actions = [
            {label:'Edit',name:'Edit'},
            {label:'Delete', name:'Delete'}
        ]
        const columns = [
            { label: 'Index', fieldName: 'index', type: 'number' },
            { label: 'Id', fieldName: 'Id' },
            { label: 'Account Name', fieldName: 'Name'},
            {
                type:'action',
                typeAttributes:{rowActions : actions}
            }
        ];
        component.set('v.mycolumns', columns);
    },

    deleteSelectedRecord: function(component) {
        try {
            const recordId = component.get("v.selectedRecordId");
            console.log('Record ID to delete: ', recordId);

            if (recordId) {
                const recordLoader = component.find("recordLoader");

                // Check if the record loader component is valid
                if (recordLoader) {
                    recordLoader.deleteRecord($A.getCallback(function(deleteResult) {
                        console.log('deleteResult: ', deleteResult);

                        if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                            console.log("Record is deleted successfully.");
                            // Optionally, refresh the datatable or perform any other actions
                        } else if (deleteResult.state === "INCOMPLETE") {
                            console.error("User is offline, device doesn't support drafts.");
                        } else if (deleteResult.state === "ERROR") {
                            console.error("Problem deleting record, error: " + JSON.stringify(deleteResult.error));
                        } else {
                            console.error("Unknown problem, state: " + deleteResult.state + ", error: " + JSON.stringify(deleteResult.error));
                        }
                    }));
                } else {
                    console.error("Record loader component not found.");
                }
            } else {
                console.error("No record ID is set for deletion.");
            }
        } catch (error) {
            console.error("An unexpected error occurred: ", error);
        }
    }
    
})