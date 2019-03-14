@isTest
public with sharing class PipeLineControllerTest {
    
    @isTest Static void getLoanOriginationTest()
    {
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
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Potential_Portal_User_Status__c = 'Training In Process',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;
            //Create Loan
            Loan_New__c LoanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Proposal',LoanNumber__c = '12345'
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LoanInsert2 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Proposal',LoanNumber__c = ''
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LoanInsert1);
            LoanList.add(LoanInsert2);
            Insert LoanList;
            string LoanId = LoanList[0].Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanList[0].Id, Primary_Client_for_the_Loan__c = true);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            PipelineResponse objPipeLine1 = new PipelineResponse();
            
            objPipeLine1.Loanid=LoanList[0].Id;
            
            objPipeLine1.LoanNumber=LoanInsert1.LoanNumber__c;
            //objPipeLine.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine1.FullName='john albert';
            objPipeLine1.LoanStatus='active';
            objPipeLine1.LoanDate='01/01/2017';
            
            PipelineResponse objPipeLine2 = new PipelineResponse();
            
            objPipeLine2.Loanid=LoanList[1].Id;
            
            //objPipeLine.LoanNumber=LoanInsert1.LoanNumber__c;
            objPipeLine2.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine2.FullName='john albert';
            objPipeLine2.LoanStatus='active';
            objPipeLine2.LoanDate='01/01/2017';
            
            
            //Test that Records are Inserted
            List<PipelineResponse> Loan1 = PipeLineController.getLoanOrigination();
            System.assertEquals(Loan1.size(),2);
        }  
    }
    
    @isTest Static void getLoanProcessingTest()
    {
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
                Potential_Portal_User_Status__c = 'Training In Process',
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;
            //Create Loan LoanStatus__c ='In Processing'
            Loan_New__c LoanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',LoanNumber__c = '12345'
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LoanInsert2 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',LoanNumber__c = ''
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LoanInsert1);
            LoanList.add(LoanInsert2);
            Insert LoanList;
            string LoanId = LoanList[0].Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanList[0].Id, Primary_Client_for_the_Loan__c = true);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            PipelineResponse objPipeLine1 = new PipelineResponse();
            
            objPipeLine1.Loanid=LoanList[0].Id;
            
            objPipeLine1.LoanNumber=LoanInsert1.LoanNumber__c;
            //objPipeLine.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine1.FullName='john albert';
            objPipeLine1.LoanStatus='active';
            objPipeLine1.LoanDate='01/01/2017';
            
            PipelineResponse objPipeLine2 = new PipelineResponse();
            
            objPipeLine2.Loanid=LoanList[1].Id;
            
            //objPipeLine.LoanNumber=LoanInsert1.LoanNumber__c;
            objPipeLine2.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine2.FullName='john albert';
            objPipeLine2.LoanStatus='active';
            objPipeLine2.LoanDate='01/01/2017';
            //Test that Records are Inserted
            List<PipelineResponse> Loan1 = PipeLineController.getLoanProcessing();
            System.assertEquals(Loan1.size(),2);
        }
        
    }
    
    @isTest Static void getLoanUnderWritingTest()
    {
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
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Potential_Portal_User_Status__c = 'Training In Process',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;
            //Conditionally Approved
            Loan_New__c LoanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Conditionally Approved',LoanNumber__c = '12345'
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LoanInsert2 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Conditionally Approved',LoanNumber__c = ''
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LoanInsert1);
            LoanList.add(LoanInsert2);
            Insert LoanList;
            string LoanId = LoanList[0].Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanList[0].Id, Primary_Client_for_the_Loan__c = true);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            PipelineResponse objPipeLine1 = new PipelineResponse();
            
            objPipeLine1.Loanid=LoanList[0].Id;
            
            objPipeLine1.LoanNumber=LoanInsert1.LoanNumber__c;
            //objPipeLine.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine1.FullName='john albert';
            objPipeLine1.LoanStatus='active';
            objPipeLine1.LoanDate='01/01/2017';
            
            PipelineResponse objPipeLine2 = new PipelineResponse();
            
            objPipeLine2.Loanid=LoanList[1].Id;
            
            //objPipeLine.LoanNumber=LoanInsert1.LoanNumber__c;
            objPipeLine2.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine2.FullName='john albert';
            objPipeLine2.LoanStatus='active';
            objPipeLine2.LoanDate='01/01/2017';
            
            //Test that Records are Inserted
            List<PipelineResponse> Loan1 = PipeLineController.getLoanUnderWriting();
            System.assertEquals(Loan1.size(),2);
        }
        
    }
    
    @isTest Static void getLoanSuspendedTest()
    {
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
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Potential_Portal_User_Status__c = 'Training In Process',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;
            //Create Loan Suspended
            Loan_New__c LoanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Suspended',LoanNumber__c = '12345'
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LoanInsert2 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Suspended',LoanNumber__c = ''
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LoanInsert1);
            LoanList.add(LoanInsert2);
            Insert LoanList;
            string LoanId = LoanList[0].Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanList[0].Id, Primary_Client_for_the_Loan__c = true);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            PipelineResponse objPipeLine1 = new PipelineResponse();
            
            objPipeLine1.Loanid=LoanList[0].Id;
            
            objPipeLine1.LoanNumber=LoanInsert1.LoanNumber__c;
            //objPipeLine.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine1.FullName='john albert';
            objPipeLine1.LoanStatus='active';
            objPipeLine1.LoanDate='01/01/2017';
            
            PipelineResponse objPipeLine2 = new PipelineResponse();
            
            objPipeLine2.Loanid=LoanList[1].Id;
            
            //objPipeLine.LoanNumber=LoanInsert1.LoanNumber__c;
            objPipeLine2.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine2.FullName='john albert';
            objPipeLine2.LoanStatus='active';
            objPipeLine2.LoanDate='01/01/2017';
            //Test that Records are Inserted
            List<PipelineResponse> Loan1 = PipeLineController.getLoanSuspended();
            System.assertEquals(Loan1.size(),2);
        }
    }
    
    @isTest Static void getLoanClosingTest()
    {
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
                Potential_Portal_User_Status__c = 'Training In Process',
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;
            //Create Loan
            Loan_New__c LoanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Closed - Awaiting Funding',LoanNumber__c = '12345'
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LoanInsert2 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Closed - Awaiting Funding',LoanNumber__c = ''
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LoanInsert1);
            LoanList.add(LoanInsert2);
            Insert LoanList;
            string LoanId = LoanList[0].Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanList[0].Id, Primary_Client_for_the_Loan__c = true);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            PipelineResponse objPipeLine1 = new PipelineResponse();
            
            objPipeLine1.Loanid=LoanList[0].Id;
            
            objPipeLine1.LoanNumber=LoanInsert1.LoanNumber__c;
            //objPipeLine.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine1.FullName='john albert';
            objPipeLine1.LoanStatus='active';
            objPipeLine1.LoanDate='01/01/2017';
            
            PipelineResponse objPipeLine2 = new PipelineResponse();
            
            objPipeLine2.Loanid=LoanList[1].Id;
            
            //objPipeLine.LoanNumber=LoanInsert1.LoanNumber__c;
            objPipeLine2.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine2.FullName='john albert';
            objPipeLine2.LoanStatus='active';
            objPipeLine2.LoanDate='01/01/2017';
            //Test that Records are Inserted
            List<PipelineResponse> Loan1 = PipeLineController.getLoanClosing();
            System.assertEquals(Loan1.size(),2);
        }
    }
    
    @isTest Static void getLoanFundedTest()
    {
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
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                Potential_Portal_User_Status__c = 'Training In Process',
                AccountId = portalAccount.Id);
            insert contact;
            //Create Loan Funded
            Loan_New__c LoanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',LoanNumber__c = '12345'
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LoanInsert2 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',LoanNumber__c = ''
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LoanInsert1);
            LoanList.add(LoanInsert2);
            Insert LoanList;
            string LoanId = LoanList[0].Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanList[0].Id, Primary_Client_for_the_Loan__c = true);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            PipelineResponse objPipeLine1 = new PipelineResponse();
            
            objPipeLine1.Loanid=LoanList[0].Id;
            
            objPipeLine1.LoanNumber=LoanInsert1.LoanNumber__c;
            //objPipeLine.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine1.FullName='john albert';
            objPipeLine1.LoanStatus='active';
            objPipeLine1.LoanDate='01/01/2017';
            
            PipelineResponse objPipeLine2 = new PipelineResponse();
            
            objPipeLine2.Loanid=LoanList[1].Id;
            
            //objPipeLine.LoanNumber=LoanInsert1.LoanNumber__c;
            objPipeLine2.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine2.FullName='john albert';
            objPipeLine2.LoanStatus='active';
            objPipeLine2.LoanDate='01/01/2017';
            //Test that Records are Inserted
            List<PipelineResponse> Loan1 = PipeLineController.getLoanFunded();
            System.assertEquals(Loan1.size(),2);
        }
        
    }
    
    @isTest Static void getLoanCancelledTest()
    {
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
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Potential_Portal_User_Status__c = 'Training In Process',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;
            //Create Loan Denied or Withdrawn
            Loan_New__c LoanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Denied',LoanNumber__c = '12345'
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LoanInsert2 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Withdrawn',Who_Requested_the_Withdraw__c='Test Client',LoanNumber__c = ''
                ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LoanInsert1);
            LoanList.add(LoanInsert2);
            Insert LoanList;
            string LoanId = LoanList[0].Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanList[0].Id, Primary_Client_for_the_Loan__c = true);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            PipelineResponse objPipeLine1 = new PipelineResponse();
            
            objPipeLine1.Loanid=LoanList[0].Id;
            
            objPipeLine1.LoanNumber=LoanInsert1.LoanNumber__c;
            //objPipeLine.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine1.FullName='john albert';
            objPipeLine1.LoanStatus='active';
            objPipeLine1.LoanDate='01/01/2017';
            
            PipelineResponse objPipeLine2 = new PipelineResponse();
            
            objPipeLine2.Loanid=LoanList[1].Id;
            
            //objPipeLine.LoanNumber=LoanInsert1.LoanNumber__c;
            objPipeLine2.LoanNumber=LoanInsert2.LoanNumber__c;
            objPipeLine2.FullName='john albert';
            objPipeLine2.LoanStatus='active';
            objPipeLine2.LoanDate='01/01/2017';
            //Test that Records are Inserted
            List<PipelineResponse> Loan1 = PipeLineController.getLoanCancelled();
            System.assertEquals(Loan1.size(),2);
        }
    }
    
    @isTest Static void getLoanSummaryTest()
    {
        try
        {
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
                    Potential_Portal_User_Status__c = 'Training In Process',
                    Email = 'Sam@gmail.com',
                    Contact_NMLS__c = '12345',
                    Source_Name__c='Michael',
                    AccountId = portalAccount.Id);
                insert contact;
                //Create Client
                Loan_New__c LoanInsert = new Loan_New__c(
                    IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanNumber__c = '12345',
                    FundtoClose__c=0.00, PropertyAppraisalValue__c=0.00,
                    TotalLesa__c=0.00,BrokerCompensation__c=0.00,
                    FinancialAssessmentResult__c='',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                    ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
                Insert LoanInsert;
                Id LoanId = LoanInsert.Id;
                Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                       Email_Optional__c='Test@ormpartner.com',DOB__c=date.today(), LoanId__c =LoanInsert.Id, Primary_Client_for_the_Loan__c = true, Phone_Number__c = '1234567890');
                Insert ClientInsert;
                string ClientId = ClientInsert.Id;
                
                PipeLineSummaryResponse objPipeLineSummary = new PipeLineSummaryResponse();
                objPipeLineSummary.LoanNumberDetails =LoanInsert.LoanNumber__c;     
                objPipeLineSummary.FullName =ClientInsert.Name +' '+ ClientInsert.Last_Name__c;
                datetime dt=ClientInsert.DOB__c;
                objPipeLineSummary.DateofBirth =dt.format();
                objPipeLineSummary.Phone ='9876543210';
                objPipeLineSummary.Email ='jsharma@try.com';
                objPipeLineSummary.ProAppValue =100.00;
                //objPipeLineSummary.CashAvlClient =100.00;
                objPipeLineSummary.CashDueClosing =100.00;
                //objPipeLineSummary.MonthPayAvlClient =100.00;
                objPipeLineSummary.FinancialAsstResult ='test Result';
                objPipeLineSummary.Email ='jsharma@try.com';
                objPipeLineSummary.LESA =100.00;
                objPipeLineSummary.BrokerComp =100.00;
                
                
                
                Test.startTest();
                PipeLineController.getLoanSummary(LoanId);
                Test.stopTest();
                //System.assertEquals(PipeLineSummary.size(),2);
            }
        } 
        catch(Exception ex)
        {}
        
        
    }
    
    @isTest Static void getLoanDetailsTest()
    {
        try
        {
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
                    Potential_Portal_User_Status__c = 'Training In Process',
                    Individual_Lead_source__c='Other', 
                    Email = 'Sam@gmail.com',
                    Contact_NMLS__c = '12345',
                    Source_Name__c='Michael',
                    AccountId = portalAccount.Id);
                insert contact;
                //Create ClientInfo
                Loan_New__c LoanInsert = new Loan_New__c(Application_Date__c=system.today() 
                                                         ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                                         ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
                Insert LoanInsert;
                string LoanId = LoanInsert.Id;
                Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', DOB__c=date.today(), Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                       LoanId__c =LoanInsert.Id);
                Insert ClientInsert;
                Id ClientId = ClientInsert.Id;
                
                string username='ormpartner@orm.com';
                string phone= PipeLineController.FormatPhone('9654160090');
                
                PipeLineDetailsResponse objPinew=new PipeLineDetailsResponse();
                objPinew.LoanNumberDetails=LoanInsert.LoanNumber__c ;
                objPinew.FullName=ClientInsert.Name +' '+ ClientInsert.Last_Name__c;
                objPinew.LoanStatus=LoanInsert.LoanStatus__c;
                objPinew.Address=ClientInsert.Street_Address__c+','+ ClientInsert.Client_State__c +','+ClientInsert.Zip__c;
                objPinew.Phone=phone;  
                datetime dt=ClientInsert.DOB__c;
                objPinew.LoanDate=dt.format();
                objPinew.CreatedBy=username; 
                
                
                //Test that Records are Inserted
                //PipeLineSummaryResponse PipeLineSummary = 
                Test.startTest();
                //id ClientId = LoanList.Id;
                //set<string> resultIds = (new Map<string,SObject>(LoanList)).keySet();
                //Id ClientId = Id.valueOf(resultIds);
                
                PipeLineController.getLoanDetails(LoanId);
                Test.stopTest();
            }
            //System.assertEquals(PipeLineSummary.size(),2);
        }
        catch(Exception ex)
        {}
    }
    
    @isTest Static void getEmailDataTest()
    {
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
            
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '12345',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Loan Officer', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Potential_Portal_User_Status__c = 'Training In Process',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;       
            Loan_New__c LoanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '123459878',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
            insert LoanInsert; 
            string LoanId = LoanInsert.Id;
            Loan_New__c LoanInsertOtherContact = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                                 LoanNumber__c = '98712345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                                 Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                                 Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                                 Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                                 Related_Partner__c = portalAccount.Id,
                                                                 PipeLine_OtherContactFlag__c=false,Alternate_Contact_Name__c = 'Dtron',
                                                                 Alternate_Contact_Phone_number__c='9654160090',PipeLine_BestContact__c = 'Drush,(123) 456-7890');
                                                                
            Insert LoanInsertOtherContact;
            string OtherContactLoanId = LoanInsertOtherContact.Id;
            
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanInsert.Id, Primary_Client_for_the_Loan__c = true,
                                                   Home_Phone__c = PipeLineController.FormatPhone('9654160090'));
            Insert ClientInsert;
            Id ClientId = ClientInsert.Id;
            
            Client__c ClientInsertOtherContact = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                               LoanId__c =LoanInsertOtherContact.Id, Primary_Client_for_the_Loan__c = true,
                                                               Home_Phone__c = PipeLineController.FormatPhone('9654160090'));
            Insert ClientInsertOtherContact;
            Id ClientIdOtherContact = ClientInsertOtherContact.Id;
            
            
            string username='ormpartner@orm.com';
            
            string phone=PipeLineController.FormatPhone('9654160090');
            
            PipeLineEmailResponse objSummary=new PipeLineEmailResponse();
            
            boolean OtherContactLoanTrue = LoanInsert.PipeLine_OtherContactFlag__c;
            boolean OtherContactLoanFalse = LoanInsertOtherContact.PipeLine_OtherContactFlag__c;
            if(OtherContactLoanTrue == true){
                objSummary.LoanNumberDetails=LoanInsert.LoanNumber__c;
                objSummary.BorrowerName=ClientInsert.First_Name__c +' '+ ClientInsert.Last_Name__c; 
                datetime dt=date.today();   
                string dttest=dt.format();
                //system.debug(dttest);
                
                objSummary.ContactTime=dttest;
                objSummary.Phone=ClientInsert.Phone_Number__c;
                objSummary.partnerName=username;
                
                objSummary.LoanStatus=LoanInsert.LoanStatus__c;
                objSummary.OrderAppFlag=LoanInsert.IsOrderAppraisalFlag__c;
                objSummary.BestContact=LoanInsert.PipeLine_BestContact__c;
                objSummary.BestContactList=PipeLineController.getBestContactList(LoanInsert.Id);           
                objSummary.OtherContactFlag=LoanInsert.PipeLine_OtherContactFlag__c;
                objSummary.BestContact='New/Other';
                String bestcontact=LoanInsert.PipeLine_BestContact__c;
                String[] arrContact = bestcontact.split('\\,');
                
                objSummary.OtherContactName=arrContact[0];
                objSummary.OtherContactPhone=arrContact[1];
            }
            if(OtherContactLoanFalse == false){
                objSummary.LoanNumberDetails=LoanInsertOtherContact.LoanNumber__c;
                objSummary.BorrowerName=ClientInsertOtherContact.First_Name__c +' '+ ClientInsertOtherContact.Last_Name__c; 
                datetime dt=date.today();   
                string dttest=dt.format();
                //system.debug(dttest);
                
                objSummary.ContactTime=dttest;
                objSummary.Phone=ClientInsertOtherContact.Phone_Number__c;
                objSummary.partnerName=username;
                
                objSummary.LoanStatus=LoanInsertOtherContact.LoanStatus__c;
                objSummary.OrderAppFlag=LoanInsertOtherContact.IsOrderAppraisalFlag__c;
                objSummary.BestContact=LoanInsertOtherContact.PipeLine_BestContact__c;
                objSummary.BestContactList=PipeLineController.getBestContactList(LoanInsertOtherContact.Id);           
                objSummary.OtherContactFlag=LoanInsertOtherContact.PipeLine_OtherContactFlag__c;
                objSummary.BestContact=LoanInsertOtherContact.PipeLine_BestContact__c;
                objSummary.OtherContactName='';
                objSummary.OtherContactPhone='';
            }
            
            //Test that Records are Inserted
            //PipeLineSummaryResponse PipeLineSummary = 
            Test.startTest();
            PipeLineController.getEmailData(LoanId);
            PipeLineController.getEmailData(OtherContactLoanId);
            Test.stopTest();
            //System.assertEquals(PipeLineSummary.size(),2);
        }
    }
    
    @isTest Static void UpdateLoanPipeLineEmailTest()
    {
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
            
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '12345',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Loan Officer', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Potential_Portal_User_Status__c = 'Training In Process',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;       
            Loan_New__c LoanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
            insert LoanInsert; 
            string LoanId = LoanInsert.Id;
            
            string JsonDataOld = '{"BestContactList":["Ronald Zaglin, (631) 864-5258","sdfsf, (123) 242-3432","New/Other"],"BorrowerName":"Ronald Zaglin","LoanOfficerName":"Michael Foster","LoanStatus":"Proposal","OrderAppFlag":false,"OtherContactFlag":false,"OtherContactName":"","OtherContactPhone":"","partnerName":"John Partner"}';
            string JsonDataNew = '{"BestContactList":["Alice Firstimer, (248) 255-5555","1234567890, (123) 456-7890","New/Other"],"BorrowerName":"Alice Firstimer","LoanOfficerName":"Bruce Olsen","LoanStatus":"Proposal","OrderAppFlag":false,"OtherContactFlag":false,"OtherContactName":"Drush","OtherContactPhone":"(965) 416-0090","partnerName":"John Partner","BestContact":"New/Other","ContactTime":"00:00"}';
            //Test that Records are Inserted
            //PipeLineSummaryResponse PipeLineSummary = 
            Test.startTest();
            PipeLineController.UpdateLoanPipeLineEmail(JsonDataOld,LoanId);
            PipeLineController.UpdateLoanPipeLineEmail(JsonDataNew,LoanId);
            Test.stopTest();
        }
    }
    
    @isTest static void GetAEAndPhoneTest()
    {
        
        QLMS_AE__c QLMSAE= new QLMS_AE__c();        
        QLMSAE.Email__c='abc@glx.com';
        QLMSAE.isActive__c=true;
        QLMSAE.Office_Phone__c='9630266959';
        QLMSAE.Name='Nausad';
        insert QLMSAE;
        // QLMS_Account_Executive__c=QLMSAE.ID,
        Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            //Email__c='test@noemail.com',
            QLMS_Account_Executive__c=QLMSAE.ID,
            Main_Phone__c='5414147852',
            Partner_Lead_Status__c='New');
        insert portalAccount;
        
        Contact contact = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Potential_Portal_User_Status__c = 'Training In Process',
            Individual_Lead_source__c='Other', 
            Email = 'Sam@gmail.com',
            //How_did_you_hear_about_us__c='Twitter', 
            //Individual_lead_Status__c='New',
            
            Source_Name__c='Michael',
            AccountId = portalAccount.Id);
        insert contact;
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
            //Blob FileData = Blob.valueOf('/services/data/v40.0/sobjects/Attachment/00P0q000000Ua3fEAC/Body');
            Test.startTest();
            User ReturnUser = PipeLineController.GetAEAndPhone();
            Test.stopTest();
            //system.assertEquals(ReturnUser.Username, users.Username);
        }
    }
    
    @isTest Static void SendMailTest()
    {
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
            
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '12345',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Loan Officer', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Potential_Portal_User_Status__c = 'Training In Process',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;       
            Loan_New__c LoanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
            insert LoanInsert; 
            string LoanIdFor = LoanInsert.Id;
            String getUserEmailID ='dkhar@galaxe.com';
            String getUsername ='Dhiresh';
            String LoanOfficerName = 'Nausad';
            String LoanNumberBlank = ' ';
            String LoanOfficerNameBlank = ' ';
            PipeLineEmailResponse Email = new PipeLineEmailResponse();
            Email.LoanNumberDetails ='12345'; 
            Email.BorrowerName ='test';
            Email.ContactTime ='4 am';
            Email.Phone ='9876543219';
            Email.LoanOfficerName ='Albert';
            Email.partnerName ='John';
            
            
            
            Test.startTest();
            PipeLineController.sendMail(Email.BorrowerName, getUserEmailID, Email.LoanNumberDetails, Email.Phone, Email.partnerName, LoanOfficerName,  Email.ContactTime,LoanIdFor);
            PipeLineController.sendMail(Email.BorrowerName, getUserEmailID, LoanNumberBlank, Email.Phone, Email.partnerName, LoanOfficerNameBlank,  Email.ContactTime,LoanIdFor);    
            Test.stopTest();
        }
        //System.assertEquals(Email.partnerName, 'John');
    }
    
    @isTest Static void GetDisclouserHistoryTest()
    {
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
            
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '12345',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Loan Officer', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Potential_Portal_User_Status__c = 'Training In Process',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;       
            Loan_New__c LoanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
            insert LoanInsert; 
            string LoanId = LoanInsert.Id;
            PipeLineReDisclouserHistoryResponse pipeLineHistoryRes = new PipeLineReDisclouserHistoryResponse();
            pipeLineHistoryRes.CurrentDisclouserDate = '01/01/1990';
            pipeLineHistoryRes.oldDisclouserDate = '01/01/1991';
            pipeLineHistoryRes.DisclouserReason = 'Disclouser';
            pipeLineHistoryRes.ReasonChangeDate = '01/01/1993';
            
            //List<PipeLine_ReDisclosure_Reason__c> obj=new List<PipeLine_ReDisclosure_Reason__c>();
            PipeLine_ReDisclosure_Reason__c ReDisclosureReasonIns = new  PipeLine_ReDisclosure_Reason__c(
                NewReDisclosurer_Date__c = date.today(),
                OldReDisclosurer_Date__c = date.today(),
                ReDisclosure_Reason__c = 'Test Reason',
                LoanId__c= LoanInsert.Id);
            Insert ReDisclosureReasonIns;
            Test.startTest();
            PipeLineController.GetDisclouserHistory(LoanId);
            Test.stopTest();
        }
        //System.assertEquals(Email.partnerName, 'John');
    }
    
    @isTest Static void GetLoanStatusHistoryTest()
    {
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
            
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '12345',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Loan Officer', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Potential_Portal_User_Status__c = 'Training In Process',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;       
            Loan_New__c LoanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
            insert LoanInsert; 
            string LoanId = LoanInsert.Id;
            
            PipeLineStatusChangeResponse objPipeLineSummary = new PipeLineStatusChangeResponse();
            objPipeLineSummary.LoanCurrentStatus ='Current';     
            objPipeLineSummary.LoanPrevioustatus ='Previuos';
            objPipeLineSummary.LoanStatusChangeDate ='01/01/1991';
            
            //List<PipeLine_ReDisclosure_Reason__c> obj=new List<PipeLine_ReDisclosure_Reason__c>();
            
            LoanStatus__c LoanStatusIns = new  LoanStatus__c(
                Name = 'Drush',
                PreviousStatus__c = 'In Processing',
                LoanId__c= LoanInsert.Id);
            Insert LoanStatusIns;
            Test.startTest();
            PipeLineController.GetLoanStatusHistory(LoanId);
            Test.stopTest();
        }
        //System.assertEquals(Email.partnerName, 'John');
    }
    
    @isTest Static void getLoanDateTest()
    {
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
                Potential_Portal_User_Status__c = 'Training In Process',
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;
            
            Loan_New__c LoanInsert = new Loan_New__c(Application_Date__c = date.today(),Appraisal_Ordered_Date__c = date.today(),Appraisal_sent_to_Client_Date__c = date.parse('11/01/2017'),                                                 
                                                     Closing_Date__c = date.parse('12/29/2017'),Counseling_Date__c = date.parse('12/29/2017'),FHA_Case_Number_Date__c = date.parse('11/11/2017'),
                                                     HOI_Effective_Date__c = date.parse('11/15/2017'),Next_Tax_Due_Date__c = date.parse('11/19/2017'),
                                                     Recent_Re_disclosure_Date__c = date.parse('12/24/2017'),Re_disclosure_Date__c = date.parse('12/24/2017'),ReDisclosure_Reason__c = 'Add Borrower',
                                                     Other_ReDisclosure_Reason__c = 'Other Redisclosure Reason',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                                     IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Proposal',
                                                     LoanNumber__c = '12345', Preferred_Contact_Type__c = 'Loan Officer',
                                                     Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);

            Insert LoanInsert;
            string LoanId = LoanInsert.Id;
            Test.startTest();
            PipeLineController.getLoanDetails(LoanId);
            PipeLineController.getLoanDate(LoanId);
            PipeLineController.getLoanSummary(LoanId);
            Test.stopTest();
        }
        //System.assertEquals(Email.partnerName, 'John');
    }
    
    @isTest(SeeAllData=True) //Bala - 4/20
    public Static void createTaskTest()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;        
        User u = [SELECT id from User where ContactId =: System.Label.Con_Id];      
        Contact c = [SELECT id, AccountId from Contact where Id =: System.Label.Con_Id ];       
        system.runAs(u)
        {            
            Loan_New__c LoanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = c.Id,
                                                     Related_Partner__c = c.AccountId);
            List<Loan_New__c> LoanList = new List<Loan_New__c>();
            LoanList.add(LoanInsert);
            insert LoanList; 
            string LoanId = LoanList[0].Id;
            
            Test.startTest();       
               PipeLineController.CreateTask(LoanId);
               PipeLineController.CreateLoanTask(LoanId);    
            Test.stopTest();
        }        
    }
    
    @isTest Static void UpdatePipelineTest()
    {
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
            
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '12345',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Loan Officer', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Potential_Portal_User_Status__c = 'Training In Process',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;       
            Loan_New__c LoanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
            insert LoanInsert; 
            string LoanId = LoanInsert.Id;
            
           Test.startTest();
           PipeLineController.UpdatePipeline(LoanInsert, LoanId);
           PipeLineController.IsDataAvailable();
           //PipeLineController.SaveTask(LoanInsert,LoanInsert.id,'test',null,userinfo.getUserid());
           Test.stopTest();
        }
    }
}
