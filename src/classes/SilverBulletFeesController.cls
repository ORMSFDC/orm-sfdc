public class SilverBulletFeesController{
   
    public class ServiceData {
        @AuraEnabled
        public Double totalAmount{get;set;}
        @AuraEnabled
        public List<FeeDetails> feeDetails{get;set;}
        
    }

    public class FeeDetails {
        @AuraEnabled
        public String feeDescription{get;set;}
        @AuraEnabled
        public String feeNumber{get;set;}
        @AuraEnabled
        public Double feeAmount{get;set;}
    }
    
    @AuraEnabled
    public static ServiceData getServiceData(string loanId) {
        List<ExternalService__c> eserviceList = [select Id,ResponsePayload__c from ExternalService__c where SourceID__c=:loanId
                                                and Status__c='Response Received'  and SourceID__c!=null 
                                                and ServiceName__c='AmrockBot' order by lastmodifieddate desc];
        
       if(eserviceList.size() > 0 && eserviceList[0].ResponsePayload__c != null)
       {
           return (ServiceData) System.JSON.deserialize(eserviceList[0].ResponsePayload__c, ServiceData.class);
       }
         else
      return null;
    }
    
}