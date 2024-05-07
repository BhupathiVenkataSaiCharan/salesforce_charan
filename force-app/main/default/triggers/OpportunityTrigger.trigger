trigger OpportunityTrigger on Opportunity (before insert, after insert,before delete) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{
            // OpportunityTriggerHandler.addDescription(trigger.new);
            OpportunityTriggerHandler.nullAmount(trigger.new);

        }
        when AFTER_INSERT{
            // OpportunityTriggerHandler.sendLatestAmount(trigger.new);
        }
        when BEFORE_DELETE{
            OpportunityTriggerHandler.allowDeletion(trigger.old);
        }
    }
}