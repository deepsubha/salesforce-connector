/*
 * Desc: This is the controller class used in Account_API(page) to get the created accounts based on public IP
 * for a particular Test User, since this is hosted in Community Page. 
 * e.g.-custom salesforce-to-salesforce connector.
 * @CreatedDate: 18 May, 2022
 */
public class Account_APIController {
    Public List<account> accList{get;set;}
    public String TestUser_Id{get; set;}   
    Public Account_APIController(){        
    } 
    
    public void getTestUser_Id(){
        System.debug('user id--'+TestUser_Id);        
        try{
            accList = New List<account>();
            String query = '';
            if(TestUser_Id == 'TestUser_All')
                query = 'SELECT Id, Name, Phone, Website FROM Account LIMIT 20';
            else
                query = 'SELECT Id, Name, Phone, Website FROM Account where TestUser_Id__c =:TestUser_Id LIMIT 20'; 
            accList = Database.query(query); 
            if(accList.size() == 0)
                apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 
                                                       'No records found for you.'));
            return;
        }catch(Exception ex){
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 
                                                       String.valueOf(ex)));
            return;
        }
    }
}