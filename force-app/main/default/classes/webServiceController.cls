@RestResource(urlMapping='/deactivateUser')
global class webServiceController {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> jsonResponse = new Map<String, Object>();

        // Parse the JSON request body
        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

        String userName = (String) params.get('userName');
        
        // Validate input
        if (String.isBlank(userName)) {
            res.statusCode = 400;
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', 'Invalid input: Email is required.');
        }

        try {
            // Find the user with the given email
            List<User> userToDeactivate = [SELECT Id, isActive FROM User WHERE userName = :userName LIMIT 1];
            if (userToDeactivate != null) {
                userToDeactivate[0].isActive = false;
                update userToDeactivate;

                res.statusCode = 200;
                jsonResponse.put('status', true);
                jsonResponse.put('message', 'User deactivated successfully.');
            } else {
                res.statusCode = 404;
                jsonResponse.put('status', false);
                jsonResponse.put('ERROR', 'User not found.');
            }
        } catch (Exception e) {
            res.statusCode = 500;
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', 'Error deactivating user: ' +e.getMessage());
        }
        res.responseBody=Blob.valueOf(JSON.serialize(jsonResponse));
        res.addHeader('Content-Type', 'application/json');
    }
}