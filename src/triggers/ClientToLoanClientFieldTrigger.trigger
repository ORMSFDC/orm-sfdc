trigger ClientToLoanClientFieldTrigger on Client__c (after insert, after update) {
    Client__c  c =new Client__c();
    c=trigger.new[0];
    string clientID = c.Id;
    string LoanId = c.LoanId__c;    
    try{
        if(c.Primary_Client_for_the_Loan__c == true)
        {
            if(![select LoanCompleteFlag__c from Loan_new__c where id=:LoanId ].LoanCompleteFlag__c )
            {
                Loan_New__c objLoan = new Loan_New__c();
                objLoan.Id = LoanId;
                objLoan.Client_Name__c = c.Last_Name__c + ', ' + c.First_Name__c;
                update objLoan;
            }
        }
  
    if(trigger.isAfter && trigger.IsInsert) {
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(clientID,LoanId,
                                                                'Client__c','Client__Share','Loan_Officer__c','LoanProcessor__c');
       }
    }
    catch(Exception ex)
    {
        system.debug(' ClientToLoanClientFieldTrigger----Exception---'+ex);
    }    
    if(trigger.isInsert && trigger.isAfter){
   
    }
    
}