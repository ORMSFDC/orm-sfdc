public class PipeLineDateResponse {

     @AuraEnabled public  string  CounselingDate { get;set; }
     @AuraEnabled public  string  AppraisalOrderDate { get;set; }
     //@AuraEnabled public  string  AppraisalExpirationDate { get;set; }
     @AuraEnabled public  string  FHACaseNaumberDate { get;set; }
     @AuraEnabled public  string  AppraisalReceivedDate { get;set; }
     //@AuraEnabled public  string  HOIEffectiveDate { get;set; }
    // @AuraEnabled public  string  AppraisalSenttoClientDate { get;set; }
     @AuraEnabled public  string  ApplicationDate { get;set; }
     @AuraEnabled public string ApplicationSignedDate { get;set; }   //Added by Bala
     @AuraEnabled public  string  ClosingDate { get;set; }
     @AuraEnabled public  string  ReDiscloserDate { get;set; }
     @AuraEnabled public  string  NextTaxDueDate { get;set; }
     @AuraEnabled public  string  ReDiscloserReason { get;set; }
    //new fields for story 1311
    @AuraEnabled public  string  AnticipatedClosingDate { get;set; }
    @AuraEnabled public  string  ScheduledClosingDate { get;set; }
    @AuraEnabled public  string  ActualFundingDate { get;set; }
    
    @AuraEnabled public  string  PayoffOrderDate { get;set; }
    @AuraEnabled public  string  CreditReportDate { get;set; }
    @AuraEnabled public  string  AppraisalScheduledDate { get;set; }
    @AuraEnabled public  string  AppraisalEffectiveDate { get;set; }
    @AuraEnabled public  string  TitleOrderedDate { get;set; }
    @AuraEnabled public  string  TitleReceivedDate { get;set; }
    @AuraEnabled public  string  FloodOrderedDate { get;set; }
    @AuraEnabled public  string  FloodReceivedDate { get;set; }
    @AuraEnabled public  string  InsuranceBinderOrderedDate { get;set; }
    @AuraEnabled public  string  InsuranceBinderReceivedDate { get;set; }
    @AuraEnabled public  string  CoolingOffNoticeSignedDate { get;set; }
    @AuraEnabled public  string  LoanOriginationState { get;set; }
    
}