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
    //public static void sendLatestAmount(List<Opportunity> oppList){
        
    //     List<Account> accList=new List<Account>();
    //     for(Opportunity opp:oppList){
    //         if(opp.Amount != null){
    //             Account acc=new Account(id=opp.AccountId,Recent_Opportunity_Amount__c=opp.Amount);
    //             accList.add(acc);
    //         }
    //     }
    //     update accList;
    // }

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


    //only admins should be able to delete opp if stage is closed won or closed lost
    public static void preventOppDeleteIfClosed(List<Opportunity> oppList){

        Set<Id> adminIds = new Set<Id>();
        for(Profile pf : [SELECT Id FROM Profile WHERE Name = 'System Administrator']){
            adminIds.add(pf.Id);
        }

        for(Opportunity opp : oppList){
            if(adminIds.contains(UserInfo.getProfileId()) && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')){
                opp.addError('Only Admin can delete Opportunities with stagename Closed Won or Closed Lost');
            }
        }
    }



    //update the account field Opportunity_Closedwon_count__c	with the sum of opportunity amount whose stage is closed won
    // public static void OppClosedWonCountInAcc(List<Opportunity> oppList){
        
    //     Set<Id> accIds = new Set<Id>();
    //     for(Opportunity opp : oppList){
    //         if(opp.AccountId != null){
    //             accIds.add(opp.AccountId);
    //         }
    //     }

    //     List<Account> accList = new List<Account>();
    //     for(AggregateResult aggr : [SELECT AccountId,SUM(Amount)totalAmount FROM Opportunity WHERE stageName = 'Closed Won' AND AccountId IN :accIds GROUP BY AccountId]){
    //         accList.add(new Account(
    //             Id = (Id)aggr.get('AccountId'),
    //             Opportunity_Closedwon_count__c = (Decimal)aggr.get('totalAmount')
    //         ));
    //     }
    //     if(!accList.isEmpty()){
    //         update accList;
    //     }
        
    // }
        
      
    
    //Populate the opportunity name with highest amount related to account
    public static void highestAmountOppName(List<Opportunity> oppList){

        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }

        List<Account> listName = new List<Account>();
        for(Account acc : [SELECT Id,(SELECT Id, Name, Amount FROM Opportunities ORDER BY Amount DESC LIMIT 1) FROM Account WHERE Id IN :accIds]){
            if(acc.Opportunities.size()>0){
                Account obj = new Account(
                    Id = acc.Id,
                    Max_Opportunity_Name__c = acc.Opportunities[0].Name
                );
                listName.add(obj);                
            }          
        }
        if(!listName.isEmpty()){
            update listName;
        }
    }
        
        
    //populate the amount of highest and lowest opportunity related to account     
    public static void highestAndLowestOppAmount(List<Opportunity> oppList){

        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }

        List<Account> accList = new List<Account>();
        for(AggregateResult agg : [SELECT AccountId,MAX(Amount)high, MIN(Amount)low FROM Opportunity WHERE AccountId IN :accIds GROUP BY AccountId]){
            Account acc = new Account(
                Id = (Id)agg.get('AccountId'),
                Highest_Opportunity_Amount__c = (Decimal)agg.get('high'),
                Lowest_Opportunity_Amount__c = (Decimal)agg.get('low')
            );
            accList.add(acc);
        }
        update accList;
    }

    //count the closed won opportunities count and their amount count in related account
    public static void countCloseWonOpps(List<Opportunity> oppList){

        //add current opp account ids to a set
        Set<Id> accIds = new Set<Id>();
        for(Opportunity opp : oppList){
            if(opp.AccountId != null){
                accIds.add(opp.AccountId);
            }
        }

        //add the values of opp to related account
        Map<Id, Account> accMap = new Map<Id, Account>();
        for(AggregateResult agg : [SELECT AccountId, COUNT(Id)totalCount ,SUM(Amount)totalAmount FROM Opportunity 
                                    WHERE StageName = 'Closed Won' AND AccountId IN :accIds GROUP BY AccountId]){

                                        Account acc = new Account(
                                            Id = (Id)agg.get('AccountId'),
                                            Opportunity_Closedwon_Amount__c = (Decimal)agg.get('totalAmount'), 	
                                            Opportunity_Closedwon_Count__c = (Integer)agg.get('totalCount')
                                        );
                                        accMap.put(acc.Id,acc);
                                    }
        //check if the account ids are in map or not if not set the values to 0
        for(Id accId : accIds){
            if(!accMap.containsKey(accId)){
                accMap.put(accId, new Account(
                    Id = accId,
                    Opportunity_Closedwon_Amount__c = 0, 	
                    Opportunity_Closedwon_Count__c = 0
                ));
            }
        }
        update accMap.values();
    }        
        
        
        
    //populate the recent created opportunity amount on related account
    public static void recentOpportunityAmount(List<Opportunity> oppList){

        List<Account> accList = new List<Account>();
        for(Opportunity opp : oppList){
            if(opp.AccountId != null && opp.Amount > 0){
                Account acc = new Account(
                    Id = opp.AccountId,
                    Recent_Opportunity_Amount__c = opp.Amount
                );
                accList.add(acc);
            }
        }
        if(!accList.isEmpty()){
            update accList;
        }

    }


    //if stage changed to closed lost and closed lost reason is empty throw error
    public static void closedLostReason(List<Opportunity> oppList){

        for(Opportunity opp : oppList){
            if (opp.StageName == 'Closed Lost' && opp.Closed_Lost_Reason__c == null) {
                opp.Closed_Lost_Reason__c.addError('If StageName is Closed Won then reason is Mandatory');
            }
        }
    }

        
        // Set<Id> accIds = new Set<Id>();
        // for(Opportunity opp : oppList){
        //     if(opp.StageName == 'Closed Won' && opp.AccountId != null){
        //         accIds.add(opp.AccountId);
        //     }
        // }

        // List<AggregateResult> aggr = [SELECT AccountId, SUM(Amount) totalAmount 
        //                                 FROM Opportunity 
        //                                 WHERE StageName = 'Closed Won' 
        //                                 AND AccountId IN :accIds
        //                                 GROUP BY AccountId];

        // List<Account> accList = new List<Account>();                                
        // for(AggregateResult agg : aggr){
        //     Account acc = new Account(
        //         Id = (Id)agg.get('AccountId'),
        //         Amount_of_ClosedWon__c	= (Decimal)agg.get('totalAmount')
        //     );
        //     accList.add(acc);
        // }
        // update accList;
}