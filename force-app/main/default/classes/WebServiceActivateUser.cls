@RestResource(urlMapping='/activateUser')
global class WebServiceActivateUser {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        res.responseBody = Blob.valueOf(JSON.serialize(WebServiceActivateUserHandler.activateUsers(req)));
        res.addHeader('Content-Type','application/json');
    }
}