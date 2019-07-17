@IsTest
public with sharing class CICControllerTest {

    @IsTest Static void SaveCIDataTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        UserRole UR1=[Select Id from UserRole where Name ='DMB - Jesse'];
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
        
        //Added by Bala
        User user2 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test2' + orgId + '.org',
                              Username = uniqueName + '@test2' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester2', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR1.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user2;
        
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
                Account_Executive_Name__c = user2.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234667',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Contact_NMLS__c = '12345789',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;
            //Create Loan
            Loan_New__c LoanInsert1 = new Loan_New__c(PCS_at_Loan_Level__c = user1.Id, Loan_Payment_Plan_Term__c = 'test',
                                                      IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Conditionally Approved',LoanNumber__c = '12345'
                                                     ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                                   ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            Loan_New__c LoanInsert2 = new Loan_New__c(Loan_Payment_Plan_Term__c = 'test',PCS_at_Loan_Level__c = user1.Id,
                                                      IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Waiting for Full Package',LoanNumber__c = '222'
                                                     ,Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                                   ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            list<Loan_New__c> LoanList = new list<Loan_New__c>();
            LoanList.add(LoanInsert1);
            LoanList.add(LoanInsert2);
            Insert LoanList;
            string LoanId1 = LoanList[0].Id;
            string LoanId2 = LoanList[1].Id;
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanList[0].Id, Primary_Client_for_the_Loan__c = true);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            ChangeInCircumstances__c CIC1 = new ChangeInCircumstances__c(change_circumstance_occurred_on__c = date.today(),CIC_RESPA__c = true,
                                                                       Loan_Id__c = LoanId1,Add_a_Non_Borrowing_Spouse__c=true,
                                                                         Reduce_Origination_Fee__c=true,Title_Fees_Received__c=true,
                                                                        AddRemove_Borrowe__c=true,Act_of_God__c=true,Appraisal_Received__c=true,
                                                                        Other_Circumstance_Client_or_Transaction__c=true,Other_Information_to_Client_Transaction__c=true,
                                                                        Other__c=true,Inaccurate_Information__c=true,Adding_a_non_borrowing_resident__c=true,
                                                                        Change_in_Employment__c=true,Change_in_Loan_Officer__c=true,Change_in_Requested_Payment_Plan__c=true,
                                                                        Bring_Optional_Funds_to_Closing__c=true,Withdraw__c=true,Other_Change__c=true);
            ChangeInCircumstances__c CIC2 = new ChangeInCircumstances__c(change_circumstance_occurred_on__c = date.today(),CIC_RESPA__c = true,
                                                                       Loan_Id__c = LoanId2);
            list<ChangeInCircumstances__c> CICList = new list<ChangeInCircumstances__c>();
            CICList.add(CIC1);
            CICList.add(CIC2);
            insert CICList;
            
            FeeChangeHistory__c FCH1 = new FeeChangeHistory__c(Fee_Name__c = 'Test abc', Previous_Amount__c = 10.00, New_Amount__c = 20.00, Loan_Id__c = LoanId1, 
                                                              ChangeInCircumtances_Id__c = CIC1.Id);
            FeeChangeHistory__c FCH2 = new FeeChangeHistory__c(Fee_Name__c = 'abc', Previous_Amount__c = 11.00, New_Amount__c = 22.00, Loan_Id__c = LoanId2, 
                                                              ChangeInCircumtances_Id__c = CIC2.Id);
            
            List<FeeChangeHistory__c> FCHList = new List<FeeChangeHistory__c>();
            FCHList.add(FCH1);
            FCHList.add(FCH2);
            insert FCHList;
            
            CICFeeResponse CICFR1 = new CICFeeResponse();
            CICFR1.FeeIndex = 123;
            CICFR1.OldAmount = FCHList[0].Previous_Amount__c;
            CICFR1.NewAmount = FCHList[0].New_Amount__c;
            CICFR1.FeeName = FCHList[0].Fee_Name__c;
            
            CICFeeResponse CICFR2 = new CICFeeResponse();
            CICFR2.FeeIndex = 789;
            CICFR2.OldAmount = FCHList[1].Previous_Amount__c;
            CICFR2.NewAmount = FCHList[1].New_Amount__c;
            CICFR2.FeeName = FCHList[1].Fee_Name__c;
            
            List<CICFeeResponse> CICFRList = new List<CICFeeResponse>();
            CICFRList.add(CICFR1);
            CICFRList.add(CICFR2);
            
            string CICFRJson = '[{"FeeName":"test1","OldAmount":100,"NewAmount":200,"FeeIndex":1},{"FeeName":"test2","OldAmount":200,"NewAmount":500,"FeeIndex":2}]';
                //Json.serialize(CICFRList);
            Test.startTest();
              CICController.SaveCICData(CICFRJson,CICList[1],CICList[1].Loan_Id__c);
              CICController.SaveCICData(CICFRJson,CICList[0],CICList[0].Loan_Id__c);
              CICController.createRecordAndSendEmails(CICFRJson,CICList[1],CICList[1].Loan_Id__c);
            Test.stopTest();
        }
    }    
}