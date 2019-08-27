@IsTest
public class SAL_CashFlowControllerTest {

    @isTest static void getCashFlowDataTest() {
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
            
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '12345',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Loan Officer', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;       
         Loan_New__c LoanInsert1 = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true, LoanStatus__c ='In Processing',
                                                   LoanNumber__c = '12345',Appraisal_Received_Date__c= Date.parse('10/10/2017'),
                                                  Household_Members__c='2', Real_Estate_Taxes__c = 1200.00, 
                                                  Hazard_Insurance__c = 350.00,HOA_PUD_Condo_Fees__c = 400.00, Estimate_of_Appraised_Value__c = 800000,
                                                  Square_Footage__c = '2000', Subject_Property_State__c = 'California',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
         insert LoanInsert1; 
         Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert1.Id, Primary_Client_for_the_Loan__c = true, DOB__c = Date.parse('09/09/1941'));
        Insert ClientInsert;
        Asset ObjAsset = new asset(Name = 'Drush', RelatedClient__c = ClientInsert.Id, RelatedLoan__c = LoanInsert1.Id,Category__c = 'Others', isActive__c = true, 
                                   Name_of_Institution__c = 'DS');
            Insert ObjAsset;
        Income_New__c IncomeInsert = new Income_New__c(Income_Source__c='',Income_Types__c='',Income_Value__c=1200.55,
                                                RelatedClient__c = ClientInsert.Id, isActive__c = true, Related_Loan__c = LoanInsert1.Id);
        insert IncomeInsert;
        Liability__c liability = new Liability__c(IsActive__c = true, RelatedClient__c = ClientInsert.Id, 
                                                  RelatedLoan__c = LoanInsert1.Id, Liability_Category__c = 'Alimony', 
                                                  Liability_Type__c  = 'Divorce', Amount__c = 100.00, 
                                                  Job_Related_Expenses__c = 150.00, Liability_Monthly_Payment__c = 200.00,
                                                 Mortgage_Payments__c = 250.00);
        Insert liability;
        ResidualIncome__c ResIncomeInsert =new ResidualIncome__c(Family_Size__c='2',MidWest__c=123,NorthEast__c=123,South__c=235,West__c=154);
        insert ResIncomeInsert;
        
         Test.startTest();
         SAL_CashFlowController.getCashFlowData(LoanInsert1.Id);
         Test.stopTest();
        }
        
    }
    
}