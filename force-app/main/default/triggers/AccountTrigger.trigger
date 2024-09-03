trigger AccountTrigger on Account (before insert,after insert,before update,after update, before delete) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{
            system.debug('checkpoint trigger.isInsert.isBefore');
            AccountTriggerHandler.ownerAsSalesRep(trigger.new);
            // AccountTriggerHandler.updateIndustryRating(trigger.new);
            // AccountTriggerHandler.copyBillingToShipping(trigger.new);
            // AccountTriggerHandler.accRating(trigger.new);
        }
        when AFTER_INSERT{
            system.debug('checkpoint trigger.isInsert.isAfter');
            // AccountTriggerHandler.createContactOpportunity(trigger.new);
            // AccountTriggerHandler.associateContactsWithExistingAccount(trigger.newMap);
            // AccountTriggerHandler.changeRelatedAccount(trigger.new);
            // AccountTriggerHandler.createContacts(trigger.new);
            // AccountTriggerHandler.accountRelatedContact(trigger.new);
            // AccountTriggerHandler.CreateAccountRelatedConAndOpp(trigger.new);
            AccountTriggerHandler.updateConMailing(trigger.newMap);
        }
        when BEFORE_UPDATE{
            system.debug('checkpoint for before update');
            // AccountTriggerHandler.ownerAsSalesRep(trigger.new);
            // AccountTriggerHandler.copyBillingToShipping(trigger.new);
            // AccountTriggerHandler.updatePhone(trigger.new);
            // AccountTriggerHandler.cannotUpdate(trigger.new);
            // AccountTriggerHandler.ifNumberChanged(trigger.new);
            // AccountTriggerHandler.updatePhoneInContact(trigger.new);
            // AccountTriggerHandler.preventAccountEditIfCreated7DaysAgo(trigger.old);
            // AccountTriggerHandler.updateDescription(trigger.new);
        }
        when AFTER_UPDATE{
            system.debug('checkpoint trigger.isUpdate');
            // AccountTriggerHandler.createContactWhenAccountisUpdated(trigger.new,trigger.newMap);
            // AccountTriggerHandler.updateDescription(trigger.new,trigger.old);
            // AccountTriggerHandler.updateConAddrWhenAccAddrUpdated(trigger.new);                 //given by nagalakshmi
            // AccountTriggerHandler.updateLowContacts(trigger.new);
            // AccountTriggerHandler.updateContacts(trigger.new);
            // AccountTriggerHandler.updateRelatedContactPhone(trigger.newMap);
            AccountTriggerHandler.updateConMailing(trigger.newMap);
        }
        when BEFORE_DELETE{
            system.debug('checkpoint trigger.isDelete');
            // AccountTriggerHandler.onAccountDelete(trigger.old);
            // AccountTriggerHandler.stopDelete(trigger.old);
            // AccountTriggerHandler.allowDeletion(trigger.old);
            // AccountTriggerHandler.cannotDelete(trigger.old);
            // AccountTriggerHandler.preventAccountdeletion(trigger.old);                          //given by nagalakshmi
            // AccountTriggerHandler.preventDeletionIfActive(trigger.old);
            AccountTriggerHandler.preventAccDelete(trigger.old);
            
        }
    }
}