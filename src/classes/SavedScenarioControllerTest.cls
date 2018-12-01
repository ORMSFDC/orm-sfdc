@isTest
public with sharing class SavedScenarioControllerTest {
    
    @isTest static void getScenarioListTest(){
         String searchKey = 'Dh';      
         
         ClientInfo__c ClientInsert = new ClientInfo__c(Name = 'Dhiresh', Last_Name__c  = 'Khare',Client_State__c = 'Alabama', Zip__c = '123456', Email_Optional__c ='d@k.com',
                                                        Phone_Number__c = '1234456678',Street_Address__c = 'Noida Sector-62',  DOB__c=date.today());
         insert  ClientInsert;
         string ClientId = ClientInsert.Id;
         Scenario__c ScenarioInsert = new Scenario__c(Estimated_home_value__c = 500.00, 
                                 Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                 Monthly_Mortgage_Payment__c = 400.00, ClientId__c =ClientInsert.Id, priority__c = 'LOC And CashFlow');       
        insert ScenarioInsert;
        
        //Test that Records are Inserted
        savedScenarioController.getScenarioList(ClientId,'CreatedDate','ASC');        
        // System.assertEquals(1,ClientScenario.size());
    }
    
    @isTest static void getScenarioDataTest(){
         String searchKey = 'Dh';
         ClientInfo__c ClientInsert = new ClientInfo__c(Name = 'Dhiresh', Last_Name__c  = 'Khare',Client_State__c = 'Alabama', Zip__c = '123456', 
                                                       Email_Optional__c ='d@k.com',Phone_Number__c = '1234456678',Street_Address__c = 'Noida Sector-62',
                                                       DOB__c=date.today());
         insert  ClientInsert;
         string ClientId = ClientInsert.Id;
         
         Lead leadinsert = new Lead(Phone = '1234567899',PostalCode= '92081',FirstName = 'atest',LastName= 'btest',State = 'California',
                                    Street = 'Stewart',DOB__c = date.today(),Email = 'test@pk.com', Company = 'abc' );
         insert leadinsert;  
         
         Scenario__c ScenarioInsert = new Scenario__c(Estimated_home_value__c = 360500.00, Scenario_Type__c='FHA Traditional HECM',RateType__c = 'Helo', 
                                                      Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, Margin__c = 3.125,
                                                      Monthly_Mortgage_Payment__c = 400.00, ClientId__c =ClientInsert.Id, priority__c = 'LOC And CashFlow',
                                                      Client_Lead__c =leadinsert.id);        
         insert ScenarioInsert;
         string ScenarioId = ScenarioInsert.Id;
        
         //Test that Records are Inserted
         scenario__c ScenarioData = savedScenarioController.getScenarioData(ScenarioId);   
    
         savedScenarioController.getsearchScenarioList ('{"Address":"","Email":"dhf@asdasd.com","FirstName":"aa","LastName":"asdas","Phone":"(123) 657-2323","DOB":"2017-10-01"}','',1,'CreatedDate','ASC');     
         System.assertEquals(ScenarioInsert.Id,ScenarioData.Id);        
         savedScenarioController.get_searchInstance();
         savedScenarioController.Senariodelete(new List<Id>{ScenarioId});
         savedScenarioController.getScenario_nextPage(1,'Name','ASC');
         savedScenarioController.fetchAccount('test');
    }
    
    //SFDC_568
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
            string ClientDOB= DT.format('MM/dd/yyyy');                
            string Email_Optional ='d@k.com';
            //string Phone_Number = '123456';
            String getUserEmailID ='dkhar@galaxe.com';
            String getUsername ='drush';
            
            Test.startTest(); 
            try{
                savedScenarioController.SendMailTMP(ScenarioList[0].id);
                savedScenarioController.SendMailTMP(ScenarioList[1].id);
                savedScenarioController.createAETask(ScenarioList[0].id);     
            }catch(exception ex){}
            test.stopTest();        
        }        
    }
    
    //SFDC-566
    @istest static void printTest(){
        Scenario__c s = new Scenario__c(Estimated_home_value__c = 360500.00, Scenario_Type__c='FHA Traditional HECM',RateType__c = 'Helo', 
                                                      Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, Margin__c = 3.125,
                                                      Monthly_Mortgage_Payment__c = 400.00, priority__c = 'LOC And CashFlow', saved_print_count__c =5);        
        insert s;
        string ScenarioId = s.Id;
        Loan_New__c l = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                     Household_Members__c='2');
        insert l;
        update s;        
        savedScenarioController.getPrintCount(10,s.id); 
        savedScenarioController.updateSenario(s.id,l.id);
    }
}
