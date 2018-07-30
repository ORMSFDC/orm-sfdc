public class AttachmentResponse {
 
	@AuraEnabled public   id Id { get;set; }
    @AuraEnabled public   String DocName { get;set; }   
     @AuraEnabled public   String CreatedDate { get;set; }
 @AuraEnabled public   String UploadedBy { get;set; }
    @AuraEnabled public   String status { get;set; }

}