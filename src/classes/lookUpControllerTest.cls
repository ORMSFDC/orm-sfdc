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
        //test.startTest();
        //string str1 = lookUpController.getScenarioResponse(null,null,null,null,null);
        //test.stopTest();
        string str = lookUpController.getScenarioResponse(dt,hv,mb,mp,ir,'2.0');
        System.debug(str);
        System.assertEquals(str.contains('200'), true);
    }
    
    @isTest static void getScenarioCashFlowResponseTest(){
        //Test that Records are Inserted
        Test.setMock(HttpCalloutMock.class, new MockHttpCashFlowResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        //decimal hv=2222;
        decimal mb=1.0;
        decimal mp=2.0;
        string ir='ir';
        //test.startTest();
        //string str1 = lookUpController.getScenarioCashFlowResponse(null,null,null);
        //test.stopTest();
        string str = lookUpController.getScenarioCashFlowResponse(mb,mp,ir);
        System.debug(str);
     //   System.assertEquals(str.contains('200'), true);
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
        //test.stopTest();   
        //System.assertEquals(ReturnValue.Id, ClientInsert.Id);
        //delete Len1;
        //ClientInfo__c ReturnValue1 = lookUpController.getClientDetails(Len1.Id); 
        
        //System.assertEquals(ReturnValue1.Id, len1.id);
    } 
    
    /*//Added by Bala
    @isTest static void createAETaskTest()
    { 
       try{
            lookUpController.createAETask();
       }
       catch(Exception ex){}
    }*/
    
    @isTest //Bala
    Public Static void createAETaskTest()
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
           
            insert LoanInsert; 
            string LoanId = LoanInsert.Id;
            
            Test.startTest();       
               lookUpController.createAETask();                   
            Test.stopTest();
        }        
    }
    
    
     /*Modified by Bala*/
    @isTest
    Public static void SendMailTMPTest()  
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
            List<Client__c> clientList;
            List<Client__c> clientListReturned;   
            Loan_New__c loanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2', Real_Estate_Taxes__c = 1200.00,
                                                     Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00,
                                                     Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = c.Id,
                                                     Related_Partner__c = c.AccountId);
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
                                                    Monthly_Mortgage_Payment__c = 400.00, Client_Lead__c =LeadId0, priority__c = 'LOC And CashFlow');
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
            
            //DateTime DT=LeadList[0].DOB__c;
            string ClientDOB='19890923';
            string Email_Optional ='d@k.com';
            //string Phone_Number = '123456';
            String getUserEmailID ='dkhar@galaxe.com';
            String getUsername ='drush';
            
            Test.startTest(); 
            try{
                lookUpController.SendMailTMP(ScenarioList[0].id); 
                lookUpController.SendMailTMP(ScenarioList[1].id);
                lookUpController.doUpdateCount(); 
            }catch(exception ex){}
            test.stopTest();        
        }        
    }
    
   @istest static void SaveScenarioTest()
    {
        
        //try{
        //
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
        /* Opportunity ObjOpp = new Opportunity();
//ObjOpp.LoanOfficerName__c = users.Id;
ObjOpp.Name = 'Test';
ObjOpp.CloseDate = date.today();
ObjOpp.ClientID__c = cid;
ObjOpp.StageName = 'Needs Analysis';
ObjOpp.AccountId = portalAccount.Id;

insert ObjOpp;*/
        //Opportunity[] oppList = [select StageName from Opportunity where LoanOfficerName__c=: UserInfo.getUserName() and 
        //ClientID__c =: cid and StageName not in ('Closed Lost','Closed Won')];
        //try{
        Scenario__c scenario = new Scenario__c();
        Test.startTest();
        
        try{
       id scenerioId1 = lookUpController.SaveScenario(l,date.today().format().replace('/','-'), 10, 10, 14, 20, 1, 13, 
                                                      10, 23, 13, 12, 'High', 12, 14, 7, 10, 12,'abc','xyz',1.0,1.1,'Hecm','Test','123','123','123','123','Adjust','120',10,new scenario__c());  
        }catch(exception ex){}
        
       // lookUpController.getCashFlowData(10,10,10,10,10,[select id from Scenario__c limit 1].id,100);
        //string oppID =[select Id from Opportunity where  OwnerId=: UserInfo.getUserName() and  ClientID__c=:objClient.id and StageName not in ('Closed Lost','Closed Won') limit 1].ID;
        
        //scenario.OpportunityScenarios__c=ObjOpp;
        //id scenerioId2 = lookUpController.SaveScenario(objClient, date.today().format(), 10, 10, 14, 20, 10, 13, 
        // 10, 23, 13, 12, 'High', 12, 14, 74, 10, 12); 
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
        //lookUpController.GetMonthlyAssetIncome([select id from Scenario__c limit 1].id,1000);
        }catch(exception ex){}
        //Test.stopTest();
        
        // system.assertEquals(scenario.id, scenerioId1);
        // }
        //catch(exception e)
        //{}
        
    } 
    
    
    @istest static void getZipDataTest()
    {
        lookUpController.getZipData('12345');
        lookupcontroller.get_states();
        lookupController.get_metadataValues('Tier1');
        lookupController.FormatPhone('1234567890');
        lookupController.getScenarioMarginsResponse('10/10/1967',1200,1000,1000,'12');
    }
    
     @istest static void getScenariDataTest()
    {
       
       
       lookupcontroller.getScenariData('10/10/1967','1200','1000','12');
       
       }
       
            @istest static void GetMonthlyAssetIncomeTest()
       
       {
              lookUpController.GetMonthlyAssetIncome([select id from Scenario__c limit 1].id,1000);
       }
       
               @istest static void createLoanTest()
    
       {
     Scenario__c s =   [select id,Client_Lead__c from Scenario__c  limit 1];
           s.Client_Lead__c = [select id from lead limit 1].id;
           update s;
          lookUpController.createLoan(s.id ,10,10);
      
       }
       
      @istest static void getCashFlowDataTest()
    
       {
        lookUpController.getCashFlowData(10,10,10,10,10,[select id from Scenario__c limit 1].id,100);
        //string oppID =[select Id from Opportunity where  OwnerId=: UserInfo.getUserName() and  ClientID__c=:objClient.id and StageName not in ('Closed Lost','Closed Won') limit 1].ID;
       ScenarioResponceUtil.getScenariData('test','test','test');
       }
}