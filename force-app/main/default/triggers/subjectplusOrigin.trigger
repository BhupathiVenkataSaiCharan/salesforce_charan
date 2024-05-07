trigger subjectplusOrigin on Case (before insert) {
    
    for(Case cs:trigger.new){
        cs.Subject=cs.Subject + '-' + cs.Origin;
    }
}