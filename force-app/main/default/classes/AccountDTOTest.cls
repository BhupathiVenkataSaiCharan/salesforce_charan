@isTest
public class AccountDTOTest {
	
    @isTest
    static void testPhoneEmail(){
        AccountDTO obj = new AccountDTO();
         
        obj.phone = '1234567890';
        obj.email = 'test@test.test';
        
        system.assertEquals('1234567890',obj.phone,'Numbers doesnt match');
        system.assertEquals('test@test.test',obj.email,'Emails doesnt match');
    }
}