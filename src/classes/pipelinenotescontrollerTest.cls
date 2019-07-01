@isTest
public with sharing class pipelinenotescontrollerTest {
    
    @isTest
    public static  void insNotes(){
        
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

        
        Loan_New__c objLoan =  new Loan_New__c(Related_Partner__c = portalAccount.Id,
                                                 IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Proposal',LoanNumber__c = '12345');
       Insert objLoan;
        
        String Loan_Id=objLoan.Id;
        Note__c objNote = new Note__c(Loan_Id__c =objLoan.Id,Name='Pipeline Note Title',Confirm_to_Show_Notes_in_Portal__c=true, Body__C='ABC');//
       try{
        insert objNote;
        }catch(Exception ex){}
        String NoteBody = objNote.Body__C;//objNote.Body__C;
        String Notetitle = objNote.Name;
        String NoteLoanId = objNote.Loan_Id__c ;
        Test.startTest();
        pipelinenotescontroller.insNotes(NoteBody,Notetitle,NoteLoanId);
        Test.stopTest();
        }
        //System.assertEquals(objNote.Name, 'Pipeline Note Title');
    }
    
    @isTest static void fetchNotesTest(){
      
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

        
        Loan_New__c objLoan =  new Loan_New__c(Related_Partner__c = portalAccount.Id,
                                                 IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Proposal',
                                               LoanNumber__c = '00011');
       Insert objLoan;
     
        
        String Loan_Id=objLoan.Id;
        Note__c objNote = new Note__c(Body__c='Test Body',  Loan_Id__c = objLoan.Id , Confirm_to_Show_Notes_in_Portal__c=true);
         insert objNote;
         //objNote.Loan_Id__c   =objLoan.Id;
         //Name='Pipeline Title');
      try{
        //insert objNote;
        }catch(Exception ex){}
        Test.startTest();
        pipelinenotescontroller.fetchNotes(Loan_Id);
        Test.stopTest();
       } 
        //System.assertEquals(objNote.Name, 'Pipeline Title');
    }
}