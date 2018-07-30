@isTest
public with sharing class ApexScheduler_UserDeactivationTest {

    @isTest
     public static void  testschedule(){
         
         Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            Main_Phone__c='5414147852',
            Company_NMLS_ID__c = '1234',
            Partner_Lead_Status__c='New');
        insert portalAccount;
      //   Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Individual Leads').getRecordTypeId();
        
          Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
      
      try{
        Contact contact = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other', 
            Email = 'Samasd@gmail.com',
            Contact_NMLS__c = '12345',
            Source_Name__c='Michael',
            AccountId = portalAccount.Id,
          RecordTypeId = RecortypeId);
        insert contact;  
        
        Profile partnerProfile = [SELECT Id FROM Profile WHERE Name='Prospective Partner User' LIMIT 1];        
        User partnerUser = new User();
        partnerUser.Username = 'partner_'+Math.random()+'@test.com';
        partnerUser.FirstName = 'test912';
        partnerUser.LastName = 'user';
        partnerUser.alias = ('test'+Math.random()).subString(0,6);
        partnerUser.Email = 'test'+Math.random()+'@test.com';
        partnerUser.CommunityNickname = String.valueOf(Math.random()).subString(0,6);
        partnerUser.ProfileId = partnerProfile.Id;
        partnerUser.TimeZoneSidKey = 'America/Los_Angeles';
        partnerUser.LocaleSidKey='en_US';
        partnerUser.EmailEncodingKey='UTF-8';
        partnerUser.LanguageLocaleKey='en_US';
        partnerUser.ContactId = contact.Id;
        insert partnerUser;   
        
        }catch(exception ex){}      
         try{
            Test.StartTest();
            string  sh = '0 0 1 23 * ?';
           ApexScheduler_UserDeactivation instScheduler = new ApexScheduler_UserDeactivation();
           system.Schedule('Test check',sh, instScheduler ); 
            Test.stopTest();
         }
         catch(exception ex){}
        
     }
    
}