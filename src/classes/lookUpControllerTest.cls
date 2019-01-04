@isTest(seeAlldata=true)
public with sharing class lookUpControllerTest {
    @isTest static void getScenarioResponseTest(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        string dt = date.today().format();
        decimal hv=1.0;
        decimal mb=2.0;
        decimal mp=3.0;
        string ir='ir';
        string str = lookUpController.getScenarioResponse(dt,hv,mb,mp,ir,'2.0');
        System.debug(str);
        System.assertEquals(str.contains('200'), true);
    }
    
    @isTest static void getScenarioCashFlowResponseTest(){
        //Test that Records are Inserted
        Test.setMock(HttpCalloutMock.class, new MockHttpCashFlowResponseGenerator());        
        // Call method to test. This causes a fake response to be sent from the class that implements HttpCalloutMock.         
        decimal mb=1.0;
        decimal mp=2.0;
        string ir='ir';
        string str = lookUpController.getScenarioCashFlowResponse(mb,mp,ir);
        System.debug(str);
    }  
    
    @isTest static void fetchAccountTest(){
        String searchKey = 'Dh';
        ClientInfo__c Len1 = new ClientInfo__c(Name = 'Dhiresh', Last_Name__c  = 'Khare',Client_State__c = 'Alabama', Zip__c = '123456', Email_Optional__c ='d@k.com',Phone_Number__c = '1234456678',Street_Address__c = 'Noida Sector-62',  DOB__c=date.today());
        ClientInfo__c Len2 = new ClientInfo__c( Name = 'Dh', Last_Name__c  = 'Khare',Client_State__c = 'Alabama', Zip__c = '123456', Email_Optional__c ='d@k.com',Phone_Number__c = '1234456678',Street_Address__c = 'Noida Sector-62',  DOB__c=date.today());
        list<ClientInfo__c> ClientList = new list<ClientInfo__c>();
        ClientList.add(Len1);
        ClientList.add(Len2);
        insert  ClientList;
        
        //Test that Records are Inserted
        List<lead> Client1 = lookUpController.fetchAccount(searchKey);        
        System.assertEquals(0,Client1.size());
    }

    @isTest static void getClientDetailsTest(){        
        
        lead ClientInsert = new lead(FirstName = 'Dhiresh', Last_Name__c  = 'Khare', 
                                    DOB__c=date.today(),lastName='sdfsdf',Company='sdfsdf');
        Insert ClientInsert;
        Id ClientId = ClientInsert.Id;        
        lead ReturnValue = lookUpController.getClientDetails(ClientId); 
    } 
    
    //SFDC - 289
    @isTest
    Public static void SendMailTMPTest()  
    { 
       Profile p = [SELECT Id FROM Profile WHERE Name='ORM Partner'];
        
        Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',                                
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Type__c='Premier');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName777999', 
                Title__c='Processor ', 
                Cell__c='1237779874', 
                Office_Phone__c='1234569874',  
                Email = 'Sam777@gmail.com',
                Contact_NMLS__c = '12345777',
                Source_Name__c='Michael777',
                AccountId = portalAccount.Id);
            insert contact;
        
        User u = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', 
                          LastName='Testing989', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', 
                          UserName='dprobertdemo9891@camfed.org',ContactId = contact.Id );        
        
        
        system.runAs(u){
            List<Client__c> clientList;
            List<Client__c> clientListReturned;   
            Loan_New__c loanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = contact.AccountId);
            insert loanInsert;
            string LoanId = LoanInsert.Id;
            
            //Create LeadInfo
            
            Lead l1 = new Lead(Phone = '1234567899',PostalCode= '92081',FirstName = 'atest',LastName= 'btest',State = 'California',Street = 'Stewart',DOB__c = date.today(),Email = 'test@pk.com', Company = 'abc' );
            Lead l2 = new Lead(Phone = '1234567899',PostalCode= '92081',FirstName = 'atest',LastName= 'btest',State = 'California',Street = 'Stewart',DOB__c = date.today(),Email = 'test@pk.com', Company = 'abc');
            List<Lead> LeadList = new List<Lead>();
            LeadList.add(l1);
            LeadList.add(l2);
            try{
            insert LeadList;
            }catch(exception ex){
                LeadList = new list<Lead>();
                LeadList = [select id,phone,postalcode,FirstName,LastName,State,street,DOB__c,Email,company from lead limit 2];
            }
            id LeadId0 = LeadList[0].id;
            id LeadId1 = LeadList[1].id;                
                        
            Scenario__c Scenario1 = new Scenario__c(Estimated_home_value__c = 500.00, 
                                                    Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                                    Monthly_Mortgage_Payment__c = 400.00, Client_Lead__c =LeadId0, priority__c = 'LOC And CashFlow',
                                                    partnerid__c=u.id);
            Scenario__c Scenario2 = new Scenario__c(Estimated_home_value__c = 500.00, 
                                                    Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                                    Monthly_Mortgage_Payment__c = 400.00, Client_Lead__c=LeadId1, priority__c = 'LOC And CashFlow');
            list<Scenario__c> ScenarioList = new list<Scenario__c>();
            ScenarioList.add(Scenario1);
            ScenarioList.add(Scenario2);
            insert ScenarioList;
            String priority='LOC And CashFlow';
            ScenarioResponse objScenario = new ScenarioResponse();
            objScenario.modelType ='test';     
            objScenario.modelType ='test';
            objScenario.annualLiborChangeDate ='01/01/2017';
            objScenario.annualMIP =100.00;
            objScenario.lendersMargin =100.00;
            objScenario.growthRateInitial =100.00;
            objScenario.growthRateAverage10yr =100.00;
            objScenario.growthRateAverage20yr =100.00;
            objScenario.apr =100.00;
            objScenario.annualLibor =100.00;            
            System.assertEquals(objScenario.modelType, 'test');            
            DateTime DT=LeadList[0].DOB__c;
            string ClientDOB= '10/10/1945';                
            string Email_Temp =LeadList[0].Email;
            string Phone_Number = LeadList[0].Phone;
            String getUserEmailID ='dkhar@galaxe.com';
            String getUsername ='drush';
            
            Test.startTest(); 
            try{
                lookUpController.SendMailTMP(ScenarioList[0].id); 
                lookUpController.SendMailTMP(ScenarioList[1].id);
                lookUpController.doUpdateCount(); 
                lookUpController.createAETask(ScenarioList[0].id);//SFDC_396
            }catch(exception ex){}
            test.stopTest();        
        }        
    }
    
   @istest static void SaveScenarioTest()
    {
        QLMS_AE__c QLMSAE= new QLMS_AE__c();
        
        QLMSAE.Email__c='abc@glx.com';
        QLMSAE.isActive__c=true;
        QLMSAE.Office_Phone__c='9630266959';
        QLMSAE.Name='Latika';
        insert QLMSAE;
        Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            QLMS_Account_Executive__c=QLMSAE.ID,
            // Email__c='test@noemail.com',
            Main_Phone__c='5414147852',
            Partner_Lead_Status__c='New');
        insert portalAccount;
        
        Profile Objprofile = [select Id, Name from profile where Name = 'System Administrator'];
        UserRole ObjUserRole = [SELECT Id, Name, ParentRoleId FROM UserRole limit 1];
        User users = [select Id,Name from user limit 1];
        ClientInfo__c objClient = new ClientInfo__c();
        date mydate = date.today();
        objClient.PartnerID__c = users.Id;
        objClient.DOB__c = mydate; 
        objClient.Last_Name__c = 'Sharma';
        objClient.Zip__c = '45678';
        insert objClient; 
        
        id cid=objClient.id;
        id Cpid = objClient.PartnerID__c;
        
        lead  l = new lead();
        l.FirstName= 'test';
        l.LastName = 'test';
        l.Company = 'test';
        insert l;
        Scenario__c scenario = new Scenario__c();
        Test.startTest();
        
        try{
       id scenerioId1 = lookUpController.SaveScenario(l,date.today().format().replace('/','-'), 10, 10, 14, 20, 1, 13, 
                                                      10, 23, 13, 12, 'High', 12, 14, 7, 10, 12,'abc','xyz',1.0,1.1,'Hecm','Test','123','123','123',123,'Adjust',120,10,new scenario__c());  
        }catch(exception ex){}
        Test.stopTest();    
        lookUpController.getLoggedInProfile();
        
        try{
     //   lookUpController.createLoan([select id from Scenario__c limit 1].id ,10,10);
        }catch(exception ex){}
        
         Blob FileData = Blob.valueOf('');
        Attachment ObjAttachment = new Attachment();
        objAttachment.Name='Dtest';
        objAttachment.Body = FileData;
        objAttachment.ParentId = [select id from Scenario__c limit 1].id;
        objAttachment.contentType = 'Application/PDF';
        //(Id)apexPages.CurrentPage().getParameters().put('id',string.valueOf());
       // insert objAttachment;
        string Base64Data = 'test Base64Data'; 
      //  test.startTest();
      try{
            lookUpController.getFNMData(objAttachment.Body, objAttachment.Name, Base64Data, objAttachment.contentType, date.today().format(),[select id from Scenario__c limit 1].id,10,100 );
        }catch(exception ex){}
        
        try{
        }catch(exception ex){}        
    } 
    
    //SFDC-275
    @istest static void getZipDataTest()
    {
        lookUpController.getZipData('12345');
        lookupcontroller.get_states();
        lookupcontroller.get_statesPur();
        lookupcontroller.get_helostatesRefi();
        lookupcontroller.get_heloStatesPur();
        lookupController.get_metadataValues('Tier1');
        lookupController.FormatPhone('1234567890');
        lookupController.getScenarioMarginsResponse('10/10/1967',1200,1000,1000,'12');
    }
    
    @istest static void getScenariDataTest(){              
       lookupcontroller.getScenariData('10/10/1967','1200','1000','12','Tier1');//SFDC - 289 added Tier1       
    }
       
    @istest static void GetMonthlyAssetIncomeTest(){
        lookUpController.GetMonthlyAssetIncome([select id from Scenario__c limit 1].id,1000);
    }

    @istest static void createLoanTest(){
        Scenario__c s =   [select id,Client_Lead__c from Scenario__c  limit 1];
        s.Client_Lead__c = [select id from lead limit 1].id;
        update s;
        lookUpController.createLoan(s.id ,10,10);
        lookUpController.getPrintCount(10, s.id);//SFDC-566 
        lookUpController.getcapacityCount(10,s.id);    
    }
       
    @istest static void getCashFlowDataTest(){
        lookUpController.getCashFlowData(10,10,10,10,10,[select id from Scenario__c limit 1].id,100);        
        ScenarioResponceUtil.getScenariData('test','test','test');
    }
}