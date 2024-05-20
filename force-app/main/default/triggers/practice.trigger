trigger practice on Account (before insert, after insert, before update, before delete) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{

            //if account industry is not null and is media then rating = hot

            // for(Account acc:trigger.new){
            //     if(acc.Industry!=null && acc.Rating.equals('media')){
            //         acc.Rating='Hot';
            //     }
            // }

        // show error when account phone is null
        //     for(Account acc:trigger.new){
        //         if(acc.Phone == null){
        //             acc.Phone.addError('phone is mandatory');
        //         }
        //     }
        }
        when AFTER_INSERT{


            // create a contact associated with account is account industry is banking

            // List<Contact> conList=new List<Contact>();
            // for(Account acc: trigger.new){
            //     if(acc.Industry=='Banking'){
            //         Contact con=new Contact(
            //         LastName=acc.Name,
            //         AccountId=acc.Id
            //         );
            //         conList.add(con);
            //     }
            // }
            // insert conList;
            
            
            
            
            //create a contact when account is created and
            
            // List<Contact> conList = new List<Contact>();
            // for(Account acc:trigger.new){
            //     Contact con=new Contact(
            //         LastName=acc.Name,
            //         Description=acc.Description
            //     );
            //     conList.add(con);
            // }
            // insert conList;

        }
        when BEFORE_UPDATE{
        //     for(Account acc:trigger.new){
        //         if(acc.Industry==null){
        //             acc.Rating='low';
        //         }
        //     }


        }
        when BEFORE_DELETE{
        //     for(Account acc: trigger.old){
        //         if(acc.Rating=='hot'){
        //             acc.addError('you cannot delete accounts with rating hot');
        //         }
        //     }
        }
    }
}


//to get more than 2 values
public static void updatePhone(List<Account> accList){

    Map<String, AccountDTO>accMap=new Map<String, AccountDTO>();
    for(Account acc: accList){
        //to get single value
        // accMap.put(acc.Id,acc.Phone);

        //to get multiple values using get set apex class Account Data transfer String =AccountDTO
        AccountDTO accD=new AccountDTO();
        accD.phone=acc.Phone
        accD.email=acc.Email
        accMap.put(acc.Id,accD);
    }

    List<Contact> conList = [SELECT Id,Phone,AccountId from Contact where AccountId IN :accMap.keyset()];

    // List<Contact> updateConList = new List<Contact>();
    for(Contact con:conList){
        con.Phone=accMap.get(con.AccountId).phone;
        con.Email=accMap.get(con.AccountId).email;
        // updateConList.add()
    }
    update conList;
}


//to get single value with id

public static void updateField(List<Account> accList){

    Map<String, String> accMap = new Map<String, String>();

    for(Account acc: accList){
        accMap.put(acc.Id,acc.Phone);
    }

    List<Contact> relatedContacts = [SELECT Id,Phone,AccountId from Contact WHERE AccountId IN :accMap.keyset()];

    for(Contact con: relatedContacts){
        con.Phone=accMap.get(con.AccountId);
    }
    update relatedContacts;
}


//batch apex

global class apexBatchClass implements Database.Batchable<sobject>, Schedulable{

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT id,Name from contact]);
    }
    global void execute(Database.BatchableContext BC, List<Account> accList){
        
        List<Account> fullList=new List<Account>();
        for(Account acc:accList){
            acc.Description='new Description from batch apex';
            fullList.add(acc);
        }
        update fullList;
    }
    global void finish(Database.BatchableContext BC){
        system.debug('Finished');
    }

    global void execute(SchedulableContext SC){
        apexBatchClass obj=new apexBatchClass();
        Database.executeBatch(obj);
    }
}


