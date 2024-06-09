({
    callme: function(component, event, helper) {
        // Get the account data from the component
        var a = component.get("v.cacc");

        // Create a server-side action to insert the account
        var action = component.get("c.createAcc");
        action.setParams({ "A": a });

        // Set the callback for the action
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (result !== 'Error') {
                    // Fire the custom event to refresh the account list in the parent component
                    var evt = component.getEvent("sona");
                    evt.fire();
                }
            } else {
                console.log('Failed to create account: ' + response.getError());
            }
        });

        // Enqueue the action
        $A.enqueueAction(action);
    }
})











/*({
    callme : function(component, event, helper) {

        // var a = component.get("v.cacc");

        // var evt = component.getEvent("sona");

        // evt.setParams({"eacc":a});
        // evt.fire(); 

        var a = component.get("v.cacc");
        var evt = component.getEvent("sona");
        var action = component.get("c.createAcc");
        action.setParams({"A":a});

        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var result=response.getReturnValue();
                if(result!= 'Error'){
                    evt.fire();
                }
            }
        });

        $A.enqueueAction(action);
    }
})
*/