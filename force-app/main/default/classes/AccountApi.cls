/*
 * Desc: This is to build the rest API endpoint for Account object. Resources(Account) can be accessed by using this endpoint.
 * e.g.-custom salesforce-to-salesforce connector.
 * @CreatedDate: 12 May, 2022
 */

@RestResource(urlMapping='/v1/AccountOperations/*')
global without sharing class AccountApi {
    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account;
    }
 
    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        //res.addHeader('Access-Control-Max-Age', '86400');
        res.addHeader('Content-Type', 'application/json; charset=UTF-8');
        //res.addHeader('Access-Control-Allow-Credentials', 'Server,range,hdntl,hdnts');
        res.addHeader('Access-Control-Allow-Credentials', 'true');
        //res.addHeader('Access-Control-Expose-Headers', 'Server,range,hdntl,hdnts');
        res.addHeader('Access-Control-Allow-Headers', 'Origin,range,hdntl,hdnts,X-Requested-With, Content-Type, Accept');
        res.addHeader('Access-Control-Allow-Origin', '*');
        res.addHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
        
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];
        return result;
    }
 
    @HttpPost
    global static String doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        res.addHeader('Access-Control-Allow-Origin', '*');
        
        string jsonString = req.requestBody.tostring();
      	AccountWrapper awrap = (AccountWrapper) JSON.deserialize(jsonString, AccountWrapper.class);
        Account acc = new Account();
        acc.TestUser_Id__c = awrap.TestUser_Id;
        for(String field: awrap.fieldValues.keySet())
            acc.put(field, awrap.fieldValues.get(field)!=null ? awrap.fieldValues.get(field) : acc.get(field));
        try{
           insert acc; 
        }catch(System.DmlException exp){
            return 'Account Creation failed. #Error:'+ String.valueOf(exp);
        }        
        return 'account created. Id: '+acc.Id;
    }
    
    @HttpPut
    global static String doUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        string jsonString = req.requestBody.tostring();
      	AccountWrapper awrap = (AccountWrapper) JSON.deserialize(jsonString, AccountWrapper.class);
        String fieldnames = 'Id';
        for(String name: awrap.fieldValues.keySet())
    		fieldnames+= ', '+name;
        String query = 'Select '+fieldnames+' from '+awrap.objApiName+' where Id =:accountId';
        Account acc = Database.query(query);
        acc.TestUser_Id__c = awrap.TestUser_Id;
        for(String field: awrap.fieldValues.keySet())
            acc.put(field, awrap.fieldValues.get(field)!=null ? awrap.fieldValues.get(field) : acc.get(field));
        try{
            update acc;
        }catch(System.DmlException exp){
            return 'Account Updation failed. #Error:'+ String.valueOf(exp);
        }        
        return 'account updated. Id: '+acc.Id;
    }
    
    global class AccountWrapper{
        global Map<String, String> fieldValues{get; set;}
        global String objApiName {get; set;}
        global String TestUser_Id{get; set;}
    }   
}