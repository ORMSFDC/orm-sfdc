@IsTest
public class ConditionControllerTest {

     @isTest static void getConditionHistoryTest() {
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
        List<Condition_Log__c> obj=new List<Condition_Log__c>();
        ConditionResponse ConditionRes=new ConditionResponse();
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
          insert ConditionInsert1;
         
         Condition_Log__c ConditionLogInsert1 = new Condition_Log__c(Loan_Id__c = LoanInsert1.Id,
                                                                     Old_Status__c = 'Outstanding ', 
                                                                     New_Status__c = 'Revision Requested ', 
                                                                     Old_Comments__c = 'Old Test Comment', 
                                                                     New_Comments__c = 'New Test Comment', 
                                                                     Old_ModifiedDate__c = date.today().format(),
                                                                    ConditionID__c = ConditionInsert1.Id);
         insert ConditionLogInsert1;
            ConditionRes.Status=ConditionInsert1.Status__c;
            ConditionRes.DescText=ConditionInsert1.Comment__c;
            //datetime dt=ConditionInsert1.LastModifiedDate;
            ConditionRes.StatusDate=date.today().format();
         
          ConditionResponse ConditionLogRes = new ConditionResponse();         
                ConditionLogRes.StatusDate= ConditionLogInsert1.Old_ModifiedDate__c;             
                ConditionLogRes.Status=ConditionLogInsert1.Old_Status__c;
                ConditionLogRes.DescText=ConditionLogInsert1.Old_Comments__c;
               
         Test.startTest();
         ConditionController.getConditionHistory(ConditionInsert1.Id);
         Test.stopTest();
        }
     }
    
    
        @isTest static void getLoanConditionTest() {
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
          insert ConditionList;
            ConditionResponse ConditionRes=new ConditionResponse();
            ConditionRes.Status=ConditionList[0].Status__c;
            ConditionRes.DescText=ConditionList[0].Comment__c;
            //datetime dt=ConditionInsert1.LastModifiedDate;
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Index=ConditionList[0].Condition_Number__c;
            ConditionRes.DropDownValue=ConditionList[0].Description__c;
            ConditionRes.CreatedDate=date.today().format();
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Id=ConditionList[0].Id;
               
         Test.startTest();
         ConditionController.getLoanCondition(ConditionList[0].Loan_Id__c);
         Test.stopTest();
        }
     }
    
     @isTest static void getConditionCountTest() {
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
       
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
          insert ConditionList;
         
               
         Test.startTest();
         ConditionController.getConditionCount(ConditionList[0].Loan_Id__c);
         Test.stopTest();
        }
     }
    
    @isTest static void SaveConditionsTest() {
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
        
        string Jasonstringfy = '[{"Index":3,"DescText":"A","DropDownValue":"B","Status":"Outstanding"}]';
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
        
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
          insert ConditionList;
         
            ConditionResponse ConditionRes=new ConditionResponse();
            ConditionRes.Status=ConditionList[0].Status__c;
            ConditionRes.DescText=ConditionList[0].Comment__c;
            //datetime dt=ConditionInsert1.LastModifiedDate;
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Index=ConditionList[0].Condition_Number__c;
            ConditionRes.DropDownValue=ConditionList[0].Description__c;
            ConditionRes.CreatedDate=date.today().format();
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Id=ConditionList[0].Id;
             //String RequestString = JSON.serialize(ConditionRes);
         //string Jasonstringfy = JSON.serialize(ConditionRes);
         Test.startTest();
         ConditionController.SaveConditions(Jasonstringfy,LoanInsert1.Id,true);
         Test.stopTest();
        }
     }
    
    @isTest static void MailSendWhileAddConditionTest() {
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                                  Preferred_Contact_Type__c='Loan Officer',LoanOfficer__c=UserInfo.getUserId(),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
          insert ConditionList;
            ConditionResponse ConditionRes=new ConditionResponse();
            ConditionRes.Status=ConditionList[0].Status__c;
            ConditionRes.DescText=ConditionList[0].Comment__c;
            //datetime dt=ConditionInsert1.LastModifiedDate;
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Index=ConditionList[0].Condition_Number__c;
            ConditionRes.DropDownValue=ConditionList[0].Description__c;
            ConditionRes.CreatedDate=date.today().format();
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Id=ConditionList[0].Id;
               
         Test.startTest();
         ConditionController.MailSendWhileAddCondition(ConditionList[0].Loan_Id__c);
         Test.stopTest();
        }
     }
    
      @isTest static void SaveEditConditionsTest() {
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
        string Jasonstringfy = '{"Index":3,"DescText":"A","DropDownValue":"B","Status":"Outstanding"}';
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
        
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
          insert ConditionList;
         
            ConditionResponse ConditionRes=new ConditionResponse();
            ConditionRes.Status=ConditionList[0].Status__c;
            ConditionRes.DescText=ConditionList[0].Comment__c;
            //datetime dt=ConditionInsert1.LastModifiedDate;
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Index=ConditionList[0].Condition_Number__c;
            ConditionRes.DropDownValue=ConditionList[0].Description__c;
            ConditionRes.CreatedDate=date.today().format();
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Id=ConditionList[0].Id;
             //String RequestString = JSON.serialize(ConditionRes);
         //string Jasonstringfy = JSON.serialize(ConditionRes);
         Test.startTest();
         ConditionController.SaveEditConditions(Jasonstringfy,LoanInsert1.Id,ConditionList[0].Id,true);
         Test.stopTest();
        }
     }
    
     @isTest static void MailSendWhileEditConditionTest() {
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                                  Preferred_Contact_Type__c='Loan Officer',LoanOfficer__c=UserInfo.getUserId(),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
          insert ConditionList;
            ConditionResponse ConditionRes=new ConditionResponse();
            ConditionRes.Status=ConditionList[0].Status__c;
            ConditionRes.DescText=ConditionList[0].Comment__c;
            //datetime dt=ConditionInsert1.LastModifiedDate;
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Index=ConditionList[0].Condition_Number__c;
            ConditionRes.DropDownValue=ConditionList[0].Description__c;
            ConditionRes.CreatedDate=date.today().format();
            ConditionRes.StatusDate=date.today().format();
            ConditionRes.Id=ConditionList[0].Id;
               
         Test.startTest();
         ConditionController.MailSendWhileEditCondition(ConditionList[0].Loan_Id__c,ConditionList[0].Id);
         Test.stopTest();
        }
     }
    
    @isTest static void getConditionByIdTest() {
        
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
          insert ConditionList;
         
               
         Test.startTest();
         ConditionController.getConditionById(ConditionList[0].Id);
         Test.stopTest();
        }
     }
    
    @isTest static void getLoanConditionPipelineTest() {
        
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
        Condition__c ConditionInsert2 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-8',Comment__c =  'Test Comment',
                                                    Status__c ='Revision Requested', Description__c = 'Trust Agreement');
        Condition__c ConditionInsert3 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-9',Comment__c =  'Test Comment',
                                                    Status__c ='Cancelled', Description__c = 'Trust Agreement');
        Condition__c ConditionInsert4 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-10',Comment__c =  'Test Comment',
                                                    Status__c ='Cleared', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
            ConditionList.Add(ConditionInsert2);
            ConditionList.Add(ConditionInsert3);
            ConditionList.Add(ConditionInsert4);
          insert ConditionList;
         
               
         Test.startTest();
         ConditionController.getLoanConditionPipeline(ConditionList[0].Loan_Id__c);
        ConditionController.getLoanConditionPipeline(ConditionList[1].Loan_Id__c);
        ConditionController.getLoanConditionPipeline(ConditionList[2].Loan_Id__c);
        ConditionController.getLoanConditionPipeline(ConditionList[3].Loan_Id__c);
         Test.stopTest();
        }
     }
    
    @isTest static void getConditionCurrentStatusandConditionTest() {
        
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
            List<Condition__c> ConditionList = new List<Condition__c>();
            ConditionList.Add(ConditionInsert1);
          insert ConditionList;
         
               
         Test.startTest();
         ConditionController.getConditionCurrentStatusandCondition(ConditionList[0].Id);
         Test.stopTest();
        }
     }
    
    @isTest static void getConditionHistoryStatusTest() {
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
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
        List<Condition_Log__c> obj=new List<Condition_Log__c>();
        ConditionResponse ConditionRes=new ConditionResponse();
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
         Condition__c ConditionInsert1 =new Condition__c(Loan_Id__c = LoanInsert1.Id,Condition_Number__c = 'Condition-7',Comment__c =  'Test Comment',
                                                    Status__c ='Outstanding', Description__c = 'Trust Agreement');
          insert ConditionInsert1;
         
         Condition_Log__c ConditionLogInsert1 = new Condition_Log__c(Loan_Id__c = LoanInsert1.Id,
                                                                     Old_Status__c = 'Outstanding', 
                                                                     New_Status__c = 'Revision Requested', 
                                                                     Old_Comments__c = 'Old Test Comment', 
                                                                     New_Comments__c = 'New Test Comment', 
                                                                     Old_ModifiedDate__c = date.today().format(),
                                                                    ConditionID__c = ConditionInsert1.Id);
         insert ConditionLogInsert1;
        
            ConditionRes.Status=ConditionInsert1.Status__c;
            ConditionRes.DescText=ConditionInsert1.Comment__c;
            //datetime dt=ConditionInsert1.LastModifiedDate;
            ConditionRes.StatusDate=date.today().format();
         
          ConditionResponse ConditionLogRes = new ConditionResponse();         
                ConditionLogRes.StatusDate= ConditionLogInsert1.Old_ModifiedDate__c;             
                ConditionLogRes.Status=ConditionLogInsert1.Old_Status__c;
                ConditionLogRes.DescText=ConditionLogInsert1.Old_Comments__c;
         
               
         Test.startTest();
         ConditionController.getConditionHistoryStatus(ConditionLogInsert1.Loan_Id__c,ConditionLogInsert1.ConditionID__c);
         Test.stopTest();
        }
     }
    
}