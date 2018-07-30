public class ClientResidentResponse {
     @AuraEnabled public string ClientId { get;set; }
      @AuraEnabled public string RecordId { get;set; }
    @AuraEnabled public   String NonborrowingResidentName { get;set; }   
   // @AuraEnabled public   String  NonborrowingResidentPhone { get;set; }
    @AuraEnabled public   Date  NonborrowingResidentDOB { get;set; }
     @AuraEnabled public   String  NonborrowingResidentRelation { get;set; }
     @AuraEnabled public   double  NonborrowingResidentMonthlyIncome { get;set; }
    
}