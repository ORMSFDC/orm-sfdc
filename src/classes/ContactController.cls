public  class ContactController
{
    public id contactId {get;set;}
        
    public List<Lead> getleads()
    {
         List<Lead> leadList =  new List<Lead>();
            
            leadList = [SELECT ORM_Loan_Number__c
                     , QL_Loan_Number__c
                     , ORM_Banker__c
                     , QL_banker__r.Name
                     , ORM_App_Date__c
                     , ORM_Folder_Date__c
                     , Closed_Date__c
                     , transfer_date__c 
                     , QL_banker__r.email                                          
                  FROM Lead WHERE QL_Banker__c =:contactId AND RecordTypeId = '01239000000EGVI' AND Killed_Lead__c = 'No' AND Closed_Date__c = Null];             
            return leadList ;           
    }
    
    public List<Lead> getleads2()
    {
         List<Lead> leadList =  new List<Lead>();
            
            leadList = [SELECT ORM_Loan_Number__c
                     , QL_Loan_Number__c
                     , ORM_Banker__c
                     , QL_banker__r.Name
                     , ORM_App_Date__c
                     , ORM_Folder_Date__c
                     , Closed_Date__c
                     , transfer_date__c 
                     , QL_banker__r.email                                          
                  FROM Lead WHERE QL_Banker__c =:contactId AND RecordTypeId = '01239000000EGVI' AND (Previous_QL_Status__c = '110 - Withdrawn' OR Previous_QL_Status__c = '100 - Denied') AND Killed_date__c = LAST_N_DAYS:30];             
            return leadList ;           
    }
    
    public List<Lead> getleads3()
    {
         List<Lead> leadList =  new List<Lead>();
            
            leadList = [SELECT ORM_Loan_Number__c
                     , QL_Loan_Number__c
                     , ORM_Banker__c
                     , QL_banker__r.Name
                     , ORM_App_Date__c
                     , ORM_Folder_Date__c
                     , Closed_Date__c
                     , transfer_date__c
                     , Killed_Lead__c 
                     , QL_banker__r.email                                          
                  FROM Lead WHERE QL_Banker__c =:contactId AND RecordTypeId = '01239000000EGVI' AND ORM_Folder_Date__c != NULL ];             
            return leadList ;           
    }
    
    public Integer getTransfer(){ //This is to get the total number of transfers for that particular contact
         Integer transfer = 0;        
         transfer = [SELECT count() FROM Lead WHERE QL_Banker__c =:contactId AND RecordTypeId = '01239000000EGVI' AND transfer_date__c = LAST_YEAR ];         
         return transfer;            
    }
    
    public Integer getTransfer2(){ 
         Integer transfer = 0;        
         transfer = [SELECT count() FROM Lead WHERE QL_Banker__c =:contactId AND RecordTypeId = '01239000000EGVI' AND transfer_date__c = THIS_YEAR ];         
         return transfer;            
    }
    
    public Integer getFolder(){ // This is to get the total number of Folders for the Leads who has folder date
         Integer folder = 0;
        folder = [SELECT count() FROM Lead WHERE QL_Banker__c =:contactId AND ORM_Folder_Date__c != Null 
        AND RecordTypeId = '01239000000EGVI' AND ORM_Folder_Date__c = LAST_YEAR];
     return folder;    
    }
    
    public Integer getFolder2(){
         Integer folder = 0;
        folder = [SELECT count() FROM Lead WHERE QL_Banker__c =:contactId AND ORM_Folder_Date__c != Null 
        AND RecordTypeId = '01239000000EGVI' AND ORM_Folder_Date__c = THIS_YEAR];
     return folder;
    
    }
    
    public Integer getClosed(){ // This is to get the total number of closed loans for the Leads who has closed date
         Integer closed = 0;         
        closed = [SELECT count() FROM Lead WHERE QL_Banker__c =:contactId AND Closed_Date__c != Null AND 
                  RecordTypeId = '01239000000EGVI' AND Closed_Date__c = LAST_YEAR];
        return closed;
    }
    
    public Integer getClosed2(){ 
         Integer closed = 0;         
        closed = [SELECT count() FROM Lead WHERE QL_Banker__c =:contactId AND Closed_Date__c != Null AND 
                  RecordTypeId = '01239000000EGVI' AND Closed_Date__c = THIS_YEAR];
        return closed;
    }
    
    public Integer getClosedMoney(){
        Integer closedmoney = 0;
        closedmoney = [SELECT count() FROM Lead WHERE QL_Banker__c =:contactId AND Closed_Date__c != Null
        AND RecordTypeId = '01239000000EGVI'AND Closed_Date__c = LAST_YEAR];     
        return (closedmoney * 1000);
    }  
    
    public Integer getClosedMoney2(){
        Integer closedmoney = 0;
        closedmoney = [SELECT count() FROM Lead WHERE QL_Banker__c =:contactId AND Closed_Date__c != Null
        AND RecordTypeId = '01239000000EGVI'AND Closed_Date__c = THIS_YEAR];     
        return (closedmoney * 1000);
    }    
         
    public recordWrapper recordWrapper{ // need to use wrapper to display the Recipient name just once 
        get{
            if(recordWrapper == null){
                recordWrapper = New recordWrapper(contactId); 
            }
            return recordWrapper;
        }
        set;
     } 
     
     public class recordWrapper{
        public String ContactName {get;set;}
        public Lead[] leadsList3 {get;set;}

        public recordWrapper(Id contactId){
            leadsList3 = [SELECT QL_banker__r.Name FROM Lead WHERE QL_Banker__c =:contactId AND RecordTypeId = '01239000000EGVI' Limit 10];
            if(!leadsList3.isEmpty()) { 
                ContactName = leadsList3[0].QL_Banker__r.Name;             
            }

        }
   }
     
}