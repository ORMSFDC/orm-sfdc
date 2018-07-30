@isTest
public with sharing class Sal_IncomeControllerTest {
    @isTest static void clientValueTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;            
        system.runAs(user1)
        {
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
                Assigned_PCS__c=user1.Id,
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
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(Loan_Originator_s_First_Name__c='Drush',Loan_Originator_s_Last_Name__c ='Test',
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
             //Test that Records are Inserted
        Test.startTest();
        Sal_IncomeController.getclientValue(LoanInsert.Id);
        Test.stopTest();
        }
        //System.assertEquals(LoanList.isEmpty(),false);
    }
    @isTest static void IncomeDataTest(){
         Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;            
        system.runAs(user1)
        {
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
                Assigned_PCS__c=user1.Id,
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
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(Loan_Originator_s_First_Name__c='Drush',Loan_Originator_s_Last_Name__c ='Test',
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                LoanId__c =LoanInsert.Id);
        Insert ClientInsert;
        //id ClientId0 = ClientList[0].id;
        system.debug(ClientInsert);
        string ClientId = ClientInsert.Id;
        Income__c IncomeInsert = new Income__c(Bonus_Income__c = 0.00,OverTime_Income__c = 0.00,Commissions_Income__c = 0.00,
                                               Dividents_Interest_Income__c = 0.00,Base_Employment_Income__c = 0.00,Net_Rental_Income__c = 0.00,
                                                RelatedClient__c = ClientInsert.Id, isActive__c = true, Related_Loan__c = LoanInsert.Id);
        insert IncomeInsert;
        //id ClientId1 = ClientList[1].id;
        Test.startTest();
        Sal_IncomeController.getIncomeData(ClientId);
        Test.stopTest();
        //system.debug(ObjIncome);
        //System.assertEquals(ClientInsert.isEmpty(),false);
        }
    }
    @isTest static void AllIncomeTest(){
     Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;            
        system.runAs(user1)
        {
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
                Assigned_PCS__c=user1.Id,
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
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(Loan_Originator_s_First_Name__c='Drush',Loan_Originator_s_Last_Name__c ='Test',
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;            
        Client__c ClientInsert = new Client__c(First_Name__c = 'Sachin', Last_Name__c  = 'Sharma',City__c='Delhi', Zip__c = '12345',
                                                LoanId__c =LoanInsert.Id);
        Insert ClientInsert;
         string ClientId = ClientInsert.Id;
        Income__c IncomeInsert = new Income__c(Social_Security_Disability_Income__c = 0.00,Pension_Retirement_Income__c= 0.00,Commissions_Income__c = 0.00,
                                               Dividents_Interest_Income__c = 0.00,Base_Employment_Income__c = 0.00,Net_Rental_Income__c = 0.00,
                                                RelatedClient__c = ClientInsert.Id, isActive__c = true, Related_Loan__c = LoanInsert.Id);
        insert IncomeInsert; 
        
        Test.startTest();        
        Sal_IncomeController.getAllIncome(LoanInsert.Id);
        Test.stopTest();
        }
    }
    @IsTest Static void incomesaveTest(){
         Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;            
        system.runAs(user1)
        {
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
                Assigned_PCS__c=user1.Id,
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
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(Loan_Originator_s_First_Name__c='Drush',Loan_Originator_s_Last_Name__c ='Test',
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
        Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                LoanId__c =LoanInsert.Id);
        Insert ClientInsert;
         string ClientId = ClientInsert.Id;
        Income__c IncomeInsert = new Income__c(Bonus_Income__c = 0.00,OverTime_Income__c = 0.00,Commissions_Income__c = 0.00,
                                               Dividents_Interest_Income__c = 0.00,Base_Employment_Income__c = 0.00,Net_Rental_Income__c = 0.00,
                                                RelatedClient__c = ClientInsert.Id, isActive__c = true, Related_Loan__c = LoanInsert.Id);
        insert IncomeInsert; 
       
        string loanId = LoanInsert.Id;
        Test.startTest();
        Sal_IncomeController.incomesave(IncomeInsert,ClientId,loanId);
        Test.stopTest();
    }
    }

}