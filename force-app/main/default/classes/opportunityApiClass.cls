@RestResource(urlMapping='/Opportunity/')
global with sharing class opportunityApiClass {

    @HttpPost
    global static void doPost(){
        //default code for all api
        RestRequest request=RestContext.request;
        RestResponse response=RestContext.response;
        
        response.responseBody=Blob.valueOf(JSON.serialize(opportunityApiClassHandler.createOpportunity(request)));
        response.addHeader('Content-Type', 'application/json');

    }


    @HttpGet
    global static void doGet(){
         
        //default 
        RestRequest request=RestContext.request;
        RestResponse response=RestContext.response;
        response.responseBody=Blob.valueOf(JSON.serialize(opportunityApiClassHandler.getOpportunity(request)));
        response.addHeader('Content-Type', 'application/json');

    }

    @HttpPut
    global static void doPut(){

        //
        RestRequest request=RestContext.request;
        RestResponse response=RestContext.response;
        response.responseBody=Blob.valueOf(JSON.serialize(opportunityApiClassHandler.updateOpportunity(request)));
        response.addHeader('Content-Type', 'application/json');

    }

    @HttpDelete
    global static void doDelete(){
        RestRequest request=RestContext.request;
        RestResponse response=RestContext.response;
        response.responseBody=Blob.valueOf(JSON.serialize(opportunityApiClassHandler.deleteOpportunity(request)));
        response.addHeader('Content-Type', 'application/json');

    }

    
}