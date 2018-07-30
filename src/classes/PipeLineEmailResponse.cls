public class PipeLineEmailResponse {
    
   
 	 @AuraEnabled public   String LoanNumberDetails { get;set; }
    @AuraEnabled public   String  BorrowerName { get;set; }
    @AuraEnabled public   string  ContactTime { get;set; }
    @AuraEnabled public   String  Phone { get;set; }
    @AuraEnabled public   String  LoanOfficerName { get;set; }
     @AuraEnabled public  String  partnerName { get;set; }
     @AuraEnabled public  String  LoanStatus { get;set; }
     @AuraEnabled public  Boolean  OrderAppFlag { get;set; }
    @AuraEnabled public  List<string>  BestContactList { get;set; }
     @AuraEnabled public string  BestContact { get;set; }
    
    @AuraEnabled public string  AccountExecutive { get;set; }
    @AuraEnabled public string  ClientName { get;set; }
    @AuraEnabled public string  Individual { get;set; }
    @AuraEnabled public string  LoanOfficer { get;set; }
    @AuraEnabled public string  OtherContactName { get;set; }
    @AuraEnabled public string  OtherContactPhone { get;set; }
    @AuraEnabled public Boolean OtherContactFlag { get;set; }
    @AuraEnabled public Boolean Fully_Signed_Application_Package { get;set; }	
    @AuraEnabled public Boolean HECM_Counseling_Certificate {get;set;}
    @AuraEnabled public Boolean Driver_License_and_Social_Security_Card { get;set; }	
    @AuraEnabled public Boolean Income_and_Asset_Documentation {get;set;}
}