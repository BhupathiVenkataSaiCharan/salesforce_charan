public class webServiceControllerHandler {

    public static Map<String, Object> deactivateUsers(RestRequest req) {
        Map<String, Object> jsonResponse = new Map<String, Object>();

        // Parse the JSON request body
        String requestBody = req.requestBody.toString();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

        // Get the list of usernames
        List<String> userNames = (List<String>) params.get('userNames');

        // Validate input
        if (userNames == null || userNames.isEmpty()) {
            jsonResponse.put('STATUS', false);
            jsonResponse.put('ERROR', 'Invalid input: At least one username is required.');
            return jsonResponse;
        }

        try {
            // Find the active users with the given usernames
            List<User> usersToDeactivate = [SELECT Id, Name, isActive FROM User WHERE userName IN :userNames AND isActive = true];

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
            return jsonResponse;
        } catch (Exception e) {
            jsonResponse.put('STATUS', false);
            jsonResponse.put('ERROR', 'Error deactivating users: ' + e.getMessage());
            return jsonResponse;
        }
    }
}
