public class PipeLineStatusChangeResponse {
    
 	@AuraEnabled public   string  LoanCurrentStatus { get;set; }
    @AuraEnabled public   string  LoanPrevioustatus { get;set; }
    @AuraEnabled public   string  LoanStatusChangeDate { get;set; }
}