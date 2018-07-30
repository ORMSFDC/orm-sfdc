public class DocResponse {
    
	@AuraEnabled public   id Id { get;set; }   
    @AuraEnabled public   String DocTitle { get;set; }
    @AuraEnabled public   String UploaderName { get;set; }
     @AuraEnabled public   String CreatedDate { get;set; }
}