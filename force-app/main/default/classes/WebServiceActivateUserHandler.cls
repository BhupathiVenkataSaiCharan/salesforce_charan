public class WebServiceActivateUserHandler {
    public static Map<String, Object> activateUsers(RestRequest req) {
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
                List<User> usersToActivate = [
                    SELECT Id, Name, isActive, FederationIdentifier
                    FROM User
                    WHERE FederationIdentifier
                    IN :federationIdentifiers
                    AND isActive = false
                ];

                //iterate over the list and deactivate users
                if(!usersToActivate.isEmpty()){
                    for(User u: usersToActivate){
                        u.isActive = true;
                    }
                    update usersToActivate;
                    
                    //prepare the response
                    List<String> ActivatedUsers = new List<String>();
                    for(User u: usersToActivate){
                        ActivatedUsers.add(u.Name);
                    }
                    jsonResponse.put('STATUS', true);
                    jsonResponse.put('message', 'Users Activated successfully.');
                    jsonResponse.put('ActivatedUsers', ActivatedUsers);
                }else{
                    jsonResponse.put('STATUS', false);
                    jsonResponse.put('ERROR', 'All users are already Activated.');
                }
                return jsonResponse;
            }catch(Exception e){
                jsonResponse.put('STATUS', false);
                jsonResponse.put('ERROR', 'Error Activating users: ' + e.getMessage());
                return jsonResponse;
            }
        }
    }
}