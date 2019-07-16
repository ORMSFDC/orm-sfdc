/**
 * @description: fetch Helo ARM Pricing response for Helo method in Pricing class 
 * @author: Sahitya
 * @date: 7/08/2019
 */

public class HeloArmRateResponse {
     @AuraEnabled public string Rate{get;set;}
     @AuraEnabled public string Price{get;set;}
     @AuraEnabled public string OriginationToPartner{get;set;}
     @AuraEnabled public string CreditToBorrower{get;set;}
     @AuraEnabled public string ServicingFee{get;set;}
}