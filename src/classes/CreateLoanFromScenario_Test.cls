@isTest(seeAlldata=true)
public class CreateLoanFromScenario_Test{
         
         @isTest static void getFNMDataTest() {
    
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
                AccountId = portalAccount.Id);
            insert contact;  
            
              Scenario__c ScenarioInsert = new Scenario__c(Estimated_home_value__c = 500.00, 
                                 Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                 Monthly_Mortgage_Payment__c = 400.00, priority__c = 'LOC And CashFlow');
       
        insert ScenarioInsert;
        
        Loan_New__c LoanInsert = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);  
                                               
        Insert LoanInsert;
        string LoanId = LoanInsert.Id;
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                LoanId__c =LoanInsert.Id);
        Insert ClientInsert;
        string ClientId = ClientInsert.Id;
        
        Blob FileData = Blob.valueOf('');
        Attachment ObjAttachment = new Attachment();
        objAttachment.Name='Dtest';
        objAttachment.Body = FileData;
        objAttachment.ParentId = LoanInsert.Id;
        objAttachment.contentType = 'Application/PDF';
        //(Id)apexPages.CurrentPage().getParameters().put('id',string.valueOf());
        insert objAttachment;
        string Base64Data = 'test Base64Data';
        test.startTest();
            CreateLoanFromScenario.getFNMData(objAttachment.Body, objAttachment.Name, Base64Data, objAttachment.contentType, date.today().format(),ScenarioInsert.id);
        Test.stopTest();
        
        }
    }


       @isTest static void getScenarioListTest(){
        
           String searchKey = 'Dh';
      
         
         ClientInfo__c ClientInsert = new ClientInfo__c(Name = 'Dhiresh', Last_Name__c  = 'Khare',Client_State__c = 'Alabama', Zip__c = '123456', Email_Optional__c ='d@k.com',Phone_Number__c = '1234456678',Street_Address__c = 'Noida Sector-62',DOB__c=date.today());
         //ClientInfo__c Len2 = new ClientInfo__c( Name = 'Dh', Last_Name__c  = 'Khare',Client_State__c = 'Alabama', Zip__c = '123456', Email_Optional__c ='d@k.com',Phone_Number__c = '1234456678',Street_Address__c = 'Noida Sector-62',  DOB__c=date.today());
         
         insert  ClientInsert;
        string ClientId = ClientInsert.Id;
        
        
         Scenario__c ScenarioInsert = new Scenario__c(Estimated_home_value__c = 500.00, 
                                 Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                 Monthly_Mortgage_Payment__c = 400.00, ClientId__c =ClientInsert.Id, priority__c = 'LOC And CashFlow');
       
        
        ScenarioInsert.Client_Lead__c = [select id from lead limit 1].id;
        insert ScenarioInsert;
        Test.startTest();
        try{
       CreateLoanFromScenario.createLoan(ScenarioInsert.Id);
       }catch(exception ex){}
       try{
       CreateLoanFromScenario.updateSenario(ScenarioInsert.id,null);
       }catch(Exception ex){}
        Test.stopTest();
             
    }

}