trigger TaskTrigger on Task (before insert, before update) {

    switch on trigger.OperationType{
       
        when BEFORE_INSERT{
            TaskTriggerHandler.assignCustomField(Trigger.new);
        }
        when AFTER_INSERT{
            
        }
        when BEFORE_UPDATE{
            TaskTriggerHandler.assignCustomField(Trigger.new);
        }
        when AFTER_UPDATE{
            
        }
        when BEFORE_DELETE{
            
        }
        when AFTER_DELETE{
            
        }
        when AFTER_UNDELETE{
            
        }
    }
}