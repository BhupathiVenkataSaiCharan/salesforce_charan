public with sharing class OpportunityRecordHandler {
    
    @AuraEnabled
    public static string CreateOpportunity(String name, String stageName, String closeDate){
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:salesforceloginnamedcredential/services/apexrest/Opportunity/');
            request.setMethod('POST');
            Map<String,String> jsonRequest = new Map<String,String>();
            jsonRequest.put('name', name);
            jsonRequest.put('stageName', stageName);
            jsonRequest.put('closeDate', closeDate);
            request.setBodyAsBlob(Blob.valueOf(JSON.serializePretty(jsonRequest)));
            System.debug('request: '+request);
            HttpResponse response = new Http().send(request);
            System.debug('response: '+response);
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                return responseBody;
            }else {
                return 'helo test';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}