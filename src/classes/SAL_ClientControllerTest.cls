@isTest()
public with sharing class SAL_ClientControllerTest {
    
    @isTest static void fetchClientsTest() {
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
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email= 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList = [Select id,Name from Client__c Limit 1];//prsn
            List<Client__c> clientListReturned;
            Loan_New__c loan = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loan;
            //Test that Records are Inserted
            
            ContactFieldPopulator.CreateContactFromClient(clientList);
            Test.startTest();
            SAL_ClientController.fetchClients(loan.Id);
            Test.stopTest();
        }  
        
    }
    
    @isTest static void SaveClientTest() {
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
                Email= 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loan = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loan;        
            Loan_New__c LoanWithoutClient =  new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345878',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Insert LoanWithoutClient;
            string loanId  = Loan.Id;
            string LoanWOClient = LoanWithoutClient.Id;
            
            Client__c Client1 = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345', LoanId__c = Loan.Id,Primary_Client_for_the_Loan__c = true);
            Client__c Client2 = new Client__c(First_Name__c = 'Leticshia', Middle_Name__c = 'Rose', Last_Name__c  = 'Schenchez',City__c='Delhi', Zip__c = '12345', LoanId__c = Loan.Id, Primary_Client_for_the_Loan__c = false);
            Insert Client1;
            //Client__c ClientInsert2 = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345', LoanId__c = Loan.Id);
            Insert Client2;
            Client__c ClientInsertEmpty = new Client__c();
            //string loanIdempty = '';
            Test.startTest();
            SAL_ClientController.SaveClient(Client1, loanId);    
            SAL_ClientController.SaveClient(Client2, LoanWOClient);
            SAL_ClientController.SaveClient(ClientInsertEmpty, LoanWOClient);
            SAL_ClientController.SaveClientNBS('[{"ClientId":'+Client1.Id+',"NonborrowingSpouseName":"fghf","NonborrowingSpousePhone":"(546) 745-7457","NonborrowingSpouseDOB":"1935-03-06","NonborrowingSpouseRelation":"Married","NonborrowingSpouseAddressSameAs":true,"NonborrowingSpouseAddress":"","NonborrowingSpouseCity":"","NonborrowingSpouseState":"","NonborrowingSpouseZip":"","NonborrowingSpouseMonthlyIncome":454,"PlaceofCelebration":"fghfgh"}]', loanId,'Yes');
             SAL_ClientController.SaveClientNBS('[{"ClientId":'+Client1.Id+',"NonborrowingSpouseName":"fghf","NonborrowingSpousePhone":"(546) 745-7457","NonborrowingSpouseDOB":"1935-03-06","NonborrowingSpouseRelation":"Married","NonborrowingSpouseAddressSameAs":true,"NonborrowingSpouseAddress":"","NonborrowingSpouseCity":"","NonborrowingSpouseState":"","NonborrowingSpouseZip":"","NonborrowingSpouseMonthlyIncome":454,"PlaceofCelebration":"fghfgh"}]', loanId,'No');
            SAL_ClientController.SaveClientNBR('[{"RecordId":"","NonborrowingResidentName":"fgh","NonborrowingResidentDOB":"1923-03-01","NonborrowingResidentRelation":"Uncle","NonborrowingResidentMonthlyIncome":456345}]',loanId,'No');
            SAL_ClientController.SaveClientNBR('[{"RecordId":"","NonborrowingResidentName":"fgh","NonborrowingResidentDOB":"1923-03-01","NonborrowingResidentRelation":"Uncle","NonborrowingResidentMonthlyIncome":456345}]',loanId,'Yes');
            string Value=SAL_ClientController.getMortgageApplied(loanId);    
            Test.stopTest();
        }
    } 
    
    @isTest static void DeleteClientTest() {
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
                Email= 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loan = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loan;        
            
            string loanId = Loan.Id;
            
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345', LoanId__c = Loan.Id);
            Insert ClientInsert;
            
            /*Income__c IncomeInsert = new Income__c(Bonus_Income__c = 0.00,OverTime_Income__c = 0.00,Commissions_Income__c = 0.00,
Dividents_Interest_Income__c = 0.00,Base_Employment_Income__c = 0.00,Net_Rental_Income__c = 0.00,
RelatedClient__c = clientId, isActive__c = true, Related_Loan__c = loanId);*/
            
            /* Address__c ObjAddress = new Address__c(Related_Client_New__c = clientId, Releted_Loan_New__c = loanId, State__c = 'Alaska', Name = 'Abcd', 
City__c = 'Zen', Number_of_years__c = 4, Zip__c = '400056');
Insert ObjAddress;*/
            
            Test.startTest();
            // SAL_ClientController.DeleteClient(clientId);
            Test.stopTest();
            
            
        }
    } 
    
    @isTest static void getClientDetailsTest() {
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
                Email= 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loan = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loan;        
            
            
            string loanId = Loan.Id;
            
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c = Loan.Id);
            Insert ClientInsert;
            
            Test.startTest();
            List <Client__c> returnList = SAL_ClientController.getClientDetails(loanId);
            System.assertEquals(1,returnList.size());
            Test.stopTest();
            
        }
    }  
    
    @isTest static void updateLiabilityForClientTest() {
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
                Email= 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loan = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loan;        
            
            
            string loanId = Loan.Id;
            
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c = Loan.Id);
            Insert ClientInsert;
            
            Test.startTest();
            SAL_ClientController.updateLiabilityForClient(loanId,ClientInsert.Id);
            //System.assertEquals(1,returnList.size());
            Test.stopTest();
            
        }
    }  
    
    @isTest static void getClientDetailsbyIdTest() {
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
                Email= 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loan = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loan;        
            string loanId = Loan.Id;
            
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c = Loan.Id);
            Insert ClientInsert;
            
            string clientId = ClientInsert.Id;
            
            Test.startTest();
            Client__c returnList = SAL_ClientController.getClientDetailsbyId(clientId);
            SAL_ClientController.DeleteClient(clientId);
            Test.stopTest();
            
            
        }
    }  
    
    @isTest static void GetClientsTest(){
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
                Email= 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c LoanInsert = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert LoanInsert;        
            string LoanId = LoanInsert.Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanInsert.Id);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            Declaration__c objDeclaration = new Declaration__c(Name = 'DRUSH', IsActive__c=true, IsDeclaration_Filled_From_Tab__c = true, DeclarationLoan__c = LoanInsert.Id, DeclarationClient__c = ClientInsert.Id);
            Insert objDeclaration; 
            
            //Test that Records are Inserted
            Test.startTest();
            SAL_ClientController.getPrimaryClientAddressDetails(LoanInsert.Id);
            SAL_ClientController.getPrimaryClientCheck(LoanInsert.Id);
            SAL_ClientController.AllClientsName(LoanId);
            //SAL_ClientController.AllClientsName(LoanId);
            SAL_ClientController.getSubjectPropertyAddressData(LoanId);
            SAL_ClientController.GetTabtatus(LoanId);
            SAL_ClientController.IsClientValidate(LoanId);
            SAL_ClientController.CreateDeclaration(ClientInsert,LoanId);
            Test.stopTest();
            
        }
    }
    
    @isTest static void UpsertNBRTest(){
        
        Loan_New__c LoanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'));
            
            insert LoanInsert;        
            string LoanId = LoanInsert.Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanInsert.Id,Non_Borrowing_Date_of_Birth__c = date.parse('10/11/1925'),
                                                   Non_Borrowing_Relation__c = 'Married', Non_Borrowing_Spouse_Addres__c = 'Delhi', 
                                                   Non_Borrowing_Spouse_City__c = 'New delhi', 
                                                   Non_Borrowing_Spouse_Name__c = 'Test Spouse', Non_Borrowing_Spouse_Phone_Number__c = '9654160090', 
                                                   Non_Borrowing_Spouse_State__c = 'California', Non_Borrowing_Spouse_Zip__c = '90001', 
                                                   Is_Non_Borrowing_Spouse_Filled__c = true, is_Active__c = true);
            Client__c ClientInsertNew = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanInsert.Id,Non_Borrowing_Date_of_Birth__c = date.parse('10/11/1925'),
                                                   Non_Borrowing_Relation__c = 'Married', Non_Borrowing_Spouse_Addres__c = 'Delhi', 
                                                   Non_Borrowing_Spouse_City__c = 'New delhi', Is_Non_Borrowing_Resident__c = true,
                                                   Non_Borrowing_Spouse_Name__c = 'Test Spouse', Non_Borrowing_Spouse_Phone_Number__c = '9654160090', 
                                                   Non_Borrowing_Spouse_State__c = 'California', Non_Borrowing_Spouse_Zip__c = '90001', 
                                                   Is_Non_Borrowing_Spouse_Filled__c = true, is_Active__c = true, Primary_Client_for_the_Loan__c=true);
            Insert ClientInsert;
            Insert ClientInsertNew;
            string ClientNewId = ClientInsertNew.Id;
            string ClientId = ClientInsert.Id;
            //List<Non_Borrowing_Resident__c> ObjNBRNotListForUpdate=new  List<Non_Borrowing_Resident__c>();
            Non_Borrowing_Resident__c ClientNBR=new Non_Borrowing_Resident__c(Loan_Id__c=LoanInsert.Id, Non_Borrowing_Resident_Name__c = 'Drush', 
                                                                              Relationship_to_Client__c = 'Father', Date_of_Birth__c = Date.parse('10/11/1920'),
                                                                              Monthly_Income__c = 15000.00, Client_Id__c = ClientInsert.Id,
                                                                              IsActiveNBR__c = true);
            
        insert ClientNBR;
        List<ClientResidentResponse>RequestList = new List<ClientResidentResponse>();
        ClientResidentResponse ObjResidentResponse = new ClientResidentResponse();
            ObjResidentResponse.ClientId = ClientNBR.Client_Id__c;
            ObjResidentResponse.RecordId = ClientNBR.Id;
            ObjResidentResponse.NonborrowingResidentName = ClientNBR.Name;
            ObjResidentResponse.NonborrowingResidentDOB = ClientNBR.Date_of_Birth__c;
            ObjResidentResponse.NonborrowingResidentRelation = ClientNBR.Relationship_to_Client__c;
            ObjResidentResponse.NonborrowingResidentMonthlyIncome = ClientNBR.Monthly_Income__c;
        ClientResidentResponse ObjResidentResponseNew = new ClientResidentResponse();
            ObjResidentResponseNew.ClientId = ClientNBR.Client_Id__c;
            ObjResidentResponseNew.RecordId = '';
            ObjResidentResponseNew.NonborrowingResidentName = ClientNBR.Name;
            ObjResidentResponseNew.NonborrowingResidentDOB = ClientNBR.Date_of_Birth__c;
            ObjResidentResponseNew.NonborrowingResidentRelation = ClientNBR.Relationship_to_Client__c;
            ObjResidentResponseNew.NonborrowingResidentMonthlyIncome = ClientNBR.Monthly_Income__c;
            RequestList.add(ObjResidentResponse);
            RequestList.add(ObjResidentResponseNew);
            String NBRList = json.serialize(RequestList);
        
        List<ClientSpouseResponse>RequestLst = new List<ClientSpouseResponse>();
        ClientSpouseResponse ObjSpouseResponse = new ClientSpouseResponse();
        ObjSpouseResponse.ClientId = ClientInsert.Id;
        //ObjSpouseResponse.NonborrowingSpouseYesNo  = ;
        ObjSpouseResponse.NonborrowingSpouseName = ClientInsert.Non_Borrowing_Spouse_Name__c;
            ObjSpouseResponse.NonborrowingSpousePhone = ClientInsert.Non_Borrowing_Spouse_Phone_Number__c;
            ObjSpouseResponse.NonborrowingSpouseDOB = ClientInsert.Non_Borrowing_Date_of_Birth__c;
            ObjSpouseResponse.NonborrowingSpouseRelation = ClientInsert.Non_Borrowing_Relation__c;
            ObjSpouseResponse.NonborrowingSpouseAddressSameAs = true;
            ObjSpouseResponse.NonborrowingSpouseAddress = ClientInsert.Non_Borrowing_Spouse_Addres__c;
            ObjSpouseResponse.NonborrowingSpouseCity = ClientInsert.Non_Borrowing_Spouse_City__c;
            ObjSpouseResponse.NonborrowingSpouseState = ClientInsert.Non_Borrowing_Spouse_State__c;
            ObjSpouseResponse.NonborrowingSpouseZip = ClientInsert.Non_Borrowing_Spouse_Zip__c;
            RequestLst.Add(ObjSpouseResponse);
            String NBSList = json.serialize(RequestLst);
        
        Test.startTest();
        SAL_ClientController.UpsertNBR(NBRList,LoanId,ClientId);
        SAL_ClientController.UpsertNBR(NBRList,LoanId,ClientNewId);
        SAL_ClientController.UpsertNBS(NBSList,LoanId);
        SAL_ClientController.SaveClientNBRNo(LoanId);
        SAL_ClientController.ShowNBRData(LoanId);
        SAL_ClientController.ShowNBR(LoanId);
        SAL_ClientController.ShowNBS(LoanId);
        SAL_ClientController.ShowNBSData(LoanId);
        // line 618 - SaveClientNBR(string NBRList,String LoanId,string ISNBR) 
        SAL_ClientController.SaveClientNBSNO(LoanId);
        SAL_ClientController.getclientValue(LoanId);
        SAL_ClientController.getClientCount(LoanId);
        SAL_ClientController.getPrimaryClientNBSYes(LoanId);
        SAL_ClientController.getPrimaryClientNBRYes(LoanId);
        Test.stopTest();
    }
}