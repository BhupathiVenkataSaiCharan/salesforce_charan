public class CustomPathStatusController {
    @AuraEnabled
    public static Opportunity stageNamePath(String recId){
        Opportunity opp = [SELECT Id,Name, StageName FROM Opportunity WHERE Id = :recId];
        System.debug('opp===>' +opp);
        return opp;
    }
}