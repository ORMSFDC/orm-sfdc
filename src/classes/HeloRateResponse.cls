/**
 * @description: fetch Helo Pricing response for Helo method in Pricing class 
 * @author: Sahitya
 * @date: 7/17/2018
 */

public class HeloRateResponse {
  @AuraEnabled public string Rate{get;set;}
     @AuraEnabled public string Price{get;set;}
     @AuraEnabled public string OriginationToPartner{get;set;}
     @AuraEnabled public string CreditToBorrower{get;set;}
     @AuraEnabled public string ServicingFee{get;set;}
}