trigger TriggerNonBorrowingResident on Non_Borrowing_Resident__c (after insert, after update)  {

    Non_Borrowing_Resident__c  c =new Non_Borrowing_Resident__c();
    c=trigger.new[0];
    string RecordID= c.Id;
    string LoanId = c.Loan_Id__c;    
    //try{ 
    if(trigger.isAfter && trigger.IsInsert) {
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(RecordID,LoanId,
                                                                'Non_Borrowing_Resident__c','Non_Borrowing_Resident__share','Loan_Officer__c','LoanProcessor');
       }
   /* }
    catch(Exception ex)
    {
       Exception_log.Create_Custom_Logs(ex.getMessage(),'TriggerNonBorrowingResident'
                                             ,'After Insert','Date'+System.today());
    }  */  
}