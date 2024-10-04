public class CustomOppPathController {
    @AuraEnabled
    public static void updateOpportunityStage(Id recordId, String newStage) {
        // Query the Opportunity record
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :recordId LIMIT 1];
        
        // Update the stage
        opp.StageName = newStage;
        update opp;
    }
}
