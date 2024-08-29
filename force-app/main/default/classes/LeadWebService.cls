@RestResource(urlMapping='/LeadApi/')
global class LeadWebService {
    
    @HttpPost
    global static void createLeads(){

        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        Map<String, Object> jsonResponse = new Map<String, Object>();
        
        String requestBody = request.requestBody.toString();
        List<Object> data = (List<Object>)JSON.deserializeUntyped(requestBody);

        try {
            List<Lead> leadList = new List<Lead>();
            for(Object obj : data){
                Map<String, Object> record = (Map<String, Object>)obj;

                Lead newLead = new Lead(
                    lastName = (String) record.get('lastName'),
                    company = (String) record.get('company')
                );
                leadList.add(newLead);
            }
            insert leadList;
            jsonResponse.put('STATUS', true);
            jsonResponse.put('RECORDS', leadList);
        } catch (Exception e) {
            jsonResponse.put('STATUS', false);
            jsonResponse.put('ERROR', e.getMessage());
        }

        //serialize the response
        response.responseBody=Blob.valueOf(JSON.serialize(jsonResponse));
        response.addHeader('Content-Type', 'application/json');
    }
}