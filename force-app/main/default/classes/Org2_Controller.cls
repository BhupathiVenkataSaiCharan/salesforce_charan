public class Org2_Controller {
    // List to store records retrieved from Org1
    public List<REST__C> records { get; set; }

    // Method to make HTTP GET request to Org1
    public void getRecords() {
        // Specify the URL of the REST endpoint in Org1
        String org1Endpoint = 'https://company-4fb-dev-ed.develop.my.salesforce.com/services/apexrest/ApiRest';

        // Create a new Http object
        Http http = new Http();
        
        // Create a new HttpRequest object
        HttpRequest request = new HttpRequest();
        request.setEndpoint(org1Endpoint);
        request.setMethod('GET');

        // Send the request and store the response
        HttpResponse response = http.send(request);

        // Parse the JSON response and deserialize it into a list of records
        records = (List<REST__C>)JSON.deserialize(response.getBody(), List<REST__C>.class);
    }
}