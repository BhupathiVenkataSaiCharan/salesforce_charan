@isTest
private class getObjectRecordsTest {
	
    //positive scenario
    @isTest
    static void testGetAccounts(){
       	Account accName= new Account(Name='Test');
        insert accName;
        
        List<Account> result = getObjectRecords.getAccounts('Test');
        
        system.assertEquals(1,result.size(), 'Accounts doesnt match');
        //system.assertEquals('Test',result[0].Name, 'Accounts doesnt match');
        
    }

    //negative scenario
    @isTest
    static void testDontGetAccounts(){
       	Account accName= new Account(Name='Test');
        insert accName;
        
        Test.startTest();
        List<Account> result = getObjectRecords.getAccounts('names');
        Test.stopTest();
        
        system.assertEquals(0,result.size(), 'no match found');
    }
}