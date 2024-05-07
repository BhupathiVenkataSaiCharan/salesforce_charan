trigger LeadTrigger on Lead (before insert) {
    switch on trigger.OperationType{

        when BEFORE_INSERT{
            LeadTriggerHandler.onLeadSource(trigger.new);
        }
    }
}