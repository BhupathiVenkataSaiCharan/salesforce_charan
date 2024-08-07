@RestResource(urlMapping='/deactivateUser')
global class WebServiceDeactivateUser {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        res.responseBody = Blob.valueOf(JSON.serialize(WebServiceDeactivateUserHandler.deactivateUsers(req)));
        res.addHeader('Content-Type','application/json');
    }
}