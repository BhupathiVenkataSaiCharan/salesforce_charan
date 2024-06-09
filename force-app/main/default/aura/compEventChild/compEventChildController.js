({
    callme : function(component, event, helper) {

        var a = component.get("v.cacc");

        var evt = component.getEvent("sona");

        evt.setParams({"eacc":a});
        evt.fire(); 
    }
})
