/**
* For Class: getClientfromDeclaration
* Aditya
**/

@isTest
public class GetClientfromDeclarationTest{
    static testMethod void testGetAllClientList(){
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
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;  
      
        List<ClientDeclarationDetails> clientDeclarationDetailsListReturned;
        List<Declaration__c> declrataionList;
        Client__c client;
        
        //Adding Loan record.
         Loan_New__c loan = new Loan_New__c(
                                               IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                               ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            
            insert loan;        
        
        //Adding Client Record
        client = new Client__c();
        client.Name = 'Name';
        client.Last_Name__c = 'LastName';
        client.First_Name__c = 'FirstName';
        client.LoanId__c = loan.Id; 
        insert client;
        
        
        //Adding Declaration Records
        Declaration__c declaration = new Declaration__c();
        declaration.Name = 'Declaration Name';
        declaration.DeclarationClient__c = client.Id;
        declaration.IsDeclaration_Filled_From_Tab__c = true;
        declaration.DeclarationLoan__c = loan.Id;
        insert declaration;
        
        clientDeclarationDetailsListReturned = new List<ClientDeclarationDetails>();
        clientDeclarationDetailsListReturned = getClientfromDeclaration.AllClientsName(loan.Id);
        
        for(ClientDeclarationDetails cdd: clientDeclarationDetailsListReturned ){
             if(cdd.ClientFirstName.equals(client.First_Name__c)){
                 System.assertEquals(cdd.ClientLastName, client.Last_Name__c,'Values Not Matched');
             }
        }
    }
    
    
    }
}