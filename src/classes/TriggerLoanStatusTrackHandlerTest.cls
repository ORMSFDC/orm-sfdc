/** * File Name   : TriggerLoanStatusTrackHandlerTest.apxt
*     Description : Test class
*     Created     : 11/26/2017
*     covers      : TriggerLoanStatusTrackHandler,TriggerLoanStatusTrack
*   * @author     : prsn
* */
@isTest
public class TriggerLoanStatusTrackHandlerTest {
     @isTest
    public static void loanShareTest() {
        
        Test.startTest();
        
        QLMS_AE__c QLMSAE = new QLMS_AE__c();        
        QLMSAE.Email__c='abc@glx.com';
        QLMSAE.isActive__c=true;
        QLMSAE.Office_Phone__c='9630266959';
        QLMSAE.Name='Nausad';
        insert QLMSAE;
        
        Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            QLMS_Account_Executive__c=QLMSAE.ID,
            // Assigned_PCS__c= UserInfo.getUserId(),
            Main_Phone__c='5414147852',
            Company_NMLS_ID__c = '1234',
            Partner_Lead_Status__c='New');
        insert portalAccount;
        
        Branches__c branch = new Branches__c();
        branch.Name = 'Test Branch';
        branch.Business_Partners_Acc__c = portalAccount.Id;
        insert branch;

        Contact contact = getContact(portalAccount.Id);
        contact.Related_Branch__c = branch.Id;
        insert contact;
        
        User partnerUser = CreatePartnerUser(Contact.Id);
        
        ClientInfo__c clientInsert1 = new ClientInfo__c(Name = 'Dhiresh', 
                                                       Last_Name__c  = 'Khare',
                                                       Client_State__c = 'Alabama', 
                                                       Zip__c = '123456', 
                                                       Email_Optional__c ='d@k.com',
                                                       Phone_Number__c = '1234456678',
                                                       Street_Address__c = 'Noida Sector-62',
                                                       PartnerID__c = partnerUser.Id,
                                                       DOB__c=date.today());
        insert  clientInsert1;
        
        Scenario__c scenario1 = new Scenario__c(Estimated_home_value__c = 500.00, 
                                                     Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                                     Monthly_Mortgage_Payment__c = 400.00, PartnerID__c = partnerUser.Id, ClientId__c = ClientInsert1.Id, priority__c = 'LOC And CashFlow');
        
        insert scenario1;
        
