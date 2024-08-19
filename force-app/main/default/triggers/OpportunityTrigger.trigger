trigger OpportunityTrigger on Opportunity (before insert, after insert,after update,before delete) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{
            // OpportunityTriggerHandler.addDescription(trigger.new);
            OpportunityTriggerHandler.nullAmount(trigger.new);

        }
        when AFTER_INSERT{
            // OpportunityTriggerHandler.sendLatestAmount(trigger.new);
            OpportunityTriggerHandler.OppClosedWonCountInAcc(trigger.new);
        }
        when AFTER_UPDATE{
            OpportunityTriggerHandler.OppClosedWonCountInAcc(trigger.new);
        }
        when BEFORE_DELETE{
            // OpportunityTriggerHandler.allowDeletion(trigger.old);
        }
        when AFTER_DELETE{
            OpportunityTriggerHandler.OppClosedWonCountInAcc(trigger.new);
        }
    }
}