// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// string tempvar = 'Enter_your_name_here';
// System.debug('Hello World!');
// System.debug('My name is ' + tempvar);


//to run the LeadWebServiceClient apex class which will make call to LeadWebService restresource class and create lead records 

List<Map<String,Object>> leadList = new List<Map<String,Object>>();
Map<String,Object> leadMap = new Map<String,Object>();
leadMap.put('lastName','aman');
leadMap.put('company','test company');
leadList.add(leadMap);
LeadWebServiceClient.createLeadFromClient(leadList);