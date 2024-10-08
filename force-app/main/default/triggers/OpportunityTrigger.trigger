trigger OpportunityTrigger on Opportunity (before insert, after insert,before update,after update,before delete,after delete) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{
            // OpportunityTriggerHandler.addDescription(trigger.new);
            // OpportunityTriggerHandler.nullAmount(trigger.new);
            // OpportunityTriggerHandler.closedLostReason(trigger.new);
            
        }
        when AFTER_INSERT{
            // OpportunityTriggerHandler.sendLatestAmount(trigger.new);
            // OpportunityTriggerHandler.OppClosedWonCountInAcc(trigger.new);
            // OpportunityTriggerHandler.highestAmountOppName(trigger.new);
            // OpportunityTriggerHandler.highestAndLowestOppAmount(trigger.new);
            // OpportunityTriggerHandler.countCloseWonOpps(trigger.new);
            // OpportunityTriggerHandler.recentOpportunityAmount(trigger.new);
        }
        when BEFORE_UPDATE{
            // OpportunityTriggerHandler.closedLostReason(trigger.new);
        }
        when AFTER_UPDATE{
            // OpportunityTriggerHandler.OppClosedWonCountInAcc(trigger.new);
            // OpportunityTriggerHandler.highestAmountOppName(trigger.new);
            // OpportunityTriggerHandler.highestAndLowestOppAmount(trigger.new);
            // OpportunityTriggerHandler.countCloseWonOpps(trigger.new);
            // OpportunityTriggerHandler.recentOpportunityAmount(trigger.new);
        }
        when BEFORE_DELETE{
            // OpportunityTriggerHandler.allowDeletion(trigger.old);
            // OpportunityTriggerHandler.preventOppDeleteIfClosed(trigger.old); 
        }
        when AFTER_DELETE{
            // OpportunityTriggerHandler.highestAmountOppName(trigger.old);
            // OpportunityTriggerHandler.OppClosedWonCountInAcc(trigger.new);
            // OpportunityTriggerHandler.highestAndLowestOppAmount(trigger.old);
            // OpportunityTriggerHandler.countCloseWonOpps(trigger.old);
            // OpportunityTriggerHandler.recentOpportunityAmount(trigger.old);
        }
    }
}