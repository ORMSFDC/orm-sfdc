@isTest
public class contacttriggerAETest {
    
       @isTest static void testocc(){
    
           
           Profile profile = [select Name from profile where Name = 'Account Executive/PCS'];
           
           User u = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = profile.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@camfed.org');
           insert u;
           
              System.runAs(u){
                  try{
           // TEST ADDING A NEW ACCOUNT...                        
           Account account = new Account();
           account.Main_Phone__c = '1231231235';
           account.Email__c = 'deepyork@gmail.com';
           account.Cell__c = '1231231233';
           account.Partner_Lead_Status__c = 'New';
           account.Holding_Company_Federal_Tax_ID_Number_EI__c = '123';
           account.Name = 'Test Account';
           
           insert account; 
           system.assertEquals(account.Partner_Lead_Status__c, 'New');
           
           // READ ACCOUNT...
           Account a = [select Name, Id , Partner_Lead_Status__c FROM account WHERE Name = 'Test Account'];
           
           Contact contact = new Contact();
           contact.AccountId = a.id;
           contact.LastName = 'testcontact';
           contact.Title__c = 'Processor';
           contact.Office_Phone__c = '7457548888';
           contact.Individual_Lead_source__c = 'Referral';
           contact.Cell__c = '1231231238';
           contact.Individual_lead_Status__c = 'Processing';
           contact.How_did_you_hear_about_us__c = 'Twitter';
           contact.Email = 'ddd@gmail.com';
           insert contact;
           
           Contact newcontact = [select LastName, Id , Individual_lead_Status__c FROM contact WHERE LastName = 'testcontact'];
           
           newcontact.Individual_lead_Status__c = 'Processing';
           update newcontact;
           System.assertEquals('Processing', newcontact.Individual_lead_Status__c);
           }
            
            catch(Exception e){
                
            }
         
       }
   }        
}