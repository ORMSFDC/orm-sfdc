trigger TriggerIncome on Income_New__c (after insert, after update) {

      Income_New__c  c =new Income_New__c();
    c=trigger.new[0];
    string RecordID= c.Id;
    string LoanId = c.Related_Loan__c;    
    //try{ 
    if(trigger.isAfter && trigger.IsInsert) {
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(RecordID,LoanId,
                                                                'Income_New__c','Income_New__share','Loan_Officer__c','LoanProcessor');
       }
    /*}
    catch(Exception ex)
    {
       Exception_log.Create_Custom_Logs(ex.getMessage(),'TriggerIncome'
                                             ,'After Insert','Date'+System.today());
    }  */  
}