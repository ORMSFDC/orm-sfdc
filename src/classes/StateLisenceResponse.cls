public class StateLisenceResponse
    {
        @AuraEnabled public boolean IsLicenseValidated{get;set;}
        @AuraEnabled public String ErrorMessage{get;set;}
    }