global class abc implements Database.Batchable<sobject>,Schedulable{

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT id,Name,Description from Account]);
    }
    global void execute(Database.BatchableContext BC, List<Account> accList){

        List<Account> wholeList=new List<Account>();
        for(Account acc:accList){
            acc.Description='add description from batch apex with schedule';
            wholeList.add(acc);
        }
        update wholeList;
    }
    global void finish(Database.BatchableContext BC){
        system.debug('finished');
    }
    global void execute(SchedulableContext SC){
        abc obj=new abc();
        Database.executeBatch(obj);
    }
}




public static void addAccCon(List<Account> accList){

    Map<String, String> accMap=new Map<String, String>();
    for(Account acc: accList){
        accMap.put(acc.Id,acc.Phone);
    }

    List<Contact> relatedContacts = [SELECT Id,Name,AccountId from Contact WHERE AccountId IN :accMap.keyset()];
    for(Contact con: relatedContacts){
        con.Phone=accMap.get(con.AccountId);
    }
    update relatedContacts;
}



global class abc1 implements Database.Batchable<sobject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Name from Contact]);
    }
    global void execute(Database.BatchableContext BC, List<Contact> conList){
        List<Contact> newList = new List<Contact>();
        for(Contact con:conList){
            con.Description='new description';
            newList.add(con);
        }
        update newList;
    }
    global void finish(Database.BatchableContext BC){
        system.debug('finished');
    }

    global void execute(SchedulableContext SC){
        abc1 obj=new abc1();
        Database.executeBatch(obj);
    }
}




global class demo implements Database.Batchable<sobject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT id,name from account]);
    }
    global void execute(Database.BatchableContext BC, List<Account> accList){
        
        List<Account> fullList=new List<Account>();
        for(Account acc:accList){
            acc.description='new desc';
            fullList.add(acc);
        }
        update fullList;
    }
    global void finish(Database.BatchableContext BC){
        system.debug('finish');
    }
    global void execute(SchedulableContext SC){
        demo obj=new demo();
        Database.executeBatch(obj);
    }
}



global class practice implements Database.Batchable<sobject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Name,Description from Account]);
    }
    global void execute(Database.BatchableContext BC,List<Account> accList){
        List<Account> fullData = new List<Account>();
        for(Account acc: accList){
            acc.Description='new description';
            fullData.add(acc);
        }
        update fullData;
    }
    global void finish(Database.BatchableContext BC){
        system.debug('finishded');
    }
    global void execute(SchedulableContext SC){
        practice pc=new practice();
        Database.executeBatch(pc);
    }
}



public static class accountContact(List<Account> accList){

    Map<String, String> mapName = new Map<String, String>();
    for(Account acc:accList){
        mapName.put(acc.Id, acc.phone);
    }

    List<Contact> conList = [SELECT id,name from contact where AccountId IN :mapName.keyset()];
    for(Contact con: conList){
        con.phone=mapName.get(con.AccountId);
    }
    update conList;
}


public static void contactAccount(List<Account> accList){

    Map<String, String> accMap = new Map<String, String>();
    for(Account acc:accList){
        accMap.put(acc.Id, acc.Phone);
    }

    List<Contact> conList = [SELECT id,name from Contact where AccountId IN :accMap.keyset()];
    for(Contact con:conList){
        con.Phone=accMap.get(con.AccountId);
    }
    update conList;
}




public static void stopDel(List<Account> accList){

    Set<ID> setName = new Set<ID>();
    for(Profile prof:[SELECT id from profile WHERE name = 'system administrator']){
        setName.add(prof.Id);
    }
    if(!setName.contains(UserInfo.getProfileId())){
        for(Account acc:accList){
            acc.addError('You dont have enough permissions to delete this');
        }
    }
}



public static void getData(List<Account> accList){

    Map<String, String> accMap = new Map<String, String>();
    for(Account acc:accList){
        accMap.put(acc.Id, acc.Phone);
    }

    List<Contact> conList = [SELECT id,Name FROM Contact where AccountId IN :accMap.keyset()];

    for(Contact con:conList){
        con.Phone=accMap.get(con.AccountId);
    }
}


global class className implements Database.Batchable<sobject>{}