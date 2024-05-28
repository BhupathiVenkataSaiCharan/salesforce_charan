public with sharing class opportunityApiClassHandler {
    
    public static Map<String, Object> createOpportunity(RestRequest request){
        String requestBody = request.requestBody.toString();
        Map<String, Object> data =  (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        Map<String, Object> jsonResponse = new Map<String, Object>();

        //get data from request from client
        String name=(String) data.get('name');
        String stageName=(String) data.get('stageName');
        String dateString=(String) data.get('closeDate');

        // data validation which we go in request and performed required operations.
        try{
            if(!checkPicklistValue(stageName)){
                jsonResponse.put('status', false);
                jsonResponse.put('ERROR', 'Given Stage Name is not valid');
            }else{
                Opportunity opp=new Opportunity(Name=name,StageName=stageName,CloseDate=Date.parse(dateString));
                Database.SaveResult saveResult=Database.insert(opp);
                if(saveResult.isSuccess()){
                    jsonResponse.put('status', true);
                    jsonResponse.put('message', 'OPPORTUNITY CREATED');
                    jsonResponse.put('Id', saveResult.getId());
                }else{
                    jsonResponse.put('status', false);
                    jsonResponse.put('ERROR', saveResult.getErrors());
                }
            }
        }catch(system.QueryException queryException){
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', 'REQUIRED FIELD MISSING');
        }
        catch(Exception e){
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', e);
        }
        return jsonResponse;
    }
    

    public static Map<String, Object> getOpportunity(RestRequest request){
        Map <String, String> data = request.params;
        Map<String, Object> jsonResponse = new Map<String, Object>();

        try{
            String oppId= data.get('Id'); 
            Opportunity oppData=[SELECT Id,Name from Opportunity where Id=:oppId LIMIT 1];
            jsonResponse.put('Id', oppData.Id);
            jsonResponse.put('Name',oppData.Name);
            jsonResponse.put('status', true);
        }catch(System.QueryException queryException){
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', 'Invalid Id value');
        }
        catch(NullPointerException nullPointerException){
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', 'Id parameter did not passe');
        }catch(Exception e){
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR', e);
        }
        return jsonResponse;
    }


    public static Map<String, Object> updateOpportunity(RestRequest request){
        String requestBody=request.requestBody.toString();
        Map<String, String> params = request.params;
        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        Map<String, Object> jsonResponse = new Map<String, Object>();

        try{
            String oppId=params.get('Id');
            String oppName=(String)data.get('name');
            Opportunity oppData=[SELECT Id,Name,stageName,CloseDate FROM Opportunity WHERE Id=:oppId];
            String message= 'Opportunity Name ['+oppName+'] from ['+ oppData.Name+'] is updated for Id: '+oppId;
            if(oppName.equals(oppData.Name)){
                jsonResponse.put('status', false);
                jsonResponse.put('error','No data changed');
            }
            oppData.Name=oppName;
            Database.SaveResult saveResult= Database.update(oppData);
            jsonResponse.put('status', true);
            jsonResponse.put('message',message);
            
        }catch(Exception e){
            jsonResponse.put('status', false);
            jsonResponse.put('error',e);
        }
        return jsonResponse;
    }

    public static Map<String, Object> deleteOpportunity(RestRequest request){

        Map<String, String> data = request.params;
        Map<String, Object> jsonResponse = new Map<String, Object>();
        try {
            String oppId=data.get('Id');
            Database.delete(oppId);
            jsonResponse.put('status', true);
            jsonResponse.put('message', 'Opportunity is Deleted');
        } catch (Exception e) {
            jsonResponse.put('status', false);
            jsonResponse.put('ERROR',e.getMessage());
        }
        return jsonResponse;
    }

    //this method is for check validating the stageName picklist value
    private static boolean checkPicklistValue(String tempStageName){
        Schema.DescribeFieldResult objFieldDescribe=Opportunity.StageName.getDescribe();
        List<Schema.PicklistEntry> objPicklistValues = objFieldDescribe.getPicklistValues();
        // system.debug('objPicklistValues:' +objPicklistValues.getValue());
        Set<String> stageNameSet = new Set<String>();
        for (Schema.PicklistEntry entry : objPicklistValues) {
            system.debug('entry' +entry.getValue());
            stageNameSet.add(entry.getValue());
        }

        if(stageNameSet.contains(tempStageName)){
            system.debug('stageNameSet contains ' +tempStageName);
            return true;
        }
        return false;
    }
}