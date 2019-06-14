@isTest
public with sharing class PartnerHomeAfterLoginControllerTest{    
    @isTest static void TestgetLender(){
        //Insert Record for testing the If situation
        Lender__c Len1 = new Lender__c(name = 'DK', LenderNumber__c  = '096055-0000');
        Lender__c Len2 = new Lender__c(name = 'SKS', LenderNumber__c  = '91970-00003');
        list<Lender__c> LenderList = new list<Lender__c>();
        LenderList.add(Len1);
        LenderList.add(Len2);
        insert LenderList;
        
        //Test that Records are Inserted
        List<Lender__c> Lenders1 = PartnerHomeAfterLoginController.getLender();
        System.assertEquals(Lenders1.size(),2);
        
        //Delete Records For testing the Else situation
        delete LenderList;
        
        //Test that Records are Deleted
        list<Lender__c> Lenders2= PartnerHomeAfterLoginController.getLender();
        system.assertEquals(Lenders2.size(),0); 
    }
    
    @isTest static void TestgetLenderLink(){
        //Insert Record for testing the If situation
        LenderLink__c Len1 = new LenderLink__c(name = 'DK', URL__c  = 'https://www.google.com');
        LenderLink__c Len2 = new LenderLink__c(name = 'SKS', URL__c  = 'https://www.godaddy.com');
        list<LenderLink__c> LenderList = new list<LenderLink__c>();
        LenderList.add(Len1);
        LenderList.add(Len2);
        insert LenderList;
        
        //Test that Records are Inserted
        List<LenderLink__c> Lenders1 =  PartnerHomeAfterLoginController.getLenderLinks();
        System.assertEquals(Lenders1.size(),2);
        
        //Delete Records For testing the Else situation
        delete LenderList;
        
        //Test that Records are Deleted
        list<LenderLink__c> Lenders2= PartnerHomeAfterLoginController.getLenderLinks();
        system.assertEquals(Lenders2.size(),0); 
    }  
    
    @isTest static void TestgetHomeContents(){
        //Insert Record for testing the If situation
        HomePageContent__c HPC1 = new HomePageContent__c(name = 'DK', DetailText__c = '<p>Test Hello sa</p>');
        HomePageContent__c HPC2 = new HomePageContent__c(name = 'SKS', DetailText__c = '<p>heello</p>');
        list<HomePageContent__c> HPCList = new list<HomePageContent__c>();
        HPCList.add(HPC1);
        HPCList.add(HPC2);
        insert HPCList;
        
        //Test that Records are Inserted
        List<HomePageContent__c > HPCs = PartnerHomeAfterLoginController.getHomeContents();
        System.assertEquals(HPCs.size(),2);
        
        //Delete Records For testing the Else situation
        delete HPCList;
        
        //Test that Records are Deleted
        list<HomePageContent__c> HPCs2= PartnerHomeAfterLoginController.getHomeContents();
        system.assertEquals(HPCs2.size(),0);         
    } 
    
    @isTest static void TestgetMessage(){
        string  AEProfileID=[select id from profile where name='Account Executive/PCS'].id;        
        string AEUR=[Select Id from UserRole where Name='Partner Care Specialist'].id;          
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = AEProfileID,userroleid=AEUR, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;            
        system.runAs(user1)
        {
            Profile  getProfile=[select id from profile where name='Prospective Partner User'];
            string ProfileId = getProfile.Id;
            UserRole  UserRoleID=[select id from UserRole where name='Loan Officer'];
            string phone = '9999999999';
            Test.startTest();
            integer msg = PartnerHomeAfterLoginController.getMessage();
            List<LenderLink__c> lst = PartnerHomeAfterLoginController.getLenderLinksWithAEData();
            List<LenderLink__c> lst1 = PartnerHomeAfterLoginController.getLenderLinksData();
            integer Retmsg = PartnerHomeAfterLoginController.getContactId(user1.id);
            String p = PartnerHomeAfterLoginController.getAEInfo(phone);
            Test.stopTest();
        }
    }
    
}