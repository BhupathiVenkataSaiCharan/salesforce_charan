@isTest
private class paginationWithJSTest {
    //if search value is passed
    @isTest
    private static void testGetAccountRecordsSuccess(){
        Account acc = new Account(
            Name = 'Test',
            Industry = 'Banking'
        );
        insert acc;

        List<Account> found = paginationWithJS.getAccountRecords('test');
        Assert.areEqual(1, found.size());
    }
    //if search value is passed but no value found
    @isTest
    private static void testGetAccountRecordsInvalidSearchKey(){
        Account acc = new Account(
            Name = 'Test',
            Industry = 'Banking'
        );
        insert acc;

        List<Account> found = paginationWithJS.getAccountRecords('new');
        Assert.areEqual(0, found.size());
    }
}