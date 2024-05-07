trigger PositionTrigger on Position__c (before insert) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{
            PositionTriggerHandler.autoFill(trigger.new);
        }
    }
}