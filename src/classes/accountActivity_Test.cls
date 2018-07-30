@isTest 
private class accountActivity_Test {
    static testMethod void testGetaccountActivity() {
       Contact con = new Contact(Firstname='Test', Lastname='Contact', Email='abc@test.com', Individual_Lead_source__c = 'Referral',Office_Phone__c ='1234567890', Title__c ='Processor');
       insert con;
       Account acc= new Account(Name='Test', Partner_Lead_Status__c='New');
       insert acc;
       
       Event event = new Event( Subject = 'Test Event',  Type = 'Email', Description = 'test'
                               , WhatId = acc.Id, ActivityDate = Date.Today() , ActivityDateTime = DateTime.now(), DurationInMinutes = 5);
       insert event;
       Task task = new Task( Subject = 'Test task',  Type = 'Email', Description = 'test'
                               , WhatId = acc.Id, ActivityDate = Date.Today() );
       insert task;
       
       accountActivity classObject = new accountActivity();
       
       classObject.accountId = acc.Id;
       
       Integer allActivity = classObject.getAllActivities();
       Integer activity7day=  classObject.getlast7DaysActivities();
       Integer activity30day=  classObject.getlast30DaysActivities();
       
       
       System.assertNotEquals(1, allActivity);
       System.assertNotEquals(1, activity7day);
       System.assertNotEquals(1, activity30day);
      
    }
}