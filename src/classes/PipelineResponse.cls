public class PipelineResponse {
    
    @AuraEnabled public   Id Loanid { get;set; }
    @AuraEnabled public   String LoanNumber { get;set; }     
    @AuraEnabled public   String  FullName { get;set; }
    @AuraEnabled public   String  LoanStatus { get;set; }
    @AuraEnabled public   string  LoanDate { get;set; }
  

}