({
    showme : function(component, event, helper) {

        component.set("v.coll",[
            {label:"First Name", fieldName:'FirstName',type:'text'},
            {label:"Last Name", fieldName:'LastName',type:'text'},
            {label:"Email", fieldName:'Email',type:'email'},
            {label:"Phone", fieldName:'Phone',type:'phone'}
        ]);

        var action = component.get("c.getcon");
        var acid = event.getParam("accID");
        action.setParams({"accid":acid});
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.data",result);
            }
        });
        $A.enqueueAction(action);
    }   
})