        Loan_New__c loanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                 LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                 Preferred_Contact_Type__c = 'Loan Officer',Related_Individual__c = contact.Id,
                                                 Related_Partner__c = portalAccount.Id);
        
        insert loanInsert1; 
        loanInsert1.LoanNumber__c = '23456';
        update loanInsert1;
        
        Contact contact1 = getContact(portalAccount.Id);
        contact1.Related_Branch__c = branch.Id;
        insert contact1;
        
        Contact executiveContact = getContact(portalAccount.Id);
        executiveContact.Related_Branch__c = branch.Id;
        insert executiveContact;
        
        Contact executiveWithoutBranch = getContact(portalAccount.Id);
        insert executiveWithoutBranch;
        User partnerUserManager;
        
        Contact loanProcessorContact = getContact(portalAccount.Id);
        insert loanProcessorContact;
        User loanProcessorUser;
        
        Test.stopTest();
        
        System.runAs(new User(Id = UserInfo.getUserId())){
            
            partnerUserManager = CreatePartnerUser(contact1.Id); 
            partnerUserManager.UserRoleId = [Select Id From UserRole Where Name = 'portalAccount Partner Manager'].Id;
            Update partnerUserManager;
            
            User partnerUserExecutive = CreatePartnerUser(executiveContact.Id); 
            partnerUserExecutive.UserRoleId = [Select Id From UserRole Where Name = 'portalAccount Partner Executive'].Id;                
            update partnerUserExecutive;
            
            User partnerUserExecutiveWithoutBranch = CreatePartnerUser(executiveWithoutBranch.Id); 
            partnerUserExecutiveWithoutBranch.UserRoleId = [Select Id From UserRole Where Name = 'portalAccount Partner Executive'].Id;                
            update partnerUserExecutiveWithoutBranch;
            
            loanProcessorUser = CreatePartnerUser(loanProcessorContact.Id);
            loanProcessorUser.ProfileId = [Select Id from profile Where Name = 'Portal Loan Processors'].Id;
            update loanProcessorUser;
        }
        
        Loan_New__c loanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                 LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                 Preferred_Contact_Type__c = 'Loan Officer',Related_Individual__c = contact.Id,
                                                 Related_Partner__c = portalAccount.Id);
        
        insert loanInsert; 
        loanInsert.LoanNumber__c = '23456';
        update loanInsert;
        
        Loan_New__c loanManager = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',Loan_Processor__c = loanProcessorUser.Id,
                                                  LoanNumber__c = '12459',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                  Preferred_Contact_Type__c = 'Loan Officer',Related_Individual__c = contact1.Id,
                                                  Related_Partner__c = portalAccount.Id);
        
  //      insert loanManager; 
        
        Client__c client = new Client__c(Name = 'sample client', LoanId__c = loanManager.Id);
        insert client;
        
        Declaration__c declaration = new Declaration__c(Name = 'sample declaration', DeclarationLoan__c = loanManager.Id);
        insert declaration;
        
        loanInsert.LoanNumber__c = '27456';
       // update loanManager;
          
        ClientInfo__c clientInsert = new ClientInfo__c(Name = 'Dhiresh', 
                                                       Last_Name__c  = 'Khare',
                                                       Client_State__c = 'Alabama', 
                                                       Zip__c = '123456', 
                                                       Email_Optional__c ='d@k.com',
                                                       Phone_Number__c = '1234456678',
                                                       Street_Address__c = 'Noida Sector-62',
                                                       PartnerID__c = partnerUser.Id,
                                                       DOB__c=date.today());
     //   insert  clientInsert;
        
        Scenario__c scenario = new Scenario__c(Estimated_home_value__c = 500.00, 
                                                     Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                                     Monthly_Mortgage_Payment__c = 400.00, PartnerID__c = partnerUser.Id, ClientId__c = ClientInsert.Id, priority__c = 'LOC And CashFlow');
        
     //   insert scenario;
        
        Scenario__c scenarioManager = new Scenario__c(Estimated_home_value__c = 500.00, 
                                                     Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00, 
                                                     Monthly_Mortgage_Payment__c = 400.00, PartnerID__c = partnerUserManager.Id, ClientId__c = ClientInsert.Id, priority__c = 'LOC And CashFlow');
        
      //  insert scenarioManager;
        
        
    }
    
    private Static User createPartnerUser(Id contactId) {
        Profile partnerProfile = [SELECT Id FROM Profile WHERE Name='ORM Partners'];        
        User partnerUser = new User();
        partnerUser.Username = 'partner_'+Math.random()+'@test.com';
        partnerUser.FirstName = 'test';
        partnerUser.LastName = 'user';
        partnerUser.alias = ('test'+Math.random()).subString(0,6);
        partnerUser.Email = 'test'+Math.random()+'@test.com';
        partnerUser.CommunityNickname = String.valueOf(Math.random()).subString(0,6);
        partnerUser.ProfileId = partnerProfile.Id;
        partnerUser.TimeZoneSidKey = 'America/Los_Angeles';
        partnerUser.LocaleSidKey='en_US';
        partnerUser.EmailEncodingKey='UTF-8';
        partnerUser.LanguageLocaleKey='en_US';
        partnerUser.ContactId = contactId;
        insert partnerUser;
        return partnerUser;
    }
    
    private static Contact getContact(Id accountId) {
        String randomText = (''+math.random()).subString(4,8);
        Contact contact = new Contact();
        contact.LastName= 'Schwartz'+randomText; 
        contact.Title__c='Processor';
        contact.Cell__c='123456'+randomText;
        contact.Office_Phone__c='123456'+randomText; 
        contact.Individual_Lead_source__c='Other';
        contact.Email = 'Sam'+randomText+'@gmail.com';
        contact.Contact_NMLS__c = randomText;
        contact.Source_Name__c='Michael'+ randomText;
        contact.AccountId = accountId;
        //insert contact;
        return contact;
    }
}