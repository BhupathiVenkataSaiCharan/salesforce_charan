({
    doInit: function(component, event, helper) {
        // Initialize the columns for the datatable
        var columns = [
            {label: 'Account Name', fieldName: 'Name'},
            {label: 'Account Phone', fieldName: 'Phone', type: 'phone'},
            {label: 'Account Industry', fieldName: 'Industry'}
        ];
        component.set("v.col", columns);

        // Load existing accounts on initialization
        var action = component.get("c.displayAcc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                component.set("v.accounts", response.getReturnValue());
            } else {
                console.log('Failed to retrieve accounts: ' + response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    showme: function(component, event, helper) {
        // Retrieve and display the updated list of accounts
        var action = component.get("c.displayAcc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var accounts = response.getReturnValue();
                component.set("v.accounts", accounts);
            } else {
                console.log('Failed to retrieve accounts: ' + response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})






/*
({
    doInit : function(component, event, helper) {

        var c = [
            {label:'Account Name', fieldName:'Name'},
            {label:'Account Phone', fieldName:'Phone',type:'phone'},
            {label:'Account Industry', fieldName:'Industry'}
        ];
        component.set("v.col",c);
    },
    showme: function (component,event,helper) {
        
        /*
        var ea = event.getParam("eacc"); // Get data from event
        var accounts = component.get("v.accounts"); // Get existing accounts from component(first time null)
        accounts.push({ ...ea }); // Create a new object using the spread operator and push to list
        component.set("v.accounts", accounts); // Update component's account list
        */

        // var action = component.get("c.displayAcc");
        // action.setCallback(this,function(response){
        //     var state = response.getState();
        //     if(state == 'SUCCESS'){
        //         var Result=response.getReturnValue();
        //         component.set("v.accounts",Result);
        //     }
        // });
        // $A.enqueueAction(action);
//     }
// })