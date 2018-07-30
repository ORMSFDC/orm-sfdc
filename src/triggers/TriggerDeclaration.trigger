trigger TriggerDeclaration on Declaration__c (after insert, after update) {
 Declaration__c  c =new Declaration__c();
    c=trigger.new[0];
    string RecordID= c.Id;
    string LoanId = c.DeclarationLoan__c;    
    //try{ 
    if(trigger.isAfter && trigger.IsInsert) {
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(RecordID,LoanId,
                                                                'Declaration__c','Declaration__share','Loan_Officer__c','LoanProcessor');
       }
   /* }
    catch(Exception ex)
    {
       Exception_log.Create_Custom_Logs(ex.getMessage(),'TriggerDeclaration'
                                             ,'After Insert','Date'+System.today());
    } */   
}