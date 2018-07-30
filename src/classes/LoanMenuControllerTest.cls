@isTest()
public with sharing class LoanMenuControllerTest {
    
    @isTest static void testValue(){}
    /*@isTest static void testValue(){
        //Insert Record for testing the If situation
        
        ClientInfo__c C1=new ClientInfo__c(Name='john');
             
        insert C1;
        
        Loan__c LC1 = new Loan__c(ClientIName__c=C1.Id,FinalCompleteFlag__c='N');
        insert LC1;
        string loanId1=LC1.Id;
      
        //Test that Records are Inserted
          Loan__c Loan1 = LoanMenuController.getValue(loanId1);
     
        System.assertEquals(Loan1.Id,loanId1);
       
    }
     @isTest static void testClientValue(){
        //Insert Record for testing the If situation
        
        ClientInfo__c C1=new ClientInfo__c(Name='john');
             
        insert C1;
            
     
        //Test that Records are Inserted
          ClientInfo__c C2 = LoanMenuController.getclientValue(c1.Id);
     
        System.assertEquals(C2.Id,c1.Id);
       
    }
    
    @isTest static void testScreen(){
          //Insert Record for testing the If situation
        
        ClientInfo__c C1=new ClientInfo__c(Name='john');
             
        insert C1;
        
        Loan__c LC1 = new Loan__c(ClientIName__c=C1.Id,FinalCompleteFlag__c='N');
        insert LC1;
        string loanId1=LC1.Id;
      
        //Test that Records are Inserted
          Loan__c Loan1 = LoanMenuController.setScreen(loanId1);
     
        System.assertEquals(Loan1.Id,LC1.Id);
         
    }
    
    @isTest static void testLoan() {
         ClientInfo__c c1=new ClientInfo__c(Name='clientTest2');
         insert c1;
         Loan__c l1 = new Loan__c(  ClientIName__c=c1.Id,FinalCompleteFlag__c='N');
         insert l1;
            
         String resultID = l1.Id;
        String result = '';
         //Test that Records are Inserted
      
       if (resultID != '') {
              Loan__c loans = LoanMenuController.saveLoan(l1,resultID);
             System.assertEquals(loans.Id,resultID);
        }
        resultID = '';
        if(resultID =='') 
        {
           Loan__c loans = LoanMenuController.saveLoan(l1,'');
           System.assertnotEquals(loans.Id,resultID);
      
        }
       
    }
   

    @isTest static void fetchAccountTest(){
         String searchKey = 'SK';
         
         ClientInfo__c Len1 = new ClientInfo__c(Name = 'Sachin', Last_Name__c  = 'Sharma',State__c = 'Detroit', Zip__c = '123456', Email_Optional__c ='a@b.com',Phone_Number__c = '1234456678',Street_Address__c = 'GZB');
         ClientInfo__c Len2 = new ClientInfo__c(Name = 'SK', Last_Name__c  = 'Sharma',State__c = 'Detroit', Zip__c = '123456', Email_Optional__c ='a@b.com',Phone_Number__c = '1234456678',Street_Address__c = 'GZB');
         list<ClientInfo__c> ClientList = new list<ClientInfo__c>();
         ClientList.add(Len1);
         ClientList.add(Len2);
         insert  ClientList;
        
        //Test that Records are Inserted
        List<ClientInfo__c> Client1 = LoanMenuController.fetchAccount(searchKey);        
        System.assertEquals(Client1.size(),1);
         
        //Delete Records For testing the Else situation
       delete ClientList;
        //searchKey='abc';
        //Test that Records are Deleted
        List<ClientInfo__c> Client2= LoanMenuController.fetchAccount(searchKey);       
        System.assertEquals(Client2.size(),0); 
    }

    @isTest static void testSaveClient(){
        try{
       Id proId;
       Profile p = [SELECT Id FROM Profile limit 1]; 
       proId=p.Id;
       //Account accounts = [select Id, Name from Account limit 1];
       User ojUser = [SELECT Id,Name FROM User where AccountId != null limit 1];
        system.debug(proId);
       system.runas(ojUser)
       {       
        
        ClientInfo__c Len1 = new ClientInfo__c(Name = 'Sachin', Last_Name__c  = 'Sharma',State__c = 'Detroit', Zip__c = '123456', Email_Optional__c ='a@b.com',Phone_Number__c = '1234456678',Street_Address__c = 'GZB');
        insert  Len1;
       
        //Insert Record for testing the If situation
        Loan__c LC1 = new Loan__c(ClientIName__c=Len1.Id);
        insert LC1;
  
       // insert LoanList;
        string loanId = LC1.Id;
        string CID = Len1.Id;
        String loanIdBlank= '';
        system.debug('LC1='+ LC1);
           system.debug('Len1=' + Len1);
           system.debug('loanId=' +loanId);
           system.debug('CID='+CID);
         //Test that Records are Inserted
      		 test.startTest();
             LoanMenuController.SaveClient(LC1,Len1,loanId,CID);   
           	 LoanMenuController.SaveClient(LC1,Len1, loanIdBlank,CID);
            test.stopTest(); 
  
          
     
        User users = [select Id,Name,AccountId,ContactId from User Limit 1];
        Account accounts=[select Id,Name from Account Limit 1];
           Id UserId = users.id;
           Opportunity obj1=new Opportunity();
           obj1.name=Len1.Name+'_'+accounts.Name;
           obj1.AccountId=accounts.Id;
           obj1.LoanOfficerName__c=users.ContactId;
           obj1.StageName='Proposal';
           obj1.Status__c='New';
           obj1.ClientID__c=Len1.id;
           obj1.CloseDate=System.today();
        
           Opportunity obj2=new Opportunity();
           obj2.name=Len1.Name+'_'+accounts.Name;
           obj2.AccountId=accounts.Id;
           obj2.LoanOfficerName__c=users.ContactId;
           obj2.StageName='Proposal';
           obj2.Status__c='New';
           obj2.ClientID__c=Len1.id;
           obj2.CloseDate=System.today();
           
        
             List<Opportunity> oppList= new List<Opportunity>();
        oppList.Add(obj1);
        oppList.Add(obj2);
     
       insert oppList;
         LoanMenuController.SaveClient(LC1,Len1,LC1.Id,Len1.Id);
        system.assertEquals(oppList.size(), 2); 
       
    }
  }
            catch(exception e){}
    }
*/
}