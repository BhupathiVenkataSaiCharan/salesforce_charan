@isTest
private class insertionAccountTest {
	
    //@isTest
    static testMethod void testInsertAccount(){
        
        insertAccount.newAccounts();
        
        List<Account> newList = [SELECT Id,Name FROM Account WHERE Name LIKE '%newaccounts%'];
        
        system.assertEquals(99,newList.size(),'Accounts not found');
    }
}