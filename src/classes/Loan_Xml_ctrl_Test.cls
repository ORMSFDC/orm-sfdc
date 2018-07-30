@isTest
public with sharing class Loan_Xml_ctrl_Test {

    @isTest static void testone()
    { 
        // Mock data static testMethod void testGetAllClientList(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User users = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert users; 
       
        System.runAs(users) {
                 
            
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
                Assigned_PCS__c=users.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;  
            //Insert Record for testing the If situation
            Loan_New__c LC1 = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= false,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                              Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            Loan_New__c LC2 = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= false,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LC1);
            LoanList.add(LC2);
            insert LoanList;
            
         Apexpages.currentpage().getparameters().put('id',LoanList[0].id);
         
         Loan_Xml_ctrl lx = new Loan_Xml_ctrl();
         
         LoanExportController ln = new LoanExportController();
         
           string fields = 'Act_of_God__c,Add_a_Non_Borrowing_Spouse__c,Adding_a_non_borrowing_resident__c,Additional_Loan_Explanation__c,AddRemove_Borrowe__c,Appraisal_Received__c,Bring_Optional_Funds_to_Closing__c,change_circumstance_occurred_on__c,Change_in_Employment__c,Change_in_Loan_Officer__c,Change_in_Requested_Payment_Plan__c,CIC_RESPA__c,Inaccurate_Information__c,Loan_Id__r.Name,No_fee_changes__c,Other__c,Other_Change__c,Other_Circumstance_Client_or_Transaction__c,Other_Information_to_Client_Transaction__c,Reduce_Origination_Fee__c,Title_Fees_Received__c,Withdraw__c';
       // LoanExportController.getRelatedlistData('ChangeInCircumstances__c' ,fields,LoanList[0].id);
       
           
        }
        
        
        
    }


}