@isTest
private class getObjectRecordsTest {

    //mock record creation
    private static Account createMockAccountForDeleteRecord(){
        
        Account acc = new Account(Name = 'Test');
        insert acc;

        Account insertedAccount = [SELECT Id,Name FROM Account WHERE Id = :acc.Id LIMIT 1];
        System.assertNotEquals(null, insertedAccount, 'no accounts are inserted');

        return insertedAccount;
    }
    
    //if ID is passed
    @isTest
    static void testDeleteRecordSuccess(){

        Account acc = createMockAccountForDeleteRecord();

        Map<String, Object> result = getObjectRecords.deleteRecord(acc.Id);

        //List<Account> deletedAccount = [SELECT Id,Name FROM Account WHERE Id = :acc.Id LIMIT 1];
        Assert.areEqual(true,result.get('STATUS'));
    }

    // if ID is Fake
    @isTest
    static void testDeleteRecordInvalidId(){

        Account acc = createMockAccountForDeleteRecord();

        Map<String, Object> result = getObjectRecords.deleteRecord('XXXXX');

        //List<Account> deletedAccount = [SELECT Id,Name FROM Account WHERE Id = :acc.Id LIMIT 1];
        Assert.areEqual(false,result.get('STATUS'));
        Assert.areEqual('INVALID ID',result.get('ERROR'));
    }

    // if ID is NULL
    @isTest
    static void testDeleteRecordNullId(){

        Account acc = createMockAccountForDeleteRecord();

        Map<String, Object> result = getObjectRecords.deleteRecord(NULL);

        //List<Account> deletedAccount = [SELECT Id,Name FROM Account WHERE Id = :acc.Id LIMIT 1];
        Assert.areEqual(false,result.get('STATUS'));
        Assert.areEqual('ID IS NULL',result.get('ERROR'));
    }
}