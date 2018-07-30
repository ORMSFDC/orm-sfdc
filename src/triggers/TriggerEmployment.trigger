trigger TriggerEmployment on Employment__c (after insert, after update) {

      Employment__c  c =new Employment__c();
    c=trigger.new[0];
    string RecordID= c.Id;
    string LoanId = c.RelatedLoan__c;    
    
    if(trigger.isAfter && trigger.IsInsert) {
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(RecordID,LoanId,
                                                                'Employment__c','Employment__share','Loan_Officer__c','LoanProcessor');
       }
    
     
}