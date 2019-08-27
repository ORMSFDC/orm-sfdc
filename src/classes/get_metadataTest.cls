/**
 * changelog:
 * 09/20/2018: Sahitya -SFDC - 289 - Modified test class for 3rd tier
 */
@isTest
public with sharing class get_metadataTest {
    @isTest static void test(){            
        Profile p = [SELECT Id FROM Profile WHERE Name='ORM Partner'];
        
        Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',                                
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Type__c='Premier');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName777999', 
                Title__c='Processor', 
                Cell__c='1237779874', 
                Office_Phone__c='1234569874',  
                Email = 'Sam777@gmail.com',
                Contact_NMLS__c = '12345777',
                AccountId = portalAccount.Id);
            insert contact;
        
        User u = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', 
                          LastName='Testing989', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', 
                          UserName='dprobertdemo9891@camfed.org',ContactId = contact.Id );
        system.runAs(u){
            
            Test.startTest();                       
                get_metadata.get_tierData('');        
                get_metadata.get_tierData_fixed('');
                get_metadata.get_tierData_Helo('');
                get_metadata.get_tierData_HeloARM('');
            Test.stopTest();
        }
    }
}