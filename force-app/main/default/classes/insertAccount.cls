public class insertAccount {

    public static void newaccounts(){
        
        List<Account> accList=new List<Account>();
        
        for(integer i=1;i<100;i++){
          	Account acc=new Account();
        	acc.Name='new accounts'+i;  
            accList.add(acc);
        }
        insert accList;
        
    }
}