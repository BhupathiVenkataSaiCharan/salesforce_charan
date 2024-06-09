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
            var action = component.get('c.deleteRecord');
            const recordId = component.get("v.selectedRecordId");
            console.log('Record ID to delete: ', recordId);
            action.setParams({
                "recordId": recordId
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(`result: ${result}`);
                    alert(`result: ${result}`);
                } else {
                    console.error("Failed with state: " + state);
                }
            });
            $A.enqueueAction(action);
        } catch (error) {
            console.error("An unexpected error occurred: ", error);
        }
    }
})