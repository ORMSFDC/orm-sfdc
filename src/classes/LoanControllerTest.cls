@isTest
public with sharing class LoanControllerTest {

    @isTest static void getNameTest()
    { 
        // Mock data static testMethod void testGetAllClientList(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert users; 
       
        System.runAs(users) {
                 
            
            QLMS_AE__c QLMSAE1= new QLMS_AE__c();        
            QLMSAE1.Email__c='abc@glx.com';
            QLMSAE1.isActive__c=true;
            QLMSAE1.Office_Phone__c='9630266959';
            QLMSAE1.Name='Nausad';
            insert QLMSAE1;
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                QLMS_Account_Executive__c=QLMSAE1.ID,
                Assigned_PCS__c=users.Id,
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
            //Insert Record for testing the If situation
            Loan_New__c LC1 = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= false,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                              Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            Loan_New__c LC2 = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= false,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LC1);
            LoanList.add(LC2);
            insert LoanList;
            
            List<Loan_New__c> LoanNameresult = new List<Loan_New__c>();
            LoanNameresult = LoanController.getName();
            // now test the prod class as mocks are done
            system.assertEquals(2,LoanNameresult.size()); 
        }
        
        
        
    }
    
    @isTest static void GetCountTest()
    {
       
        // Mock data static testMethod void testGetAllClientList(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert users; 
       
        System.runAs(users) {
                 
            
            QLMS_AE__c QLMSAE1= new QLMS_AE__c();        
            QLMSAE1.Email__c='abc@glx.com';
            QLMSAE1.isActive__c=true;
            QLMSAE1.Office_Phone__c='9630266959';
            QLMSAE1.Name='Nausad';
            insert QLMSAE1;
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                QLMS_Account_Executive__c=QLMSAE1.ID,
                Assigned_PCS__c=users.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Email = 'Sam@gmail.com',
                Individual_Lead_source__c='Other', 
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;  
            //Insert Record for testing the If situation
       
            //Insert Record for testing the If situation
            Loan_New__c LC1 = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= false,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            Loan_New__c LC2 = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= false,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LC1);
            LoanList.add(LC2);
            insert LoanList;
            Integer GetCountResult = LoanController.getCount();
            // now test the prod class as mocks are done
            system.assertEquals(2,GetCountResult); 
        }
        
        
        
    }
    @isTest static void deleteDataControllerTest()
    {
       
        // Mock data
      //  static testMethod void testGetAllClientList(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert users; 
        System.runAs(users) {
            
            
            QLMS_AE__c QLMSAE1= new QLMS_AE__c();        
            QLMSAE1.Email__c='abc@glx.com';
            QLMSAE1.isActive__c=true;
            QLMSAE1.Office_Phone__c='9630266959';
            QLMSAE1.Name='Nausad';
            insert QLMSAE1;
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                QLMS_Account_Executive__c=QLMSAE1.ID,
                Assigned_PCS__c=users.Id,
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
            //Insert Record for testing the If situation
            Loan_New__c LC1 = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LC2 =new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LC1);
            LoanList.add(LC2);
            insert LoanList;
            // now test the prod class as mocks are done
          LoanController.deleteData(LoanList[0].id); 
        }
        
    }
    
    
    
}