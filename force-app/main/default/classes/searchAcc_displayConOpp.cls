public class searchAcc_displayConOpp {
    
    //search contact
    @AuraEnabled
    public static string searchAcc(string accName, string accIndustry){
        try {
            string accid;
            List<Account> accs = [SELECT Id,Name,Industry FROM Account WHERE Name=:accName AND Industry=:accIndustry];
            if(accs.size()==0){
                accid='NoData';
            }else{
                accid = accs[0].Id;
            }
            return accid;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    //get related contacts from above searched account
    @AuraEnabled
    public static List<Contact> getcon(string accid){
        try {
            List<Contact> con = [SELECT Id,FirstName,LastName,Email,Phone FROM Contact WHERE AccountId=:accid];
            return con;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    //get opportunities from above searched account
    @AuraEnabled
    public static List<Opportunity> getopp(string accid){
        try {
            List<Opportunity> opty = [SELECT Id,Name,StageName,Amount FROM Opportunity WHERE AccountId=:accid];
            return opty;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}