/** * File Name   : ScenarioPackageTriggerTest.apxc
*     Description : test class
*     Created     : 11/27/2017, prsn
*     Covers      : scenarioTrigger,scenarioPackageTrigger,ScenarioTriggerHandler,ScenarioPackageTriggerHandler
*   * @author     : 
* */
@isTest
public class ScenarioPackageTriggerTest {
    @TestSetup
    public static void setUpData() {
        Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            Main_Phone__c='5414147852',
            Company_NMLS_ID__c = '1234',
            Partner_Lead_Status__c='New');
        insert portalAccount;
        
        Contact contact = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other', 
            Email = 'Sam@gmail.com',
            Contact_NMLS__c = '12345',
            Source_Name__c='Michael',
            AccountId = portalAccount.Id);
        insert contact;  
        
        Profile partnerProfile = [SELECT Id FROM Profile WHERE Name='ORM Partners' LIMIT 1];        
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
    }
    
    @isTest
    public static void scenarioPackageMethod() {
        User user = [Select Id From User Where FirstName = 'test912' AND Profile.Name = 'ORM Partners'];
        ClientInfo__c ClientInsert = new ClientInfo__c(Name = 'Dhiresh', 
                                                       Last_Name__c  = 'Khare',
                                                       Client_State__c = 'Alabama', 
                                                       Zip__c = '123456', 
                                                       Email_Optional__c ='d@k.com',
                                                       Phone_Number__c = '1234456678',
                                                       Street_Address__c = 'Noida Sector-62',
                                                       PartnerID__c = user.Id,
                                                       DOB__c=date.today());
        insert  ClientInsert;
        
        Scenario__c ScenarioInsert = new Scenario__c(Estimated_home_value__c = 500.00, 
                                                     Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                                     Monthly_Mortgage_Payment__c = 400.00, PartnerID__c = user.Id, ClientId__c =ClientInsert.Id, priority__c = 'LOC And CashFlow');
        
        insert ScenarioInsert;
        delete ScenarioInsert;
        delete ClientInsert;
    }
}