@isTest
private class accountsListforAuraTest {

    @isTest
    static void testDeleteRecord() {
        // Step 1: Set up test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Step 2: Call the deleteRecord method
        String result = accountsListforAura.deleteRecord(testAccount.Id);
        
        // Step 3: Verify the result
        // Verify that the account is deleted successfully
        
        System.assertEquals(testAccount.Id, result, 'The account should be deleted successfully.');
        
        // Verify that the account no longer exists in the database
        List<Account> deletedAccount = [SELECT Id FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        System.assertEquals(0, deletedAccount.size(), 'The account should no longer exist.');
    }

    @isTest
    static void testDeleteRecordNonExistentId() {
        // Step 1: Call the deleteRecord method with a non-existent ID
        String nonExistentId = '001000000000000AAA';
        String result = accountsListforAura.deleteRecord(nonExistentId);
		System.debug('RRR '+result);        
        // Step 2: Verify the result
        System.assert(result.contains('Delete failed'), 'The method should return an error message for non-existent ID.');
    }

    @isTest
    static void testDeleteRecordWithException() {
        // Step 1: Call the deleteRecord method with a malformed ID
        String malformedId = 'malformedId';
        String result = accountsListforAura.deleteRecord(malformedId);
        system.debug('RRR '+result);
        // Step 2: Verify the result
        System.assert(result.contains('malformedId'), 'The method should return an error message for malformed ID.');
    }
     @isTest
    static void testAccListData() {
        // Step 1: Set up test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        accountsListforAura.PaginationResult wrapper = accountsListforAura.accListData(1, 1, 'Test');
        System.assertEquals(1,wrapper.totalCount);
    }
}