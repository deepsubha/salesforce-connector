public without sharing class CalloutDemoController {
    public String TestUser_Id{get; set;}
    Public List<account> accList{get;set;}
    public Account resAccount{get; set;}
    public Account newAccount{get; set;}
    public String searchId{get;set;}
    public Boolean isEditable{get;set;}
    public Boolean openWindow{get;set;}
    public String sandbox{get; set;}
    Public CalloutDemoController(){
        openWindow = false;
        sandbox = 'SFDC_deepsubha16';
        newAccount = new Account();
        resAccount = new Account();
    } 
    
    public void getTestUser_Id(){
        System.debug('***Test User Id***'+TestUser_Id);        
    }
    
    public void searchAccount(){
        if(searchId != '' || searchId != null){
            try{
				AccountAPISFToSF callout = new AccountAPISFToSF(sandbox);
                String accountId = searchId;
				String response = callout.getAccount(accountId);
                AccountApiGetResponse obj = AccountApiGetResponse.parse(response);
                refreshAccList(obj.Id, obj.Name, obj.Phone, obj.website);
                searchId = '';
                if(accList?.size() == 0)
                    apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 
                                                               'No records found for you.'));
                return;
            }catch(Exception ex){
                accList = null;
                apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 
                                                           String.valueOf(ex)));
                return;
            }   
        }      
    }
    
    public void refreshAccList(String id, String name, String phone, String website){
        accList = new List<Account>(); 
		Account acc = new Account(Id=id, Name=name, Phone=phone, Website=website);
        accList.add(acc);
        resAccount  = acc.clone(false, false, false, false);
    }
    
    public void editAccount(){
        isEditable = true;
        openWindow = true;
    }
    
	public void newAccount(){
        isEditable = false;
        openWindow = true;
		accList = null;        
    }
    
    public void doCancel(){
        openWindow = false;
        newAccount = new Account();
    }
    
    public void onSave(){
		AccountAPISFToSF callout = new AccountAPISFToSF(sandbox);
        AccountAPISFToSF.AccountWrapper accountRec = new AccountAPISFToSF.AccountWrapper();
        accountRec.objApiName = 'Account';
        //accountRec.TestUser_Id = 'TestUser_103.50.83.28';
        accountRec.TestUser_Id = TestUser_Id;         
        String response;
        if(isEditable){
            String accountId = accList.get(0).Id;
            Map<String, String> data = new Map<String, String>();
            data.put('Name', resAccount.Name);
            data.put('Phone', resAccount.phone);
            data.put('website', resAccount.website);
            accountRec.fieldValues = data; 
        	response = callout.upsertAccount(accountId, accountRec);
            refreshAccList(accountId, resAccount.Name, resAccount.phone, resAccount.website);
        }else{
            Map<String, String> data = new Map<String, String>();
            data.put('Name', newAccount.Name);
            data.put('Phone', newAccount.phone);
            data.put('website', newAccount.website);
            accountRec.fieldValues = data; 
        	response = callout.createAccount(accountRec);   
        }
		apexPages.addmessage(new apexpages.message(apexpages.severity.INFO, 
                                                       response));
        doCancel();       
    }
    
    public void deleteAccount(){
		AccountAPISFToSF callout = new AccountAPISFToSF(sandbox);
        String accountId = accList.get(0).Id;
        String response = callout.deleteAccount(accountId);
        if(response?.length()>0)
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 
                                                       response));
        else
        	apexPages.addmessage(new apexpages.message(apexpages.severity.INFO, 
                                                       'Successfully Deleted Account '+accountId));
        accList = null;
        doCancel();
    }
}