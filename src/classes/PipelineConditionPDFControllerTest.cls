@IsTest
public class PipelineConditionPDFControllerTest {
    @IsTest Static void SaveLoanTest(){
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
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Loan_New__c loanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                     Preferred_Contact_Type__c = 'Loan Officer',Related_Individual__c = contact.Id,                                                     
                                                     Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;  
            list<condition__c> ConditionList = new list<condition__c>();
            Condition__c Conditio = new Condition__c(Condition_Number__c= '1', Comment__c ='Funded',Status__c='Outstanding',
                                                     Description__c = 'Alternate Address Clarification' ,Condition_Created_Date__c=Date.parse('10/11/2019'),Status_Date__c=Date.parse('10/11/2019'),
                                                     Loan_Id__c = loanInsert.Id);
            Condition__c Conditio1 = new Condition__c(Condition_Number__c= '1', Comment__c ='Funded',Status__c='Cancelled',
                                                      Description__c = 'Alternate Address Clarification' ,Condition_Created_Date__c=Date.parse('10/11/2019'),Status_Date__c=Date.parse('10/11/2019'),
                                                      Loan_Id__c = loanInsert.Id);
            Condition__c Conditio2 = new Condition__c(Condition_Number__c= '1', Comment__c ='Funded',Status__c='Cleared',
                                                      Description__c = 'Alternate Address Clarification' ,Condition_Created_Date__c=Date.parse('10/11/2019'),Status_Date__c=Date.parse('10/11/2019'),
                                                      Loan_Id__c = loanInsert.Id);
            Condition__c Conditio3= new Condition__c(Condition_Number__c= '1', Comment__c ='Funded',Status__c='Revision Requested',
                                                     Description__c = 'Alternate Address Clarification' ,Condition_Created_Date__c=Date.parse('10/11/2019'),Status_Date__c=Date.parse('10/11/2019'),
                                                     Loan_Id__c = loanInsert.Id);
            Condition__c Conditio5 = new Condition__c(Condition_Number__c= '1', Comment__c ='Funded',Status__c='Cleared',
                                                      Description__c = 'Alternate Address Clarification' ,Condition_Created_Date__c=Date.parse('10/11/2019'),Status_Date__c=Date.parse('10/11/2019'),
                                                      Loan_Id__c = loanInsert.Id);
            
            ConditionList.add(Conditio);
            ConditionList.add(Conditio1);
            ConditionList.add(Conditio2);
            ConditionList.add(Conditio3);
            ConditionList.add(Conditio5);
            insert ConditionList;
            Condition__c Conditio6 = new Condition__c(Condition_Number__c= '1', Comment__c ='Funded',Status__c='Outstanding',
                                                      Description__c = 'Alternate Address Clarification',Condition_Created_Date__c=Date.parse('10/11/2019'),Status_Date__c=Date.parse('10/11/2019'),
                                                      Loan_Id__c = loanInsert.Id,id=ConditionList[0].id);
            update Conditio6; 
            
        
            LoanStatus__c LoanStatus = new LoanStatus__c(Name = 'Application Package Received', LoanId__c = loanInsert.Id, 
                                                         PreviousStatus__c = 'Waiting for Full Package');
            Insert LoanStatus;
            PipelineConditionResponse PCR = new PipelineConditionResponse();
           		PCR.Id				= ConditionList[0].Id;
                PCR.ApplicationDate	= '10/11/2017';
                PCR.Status			= ConditionList[0].status__c;
                PCR.PCS_Name		= 'Drush';
                PCR.PhoneNumber		= '1234567890';
                PCR.TodaysDate 		= '01/19/2018';
                PCR.ClientName		= 'JOJO';
            
            
            Test.startTest();
            string num='9630266959';
            
            string Phone = PipelineConditionPDFController.FormatPhone(num);                      
            Test.stopTest();
            try{
                ApexPages.StandardController sc = new ApexPages.StandardController(loanInsert);
                
                ApexPages.currentPage().getParameters().put('id', loanInsert.Id);
                List<ConditionResponsePipeline> lst=PipelineConditionPDFController.getdata(); 
                List<PipelineConditionResponse> lst1=PipelineConditionPDFController.getConditiondetails();
                map<id,list<Condition_Log__c>> GetConditionLogMap=PipelineConditionPDFController.GetConditionLog(loanInsert.Id);
                //System.assertEquals(loanInsert.Id, LoanId);
            }catch(exception ex){}       
            
        }
    }
}
