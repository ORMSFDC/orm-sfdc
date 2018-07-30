@isTest
private class CTIServiceProviderControllerTest{
    
    public static TestMethod void CTIServiceProviderTest() {
                      
   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
                
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;            
      
     //System.runAs(u){
     system.runAs(user1) 
        {
     Account Acc = new Account();
        Acc.Name='LOSample';
        insert Acc;
    Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Committed Partner').getRecordTypeId();
        Acc.RecordTypeId = AccountRecordTypeId;
        update Acc;
      String AccId = Acc.Id;
       Contact individual = new Contact();
       // individual.ContactNMLS__c = '32424';
        individual.LastName = 'Test';
        individual.AccountId = AccId;
        individual.Email = 'asd@asdf.com';
       // individual.Role__c ='Loan Officer';
       // individual.Status__c = 'New';
        individual.Phone = '2345678901';
        insert individual;   
         String ContId = individual.id;
        
         Opportunity opp = new Opportunity();
         opp.stageName = 'App Ready';
         opp.AccountId = AccId;
         opp.Contact__c = ContId;
         opp.closeDate = Date.today();
         opp.ForecastCategoryName = 'Pipeline';
         opp.Name = 'Drush1';
         //opp.CreatedDate = Date.today();
        opp.OwnerId =  UserInfo.getUserID();
        insert opp;
    
      
       Task AccTask=new Task(WhatId = AccId,TaskSubtype='Task',Status = 'Open',Priority = 'Normal',ActivityDate=System.today());
       Task ConTask=new Task(WhoId = ContId,TaskSubtype='Task',Status = 'Open',Priority = 'Normal',ActivityDate=System.today());
       Task OppTask=new Task(WhatId = opp.Id,TaskSubtype='Task',Status = 'Open',Priority = 'Normal',ActivityDate=System.today());
        insert AccTask;
      
    Test.Starttest();
     CTIServiceProviderController.getUserName();
     CTIServiceProviderController.getPickList();
            CTIServiceProviderController.getSubjectTypePickList();
            
     CTIServiceProviderController.UpdateTaskDetails(AccId,AccTask.Id,'{"Subject":"dd","Comments":"asd","CreateFollowUp_Task":"YES","FollowUp_DueDate":"2018-02-06","FollowUp_Subject":"asda","FollowUp_Status":"Open","FollowUp_Comments":"asd","FollowUp_Reminder":true,"FollowUp_ReminderDatetime":"2018-02-27T17:00:00.000Z"}');
     CTIServiceProviderController.getTaskDetails(AccId);
     CTIServiceProviderController.GenerateTask(AccId,AccTask);
     CTIServiceProviderController.GenericTask_ForWhatID(AccTask.WhatId,AccTask);
     CTIServiceProviderController.GenericTask_ForWhoID(ContId,'Contact',ConTask);
     CTIServiceProviderController.OpportunityTask(opp.Id,OppTask);
   Test.Stoptest();
        }
  }
}