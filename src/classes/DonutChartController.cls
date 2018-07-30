/**
*    File Name: DonutChartController.apxc
*    Description: Controller to Display count of LoanStatus on PieChart for loggedin users
*    Author: Bala Sahitya 
*    Modified By: 
***/

public class DonutChartController {
    public List<PieWedgeData> getPieData() {
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        Integer ConApp = 0, InProcess = 0, Apprec = 0, Uwcc = 0, susp=0, awaiting= 0, closedawaiting = 0;  
                      
        ConApp = [Select Count() from Loan_New__c where LoanStatus__c = 'Conditionally Approved' AND PCS_at_Loan_Level__r.Id =: userId];
        InProcess = [Select Count() from Loan_New__c where Loanstatus__c = 'In Processing' AND PCS_at_Loan_Level__r.Id =: userId];     
        Apprec = [Select Count() from Loan_New__c where Loanstatus__c = 'Application Package Received' AND PCS_at_Loan_Level__r.Id =: userId];     
        Uwcc = [Select Count() from Loan_New__c where Loanstatus__c = 'Underwriting Clear to Close' AND PCS_at_Loan_Level__r.Id =: userId];     
        susp = [Select Count() from Loan_New__c where Loanstatus__c = 'Suspended' AND PCS_at_Loan_Level__r.Id =: userId];     
        awaiting = [Select Count() from Loan_New__c where Loanstatus__c = 'Awaiting Closing' AND PCS_at_Loan_Level__r.Id =: userId];     
        closedawaiting = [Select Count() from Loan_New__c where Loanstatus__c = 'Closed - Awaiting Funding' AND PCS_at_Loan_Level__r.Id =: userId];      
        
        List<PieWedgeData> data = new List<PieWedgeData>();        
            data.add(new PieWedgeData('Conditionally Approved', ConApp));
            data.add(new PieWedgeData('In Processing', InProcess));
            data.add(new PieWedgeData('App Package Received', Apprec ));
            data.add(new PieWedgeData('UW Clear to Close', Uwcc ));
            data.add(new PieWedgeData('Suspended', susp ));
            data.add(new PieWedgeData('Awaiting Closing', awaiting ));        
            data.add(new PieWedgeData('Closed - Awaiting Funding', awaiting ));                    
        return data;        
    }
    // Wrapper class
    public class PieWedgeData {

        public String loanStatus{ get; set; }
        public Integer loanCount { get; set; }        
        public PieWedgeData(String loanStatus, Integer loanCount) {            
            this.loanStatus = loanStatus + ' [' + loancount + ']';
            this.loanCount = loanCount;            
        }
    }
}