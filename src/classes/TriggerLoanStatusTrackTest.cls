/** * File Name   : TriggerLoanStatusTrackTest.apxt
*     Description : Test class
*     covers      : TriggerLoanStatusTrackHandler,TriggerLoanStatusTrack, TriggerHandlerLoan
*   * @author     : Sahitya
* */

@isTest
private class TriggerLoanStatusTrackTest {
    
    @isTest static void LoanStatusTrackTest(){
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
        User Usr=[select isactive,contactid,ProfileId,AccountId from user where ISPortalEnabled=true order by createddate desc limit 1];

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
            
            Branches__c branch = new Branches__c();
            branch.Name = 'New York';
            branch.Business_Partners_Acc__c	= portalAccount.Id;
            branch.IsActive__c = true;
            insert branch;
            
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                Related_Branch__c = branch.Id,
                AccountId = portalAccount.Id);
            insert contact;        
            List<Client__c> clientList;
            List<Client__c> clientListReturned;
            Id sAdmin=[select Id from Profile where Name=:'System Administrator' limit 1].Id;
        	User Uid =[select Id from User where ProfileId !=:sAdmin and IsActive=true limit 1];
            Loan_New__c loanInsert = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= false,LoanStatus__c ='Funded',
                                                     LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                     Preferred_Contact_Type__c = 'Loan Officer',Related_Individual__c = contact.Id,
                                                     Related_Partner__c = portalAccount.Id);
            
            insert loanInsert;        
            Loan_New__c LoanUpdate = new Loan_New__c(Loan_Processor__c = Usr.Id, Preferred_Contact_Type__c = 'Loan Processor',IsLoanCreatedByLoanProcessor__c=false, 
                                                     LoanStatus__c = 'Waiting for Full Package', Id = loanInsert.Id,LoanCompleteFlag__c= true,
                                                    ownerid=Uid.id);
             
        
        
            system.debug(Uid.id+'dfg'+Userinfo.getUserId());


            update LoanUpdate;

            //delete LoanUpdate;
        }
    }
   
}