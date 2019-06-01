@isTest
public with sharing class MarketingHub_ControllerTest{

    @isTest 
    static void createUserTest()
    {            
        String link = 'www.test.salesforce.com';       
        String str = MarketingHub_Controller.getLoggedInUserInfo(link);
    
    }
    
}