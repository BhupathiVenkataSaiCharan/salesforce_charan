@RestResource(urlMapping='/deactivateUsers')
global class DeactivateUserController {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> jsonResponse = new Map<String, Object>();

        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        
   //List to store the fedIds after changing them from object to list of string
        List<String> federationIdentifiers = new List<String>();
 
        //Traverse the postman object list and convert them to list of strings and add them to the above list
        for(Object obj : (List<Object>)params.get('fedIds')){
            federationIdentifiers.add((String)obj);
        } 

        // Validate input
        if (federationIdentifiers.isEmpty()) {
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', 'Invalid input: At least one Federation Identifier is required.');
            res.responseBody = Blob.valueOf(JSON.serialize(jsonResponse));
            res.addHeader('Content-Type', 'application/json');
            return;
        }else{

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
                jsonResponse.put('status', true);
                jsonResponse.put('message', 'Users deactivated successfully.');
                jsonResponse.put('deactivatedUserNames', deactivatedUserNames);
            } else {
                jsonResponse.put('status', false);
                jsonResponse.put('ERROR', 'No users found or all users are already deactivated.');
            }
        } catch (Exception e) {
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', 'Error deactivating users: ' + e.getMessage());
        }
        }
        res.responseBody = Blob.valueOf(JSON.serialize(jsonResponse));
        res.addHeader('Content-Type', 'application/json');
    }
}