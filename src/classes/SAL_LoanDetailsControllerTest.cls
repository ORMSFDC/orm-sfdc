@IsTest
public with sharing class SAL_LoanDetailsControllerTest {

    @isTest static void GetLoanDetailsByIdTest(){
        Loan_New__c ObjNewLoan = new Loan_New__c();
        Id Loan_Id;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Account Executive'];  
        UserRole UR1=[Select Id from UserRole where Name='Partner Care Specialist Lead'];
        
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

		String orgId1 = UserInfo.getOrganizationId();
        String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName1 = orgId1 + dateString1 + randomInt1;
        
         User user2 = new User(Alias = uniqueName1.substring(18, 23),  email = uniqueName1 + '@test1' + orgId1 + '.org',
                              Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR1.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user2;
        
        system.runAs(user1)
        {
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user2.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id,
            Potential_Portal_User_Status__c = 'Ready',
            	RecordTypeId=RecortypeId);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c ObjLoan = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert ObjLoan;         
        Loan_Id = objLoan.Id;
       
        Test.startTest();
        ObjNewLoan = SAL_LoanDetailsController.GetLoanDetailsById(Loan_Id);
        Test.stopTest();
        }
        //system.debug('ObjNewLoan.Id'+ObjNewLoan.Id);
        System.assertEquals(ObjNewLoan.Id, Loan_Id);
    }
    
    @isTest static void SaveLoanWithPreferredContactTest(){
     	Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Account Executive'];  
        UserRole UR1=[Select Id from UserRole where Name='Partner Care Specialist Lead'];
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles',IsActive = true);
        insert user1;  
        
        String orgId1 = UserInfo.getOrganizationId();
        String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName1 = orgId1 + dateString1 + randomInt1;
        
         User user2 = new User(Alias = uniqueName1.substring(18, 23),  email = uniqueName1 + '@test1' + orgId1 + '.org',
                              Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR1.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user2;
        
        system.runAs(user1)
        {
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user2.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id,
            	Potential_Portal_User_Status__c = 'Ready',
            	RecordTypeId=RecortypeId);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c ObjLoan = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert ObjLoan;        
                Id Loan_Id = objLoan.Id;
            
            LoanProcessorResponse ObjLoanProcessor = New LoanProcessorResponse();
                                      
                ObjLoanProcessor.Id = user1.Id;
                ObjLoanProcessor.LoanProcessorName=user1.Name;
                    
            LoanOfficerResponse ObjLoanOfficer = New LoanOfficerResponse();
               
                ObjLoanOfficer.Id = user1.Id;
                ObjLoanOfficer.LoanofficerName=user1.Name;
       
        Test.startTest();
        SAL_LoanDetailsController.SaveLoanWithPreferredContact(objLoan,Loan_Id,ObjLoan.LoanOfficer__c,ObjLoan.Loan_Processor__c,ObjLoan.Preferred_Contact_Type__c);
        string GetContactUser = SAL_LoanDetailsController.getUserId(objLoan.Id);
        Loan_New__c GetValidatedData = SAL_LoanDetailsController.LoanDetailsTabsValidatedData(objLoan.Id);
        List<LoanOfficerResponse>  getLoanOfficerResponse =  SAL_LoanDetailsController.getLoanOfficerList();
        Test.stopTest();
        }
        //System.assertEquals(objNote.Title__c, 'Pipeline Title');
    }
    
     @IsTest Static void GetLoanContactsByIdTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Account Executive'];  
        UserRole UR1=[Select Id from UserRole where Name='Partner Care Specialist Lead']; 
        //Portal Loan Processors 
        //Profile pr = [SELECT Id FROM Profile WHERE Name='Portal Loan Processors'];      
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
         
         String orgId1 = UserInfo.getOrganizationId();
        String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName1 = orgId1 + dateString1 + randomInt1;
        
         User user2 = new User(Alias = uniqueName1.substring(18, 23),  email = uniqueName1 + '@test1' + orgId1 + '.org',
                              Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR1.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user2;
         
         //User user1 = new User(Username = userIns.Username,ProfileId = pr.Id);
         //update user1;
        system.runAs(user1)
        {
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user2.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id,
                Potential_Portal_User_Status__c = 'Ready',
            	RecordTypeId=RecortypeId);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
            
        Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345', LoanId__c = LoanInsert.Id);
        Insert ClientInsert;
            
        Test.startTest();
        Loan_New__c GetContact = SAL_LoanDetailsController.GetLoanContactsById(LoanInsert.Id);
        List<LoanProcessorResponse>  getLoanProcessorResponse = SAL_LoanDetailsController.getLoanProcessorList();
        Test.stopTest();
        }
        }
    
    @IsTest Static void getLoanProcessorTest(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Account Executive'];  
        UserRole UR1=[Select Id from UserRole where Name='Partner Care Specialist Lead']; 
        //Portal Loan Processors 
        //Profile pr = [SELECT Id FROM Profile WHERE Name='Portal Loan Processors'];      
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
        
        String orgId1 = UserInfo.getOrganizationId();
        String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName1 = orgId1 + dateString1 + randomInt1;
        
         User user2 = new User(Alias = uniqueName1.substring(18, 23),  email = uniqueName1 + '@test1' + orgId1 + '.org',
                              Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR1.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user2;
        
         //User user1 = new User(Username = userIns.Username,ProfileId = pr.Id);
         //update user1;
        system.runAs(user1)
        {
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user2.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id,
                Potential_Portal_User_Status__c = 'Ready',
            	RecordTypeId=RecortypeId);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id,
            									IsLoanCreatedByLoanProcessor__c=true);
            
            insert loanInsert;
        SAL_LoanDetailsController.getLoanProcessor(loanInsert.Id);
        Test.stopTest();
    }
    }
    @IsTest Static void LPLO_ResponseTest()
    {
        //SAL_LoanDetailsController sl = new SAL_LoanDetailsController();
        //sl.LPLO_Response slo = new sl.LPLO_Response();
        SAL_LoanDetailsController.LPLO_Response slo= new SAL_LoanDetailsController.LPLO_Response();
        slo.LoanOfficer = true;
        slo.LoanProcessor = true;
    }
}