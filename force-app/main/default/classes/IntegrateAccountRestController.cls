public with sharing class IntegrateAccountRestController {

    public String a { get; set; }

    public String responses { get; set; }
    public List<REST__C> records { get; set; }

    // 1st request for obtaining access token and submitting data
    public PageReference submit() {
        Http h1 = new Http();
        Http h2 = new Http();

        // Your authentication code remains the same
        HttpRequest req1 = new HttpRequest();
        req1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        string reqbody='grant_type=password&client_id=3MVG9pRzvMkjMb6kWx35KWnuWT0HQVlVKNEBI0nroqOCQKcBd9TozVj.GPFWDu.nQ8Re_HCApFxtZdxh_oxwP&client_secret=1C219020E7D6112A2D5B6491E476361EC557030EDBC28A1B1E68ADB95A88266C&username=bvsc@gmail.com&password=ChArAn12$k4mCrN1IorKSdOmMqhjgTjR9O';
        req1.setBody(reqbody);
        req1.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req1.setMethod('POST');
        HttpResponse res1=h1.send(req1);
        System.debug(res1.getBody());
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res1.getbody(), OAuth2.class);
        

        // Assuming your REST service in Org2 has a method to insert records
        String restEndpoint = 'https://company-4fb-dev-ed.develop.my.salesforce.com/services/apexrest/ApiRest';
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        req2.setHeader('Authorization', 'Bearer ' + objAuthenticationInfo.access_token);
        req2.setHeader('Content-Type', 'application/json; charset=UTF-8');
        req2.setHeader('Accept', 'application/json');
        req2.setEndpoint(restEndpoint);

        //String dataUpload = JSON.serialize(r);
        //req2.setBody(dataUpload);

        HttpResponse res2 = h2.send(req2);
        responses = res2.getBody();

        system.debug(res2.getBody());
        return null;
    }

    // 2nd request for getting records
    public PageReference getRecords() {
        Http h1 = new Http();
        Http h2 = new Http();

        // Your authentication code remains the same
        HttpRequest req1 = new HttpRequest();
req1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
string reqbody='grant_type=password&client_id=3MVG9pRzvMkjMb6kWx35KWnuWT0HQVlVKNEBI0nroqOCQKcBd9TozVj.GPFWDu.nQ8Re_HCApFxtZdxh_oxwP&client_secret=1C219020E7D6112A2D5B6491E476361EC557030EDBC28A1B1E68ADB95A88266C&username=bvsc@gmail.com&password=ChArAn12$k4mCrN1IorKSdOmMqhjgTjR9O';
req1.setBody(reqbody);
req1.setEndpoint('https://login.salesforce.com/services/oauth2/token');
req1.setMethod('GET');
HttpResponse res1=h1.send(req1);
System.debug(res1.getBody());
OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res1.getbody(), OAuth2.class);
        

        // Assuming your REST service in Org2 has a method to get all records
        String restEndpoint = 'https://company-4fb-dev-ed.develop.my.salesforce.com/services/apexrest/ApiRest';
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        req2.setHeader('Authorization', 'Bearer ' + objAuthenticationInfo.access_token);
        req2.setHeader('Accept', 'application/json');
        req2.setEndpoint(restEndpoint);

        HttpResponse res2 = h2.send(req2);
        responses = res2.getBody();

        // Deserialize the response to a list of records
        // records = (List<REST__C>)JSON.deserialize(res2.getBody(), List<REST__C>.class);

        try {
        records = (List<REST__C>)JSON.deserialize(res2.getBody(), List<REST__C>.class);
    } catch (System.JSONException e) {
        // If it's not an array, try deserializing as a single object
        try {
            REST__C singleRecord = (REST__C)JSON.deserialize(res2.getBody(), REST__C.class);
            records = new List<REST__C>{singleRecord};
        } catch (System.JSONException ex) {
            // Handle the case where neither array nor object is present in the response
            records = new List<REST__C>();
        }
    }

        return null;
    }

    public REST__C r { get; set; }
    
    public IntegrateAccountRestController(){
        r=new REST__C();
    }

    // OAuth2 wrapper class remains the same
    public class OAuth2 {
        public String id { get; set; }
        public String issued_at { get; set; }
        public String instance_url { get; set; }
        public String signature { get; set; }
        public String access_token { get; set; }
    }
}