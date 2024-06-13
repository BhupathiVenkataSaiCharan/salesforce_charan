({
    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        var recordEditForm = component.find("recordEditForm");
        recordEditForm.submit();
    }
})