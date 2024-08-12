trigger LeadTrigger on Lead (before insert, before update) {
    switch on trigger.OperationType{

        when BEFORE_INSERT{
            // LeadTriggerHandler.onLeadSource(trigger.new);
            LeadTriggerHandler.checkDuplicateNameEmail(trigger.new);
        }
    }
}