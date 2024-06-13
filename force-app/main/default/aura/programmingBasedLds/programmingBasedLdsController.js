({
    doInit : function(component, event, helper) {
        // alert('Hello from Init');
        component.find("recordData").getNewRecord(
            "Contact",
            null,
            false,
            $A.getCallback(function(){})
        );
    },
    handleSubmit : function(component,event,helper){
        component.find("recordData").saveRecord(function(saveresult){
            //for toast
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "The record has been created successfully.",
                "type":"success"
            });
            toastEvent.fire();
        });
    }
})