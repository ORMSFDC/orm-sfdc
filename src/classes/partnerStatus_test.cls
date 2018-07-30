@isTest()
private class partnerStatus_test{

    static testMethod void getpartnerStatus(){        
        Account acc= new Account(Name='Test', Partner_Lead_Status__c='Processing');
        Event event = new Event( Subject = 'Test Event',  Type = 'Email', Description = 'test', WhatId = acc.Id, ActivityDate = Date.Today() , ActivityDateTime = DateTime.now(), DurationInMinutes = 5);
        Task task = new Task( Subject = 'Test task',  Type = 'Email', Description = 'test', WhatId = acc.Id, ActivityDate = Date.Today() );
        Loan_new__c l = new Loan_New__c( LoanStatus__c = 'In Processing', Closing_Date__c = Date.Today() );
        Scenario__c s = new Scenario__c (Priority__c = 'Test' );
        insert l;
        insert s;
        insert task;        
        insert event;
        insert acc;       
               
        partnerStatus classObject = new partnerStatus();
        classObject.accountId = acc.Id;
        
        
        Integer s1 = classObject.getScenarios1();
        Integer s2 = classObject.getScenarios2();
        Integer s3 = classObject.getScenarios3();
        Integer s4 = classObject.getScenarios4();
        Integer process = classObject.getStatusProcessing();
        Integer approved = classObject.getStatusApproved();        
        Integer activity1 = classObject.getAllActivities1(); 
        Integer process2 = classObject.getStatusProcessing2();
        Integer approved2 = classObject.getStatusApproved2();        
        Integer activity2 = classObject.getAllActivities2(); 
        Integer process3 = classObject.getStatusProcessing3();
        Integer approved3 = classObject.getStatusApproved3();        
        Integer activity3 = classObject.getAllActivities3(); 
        Integer process4 = classObject.getStatusProcessing4();
        Integer approved4 = classObject.getStatusApproved4();        
        Integer activity4 = classObject.getAllActivities4(); 
        Integer l1 = classObject.getFolder1();
        Integer l2 = classObject.getFolder2();
        Integer l3 = classObject.getFolder3();
        Integer l4 = classObject.getFolder4();
        Integer l5 = classObject.getLoan1();
        Integer l6 = classObject.getLoan2();
        Integer l7 = classObject.getLoan3();
        Integer l8 = classObject.getLoan4();
        
        
        
        system.assertNotEquals(0, s1);
        system.assertNotEquals(1, s2);
        system.assertNotEquals(0, s3);
        system.assertNotEquals(0, s4);
        system.assertNotEquals(0, l1);
        system.assertNotEquals(1, l2);
        system.assertNotEquals(0, l3);
        system.assertNotEquals(0, l4); 
        system.assertNotEquals(0, l5);
        system.assertNotEquals(1, l6);
        system.assertNotEquals(0, l7);
        system.assertNotEquals(0, l8);                        
        system.assertNotEquals(0, process);
        system.assertNotEquals(1, approved);
        system.assertNotEquals(1, activity1);
        system.assertNotEquals(1, process2);
        system.assertNotEquals(1, approved2);
        system.assertNotEquals(1, activity2);
        system.assertNotEquals(0, process3);
        system.assertNotEquals(1, approved3);
        system.assertNotEquals(1, activity3);
        system.assertNotEquals(0, process4);
        system.assertNotEquals(1, approved4);
        system.assertNotEquals(1, activity4);        
        }    
}