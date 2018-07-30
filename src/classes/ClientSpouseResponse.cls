public class ClientSpouseResponse {
    @AuraEnabled public   string 	ClientId 						{ get;set; }
    @AuraEnabled public   String 	NonborrowingSpouseYesNo 		{ get;set; }     
    @AuraEnabled public   String  	NonborrowingSpouseName 			{ get;set; }
    @AuraEnabled public   String  	NonborrowingSpousePhone 		{ get;set; }
    @AuraEnabled public   Date  	NonborrowingSpouseDOB 			{ get;set; }
    @AuraEnabled public   String  	NonborrowingSpouseRelation 		{ get;set; }
    @AuraEnabled public   Boolean  	NonborrowingSpouseAddressSameAs { get;set; }
    @AuraEnabled public   string  	NonborrowingSpouseAddress 		{ get;set; }
    @AuraEnabled public   string  	NonborrowingSpouseCity 			{ get;set; }
    @AuraEnabled public   string  	NonborrowingSpouseState 		{ get;set; }
    @AuraEnabled public   string  	NonborrowingSpouseZip 			{ get;set; }
    @AuraEnabled public   double 	NonborrowingSpouseMonthlyIncome { get;set; }
    @AuraEnabled public   string  	PlaceofCelebration 				{ get;set; }
}