@isTest()
public with sharing class PartnerResourcesControllerTest {
    //Reversity TAb
    //ReversityContentControllerTest
    @isTest static void ReversityContentControllerTest()
    {
       
        // Mock data
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
  insert users;
  System.runAs(users) {
    
 //Insert Record for testing the If situation
        ReverseVideoContents__c RVC1 = new ReverseVideoContents__c(OwnerId=users.Id,name = 'DK', Details__c  = '<p><a href="https://ormmortgageservices--dev.cs64.my.salesforce.com/sfc/p/0q0000000QFY/a/0q000000002b/3dMvMa6ia2NuHEaxoxjYi547hm703ZkbbU94QS1Ml6s" target="_blank">Financial Assessment Cheat Sheet PDF</a></p>', IsActive__c=true);
        ReverseVideoContents__c RVC2 = new ReverseVideoContents__c(OwnerId=users.Id,name = 'SKS', Details__c  = '<p><a href="https://ormmortgageservices--dev.cs64.my.salesforce.com/sfc/p/0q0000000QFY/a/0q000000002c/3bAoZSyqp3v4NWkKEuOUp_edvBph.io7FXDcydhqUzE" target="_blank">Financial Assessment Summary PDF</a></p>', IsActive__c=true);
        list<ReverseVideoContents__c> ReverseVideoList = new list<ReverseVideoContents__c>();
        ReverseVideoList.add(RVC1);
        ReverseVideoList.add(RVC2);
        insert ReverseVideoList;
     // now test the prod class as mocks are done
     system.assertEquals(2,PartnerResourcesController.getReversityContents().size()); 
  }
        
    }
    //FAQ Tab
    //FAQControllerTest
    @isTest static void FAQControllerTest(){
       // Mock data
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
   String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
        insert users;
  System.runAs(users) {
        //Insert Record for testing the If situation
        FAQ__c FAQ1 = new FAQ__c(name = 'FAQ1', FAQ_Detail__c = '<p><a href="http://zip4.usps.com/zip4/welcome.jsp" target="_blank" style="background-color: white; color: rgb(29, 66, 126); font-family: Arial, sans-serif; font-size: 10.5pt;">http://zip4.usps.com/zip4/welcome.jsp</a></p>',IsActive__c = true ,OwnerId = users.Id);
        FAQ__c FAQ2 = new FAQ__c(name = 'FAQ2', FAQ_Detail__c = '<p><a href="http://www.hud.gov/offices/hsg/sfh/hcc/hcs.cfm" target="_blank" style="background-color: white; color: rgb(29, 66, 126); font-family: Arial, sans-serif; font-size: 10.5pt;">http://www.hud.gov/offices/hsg/sfh/hcc/hcs.cfm</a></p>', IsActive__c = true ,OwnerId = users.Id);
        list<FAQ__c> FAQList = new list<FAQ__c>();
        FAQList.add(FAQ1);
        FAQList.add(FAQ2);
        insert FAQList;
       system.assertEquals(2,PartnerResourcesController.getFAQContents().size()); 
 } 
    }
    
    //ContactUs Tab
    //ContactUsControllerTest
    @isTest static void ContactUsMethod(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
   String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
  insert users;
  System.runAs(users) {
        //Insert Record for testing the If situation
        Contact_Us__c CUS1 = new Contact_Us__c(name = 'Sachin', Contact_Detail__c= '<p>9818370974</p>',Is_Active__c=true);
        Contact_Us__c CUS2 = new Contact_Us__c(name = 'Dhiresh', Contact_Detail__c= '<p>9971639155</p>',Is_Active__c=true);
        list<Contact_Us__c> CUSList = new list<Contact_Us__c>();
        CUSList.add(CUS1);
        CUSList.add(CUS2);
        insert CUSList;
          system.assertEquals(2,PartnerResourcesController.getContacts().size());
      // PartnerResourcesController.getContacts()
  }}
         
    
    //Our Process Tab
    //ProcessContentController
    @isTest static void ProcessContentMethod(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
  String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
  insert users;
  System.runAs(users) {
        //Insert Record for testing the If situation
        ProcessContents__c PC1 = new ProcessContents__c(OwnerId=users.Id,name = 'DK', Details__c= '<p>9818370974</p>',IsActive__c =true);
        ProcessContents__c PC2 = new ProcessContents__c(OwnerId=users.Id,name = 'DK', Details__c= '<p>9971639155</p>',IsActive__c =true);
        list<ProcessContents__c> PCList = new list<ProcessContents__c>();
        PCList.add(PC1);
        PCList.add(PC2);
        insert PCList;
         
        //Test that Records are Inserted
       
        system.assertEquals(2,PartnerResourcesController.getProcessContents().size()); 
  }}

    //Our Resource Tab
    //ResourceFormsController
     @isTest static void ResourceFormsMethod(){
         
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
  String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
  insert users;
  System.runAs(users) {
        //Insert Record for testing the If situation
        ResourceForms__c RF1 = new ResourceForms__c(OwnerId=users.Id,Name = 'DK', DetailText__c= '<p>9818370974</p>',IsActive__c =true);
        ResourceForms__c RF2 = new ResourceForms__c(OwnerId=users.Id,Name = 'DK', DetailText__c= '<p>9971639155</p>',IsActive__c =true);
        list<ResourceForms__c> RFList = new list<ResourceForms__c>();
        RFList.add(RF1);
        RFList.add(RF2);
        insert RFList;
         
        system.assertEquals(2, PartnerResourcesController.getResourceForms().size());
  }
     }
    //Our Youtube Tab
    //YoutubeVideoListController
    @isTest static void getYoutubeLinksMethod(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
  String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
  insert users;
  System.runAs(users) { //Insert Record for testing the If situation
        YoutubeLinks__c YTL = new YoutubeLinks__c(OwnerId=users.Id,YouTubeHeader__c = 'Walk and Talk with Henry Winkler 121 - One Reverse Mortgage', YoutubeURL__c= 'https://www.youtube.com/embed/h7HNRonQvYg',IsActive__c =true);
        //YoutubeLinks__c YTL2 = new YoutubeLinks__c(OwnerId=users.Id,YouTubeHeader__c = 'Simple Explanation of a Reverse Mortgage', YoutubeURL__c= 'https://www.youtube.com/embed/2oy68uKG7B8',IsActive__c =true);
        list<YoutubeLinks__c> YTList = new list<YoutubeLinks__c>();
        YTList.add(YTL);
        //YTList.add(YTL2);
        insert YTList;
      
        system.assertEquals(1,  PartnerResourcesController.getYoutubeLinks().Size()); 
    }
    }
    
    @isTest static void getYoutubeLinkDetailByIdMethod(){
        
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
  String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
  insert users;
  System.runAs(users) {
        //Insert Record for testing the If situation
        YoutubeLinks__c YTL1 = new YoutubeLinks__c(OwnerId=users.Id,YouTubeHeader__c = 'Walk and Talk with Henry Winkler 1 - One Reverse Mortgage', YoutubeURL__c= 'https://www.youtube.com/embed/h7HNRonQvYg',IsActive__c =true);
        //YoutubeLinks__c YTL2 = new YoutubeLinks__c(OwnerId=users.id,YouTubeHeader__c = 'Simple Explanation of a Reverse Mortgage', YoutubeURL__c= 'https://www.youtube.com/embed/2oy68uKG7B8',IsActive__c =true);
        list<YoutubeLinks__c> YTList = new list<YoutubeLinks__c>();
        YTList.add(YTL1);
        //YTList.add(YTL2);
        insert YTList;
         
       
       
        System.assertEquals('https://www.youtube.com/embed/h7HNRonQvYg', PartnerResourcesController.getYoutubeLinkDetailById(YTList[0].Id));
       
  }
    }
    
    //Our Process Tab
    //ProcessVideosListController
    @isTest static void getProcessVideoLinksMethod(){
        
        
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
         String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
  insert users;
  System.runAs(users) {
      //Insert Record for testing the If situation
        Process_Videos__c PV1 = new Process_Videos__c(OwnerId=users.Id,ProcessVideoHeader__c='One Reverse Mortgage - Henry Winkler - Take Control 122',ProcessVideoImage__c='<img src="https://img.youtube.com/vi/8mSCiFoj2as/mqdefault.jpg" width="120" height="101"></img>',ProcessVideoURL__c='https://www.youtube.com/embed/8mSCiFoj2as',IsActive__c =true);
        //Process_Videos__c PV2 = new Process_Videos__c(OwnerId=users.Id,ProcessVideoHeader__c='NBC Today Show - The Pros and Cons of a Reverse Mortgage',ProcessVideoImage__c='<img src="https://img.youtube.com/vi/S9oQ4XfG7JY/mqdefault.jpg" width="120" height="101"></img>',ProcessVideoURL__c='https://www.youtube.com/embed/S9oQ4XfG7JY',IsActive__c =true);
        list<Process_Videos__c> PVList1 = new list<Process_Videos__c>();
        PVList1.add(PV1);
        //PVList1.add(PV2);
        insert PVList1;
         
        //Test that Records are Inserted
       // List<Process_Videos__c> PVs = PartnerResourcesController.getProcessVideoLinks();
        System.assertEquals(1,PartnerResourcesController.getProcessVideoLinks().size());
  }  
    }
    @isTest static void getProcessVideoLinksByIdMethod(){
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
   String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
  User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org', 
                    EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', ProfileId = p.Id, 
                    TimeZoneSidKey='America/Los_Angeles');
  insert users;
  System.runAs(users) {
      //Insert Record for testing the If situation
        Process_Videos__c PV1 = new Process_Videos__c(OwnerId=users.Id,ProcessVideoHeader__c='One Reverse Mortgage - Henry Winkler - Take Control',ProcessVideoImage__c='<img src="https://img.youtube.com/vi/8mSCiFoj2as/mqdefault.jpg" width="120" height="101"></img>',ProcessVideoURL__c='https://www.youtube.com/embed/8mSCiFoj2as',IsActive__c =true);
        //Process_Videos__c PV2 = new Process_Videos__c(OwnerId='0050q000000ERRlAAO',ProcessVideoHeader__c='NBC Today Show - The Pros and Cons of a Reverse Mortgage',ProcessVideoImage__c='<img src="https://img.youtube.com/vi/S9oQ4XfG7JY/mqdefault.jpg" width="120" height="101"></img>',ProcessVideoURL__c='https://www.youtube.com/embed/S9oQ4XfG7JY',IsActive__c =true);
        list<Process_Videos__c> PVList2 = new list<Process_Videos__c>();
        PVList2.add(PV1);
        //PVList.add(PV2);
        insert PVList2;
         
       
        
      System.assertEquals('https://www.youtube.com/embed/8mSCiFoj2as',PartnerResourcesController.getProcessVideoLinksById(PVList2[0].Id));
        
       
  }}
}