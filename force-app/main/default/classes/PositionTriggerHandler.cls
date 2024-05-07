public with sharing class PositionTriggerHandler {
    
    public static void autoFill(List<Position__c> posList){
        for(Position__c pos:posList){
            if(pos.Open_Date__c == null){
                pos.Open_Date__c= Date.today();
            }
            if(pos.Min_Pay__c == null){
                pos.Min_Pay__c=10000;
            }
            if(pos.Max_Pay__c == null){
                pos.Max_Pay__c=15000;
            }
        }
    }
}