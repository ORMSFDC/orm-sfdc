/**
* An apex page controller that exposes the site login functionality
*/
@IsTest global with sharing class SiteLoginControllerTest {
    @IsTest(SeeAllData=true) global static void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456';         
        System.assertEquals(controller.login(),null);                           
    } 
    
    
    @isTest public static void PartnerWithUsTest() {
        Lead obj=new Lead(FirstName='tommy',LastName='Hiills',Company='GxDtroit');
        insert obj;
        string LeadID=obj.Id;
        Test.startTest();
        
        
        SiteLoginController controller = new SiteLoginController ();
        
        controller.submit();
        SiteLoginController.createTask(LeadID);
        SiteLoginController.getORMAccountExecutive();
        SiteLoginController.getPicklistValues();
        SiteLoginController.getState();
        SiteLoginController.SendEmail('joshevink@saleds.com', 'Josh', LeadID);
        Test.stopTest();
        
        
    }
}