({
    doInit : function(component, event, helper) {
        helper.getStageNameHelper(component, event, helper);
    },

    stagePicklistSelect : function(component, event, helper) {
        var stepName = event.getParam("detail").value;
        component.set("v.selectedStage", stepName);
    },

    markStatusComplete : function(component, event, helper) {
        var selectedStage = component.get("v.selectedStage");
        if(selectedStage) {
            component.set("v.stagePicklistField.StageName", selectedStage);

            component.find("record").saveRecord(
                $A.getCallback(function(response) {
                    if(response.state === "SUCCESS") {
                        $A.get('e.force:refreshView').fire();
                    } else {
                        console.error("Error saving record:", response);
                    }
                })
            );
        } else {
            alert('Please select a stage before marking it complete.');
        }
    }
})
