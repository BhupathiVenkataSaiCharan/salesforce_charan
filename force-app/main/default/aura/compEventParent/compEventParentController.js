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
        
        var ea = event.getParam("eacc"); // Get data from event
        var accounts = component.get("v.accounts"); // Get existing accounts
        accounts.push({ ...ea }); // Create a new object using the spread operator and push to list
        component.set("v.accounts", accounts); // Update component's account list
    }
})
