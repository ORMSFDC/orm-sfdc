@isTest
public class GenericControllerTest{
    static testMethod void testGetAllClientList(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Account Executive'];
        UserRole UR1=[Select Id from UserRole where Name='Partner Care Specialist Lead'];
        
        String orgId1 = UserInfo.getOrganizationId();
        String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName1 = orgId1 + dateString1 + randomInt1;
        User user2 = new User(Alias = uniqueName1.substring(18, 23),  email = uniqueName1 + '@test1' + orgId1 + '.org',
                              Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR1.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user2;            
        
        
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
            system.debug('user1.Name'+user1.Id);
            Account portalAccount = new Account(
                Name='poAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user2.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New',
                ORM_Account_Executive_Email__c=user1.Email);
            insert portalAccount;
            Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                LastName='Test Drush', 
                Title__c='Processor ', 
                Cell__c='9876543210', 
                Office_Phone__c='1234567890', 
                Individual_Lead_source__c='Other', 
                Contact_NMLS__c = '99887',
                Email = 'abc@xyz.com',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id,
                Potential_Portal_User_Status__c = 'Ready',
                RecordTypeId=RecortypeId);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loan = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               
                                               LoanNumber__c = '5999',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                               Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id,IsDeclarationFilled_Flag__c=false);
            
            insert loan;
            Loan_New__c loanNew = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                  LoanNumber__c = '123453215',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                  Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id,IsDeclarationFilled_Flag__c=false);
            
            insert loanNew;
            string LoanId = loan.Id;
            string LoanNewId = loanNew.Id;
            clientList = new List<Client__c>();        
            //Adding Client Records
            for(Integer i=0;i<2;i++){
                Client__c client = new Client__c();
                client.Name = 'Name'+i;
                client.Last_Name__c = 'LastName'+i;
                client.First_Name__c = 'FirstName'+i;
                client.LoanId__c = loan.Id;
                clientList.add(client);
            }
            insert clientList;  
            Employment__c objEmployment = new Employment__c(City__c = 'Ghaziabad',EmployerAddress__c = 'Delhi',
                                                            EmployerName__c = 'ORMS',EmployerPhone__c = '7894561230',Months__c = 2,is_Active__c = true,
                                                            PositionTitle__c = 'Manager',RelatedLoan__c = LoanId ,Client_id__c = clientList[0].Id,
                                                            State__c = 'California',Years__c = 2,IncomeValue__c = 0.00, Income_Type__c = 'Employment Income');
            Insert objEmployment;
            Income_New__c IncomeInsert = new Income_New__c(Income_Source__c='',Income_Types__c='',Income_Value__c=0.00,
                                                           RelatedClient__c = clientList[0].Id, IsActive__c = true, 
                                                           Related_Loan__c = loan.Id);
            insert IncomeInsert;
            Asset ObjAsset = new asset(Name = 'Drush', RelatedClient__c = clientList[0].Id, RelatedLoan__c = loan.Id,
                                       Category__c = 'Others', isActive__c = true, Name_of_Institution__c = 'DS',
                                       AccountId = portalAccount.Id, ContactId= contact.Id);
            Insert ObjAsset;
            Liability__c liability = new Liability__c(isActive__c = true, RelatedClient__c = clientList[0].Id,
                                                      RelatedLoan__c = loan.Id, Liability_Category__c = 'Alimony', 
                                                      Liability_Type__c  = 'Divorce',Is_Liability_Validated__c=true);
            Insert liability;
            
            Client__c Client1 = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', 
                                              Zip__c = '12345', LoanId__c = LoanNew.Id,Primary_Client_for_the_Loan__c = true,
                                              Is_Client_Validated__c=true,is_Active__c = true);
            insert Client1;
            Declaration__c Declaration1 = new Declaration__c(Name = 'DRUSH', IsActive__c=true, IsDeclaration_Filled_From_Tab__c = true, DeclarationLoan__c = loan.Id, DeclarationClient__c = clientList[0].Id);
            Insert Declaration1;
            Declaration__c Declaration2 = new Declaration__c(Name = 'DRUSH', IsActive__c=true, IsDeclaration_Filled_From_Tab__c = true, DeclarationLoan__c = loanNew.Id, DeclarationClient__c = Client1.Id);
            Insert Declaration2;
            
            clientListReturned = new  List<Client__c>();
            Test.startTest();
            clientListReturned  = GenericController.getAllClientList(loan.Id); 
            GenericController.TabsData(LoanId);
            GenericController.UpdateDeclarationFlag(LoanNewId);
            // if(Test.isRunningTest())
            GenericController.UpdateClientFlag(loanNew.Id);
            GenericController.UpdateEmploymentFlag(loan.Id);
            GenericController.UpdateIncomeFlag(loan.Id);
            GenericController.UpdateAssetFlag(loan.Id);
            GenericController.UpdateLiabilityFlag(loan.Id);
            GenericController.UpdateDeclarationFlagAfterClientInsert(LoanId);
            GenericController.UpdateEmploymentFlagAfterDelete(LoanId);
            GenericController.UpdateEmploymentFlagAfterDelete(LoanNewId);
            GenericController.UpdateIncomeFlagAfterDelete(loan.Id);
            GenericController.UpdateIncomeFlagAfterDelete(LoanNew.Id);
            GenericController.UpdateAssetFlagAfterDelete(LoanId);
            GenericController.UpdateAssetFlagAfterDelete(LoanNewId);
            GenericController.UpdateLiabilityFlagAfterDelete(LoanId);
            GenericController.UpdateLiabilityFlagAfterDelete(LoanNewId);
            //GenericController.UpdateDeclarationFlagAfterClientDelete(LoanNewId);
            GenericController.UpdateDeclarationFlagAfterClientDelete(LoanId);
            //List<LoanOfficerResponse>  lst =GenericController.getLoanOfficer();
            boolean a=  GenericController.IsLoanCreatedByLoanProcessor();
            
            Test.stopTest();
            
            /* Client__c testClient = new Client__c();
testClient = clientList[1];
System.assertEquals(clientList.size(), clientListReturned.size(), 'List size not equal.');
for(Client__c c: clientListReturned){
if(c.Name.equals(testClient.Name)){
System.assertEquals(testClient.Name, c.Name,'Values Not Matched');
System.assertEquals(testClient.Last_Name__c, c.Last_Name__c,'Values Not Matched');
System.assertEquals(testClient.First_Name__c, c.First_Name__c,'Values Not Matched');
}
} */
            
        }
    }
    static testMethod void testLOList(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Account Executive'];   
        UserRole UR1=[Select Id from UserRole where Name='Partner Care Specialist Lead'];
        
        String orgId1 = UserInfo.getOrganizationId();
        String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName1 = orgId1 + dateString1 + randomInt1;
        User user2 = new User(Alias = uniqueName1.substring(18, 23),  email = uniqueName1 + '@test1' + orgId1 + '.org',
                              Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR1.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user2;            
        
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
                Name='pAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user2.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                LastName='Test Drush', 
                Title__c='Processor ', 
                Cell__c='9876543210', 
                Office_Phone__c='1234567890', 
                Individual_Lead_source__c='Other', 
                Contact_NMLS__c = '99887',
                Email = 'abc@xyz.com',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id,
                Potential_Portal_User_Status__c = 'Ready',
                RecordTypeId=RecortypeId);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loan = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                               Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loan;
            Loan_New__c loanNew = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                  LoanNumber__c = '12345987',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                  Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanNew;
            string LoanId = loan.Id;
            string LoanNewId = loanNew.Id;
            clientList = new List<Client__c>();        
            //Adding Client Records
            for(Integer i=0;i<2;i++){
                Client__c client = new Client__c();
                client.Name = 'Name'+i;
                client.Last_Name__c = 'LastName'+i;
                client.First_Name__c = 'FirstName'+i;
                client.LoanId__c = loan.Id;
                clientList.add(client);
            }
            insert clientList;  
            
            
            Employment__c objEmployment = new Employment__c(City__c = 'Ghaziabad',EmployerAddress__c = 'Delhi',
                                                            EmployerName__c = 'ORMS',EmployerPhone__c = '7894561230',Months__c = 2,is_Active__c = true,
                                                            PositionTitle__c = 'Manager',RelatedLoan__c = LoanNewId ,Client_id__c = clientList[0].Id,
                                                            State__c = 'California',Years__c = 2,IncomeValue__c = 0.00, Income_Type__c = 'Employment Income');
            Insert objEmployment;
            Income_New__c IncomeInsert = new Income_New__c(Income_Source__c='',Income_Types__c='',Income_Value__c=0.00,
                                                           RelatedClient__c = clientList[0].Id, IsActive__c = true, 
                                                           Related_Loan__c = loanNew.Id);
            insert IncomeInsert;
            Asset ObjAsset = new asset(Name = 'Drush', RelatedClient__c = clientList[0].Id, RelatedLoan__c = loanNew.Id,
                                       Category__c = 'Others', isActive__c = true, Name_of_Institution__c = 'DS',
                                       AccountId = portalAccount.Id, ContactId= contact.Id);
            Insert ObjAsset;
            Liability__c liability = new Liability__c(isActive__c = true, RelatedClient__c = clientList[0].Id,
                                                      RelatedLoan__c = loanNew.Id, Liability_Category__c = 'Alimony', 
                                                      Liability_Type__c  = 'Divorce',Is_Liability_Validated__c=true);
            Insert liability;
            //clientListReturned = new  List<Client__c>();IsDeclaration_Filled_From_Tab__c=true and IsActive__c=:true
            
            Test.startTest();
            List<LoanOfficerResponse>  lst =GenericController.getLoanOfficer();
            Test.stopTest(); 
            
        }
    }
    
}