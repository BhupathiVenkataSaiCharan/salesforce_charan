({
    showme : function(component, event, helper) {

        var params = event.getParam("arguments");

        var nnn = params.mempname;
        var aaa = params.mempage;
        var ddd = params.mempdob;

        component.set("v.cempname",nnn);
        component.set("v.cempage",aaa);
        component.set("v.cempdob",ddd);

    }
})