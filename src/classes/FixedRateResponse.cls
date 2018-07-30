public class FixedRateResponse {
	@AuraEnabled public string Rate{get;set;}
     @AuraEnabled public string Price{get;set;}
     @AuraEnabled public string OriginationToORM{get;set;}
     @AuraEnabled public string CreditToBorrower{get;set;}
}