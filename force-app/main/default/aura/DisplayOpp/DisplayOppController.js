({
    showme : function(component, event, helper) {

        component.set("v.coll",[
            {label:"Opp Name", fieldName:'Name',type:'text'},
            {label:"Stage Name", fieldName:'Stage Name',type:'text'},
            {label:"Close Date", fieldName:'CloseDate',type:'date'},
            {label:"Amount", fieldName:'Amount',type:'currency'}
        ]);

        var action = component.get("c.getopp");
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
