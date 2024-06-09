({
    doInit: function(component, event, helper) {
        helper.getAccList(component);
        helper.getAccField(component);
    },

    firstPage: function(component, event, helper) {
        component.set("v.currentPage", 1);
        helper.getAccList(component);
    },

    previousPage: function(component, event, helper) {
        var currentPage = component.get("v.currentPage");
        console.log('current page' + currentPage);
        component.set("v.currentPage", Math.max(1, currentPage - 1));
        helper.getAccList(component);
    },

    nextPage: function(component, event, helper) {
        var currentPage = component.get("v.currentPage");
        console.log('current page' + currentPage);
        component.set("v.currentPage", Math.min(currentPage + 1, component.get("v.totalPages")));
        helper.getAccList(component);
    },

    lastPage: function(component, event, helper) {
        component.set("v.currentPage", component.get("v.totalPages"));
        helper.getAccList(component);
    },

    searchAccounts: function(component, event, helper) {
        component.set("v.currentPage", 1); // Reset pagination to the first page
        helper.getAccList(component);
    },

    handleRowAction: function(component, event, helper) {
        // Log the event object
        console.log('event', event);

        // Retrieve the action details
        const action = event.getParam('action');
        const row = event.getParam('row');

        // Log the action and row details
        console.log('action', JSON.stringify(action));
        console.log('row.Id: ', row.Id);

        // Determine the action name and handle accordingly
        const actionName = action.name;
        switch (actionName) {
            case "Edit":
                component.set("v.showEdit", true);
                component.set("v.selectedRecordId", row.Id);
                // Handle the Edit action (if any logic is needed)
                break;
            case "Delete":
                // Handle the Delete action
                console.log('inside delete');
                component.set("v.showDelete", true);
                component.set("v.selectedRecordId", row.Id);
                console.log('delete clicked', component.get("v.showDelete"));
                break;
        }
    },

    confirmDelete: function(component, event, helper) {
        component.set("v.showDelete", false);
        console.log("DELETED JS");
        helper.deleteSelectedRecord(component);
        helper.getAccList(component);
    },
    updateRecord: function(component,event,helper){
        console.log('Record Updated');
        component.set("v.showEdit", false);
        helper.getAccList(component);
    }, 
    closeEditModal: function(component, event, helper) {
        component.set("v.showEdit", false);
    },
    closeDeleteModal: function(component, event, helper) {
        component.set("v.showDelete", false);
    },
})