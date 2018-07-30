@isTest
public with sharing class loanOfficer_ctrlTest {
    @isTest static void loanOfficer_ctrlMethodTest (){
        Profile p = [SELECT Id FROM Profile WHERE Name='ORM Partners'];
        QLMS_AE__c QLMSAE= new QLMS_AE__c();
        
        QLMSAE.Email__c='abc@glx.com';
        QLMSAE.isActive__c=true;
        QLMSAE.Office_Phone__c='9630266959';
        QLMSAE.Name='Latika';
        insert QLMSAE;
        Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            QLMS_Account_Executive__c=QLMSAE.ID,
            //Email__c='test@noemail.com',
            Main_Phone__c='5414147852',
            Partner_Lead_Status__c='New');
        insert portalAccount;
        Contact con = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other', 
            //How_did_you_hear_about_us__c='Twitter', 
            //Individual_lead_Status__c='New',
            Source_Name__c='Michael',
            AccountId = portalAccount.Id);
        insert con;
        
        User u = new User(
            Alias='loandate', 
            Email='loandatecontrollertest@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            CommunityNickname='loandatecontrollertest',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='loandatecontrollertest@testorg.com',
            ContactId = con.Id);
        insert u;   
        
        Test.startTest();
        loanOfficer_ctrl obj=new loanOfficer_ctrl();
        Test.stopTest();
    }
}