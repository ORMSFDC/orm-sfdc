/**
* @description:  Update Client Name on Loan when client is updated/created 
*                share record with Loan                    
* @modified date 6/28/2019
*
*/
trigger ClientToLoanClientFieldTrigger on Client__c (after insert, after update) {
    Client__c  c =new Client__c();
    c=trigger.new[0];
    string clientID = c.Id;
    string LoanId = c.LoanId__c;    
    try{
        Loan_New__c objLoan = new Loan_New__c();
        objLoan.Id = LoanId;
        String middleName;
        if(c.Middle_Name__c == null){
            middleName = '';
        }else{
            middleName = c.Middle_Name__c;
        }
        String fullName = (c.Last_Name__c + ', ' + c.First_Name__c +' '+ middleName).left(60);
        //Update Client Name on Loan
        if(c.Primary_Client_for_the_Loan__c == true)
        {
            objLoan.Client_Name__c = fullName;            
            update objLoan;
        }
        //Update Co-Client Name on Loan
        if(c.Primary_Client_for_the_Loan__c == false){            
            if(c.Primary_Client_for_the_Loan__c == false){
                objLoan.Co_Client_Name__c = fullName;
            }
            update objLoan; 
        }
        //update Is there a POA? (Name, Representing field on loan
        if(c.Is_there_a_POA__c == 'Yes' && c.Primary_Client_for_the_Loan__c == true){
            objLoan.Is_there_a_POA_Name_Representing_and__c = 'Yes';
            update objLoan;
        }
        if(c.Is_there_a_POA__c == 'No' && c.Primary_Client_for_the_Loan__c == true){
            objLoan.Is_there_a_POA_Name_Representing_and__c = 'No';
            update objLoan;
        }
  
    if(trigger.isAfter && trigger.IsInsert) {
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(clientID,LoanId,'Client__c','Client__Share','Loan_Officer__c','LoanProcessor__c');
       }
    }
    catch(Exception ex)
    {
        system.debug(' ClientToLoanClientFieldTrigger----Exception---'+ex);
    }    
    if(trigger.isInsert && trigger.isAfter){
   
    }
    
}