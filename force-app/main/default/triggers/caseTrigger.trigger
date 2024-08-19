trigger caseTrigger on Case (before insert, after insert) {
    switch on trigger.OperationType{

        when BEFORE_INSERT{
            // caseTriggerHandler.originBasedStatusPriority(trigger.new);
        }
        when AFTER_INSERT{
            caseTriggerHandler.latestCaseNumberOnAccount(trigger.new);
        }
    }
}