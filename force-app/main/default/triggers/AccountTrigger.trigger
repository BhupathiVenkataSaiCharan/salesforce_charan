trigger AccountTrigger on Account (before insert,after insert,before update,after update, before delete) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{
            system.debug('checkpoint trigger.isInsert.isBefore');
            // AccountTriggerHandler.updateIndustryRating(trigger.new);
            // AccountTriggerHandler.copyBillingToShipping(trigger.new);
            // AccountTriggerHandler.accRating(trigger.new);
        }
        when AFTER_INSERT{
            system.debug('checkpoint trigger.isInsert.isAfter');
                system.debug('checkpoint trigger.isInsert.isAfter.Banking');
                // AccountTriggerHandler.createContactWhenAccountisCreated(trigger.new);
            // AccountTriggerHandler.associateAccountwithContact(trigger.new);
            // AccountTriggerHandler.createContactOpportunity(trigger.new);
            // AccountTriggerHandler.associateContactsWithExistingAccount(trigger.newMap);
            AccountTriggerHandler.changeRelatedAccount(trigger.new);
		}
        when BEFORE_UPDATE{
            system.debug('checkpoint for before update');
            // AccountTriggerHandler.copyBillingToShipping(trigger.new);
            AccountTriggerHandler.updatePhone(trigger.new);
            // AccountTriggerHandler.cannotUpdate(trigger.new);
        }
        when AFTER_UPDATE{
            system.debug('checkpoint trigger.isUpdate');
            // AccountTriggerHandler.createContactWhenAccountisUpdated(trigger.new,trigger.newMap);
            AccountTriggerHandler.updateDescription(trigger.new,trigger.old);
        }
        when BEFORE_DELETE{
        	system.debug('checkpoint trigger.isDelete');
        	// AccountTriggerHandler.onAccountDelete(trigger.old);
            // AccountTriggerHandler.stopDelete(trigger.old);
            // AccountTriggerHandler.allowDeletion(trigger.old);
            AccountTriggerHandler.cannotDelete(trigger.old);
        }
    }
}