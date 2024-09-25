trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    switch on trigger.OperationType{
        when BEFORE_INSERT{}
        
        when AFTER_INSERT{
            // OpportunityLineItemTriggerHandler.updateOLICountOnAccount(trigger.new);   
            OpportunityLineItemTriggerHandler.updateOliCntOnAccWithMultipleOpps(trigger.new);
            System.debug('CCC after insert');   
        }
        
        when BEFORE_UPDATE{}
        
        when AFTER_UPDATE{
            OpportunityLineItemTriggerHandler.updateOliCntOnAccWithMultipleOpps(trigger.new);
            System.debug('CCC after update');
        }
        
        when BEFORE_DELETE{}
        
        when AFTER_DELETE{
            OpportunityLineItemTriggerHandler.updateOliCntOnAccWithMultipleOpps(trigger.old);
            System.debug('CCC after delete');
        }
        
        when AFTER_UNDELETE{}
    }
}