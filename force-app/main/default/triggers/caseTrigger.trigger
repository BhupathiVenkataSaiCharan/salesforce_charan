trigger caseTrigger on Case (before insert, after insert) {
    switch on trigger.OperationType{

        when BEFORE_INSERT{
            // caseTriggerHandler.onCaseOrigin(trigger.new);
        }
        when AFTER_INSERT{
            caseTriggerHandler.sendLatestCaseNumber(trigger.new);
        }
    }
}