public class OpportunityTriggerHandler {
    
    //if opportunity amount is not null and greater than 1,00,000 then populate 'Hot Opportunity' in description field
    public static void addDescription(List<Opportunity> oppList){
        for(Opportunity opp:oppList){
            if(opp.amount!=null && opp.amount>100000){
                opp.Description='Hot Opportunity from trigger';
            }
        }
    }

    //populate the amount of the recently created opportunity in the related account 'recent opportunity amount' field
    public static void sendLatestAmount(List<Opportunity> oppList){
        
        List<Account> accList=new List<Account>();
        for(Opportunity opp:oppList){
            if(opp.Amount != null){
                Account acc=new Account(id=opp.AccountId,Recent_Opportunity_Amount__c=opp.Amount);
                accList.add(acc);
            }
        }
        update accList;
    }

    //error if amount is null while creating an opportunity
    public static void nullAmount(List<Opportunity> oppList){
        for(Opportunity opp:oppList){
            if(opp.Amount ==null){
                opp.addError('Amount field is empty');
            }else if(opp.Amount ==0 ){
                opp.addError('Amount field must be greater than 0');
            }
        }
    }
     //allow only admin to delete the records if stage is closed
    public static void allowDeletion(List<Opportunity> oppList){
        Set<Id> loggedUser=new Set<Id>();
        for(Profile prof:[SELECT id FROM Profile WHERE Name='system administrator']){
            loggedUser.add(prof.Id);
        }

        for(Opportunity opp: oppList){
            if(loggedUser.contains(UserInfo.getProfileId()) && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')){
                opp.addError('only admin can delete records with stagename is closed');
            }
        }
    }
}
