public class MetaDataOppValues {
    
    @AuraEnabled(cacheable=true)
    public static List<Opp_value__mdt> getOppValues() {
        try {
            List<Opp_value__mdt> oppVal = [SELECT Id, MasterLabel, Test_value__c FROM Opp_value__mdt];

            System.debug('Meta Data Values From Opp Values ::: ' + oppVal);
            return oppVal;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
