public class ClientDeclarationDetails {
    @AuraEnabled public string ClientId {get;set;}
	@AuraEnabled public string ClientFirstName {get;set;}
      @AuraEnabled  public string ClientLastName {get;set;}
    @AuraEnabled  public string ClientFullName {get;set;}
        
   @AuraEnabled  public boolean ClientDeclarationStatus  {get;set;}
}