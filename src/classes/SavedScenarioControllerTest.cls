@isTest(seeAlldata=true)
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
         //savedScenarioController.SendMailTMP(ScenarioId);
         savedScenarioController.Senariodelete(new List<Id>{ScenarioId});
         //ScenarioExportUtil.getExportForscenarioId(ScenarioId);
         savedScenarioController.getScenario_nextPage(1,'Name','ASC');
         savedScenarioController.fetchAccount('test');
         //savedScenarioController.updateSenario(ScenarioInsert.id,null);
    }
}