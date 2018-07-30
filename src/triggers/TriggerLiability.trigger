trigger TriggerLiability on Liability__c (after insert, after update) {

      Liability__c  c =new Liability__c();
    c=trigger.new[0];
    string RecordID= c.Id;
    string LoanId = c.RelatedLoan__c;    
    //try{ 
    if(trigger.isAfter && trigger.IsInsert) {
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(RecordID,LoanId,
                                                                'Liability__c','Liability__share','Loan_Officer__c','LoanProcessor');
       }
    /*}
    catch(Exception ex)
    {
       Exception_log.Create_Custom_Logs(ex.getMessage(),'TriggerLiability'
                                             ,'After Insert','Date'+System.today());
    }  */  
}