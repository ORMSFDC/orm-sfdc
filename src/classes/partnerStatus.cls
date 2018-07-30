public class partnerStatus{

    public Id accountId{get;set;}     
        
    //Folders Recieved, loans Inprocess
    public Integer getFolder1(){
        Integer count = 0;
        count = [SELECT count() FROM Loan_New__c WHERE LoanStatus__c = 'In Processing' AND Loan_Status_Change_Date__c= THIS_WEEK];
        return count;    
    }
    public Integer getFolder2(){
        Integer count = 0;
        count = [SELECT count() FROM Loan_New__c WHERE LoanStatus__c = 'In Processing' AND Loan_Status_Change_Date__c= LAST_WEEK];
        return count;    
    }
    public Integer getFolder3(){
        Integer count = 0;
        count = [SELECT count() FROM Loan_New__c WHERE LoanStatus__c = 'In Processing' AND Loan_Status_Change_Date__c= THIS_MONTH];
        return count;    
    }
    public Integer getFolder4(){
        Integer count = 0;
        count = [SELECT count() FROM Loan_New__c WHERE LoanStatus__c = 'In Processing' AND Loan_Status_Change_Date__c= THIS_YEAR];
        return count;    
    }
    
    
    //Loans Closing
    public Integer getLoan1(){
        Integer count = 0;
        count = [SELECT count() FROM Loan_New__c WHERE Closing_Date__c = THIS_WEEK];
        return count;    
    }
        public Integer getLoan2(){
        Integer count = 0;
        count = [SELECT count() FROM Loan_New__c WHERE Closing_Date__c = LAST_WEEK];
        return count;    
    }
        public Integer getLoan3(){
        Integer count = 0;
        count = [SELECT count() FROM Loan_New__c WHERE Closing_Date__c = THIS_MONTH];
        return count;    
    }
        public Integer getLoan4(){
        Integer count = 0;
        count = [SELECT count() FROM Loan_New__c WHERE Closing_Date__c = THIS_YEAR];
        return count;    
    }
    
    
    
    //Partners Approval request
    public Integer getStatusProcessing() {        
        Integer count = 0;
        count = [SELECT count() FROM Account WHERE Partner_Lead_Status__c = 'Processing' AND Lead_status_change_date__c = THIS_WEEK];
        return count;        
    }
    public Integer getStatusProcessing2() {        
        Integer count = 0;
        count = [SELECT count() FROM Account WHERE Partner_Lead_Status__c = 'Processing' AND Lead_status_change_date__c = LAST_WEEK];
        return count;        
    }
    public Integer getStatusProcessing3() {        
        Integer count = 0;
        count = [SELECT count() FROM Account WHERE Partner_Lead_Status__c = 'Processing' AND Lead_status_change_date__c = THIS_MONTH];
        return count;        
    }
    public Integer getStatusProcessing4() {        
        Integer count = 0;
        count = [SELECT count() FROM Account WHERE Partner_Lead_Status__c = 'Processing' AND Lead_status_change_date__c = THIS_YEAR];
        return count;        
    }
    
    
    //Partners Approved
    public Integer getStatusApproved() {        
        Integer count = 0;
        count = [SELECT count() FROM Account WHERE Partner_Lead_Status__c = 'Approved' AND Lead_status_change_date__c = THIS_WEEK];
        return (count);        
    }
    public Integer getStatusApproved2() {        
        Integer count = 0;
        count = [SELECT count() FROM Account WHERE Partner_Lead_Status__c = 'Approved' AND Lead_status_change_date__c = LAST_WEEK];
        return (count);        
    }
    public Integer getStatusApproved3() {        
        Integer count = 0;
        count = [SELECT count() FROM Account WHERE Partner_Lead_Status__c = 'Approved' AND Lead_status_change_date__c = THIS_MONTH];
        return (count);        
    }
     public Integer getStatusApproved4() {        
        Integer count = 0;
        count = [SELECT count() FROM Account WHERE Partner_Lead_Status__c = 'Approved' AND Lead_status_change_date__c = THIS_YEAR];
        return (count);        
    }
    
    
    //Attempted to contact
    public Integer getAllActivities1(){
        Integer taskCount = 0;
        Integer eventCount = 0;
        taskCount = [SELECT count() FROM Task WHERE Subject != Null AND createdDate = THIS_WEEK AND (Owner.Name = 'Josh Evink' OR Owner.Name = 'Joe Rizzo' OR Owner.Name = 'Raymond Kangas' OR Owner.Name = 'Jesse Hanson') ];
        eventCount = [SELECT count() FROM Event WHERE Subject != Null AND createdDate = THIS_WEEK AND (Owner.Name = 'Josh Evink' OR Owner.Name = 'Joe Rizzo' OR Owner.Name = 'Raymond Kangas' OR Owner.Name = 'Jesse Hanson') ];
        system.debug('all activities' +taskCount);    
        return (taskCount + eventCount);
    }   
    public Integer getAllActivities2() {
        
        Integer taskCount = 0;
        Integer eventCount = 0;
        taskCount = [SELECT count() FROM Task WHERE Subject != Null AND CreatedDate = LAST_WEEK AND (Owner.Name = 'Josh Evink' OR Owner.Name = 'Joe Rizzo' OR Owner.Name = 'Raymond Kangas' OR Owner.Name = 'Jesse Hanson')];
        eventCount = [SELECT count() FROM Event WHERE Subject != Null AND CreatedDate = LAST_WEEK AND (Owner.Name = 'Josh Evink' OR Owner.Name = 'Joe Rizzo' OR Owner.Name = 'Raymond Kangas' OR Owner.Name = 'Jesse Hanson')];
        return (taskCount + eventCount);
    }
    public Integer getAllActivities3() {
        
        Integer taskCount = 0;
        Integer eventCount = 0;
        taskCount = [SELECT count() FROM Task WHERE Subject != Null AND CreatedDate = THIS_MONTH AND (Owner.Name = 'Josh Evink' OR Owner.Name = 'Joe Rizzo' OR Owner.Name = 'Raymond Kangas' OR Owner.Name = 'Jesse Hanson')];
        eventCount = [SELECT count() FROM Event WHERE Subject != Null AND CreatedDate = THIS_MONTH AND (Owner.Name = 'Josh Evink' OR Owner.Name = 'Joe Rizzo' OR Owner.Name = 'Raymond Kangas' OR Owner.Name = 'Jesse Hanson')];
        return (taskCount + eventCount);
    }
    public Integer getAllActivities4() {
        
        Integer taskCount = 0;
        Integer eventCount = 0;
        taskCount = [SELECT count() FROM Task WHERE Subject != Null AND CreatedDate = THIS_YEAR AND (Owner.Name = 'Josh Evink' OR Owner.Name = 'Joe Rizzo' OR Owner.Name = 'Raymond Kangas' OR Owner.Name = 'Jesse Hanson')];
        eventCount = [SELECT count() FROM Event WHERE Subject != Null AND CreatedDate = THIS_YEAR AND (Owner.Name = 'Josh Evink' OR Owner.Name = 'Joe Rizzo' OR Owner.Name = 'Raymond Kangas' OR Owner.Name = 'Jesse Hanson')];
        return (taskCount + eventCount);
    }   
    
    
    
    
    public Integer getScenarios1(){
        Integer count = 0;
        count = [SELECT count() FROM Scenario__c where createdDate = THIS_WEEK];
        return count; 
    }
    public Integer getScenarios2(){
        Integer count = 0;
        count = [SELECT count() FROM Scenario__c where createdDate = LAST_WEEK];
        return count; 
    }
    public Integer getScenarios3(){
        Integer count = 0;
        count = [SELECT count() FROM Scenario__c where createdDate = THIS_MONTH];
        return count; 
    }
    public Integer getScenarios4(){
        Integer count = 0;
        count = [SELECT count() FROM Scenario__c where createdDate = THIS_YEAR];
        return count; 
    }   
    
}