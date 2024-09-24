trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    switch on trigger.OperationType{
        when BEFORE_INSERT{}
        
        when AFTER_INSERT{
            OpportunityLineItemTriggerHandler.updateOLICountOnAccount(trigger.new);   
        }
        
        when BEFORE_UPDATE{}
        when AFTER_UPDATE{}
        when BEFORE_DELETE{}
        when AFTER_DELETE{}
        when AFTER_UNDELETE{}
    }
}