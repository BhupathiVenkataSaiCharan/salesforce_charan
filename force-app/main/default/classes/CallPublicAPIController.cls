public class CallPublicAPIController {

    @AuraEnabled
    public static Map<String, Object> getData(){
        try {
            
            Http http = new Http();

            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://catfact.ninja/fact');
            request.setMethod('GET');

            HttpResponse response = http.send(request);

            if(response.getStatusCode()==200){
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                return result;
            }else{
                throw new AuraHandledException('error');
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}