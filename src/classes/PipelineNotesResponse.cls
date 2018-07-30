public class PipelineNotesResponse {   
    
    
    @AuraEnabled public string Id { get;set; }
    @AuraEnabled public   String Title { get;set; }     
    @AuraEnabled public   String  Body { get;set; }
    @AuraEnabled public   String  LastModifiedDate { get;set; }
    @AuraEnabled public   string  owner { get;set; }
     @AuraEnabled public   string  ownerType { get;set; }
  



}