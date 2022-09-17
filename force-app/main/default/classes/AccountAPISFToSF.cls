/*
 * This service class is to make a callout to another salesforce instance. Salesforce-to-salesforce custom connector.
 * @Date: 12 May, 2022
 * Reference: 1. Token Endpoint: https://login.salesforce.com/services/oauth2/token
 * 			  2. ApexRest Endpoint: https://`your-domain-name`.my.salesforce.com/services/apexrest
 */
public without sharing class AccountAPISFToSF {
    private String endpoint;
    private String restEndpoint;
    private String username;
    private String password;
    private String ClientId;
    private String ClientSecret;
    
    private HttpRequest req;
    private HttpResponse res;  
    private Http http = new Http();
    
    /* This is to get all the settings in order to connect your salesforce connected app. */
    public AccountAPISFToSF(){}
    public AccountAPISFToSF(String sandbox){
        List<Authentication_Setting__c> settings = [Select Id, Name, Name_of_the_Application__c, Secret_Type__c, Value__c 
                                                    from Authentication_Setting__c where Name_of_the_Application__c =:sandbox
                                                                                     and isActive__c = true];
        System.debug('****settings****'+settings);
        if(settings.size() > 0){
            endpoint = Label.SFDC_TokenEndpoint; 
            restEndpoint = Label.Apex_RESTService;
            for(Authentication_Setting__c setting: settings){
                if(setting.Secret_Type__c == 'User name') username = setting.Value__c;
                else if(setting.Secret_Type__c == 'Password') password = setting.Value__c;
                else if(setting.Secret_Type__c == 'Client Id') ClientId = setting.Value__c;
                else if(setting.Secret_Type__c == 'Client Secret') ClientSecret = setting.Value__c;
            } 
        }      
    }
    
    /* 1. This method is to get the account information based on accountId */
    public String getAccount(String accountId){     
        String Access_Token = getAuthorized();
        if (Access_Token != '') {
            req = new HttpRequest();
            String reqEndpoint = restEndpoint +'/v1/AccountOperations/'+ accountId;
            req.setEndpoint(reqEndpoint);  
            req.setMethod('GET');    
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setHeader('Authorization','Bearer '+Access_Token);            
            http = new Http();
            res = http.send(req);                 
            System.debug('*****response account record******'+res.getBody());
            return res.getBody();
        }
        return null;
    }

    /* 2. This is to create single account record based on accountId*/
    public String createAccount(AccountWrapper newAccount){
        System.debug('createAccount****'+newAccount);
        String Access_Token = getAuthorized();
        if (Access_Token != '') {
            req = new HttpRequest();
            req.setMethod('POST');
            String reqEndpoint = restEndpoint +'/v1/AccountOperations/';
            req.setEndpoint(reqEndpoint);     
            req.setHeader('Content-Type','application/json;charset=UTF-8');
            req.setHeader('Authorization','Bearer '+Access_Token);   
            req.setBody(JSON.serialize(newAccount));
            http = new Http();
            res = http.send(req);
            System.debug(res.getBody());       
            return res.getBody();
        }
        return null;
    }
    
    /* 3. This is to delete a single account record based on accountId */
    public String deleteAccount(String accountId) {
        String Access_Token = getAuthorized();        
        req = new HttpRequest();  
        String reqEndpoint = restEndpoint +'/v1/AccountOperations/'+ accountId;
        req.setEndpoint(reqEndpoint);  
        req.setMethod('DELETE');    
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setHeader('Authorization','Bearer '+Access_Token);            
        http = new Http();
        res = http.send(req);                 
        System.debug('*****response account record******'+res.getBody());
        return res.getBody();
    }
    
    /* 4. This method is for Httpput method or to update the resource*/
    public String upsertAccount(String accountId, AccountWrapper updatedAccount){
        System.debug('upsertAccount****'+accountId);
        System.debug('upsertAccount****'+updatedAccount);
        String Access_Token = getAuthorized();       
        if (Access_Token != '') {
            req = new HttpRequest();  
            String reqEndpoint = restEndpoint +'/v1/AccountOperations/'+ accountId;
        	req.setEndpoint(reqEndpoint);  
        	req.setMethod('PUT');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization','Bearer '+Access_Token);            
 
            req.setBody(JSON.serialize(updatedAccount));
            http = new Http();
        	res = http.send(req);                 
        	System.debug('*****response account record******'+res.getBody());
        	return res.getBody();  
        }
        return null;
    }
    
    /* This method is to get the access_token */
    private String getAuthorized(){
        req = new HttpRequest();    
        req.setMethod('POST');         
        req.setBody('grant_type=password + &client_id=' + ClientId + '&client_secret=' + ClientSecret + '&username=' + username +'&password=' + password);        
        req.setEndpoint(endpoint);     
        String Access_Token;
        try {
            res = http.send(req);                
            system.debug('****response****'+res.getBody());  
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    Access_Token = parser.getText();    
                } 
            }            
        }catch(system.CalloutException e){            
            system.debug('*****callout Exception*****'+e);
        }
        return Access_Token!=''? Access_Token : null;
    }
    
    /* new Account wrapper class */
    public class AccountWrapper {
        public Map<String, String> fieldValues{get; set;}
        public String objApiName{get; set;}
        public String TestUser_Id{get; set;}
    }
}