global class batchApex1 implements Database.Batchable<sObject>, Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select id,name,Description from Account]);
    }

    global void execute(Database.BatchableContext BC, List<Account> accList){

        List<Account> updateList=new List<Account>();
        for(Account acc: accList){
            acc.Description='this is the batchable description';
            updateList.add(acc);
        }
        update updateList;
    }
    global void finish(Database.BatchableContext BC)   {
        system.debug('finished');
    }
    global void execute(SchedulableContext SC){
        system.debug('schedule');
        batchApex1 obj=new batchApex1();
        Database.executeBatch(obj);
    }
}