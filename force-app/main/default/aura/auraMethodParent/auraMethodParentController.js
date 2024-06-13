({
    callme : function(component, event, helper) {

        var nm = component.get("v.pempname");
        var ag = component.get("v.pempage");
        var dob = component.get("v.pempdob");

        var cp = component.find("childcomp");
        cp.showempdet(nm,ag,dob);
    }
})