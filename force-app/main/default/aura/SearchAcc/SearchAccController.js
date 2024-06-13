({
    clickme : function(component, event, helper) {

        var acnm = component.get("v.accNm");
        var acind = component.get("v.accIndust");

        var action = component.get("c.searchAcc");

        action.setParams({"accName":acnm,"accIndustry":acind});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state == 'SUCCESS'){
                var result=response.getReturnValue();
                if(result !='NoData'){
                    var evt = $A.get("e.c:SearchAccDisplayConOpp");
                    evt.setParams({"accID":result});
                    evt.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})