// @RestResource(urlMapping='/deactivateUser')
// global class webServiceController {
//     @HttpPost
//     global static void doPost() {
//         RestRequest req = RestContext.request;
//         RestResponse res = RestContext.response;

//         res.responseBody = Blob.valueOf(JSON.serialize(webServiceControllerHandler.deactivateUser(req)));
//         res.addHeader('Content-Type', 'application/json');
//     }
// }

@RestResource(urlMapping='/ds')
global class webServiceController {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> jsonResponse = new Map<String, Object>();

        // Parse the JSON request body
        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

        // Properly cast the list of federation identifiers
        // Object fedIdsObject = params.get('fedIds');
        // List<String> federationIdentifiers = new List<String>();

        // if (fedIdsObject instanceof List<Object>) {
        //     for (Object obj : (List<Object>) fedIdsObject) {
        //         if (obj instanceof String) {
        //             federationIdentifiers.add((String) obj);
        //         }
        //     }
        // }
        // List<Object> federationIdentifiers = (List<Object>)params.get('fedIds');

        //new list to store the identifiers
        List<String> federationIdentifiers = new List<String>();

        //traverse through the fed ids which are object and adding them to the list by converting them to strings
        for(Object obj: (List<Object>)params.get('fedIds')){
            federationIdentifiers.add((String)obj);
        }


        // Validate input
        if (federationIdentifiers.isEmpty()) {
            jsonResponse.put('STATUS', false);
            jsonResponse.put('ERROR', 'Invalid input: At least one Federation Identifier is required.');
            res.responseBody = Blob.valueOf(JSON.serialize(jsonResponse));
            res.addHeader('Content-Type', 'application/json');
            return;
        }

        else{
            try {
                // Find the active users with the given federation identifiers
                List<User> usersToDeactivate = [SELECT Id, Name, isActive, FederationIdentifier 
                                                FROM User 
                                                WHERE FederationIdentifier IN :federationIdentifiers AND isActive = true];

                if (!usersToDeactivate.isEmpty()) {
                    // Deactivate users
                    for (User user : usersToDeactivate) {
                        user.isActive = false;
                    }
                    update usersToDeactivate;

                    // Prepare the response
                    List<String> deactivatedUserNames = new List<String>();
                    for (User user : usersToDeactivate) {
                        deactivatedUserNames.add(user.Name);
                    }

                    jsonResponse.put('STATUS', true);
                    jsonResponse.put('message', 'Users deactivated successfully.');
                    jsonResponse.put('deactivatedUserNames', deactivatedUserNames);
                } else {
                    jsonResponse.put('STATUS', false);
                    jsonResponse.put('ERROR', 'No users found or all users are already deactivated.');
                }
            } catch (Exception e) {
                jsonResponse.put('STATUS', false);
                jsonResponse.put('ERROR', 'Error deactivating users: ' + e.getMessage());
            }
        }
        res.responseBody = Blob.valueOf(JSON.serialize(jsonResponse));
        res.addHeader('Content-Type', 'application/json');
    }
}
