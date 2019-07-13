/**
* @description:  Update Client Name on Loan when client is updated/created 
*                share record with Loan                    
* @modified date 6/28/2019
*
*/
trigger ClientToLoanClientFieldTrigger on Client__c (after insert, after update, before insert, before update) {
   
   Client__c  c =new Client__c();
        c=trigger.new[0];
        string clientID = c.Id;
        string LoanId = c.LoanId__c; 
    try{
      
        if(Trigger.isInsert && Trigger.isAfter){     
            ClientLoan.updateLoanPOA(clientId); 
        }

        if(Trigger.isAfter && Trigger.IsInsert) {
            SAL_ApexManagedSharingController.ShareRecordAfterInsert(clientID,LoanId,'Client__c','Client__Share','Loan_Officer__c','LoanProcessor__c');
        }
        
       if(Trigger.isBefore){
            if(Trigger.isUpdate || Trigger.isInsert){
                ClientLoan.validatePrimaryClient(clientId, LoanId, (List<Client__c>)Trigger.new); 
            }
        }
    }catch(Exception ex){system.debug(' ClientToLoanClientFieldTrigger----Exception---'+ex);}
    
}