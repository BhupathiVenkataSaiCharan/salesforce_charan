({
    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        var recordEditForm = component.find("recordEditForm");
        recordEditForm.submit();
    },
    handleDelete : function (component,event,helper) {
        var recordId = component.get("recordId");
        var recorddata
    }
})
