public class practice {
    public practice() {

    }

    public static void createContactfromAccount(List<Account> accList){

        List<Contact> conList=new List<Contact>();

        for(Account acc: accList){
            Contact con=new Contact();
            con.id=acc.id;
            con.LastName=acc.Name;
            con.Description='is this the description';
            conList.add(con);
        }
        update conList;
    }
}