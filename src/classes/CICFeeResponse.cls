public class CICFeeResponse {
	@AuraEnabled public   Integer  FeeIndex { get;set; }
     @AuraEnabled public   Decimal  OldAmount { get;set; }
    @AuraEnabled public   Decimal  NewAmount { get;set; }
     @AuraEnabled public   String  FeeName { get;set; }
}