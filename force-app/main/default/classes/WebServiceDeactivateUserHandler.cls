public class WebServiceDeactivateUserHandler {
    public static Map<String, Object> deactivateUsers(RestRequest req) {
        
        Map<String, Object> jsonResponse = new Map<String, Object>();

        //parse json request body
        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(requestBody);

        //List to store the fedIds after changing them from object to list of string
        List<String> federationIdentifiers = new List<String>();

        //Traverse the postman object list and convert them to list of strings and add them to the above list 
        for(Object obj : (List<Object>)params.get('fedIds')){
            federationIdentifiers.add((String)obj);
        }

        if(federationIdentifiers.isEmpty()){
            jsonResponse.put('STATUS', false);
            jsonResponse.put('ERROR','Invalid Input: Aleast one Federation Identifier is required');
            return jsonResponse;
        }
        else{
            try{
                List<User> usersToDeactivate = [
                    SELECT Id, Name, isActive, FederationIdentifier
                    FROM User
                    WHERE FederationIdentifier
                    IN :federationIdentifiers
                    AND isActive = true
                ];

                //iterate over the list and deactivate users
                if(!usersToDeactivate.isEmpty()){
                    for(User u: usersToDeactivate){
                        u.isActive = false;
                    }
                    update usersToDeactivate;
                    
                    //prepare the response
                    List<String> deactivatedUsers = new List<String>();
                    for(User u: usersToDeactivate){
                        deactivatedUsers.add(u.Name);
                    }
                    jsonResponse.put('STATUS', true);
                    jsonResponse.put('message', 'Users deactivated successfully.');
                    jsonResponse.put('deactivatedUsers', deactivatedUsers);
                }else{
                    jsonResponse.put('STATUS', false);
                    jsonResponse.put('ERROR', 'No users found or all users are already deactivated.');
                }
                return jsonResponse;
            }catch(Exception e){
                jsonResponse.put('STATUS', false);
                jsonResponse.put('ERROR', 'Error deactivating users: ' + e.getMessage());
                return jsonResponse;
            }
        }
    }
}