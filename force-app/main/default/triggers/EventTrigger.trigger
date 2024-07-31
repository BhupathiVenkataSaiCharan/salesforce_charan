trigger EventTrigger on Event (before insert, before update) {
    
    switch on trigger.OperationType {
        when BEFORE_INSERT{
            EventTriggerHandler.assignCustomField(Trigger.new);
        }
        when BEFORE_UPDATE{
            EventTriggerHandler.assignCustomField(Trigger.new);
        }
    }
}