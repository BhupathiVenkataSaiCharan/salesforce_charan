({
    fireComponentEvent : function(component, event, helper) {
        var componentEvent = component.getEvent('cmpEvent');
        var messageString = component.get("v.messageString");
        messageString = $A.util.isEmpty(messageString) ? "No message passed" : messageString;

        componentEvent.setParams({
            "message":messageString,
            "label":"Aman"
        })
        console.log('componentEvent: ', componentEvent);
        componentEvent.fire();
        console.log('componentEvent: ', componentEvent);
    }
})