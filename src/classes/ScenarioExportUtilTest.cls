@isTest
public with sharing class ScenarioExportUtilTest {
      @isTest static void getScenarioListTest(){
       Profile p = [SELECT Id FROM Profile WHERE Name='ORM Partner'];
        
        Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',                                
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Type__c='Premier'); //SFDC-289
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName777999', 
                Title__c='Processor ', 
                Cell__c='1237779874', 
                Office_Phone__c='1234569874',  
                Email = 'Sam777@gmail.com',
                Contact_NMLS__c = '12345777',
                Source_Name__c='Michael777',
                AccountId = portalAccount.Id);
            insert contact;
        
        User u = new User(Alias = 'stdt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', 
                          LastName='Testing989', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', 
                          UserName='dpr2emo9891@camfed.org',ContactId = contact.Id );        
        system.runAs(u)
        {
            
             ClientInfo__c ClientInsert = new ClientInfo__c(Name = 'Dhiresh', Last_Name__c  = 'Khare',Client_State__c = 'Alabama', Zip__c = '123456', 
                                                            Email_Optional__c ='d@k.com',Phone_Number__c = '1234456678',Street_Address__c = 'Noida Sector-62',  
                                                            DOB__c=date.today());
         
            insert  ClientInsert;
            string ClientId = ClientInsert.Id;  
            Scenario__c ScenarioInsert = new Scenario__c(Estimated_home_value__c = 500.00, 
                             Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                             Monthly_Mortgage_Payment__c = 400.00, ClientId__c =ClientInsert.Id, priority__c = 'LOC And CashFlow');
        
            insert ScenarioInsert;
            string ScenarioId = ScenarioInsert.Id;
        
            ScenarioExportUtil.getExportForscenarioId(ScenarioId);
            ScenarioChannelClient.sendEvent('test',ScenarioExportUtil.getExportForscenarioId([select id from Scenario__c limit 1].id),[select id from Scenario__c  limit  1].id);            
       }
      }

}