@isTest
public class UpdateDatesTiggerHandlerTest 
{   
        @isTest
        Public static void UpdateDatesTest()
        {
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
            QLMSAE1.Email__c='orm@orm.com';
            QLMSAE1.isActive__c=true;
            QLMSAE1.Office_Phone__c='1111111111';
            QLMSAE1.Name='User1';
            insert QLMSAE1;
            Account newAccount = new Account(
                Name='Test Partner',
                Cell__c='2222222222',
                QLMS_Account_Executive__c=QLMSAE1.ID,
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='3333333333',
                Company_NMLS_ID__c = '98765',
                Partner_Lead_Status__c='New', 
                Financials__c = True);
            insert newAccount;
            
            newAccount.Resumes__c = True;
            newAccount.Financials__c = False;
            newAccount.RecordtypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partners').getRecordTypeId();
            
            //Schema.SObjectType.Account.getRecordTypeInfosByName().get('Approved Partners').getRecordTypeId();
            update newAccount;
             Test.startTest();
            	//CICController.SaveCICData(CICFRJson,CICList[1],CICList[1].Loan_Id__c);
            	UpdateDatesTriggerHandler.SendEmail(user1.Id,newAccount.id);
            Test.stopTest();
     }
}
}