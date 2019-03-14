@isTest
public with sharing class UploadControllerTest {
    
    @isTest static void GetAttLoanPartnerTest(){
    
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
        Contact contact = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other', 
            Email = 'Sam@gmail.com',
            //How_did_you_hear_about_us__c='Twitter', 
            //Individual_lead_Status__c='New',
            Source_Name__c='Michael',
            AccountId = portalAccount.Id);
        insert contact;
        
        
        system.debug('GetAttLoanPartner--usersId---'+ userinfo.getUserId());
        Loan_New__c Loan1 = new Loan_New__c(
                                            IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',LoanNumber__c = '12345',
                                            Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
        Loan_New__c Loan2 = new Loan_New__c(
                                            IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='In Processing',LoanNumber__c = '12345',
                                            Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
        List<Loan_New__c> LoanInsert = new List<Loan_New__c>();
        LoanInsert.add(Loan1);
        LoanInsert.add(Loan2);
        Insert LoanInsert;
        //string LoanId = LoanInsert.Id;
     //   system.debug('GetAttLoanPartner--LoanId---'+ LoanInsert.Id);
        Client__c Client1 = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                          LoanId__c =LoanInsert[0].Id, Primary_Client_for_the_Loan__c = true);
        Client__c Client2 = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                          LoanId__c =LoanInsert[0].Id, Primary_Client_for_the_Loan__c = true);
        List<Client__c> ClientInsert = new List<Client__c>();
        ClientInsert.add(Client1);
        ClientInsert.add(Client2);
        Insert ClientInsert;
        //string ClientId = ClientInsert.Id;
        //system.debug('GetAttLoanPartner--ClientId---'+ ClientInsert[0].Id);
        
        Blob FileData1 = Blob.valueOf('');
        Attachment Attachment1 = new Attachment(Name='Dtest', ParentId = LoanInsert[0].Id, Body = FileData1, 
                                               ContentType = 'text/plain', IsPrivate = false,  OwnerId = user1.Id);
        Blob FileData = Blob.valueOf('');
        Attachment Attachment2 = new Attachment(Name='Drushtest', ParentId = LoanInsert[1].Id, Body = FileData, 
                                               ContentType = 'text/plain', IsPrivate = false, OwnerId = user1.Id);
        List<Attachment> ObjAttachment = new List<Attachment>();
        ObjAttachment.Add(Attachment1);
        ObjAttachment.Add(Attachment2);
        insert ObjAttachment;
        
        AttachmentResponse AttRes = new AttachmentResponse();
        AttRes.Id = ObjAttachment[0].Id;
        AttRes.DocName = 'Dtest';
        AttRes.CreatedDate = '20170914';
       // AttRes.UploadedBy = users[0].Name;
        
        AttachmentResponse AttRes1 = new AttachmentResponse();
        AttRes.Id = ObjAttachment[1].Id;
        AttRes.DocName = 'Drushtest';
        AttRes.CreatedDate = '20170914';
       // AttRes.UploadedBy = users[1].Name;
        UploadController.UpdateAttachmentStatus(ObjAttachment[1].Id);
        //System.runAs(users[0]) {
        //Blob FileData = Blob.valueOf('/services/data/v40.0/sobjects/Attachment/00P0q000000Ua3fEAC/Body');
        //system.debug('GetAttLoanPartner--ObjAttachmentId---'+ ObjAttachment.Id);
        Test.startTest();
        List<AttachmentResponse> AttResponse1 = UploadController.GetAttLoanPartner(LoanInsert[0].Id);
             List<AttachmentResponse> AttResponse2 = UploadController.GetAttLoanPartnerForAE(LoanInsert[0].Id);
        //List<AttachmentResponse> AttResponse2 = UploadController.GetAttLoanPartner(LoanInsert[1].Id);
        Test.stopTest();
        //system.assertEquals(AttResponse[0].DocName, AttRes.DocName);
        //}
        
        }
    }
    
    @isTest static void GetAttLoanOfficerTest(){
        
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
          Loan_New__c LoanInsert =  new Loan_New__c(Related_Partner__c = portalAccount.Id,
                                                 IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Proposal',LoanNumber__c = '12345');
       Insert LoanInsert;
     
      string LoanId = LoanInsert.Id;
      Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                            LoanId__c =LoanInsert.Id, Primary_Client_for_the_Loan__c = true);
      Insert ClientInsert;
       string ClientId = ClientInsert.Id;
        
        Blob FileData = Blob.valueOf('');
        Attachment ObjAttachment = new Attachment(Name='Dtest', ParentId = LoanInsert.Id, Body = FileData);
        insert ObjAttachment;
        
        AttachmentResponse AttRes = new AttachmentResponse();
        AttRes.Id = ObjAttachment.Id;
        AttRes.DocName = 'Dtest';
        AttRes.CreatedDate = '20170707';
        AttRes.UploadedBy = 'Drush';
        
        List<AttachmentResponse> AttResponse = UploadController.GetAttLoanOfficer(LoanInsert.Id);
        system.assertEquals(AttResponse.size(), 1);
        
        }
    }
    
    
    
    @isTest static void getObjAttachmentTest(){
        
        UploadController ObjUploadController = new UploadController();
        //Blob FileData = Blob.valueOf('/services/data/v40.0/sobjects/Attachment/00P0q000000Ua3fEAC/Body');
        Attachment ObjAttachment = new Attachment();
        //insert ObjAttachment;
        Test.startTest();       
        attachment ReturnAttachment = ObjUploadController.getObjAttachment();
        Test.stopTest();
        system.assertEquals(ObjAttachment, ReturnAttachment);
    }
    
    
    public transient Attachment objAttachment;
    
    
    
    @isTest static void uploadFileTest(){
        
        Test.startTest();
        
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
          Loan_New__c LoanInsert =  new Loan_New__c(Related_Partner__c = portalAccount.Id,
                                                 IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Proposal',LoanNumber__c = '12334545',PCS_at_Loan_Level__c = user1.id);
       Insert LoanInsert;
     

       string LoanId = LoanInsert.Id;
        Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert.Id);
        Insert ClientInsert;
        string ClientId = ClientInsert.Id;
        
        UploadController ObjUploadController = new UploadController();
        ObjUploadController.fileUploadProcessed = true;
        ObjUploadController.message = 'Test File was uploaded successfully';
        ObjUploadController.messageType = 'Test success';
        Blob FileData = Blob.valueOf('');
        
        Attachment ObjAttachment = new Attachment(Name='Dtest', ParentId = LoanInsert.Id, Body = FileData, 
                                                  ContentType = 'text/plain', IsPrivate = false);
        
        //(Id)apexPages.CurrentPage().getParameters().put('id',string.valueOf());
        insert objAttachment;
        string message = ObjUploadController.message;
        string  messageType = ObjUploadController.messageType;
        
        ObjUploadController.uploadFile();
        }
        Test.stopTest();
    }
    
    @isTest static void DeleteAttachmentTest(){
    
        
     
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
        Loan_New__c LoanInsert =  new Loan_New__c(Related_Partner__c = portalAccount.Id,
                                                 IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Proposal',LoanNumber__c = '12345');
       Insert LoanInsert;
        string LoanId = LoanInsert.Id;
        Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                               LoanId__c =LoanInsert.Id, Primary_Client_for_the_Loan__c = true);
        Insert ClientInsert;
        string ClientId = ClientInsert.Id;
        
        UploadController ObjUploadController = new UploadController();
        ObjUploadController.fileUploadProcessed = true;
        ObjUploadController.message = 'Test File was uploaded successfully';
        ObjUploadController.messageType = 'Test success';
        Blob FileData = Blob.valueOf('');
        Attachment ObjAttachment = new Attachment();
        objAttachment.Name='Dtest';
        objAttachment.Body = FileData;
        objAttachment.ParentId = LoanInsert.Id;
        //(Id)apexPages.CurrentPage().getParameters().put('id',string.valueOf());
        insert objAttachment;
        string AttachmentId =(string)objAttachment.id;
        Test.startTest();
        UploadController.DeleteAttachment(AttachmentId);
        UploadController.GetProfileDetail();
        Test.stopTest();
        
        }
    }
    
    /* @isTest static void getAttachmentOnRefershTest(){

//Insert Record for testing the If situation  
Loan__c LC1 = new Loan__c(ClientIName__c= 'a0G0q0000005LviEAE',FinalCompleteFlag__c='N', IsActiveFlag__c= true,Loan_Number__c = '', Loan_Status__c='Cancelled/Denied', PlineCashDueforClosing__c=500.00, PlineCashAvaliabletoClient__c=500.00, PlinePropertyAppraisalValue__c = 50.00,
PlineTotalLESA__c=500.00,PlineBrokerCompensation__c=500.00,PlineMonthlyPaymentavailabletoClient__c=500.00,PlineFinancialAssessmentResult__c='');
Loan__c LC2 = new Loan__c(ClientIName__c= 'a0G0q0000005K8LEAU',FinalCompleteFlag__c='N', IsActiveFlag__c= true,Loan_Number__c = '', Loan_Status__c='Cancelled/Denied', PlineCashDueforClosing__c=500.00, PlineCashAvaliabletoClient__c=500.00, PlinePropertyAppraisalValue__c = 50.00,
PlineTotalLESA__c=500.00,PlineBrokerCompensation__c=500.00,PlineMonthlyPaymentavailabletoClient__c=500.00,PlineFinancialAssessmentResult__c='');
list<Loan__c> LoanList = new list<Loan__c>();
LoanList.add(LC1);
LoanList.add(LC2);
insert LoanList;

Blob FileData = Blob.valueOf('/services/data/v40.0/sobjects/Attachment/00P0q000000Ua3fEAC/Body');
Attachment ObjAttachment = new Attachment(Name='Dtest', ParentId = LoanList[0].Id, Body = FileData);
insert ObjAttachment;
AttachmentResponse AttRes = new AttachmentResponse();
AttRes.Id = '00P0q000000UZnHEAW';
AttRes.DocName = 'Dtest';
AttRes.CreatedDate = '20170707';
AttRes.UploadedBy = 'Drush';

List<AttachmentResponse> AttResponse = UploadController.getAttachmentOnRefersh(LoanList[0].Id);
system.assertEquals(AttResponse[0].DocName, AttRes.DocName);
}

@isTest static void getLoanOfficerAttachmentTest(){

//Insert Record for testing the If situation  
Loan__c LC1 = new Loan__c(ClientIName__c= 'a0G0q0000005LviEAE',FinalCompleteFlag__c='N', IsActiveFlag__c= true,Loan_Number__c = '', Loan_Status__c='Cancelled/Denied', PlineCashDueforClosing__c=500.00, PlineCashAvaliabletoClient__c=500.00, PlinePropertyAppraisalValue__c = 50.00,
PlineTotalLESA__c=500.00,PlineBrokerCompensation__c=500.00,PlineMonthlyPaymentavailabletoClient__c=500.00,PlineFinancialAssessmentResult__c='');
Loan__c LC2 = new Loan__c(ClientIName__c= 'a0G0q0000005K8LEAU',FinalCompleteFlag__c='N', IsActiveFlag__c= true,Loan_Number__c = '', Loan_Status__c='Cancelled/Denied', PlineCashDueforClosing__c=500.00, PlineCashAvaliabletoClient__c=500.00, PlinePropertyAppraisalValue__c = 50.00,
PlineTotalLESA__c=500.00,PlineBrokerCompensation__c=500.00,PlineMonthlyPaymentavailabletoClient__c=500.00,PlineFinancialAssessmentResult__c='');
list<Loan__c> LoanList = new list<Loan__c>();
LoanList.add(LC1);
LoanList.add(LC2);
insert LoanList;

Blob FileData = Blob.valueOf('/services/data/v40.0/sobjects/Attachment/00P0q000000Ua3fEAC/Body');
ContentDocument ContentDoc = new ContentDocument();
ContentDoc.Id = '0690q0000000BvRAAU';
ContentDoc.Title = 'Test1 Title';
//ContentDoc = [Select Id ,Title from ContentDocument];

contentdocumentlink ContentDocLink = new contentdocumentlink();
//ContentDocLink.Id = '06A0q0000000DGfEAM';
//ContentDocLink.LinkedEntityId  = '0050q000000ERRlAAO';
//ContentDocLink.ContentDocumentId= '0690q0000000BvRAAU';
//[SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink where ContentDocumentId =: ContentDoc.Id];
//insert ContentDocLink;

List<ContentVersion> cv =  [SELECT Id,Title, createddate, createdbyid FROM ContentVersion WHERE ContentDocumentId =: '0690q0000000BvRAAU'];

DocResponse DocRes = new DocResponse();
DocRes.Id = '00P0q000000UZnHEAW';
DocRes.DocTitle = 'Test Doc Title';
DocRes.UploaderName = 'Drush';
DocRes.CreatedDate = '20170707';
//System.assertEquals(DocRes.DocTitle, 'Test Doc Title');

List<DocResponse> DocResponse = UploadController.getLoanOfficerAttachment(LoanList[0].Id);
system.assertEquals(DocResponse.size(), 0);
}*/
}
