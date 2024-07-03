@isTest
private class paginationWithJSTest {

    @TestSetup
    static void testData(){
        Account acc = new Account(
            Name = 'Test',
            Industry = 'Banking'
        );
        insert acc;
    }

    //if search value is passed
    @isTest
    private static void testGetAccountRecordsSuccess(){

        Test.startTest();
        List<Account> found = paginationWithJS.getAccountRecords('test');
        Test.stopTest();

        Assert.areEqual(1, found.size());
    }
}