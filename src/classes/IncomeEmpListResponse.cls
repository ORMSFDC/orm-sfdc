public class IncomeEmpListResponse {
   
    @AuraEnabled public   String IncomeType { get;set; }
    @AuraEnabled public   String SourceName { get;set; }
    @AuraEnabled public   decimal  MonthlyIncomeValue { get;set; }
    @AuraEnabled public   ID  RecordID { get;set; }
    @AuraEnabled public   string  ObjectType { get;set; }
    @AuraEnabled public   string  ClientId { get;set; }
     @AuraEnabled public   Boolean IsValidated { get;set; }
    

}