public class LeadWebServiceClient {
    public static String createLeadFromClient(List<Map<String,Object>> newList){   
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Lead_Web_Service_Client_Call_Named_Credential/services/apexrest/LeadApi/');
            request.setMethod('POST');
            request.setBodyAsBlob(Blob.valueOf(JSON.serializePretty(newList)));
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