trigger emailphoneMandatory on Lead (before insert, before update) {

    for(Lead ld:trigger.new){
        
        if(ld.Email==null){
            ld.Email.addError('Email field is mandatory');
        }else if(ld.Phone==null){
            ld.Phone.addError('Phone field is mandatory');
        }else{}
    }
}