({
    doInit : function(component, event, helper) {
        helper.getAccList(component);
        helper.getAccField(component);
    },
    firstPage : function(component, event, helper) {
        component.set("v.currentPage", 1);
        helper.getAccList(component);
    },

    previousPage : function(component, event, helper) {
        var currentPage = component.get("v.currentPage");
        console.log('current page' +currentPage);
        component.set("v.currentPage", Math.max(1, currentPage - 1));
        helper.getAccList(component);
    },

    nextPage : function(component, event, helper) {
        var currentPage = component.get("v.currentPage");
        console.log('current page' +currentPage);
        component.set("v.currentPage", Math.min(currentPage + 1, component.get("v.totalPages")));
        helper.getAccList(component);
    },

    lastPage : function(component, event, helper) {
        component.set("v.currentPage", component.get("v.totalPages"));
        helper.getAccList(component);
    },
    searchAccounts : function(component, event, helper) {
        component.set("v.currentPage", 1); // Reset pagination to the first page
        helper.getAccList(component);
    }
})