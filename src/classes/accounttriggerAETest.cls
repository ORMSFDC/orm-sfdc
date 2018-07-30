@isTest
public class accounttriggerAETest {
    
       @isTest static void testocc(){
   
             Profile profile = [select Id,Name from profile where Name = 'Account Executive/PCS'];
          
            //Profile profile = [select Id,Name from profile where Name = 'System Administrator'];
          
            User u = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@camfed.org');
            insert u;
           
           System.runAs(u){
           
                Account account = new Account();
                account.Main_Phone__c = '1231231235';
                account.Email__c = 'deepyork@gmail.com';
                account.Cell__c = '1231231233';
                account.Partner_Lead_Status__c = 'Processing';
                account.Holding_Company_Federal_Tax_ID_Number_EI__c = '123';
                account.Name = 'Test Account';
          
               insert account;   
               
              Account a = [SELECT Id, Name, Partner_Lead_Status__c FROM Account 
                            WHERE Name = 'Test Account'];
               
               a.Partner_Lead_Status__c = 'Processing';
               
               update a;
               System.assertEquals('Processing', a.Partner_Lead_Status__c);
            
           }
       
          
        }    

          
}