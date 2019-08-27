@IsTest
public class SAL_LoanControllerTest {   
    @IsTest Static void SaveLoanTest(){  
         Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
        
        User AdminUser =  [ select Id from User where Id = :UserInfo.getUserId()];
         
        system.runAs(AdminUser){
            Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
            UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];
               system.debug('AdminUser--- '+AdminUser.Id);
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
        //User user1 = [select Id,AccountId,ContactId from User where Id=: AdminUser.Id];//prsn
        //insert user1;            
        system.debug('user1-AccountId---  '+user1.AccountId);
        system.debug('user1-ContactId---  '+user1.ContactId);
            
            Account portalAccount = new Account(
                Name='pAccount',
                Cell__c='9876543210',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='1234567890',
                Company_NMLS_ID__c = '96385',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id ContactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                RecordTypeId = ContactrecordTypeId,
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
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            
            Loan_New__c loanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.today(),Loan_Originator_Identifier__c = contact.Contact_NMLS__c,                                            
                                                     Preferred_Contact_Type__c = 'Loan Officer',Related_Individual__c = user1.ContactId,
                                                     Related_Partner__c = user1.AccountId);            
            insert loanInsert;        
            LoanStatus__c LoanStatus = new LoanStatus__c(Name = 'Application Package Received', LoanId__c = loanInsert.Id, 
                                                         PreviousStatus__c = 'Waiting for Full Package');
            Insert LoanStatus;
            
            
            Test.startTest();
            string num='1234567890';
            string Phone = SAL_LoanController.formatphonenum(num); 
            id LoanId=SAL_LoanController.SaveLoan(loanInsert);
            string result = SAL_LoanController.getLoanOfficerLoanById(loanInsert.Id);
            Test.stopTest();
            System.assertEquals(loanInsert.Id, LoanId);
            
       
        }
    }
    
    
    @IsTest Static void getLoanByIdTest(){
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
            Id ContactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                RecordTypeId = ContactrecordTypeId,
                Potential_Portal_User_Status__c = 'Ready',
                LastName = 'TestName',
                Title__c='Processor', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
            string LoanId = LoanInsert.Id;
            Test.startTest();
            SAL_LoanController.getLoanById(LoanId);
            Test.stopTest();
        }
    }
    
    @IsTest Static void getSubjectPropertyByLoanIdTest(){
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
                Name='porAccount',
                Cell__c='9586243103',
                QLMS_Account_Executive__c=QLMSAE1.ID,
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='7536241520',
                Company_NMLS_ID__c = '96385',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id ContactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                RecordTypeId = ContactrecordTypeId,
                Potential_Portal_User_Status__c = 'Ready',
                Title__c='Loan Officer',             
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                LastName='LastName', 
                Cell__c='1234569874', 
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
            string LoanId = LoanInsert.Id;
            Test.startTest();
            SAL_LoanController.getSubjectPropertyByLoanId(LoanId);
            Test.stopTest();
        }
    }
    
    @IsTest Static void UpdateSubjectPropertyTest(){
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
            Id ContactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                RecordTypeId = ContactrecordTypeId,
                Potential_Portal_User_Status__c = 'Ready',
                LastName='LastName', 
                Title__c='Processor', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;  
            
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id,Subject_Property_Type__c= 'Condominium');
            
            insert loanInsert;  
            Loan_New__c loanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id,Originating_Loan_Officer__c=user1.Id);
            
            insert loanInsert1; 
            string LoanId = LoanInsert.Id;
            string LoanId1 = loanInsert1.Id;
            Test.startTest();
            SAL_LoanController.UpdateSubjectProperty(LoanInsert,LoanId);
            SAL_LoanController.UpdateSubjectProperty(loanInsert1,LoanId1);
            Test.stopTest();
        }
    }
    
    @IsTest Static void getLoanNameTest(){
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        UserRole UR=[Select Id from UserRole where Name='System Administrator' ];        
        user usr = [SELECT Id FROM user WHERE  profileid=:p.id and isactive=true limit 1];
        system.runAs(usr)
        {
        StateLisenceResponse objFc =new StateLisenceResponse();
            objFc.IsLicenseValidated=true;
            Account portalAccount = new Account(
                Name='portalAccount',
                Company_NMLS_ID__c = '1234',                
                partner_type__c = 'Non Premier');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName',                
                Contact_NMLS__c = '12345',                
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Profile p1 = [SELECT Id FROM Profile WHERE Name='ORM Partners'];
            UserRole UR1=[Select Id from UserRole where Name='Principal'];        
            String orgId1 = UserInfo.getOrganizationId();
            String dateString1 = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            Integer randomInt1 = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName1 = orgId1 + dateString1 + randomInt1;
            User user2 = new User(Alias = uniqueName1.substring(18, 23),  email = uniqueName1 + '@test1' + orgId1 + '.org',
                                  Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                                  EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p1.Id,
                                  //userroleid=UR1.ID,
                                  contactid=contact.id, 
                                  TimeZoneSidKey='America/Los_Angeles');
            insert user2;            
            system.runAs(user2)
            {
            Loan_New__c loanInsert = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
            string LoanId = LoanInsert.Id;

            Test.startTest();
            String Name =  SAL_LoanController.getLoanName(LoanId);
            List<string> lst1=SAL_LoanController.getZipData('90001');
            List<string> lst2=SAL_LoanController.getRateFixProduct(); 
            List<string> lst3=SAL_LoanController.getHeloRate();           
            List<string> lst4=SAL_LoanController.getARMRate();  //SFDC-377
            List<string> lst5=SAL_LoanController.getHeloArmRate();
            String ReturnVal1 = SAL_LoanController.getOrigination('5.060');
            String ReturnVal2 = SAL_LoanController.getHeloMargin('6.625');
            String ReturnVal3 = SAL_LoanController.getHeloArmMargin('6.000');
            String ReturnVal4 = SAL_LoanController.getBorrower('5.060');
            String ReturnVal5 = SAL_LoanController.getHeloOrigination('5.060');
            String ReturnVal6 = SAL_LoanController.getHeloArmOrigination('5.060');
            Test.stopTest();
        }
        }
    }
    @IsTest Static void getStateNameTest(){
       //User Usr=[select isactive,contactid,ProfileId,AccountId from user where ISPortalEnabled=true order by createddate desc limit 1];
        Profile pro = [SELECT Id FROM Profile WHERE Name='Portal Loan Processors']; 
          Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist']; 
       
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User Usr = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert Usr;            
            system.runAs(Usr)
            {
                
                Account portalAccount = new Account(
                Name='portalAccount',
                Type_of_Institution__c='State Charter',
                Cell__c='1236547410',
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New',
                partner_type__c = 'Premier');
            insert portalAccount;
            Id ContactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                RecordTypeId = ContactrecordTypeId,
                Potential_Portal_User_Status__c = 'Ready',
                LastName='LastName', 
                Title__c='Processor', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact; 
                // 
                
                Loan_New__c loanInsert = new Loan_New__c(Subject_Property_State__c='California',
                                                         IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                         LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.today(),Margin__c ='2.500',                                            
                                                         Estimate_of_Appraised_Value__c=1500.00,Related_Individual__c = Usr.ContactId, 
                                                         Related_Partner__c = Usr.AccountId);
                
                insert loanInsert;  
                Id Branch_RecortypeId = Schema.SObjectType.License__c.getRecordTypeInfosByName().get('Branch Licenses').getRecordTypeId();
                Id Individual_RecortypeId = Schema.SObjectType.License__c.getRecordTypeInfosByName().get('Individual Licenses').getRecordTypeId();
                Id Partner_RecortypeId = Schema.SObjectType.License__c.getRecordTypeInfosByName().get('Partner Licenses').getRecordTypeId();
                
                List<License__c> LicenseList = new List<License__c>();
                License__c ObjLicense1= new License__c( State__c = 'California',Related_Account__c=Usr.AccountId,recordtypeid = Individual_RecortypeId, Related_Contact__c = Usr.ContactId, License_Number__c = '1234',Contact_License_Type__c='BRE - Real Estate Broker License Endorsement',Account_License_Type__c='DBO - Finance Lenders Law License');
                License__c ObjLicense2= new License__c( State__c = 'Colorado',Related_Account__c=Usr.AccountId,recordtypeid = Branch_RecortypeId, Related_Contact__c = Usr.ContactId, License_Number__c = '1235',Contact_License_Type__c='Mortgage Loan Originator License', Account_License_Type__c='Mortgage Company Registration');
                License__c ObjLicense3= new License__c( State__c = 'Arkansas',Related_Account__c=Usr.AccountId,recordtypeid = Partner_RecortypeId, Related_Contact__c = Usr.ContactId, License_Number__c = '1236',Contact_License_Type__c='Mortgage Loan Originator License',Account_License_Type__c='Combination Mortgage Banker-Broker-Servicer License');
                LicenseList.Add(ObjLicense1);
                LicenseList.Add(ObjLicense2);
                LicenseList.Add(ObjLicense3);
                insert LicenseList;
                Test.startTest();
                // String Name =  SAL_LoanController.getLoanName(LoanId);
                SAL_LoanController.IsLoanCreatedByLoanProcessor(loanInsert.Id);
                StateLisenceResponse lst1=SAL_LoanController.getStateName(LicenseList[0].State__c,Usr.ContactId);
                StateLisenceResponse lst2=SAL_LoanController.getStateName(LicenseList[1].State__c,Usr.ContactId);
                StateLisenceResponse lst3=SAL_LoanController.getStateName(LicenseList[2].State__c,Usr.ContactId);
                Loan_New__c obj=SAL_LoanController.TabsValidatedData(loanInsert.id);
                String ReturnVal1 = SAL_LoanController.getOrigination('5.060');
                String ReturnVal2 = SAL_LoanController.getBorrower('5.060');
                //SFDC-289
                List<String> ReturnVal3 = SAL_LoanController.getRateFixedPriceTier1();
                List<String> ReturnVal4 = SAL_LoanController.getRateFixedPriceTier2();
                List<String> ReturnVal13 = SAL_LoanController.getRateFixedPriceTier3();
                String ReturnVal5 = SAL_LoanController.getORMOriginationT1(5.060);
                String ReturnVal6 = SAL_LoanController.getORMOriginationT2(5.060);
                String ReturnVal16 = SAL_LoanController.getORMOriginationT3(5.060);                
                String ReturnVal7 = SAL_LoanController.getORMBorrowerT1(5.060);
                String ReturnVal8 = SAL_LoanController.getORMBorrowerT2(5.060);
                String ReturnVal15 = SAL_LoanController.getORMBorrowerT3(5.060);                
                List<String> ReturnVal9 = SAL_LoanController.getHeloRateTier1();
                List<String> ReturnVal10 = SAL_LoanController.getHeloRateTier2();
                List<String> ReturnVal14 = SAL_LoanController.getHeloRateTier3();
                String ReturnVal11 = SAL_LoanController.getHeloOrigination('5.060');
                String ReturnVal12 = SAL_LoanController.getHeloArmOrigination('5.060');
                //String ReturnVal12 = SAL_LoanController.getHeloMargin('6.625');
               // String ReturnVal12_1 = SAL_LoanController.getHeloMargin(6.625);
                List<String> ReturnVal02 = SAL_LoanController.getArmRateTier1(); //SFDC-377
                List<String> ReturnVal03 = SAL_LoanController.getArmRateTier2();
                List<String> ReturnVal04 = SAL_LoanController.getArmRateTier3();
                Test.stopTest();
            }
      
    }
    @IsTest Static void getStatesTest(){
        Test.startTest();
        SAL_LoanController.getLoanOfficerList();
        SAL_LoanController.getStates();
        SAL_LoanController.getStatesPur();
        SAL_LoanController.get_heloStatesPur();
        SAL_LoanController.get_heloStatesRefi();
        SAL_LoanController.get_heloArmStatesRefi();
        SAL_LoanController.get_heloArmStatesPur();
        Test.stopTest();
        
    }
    @IsTest Static void UpdateLiabilityTest(){
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
                Name='poAccount',
                Cell__c='9516238470',
                QLMS_Account_Executive__c=QLMSAE1.ID,
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='9638527410',
                Company_NMLS_ID__c = '9631',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id ContactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                RecordTypeId = ContactrecordTypeId,
                Potential_Portal_User_Status__c = 'Ready',
                LastName='TestName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Mishel',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
            string LoanId = LoanInsert.Id;
            Test.startTest();
            SAL_LoanController.UpdateLiability(LoanInsert,LoanId);
            Test.stopTest();
        }
    }
    @IsTest Static void checkAndUpdateLiabilityClientTest(){
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
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Id ContactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
            Contact contact = new Contact(
                RecordTypeId = ContactrecordTypeId,
                Potential_Portal_User_Status__c = 'Ready',
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
            string LoanId = LoanInsert.Id;
            Loan_New__c loanInsert1 = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345007',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id,Is_Loan_Created_Manually__c=false);
            
            insert loanInsert1;        
            string LoanId1 = LoanInsert1.Id;
            
        Client__c clientLoan = new Client__c();
        clientLoan.Name  = 'Drush';
        clientLoan.LoanId__c = loanInsert.Id;
        clientLoan.Primary_Client_for_the_Loan__c = true;
        clientLoan.is_Active__c=true;
        insert clientLoan;
            
        Liability__c liability = new Liability__c(isActive__c = true, RelatedClient__c = clientLoan.Id, RelatedLoan__c = LoanInsert.Id, Liability_Category__c = 'Alimony', Liability_Type__c  = 'Divorce');
        Insert liability;
            Test.startTest();
            SAL_LoanController.checkAndUpdateLiabilityClient(LoanId);
            Test.stopTest();
        }
    }
}