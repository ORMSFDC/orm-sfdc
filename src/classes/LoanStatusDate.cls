/**
* @description: LoanStatusDate class captures all the status dates when loan status
*               is updated
* @author Sahitya
* @date 6/28/2019
*
*/
public class LoanStatusDate{

    public static void loanDate(Map<Id, Loan_New__c> oldLoanMap, List<Loan_New__c> newLoans){
        Logger.push('loanDate','LoanStatusDate');        
        for(Loan_New__c newLoan : newLoans)
        {
            Loan_New__c oldLoan = oldLoanMap.get(newLoan.Id);
            updateDates(newLoan, oldLoan);            
        }                    
        Logger.pop();
    }

    public static void updateDates(Loan_New__c newLoan, Loan_New__c oldLoan){
        Logger.push('loanDate','LoanStatusDate');
        String newloanStatus = newLoan.loanstatus__c;

        if(newloanStatus == 'Proposal'){
           newLoan.Loan_Status_Change_Date__c = DateTime.now();
           newLoan.App_Requested_Date__c = DateTime.now();                
        }
        if(newloanStatus == 'Waiting for Full Package'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Waiting_for_Full_Package_Date0__c = DateTime.now();
        }
        if(newloanStatus == 'Application Package Received'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Submitted_to_Lender_Date__c  = DateTime.now();
        }
        if(newloanStatus == 'Loan Submission Received- Awaiting Review'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Loan_Received_Awaiting_Review__c = DateTime.now();
        }
        if(newloanStatus == 'Full Application Received - Incomplete'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Loan_Submitted_Incomplete__c  = DateTime.now();
        }
        if(newloanStatus == 'In Processing'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.In_Processing_Date0__c  = DateTime.now();
        }
        //Logic in PB
       /* if(newloanStatus == 'In Underwriting Review'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.In_Underwriting_Review_Date__c  = DateTime.now();
        }*/
        if(newloanStatus == 'Conditionally Approved'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Conditionally_Approved_Date0__c  = DateTime.now();
        }
        if(newloanStatus == 'Underwriting Clear to Close'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Clear_to_Close_Date__c  = DateTime.now();
        }
        if(newloanStatus == 'In final HUD Review'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.In_final_HUD_Review_Date__c  = DateTime.now();
        }
        if(newloanStatus == 'Docs Out to Settlement Agent'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Docs_Out_to_Settlement_Agent_Date__c  = DateTime.now();
        }
        if(newloanStatus == 'Closed - Awaiting Funding'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Closed_Awaiting_Funding_Date0__c  = DateTime.now();
        }
        if(newloanStatus == 'Funded'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Loan_Funded_Date__c  = DateTime.now();
        }        
        if(newloanStatus == 'Loan Rescinded'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Loan_Rescinded_Date__c  = DateTime.now();
        }
        if(newloanStatus == 'Application Approved but Not Accepted'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Application_Approved_Not_Accepted_Date__c  = DateTime.now();
        }
        if(newloanStatus == 'File Closed for Incompleteness'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.File_Closed_for_Incompleteness_Date__c  = DateTime.now();
        }
        if(newloanStatus == 'Suspended'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Suspended_Date0__c  = DateTime.now();
        }
        if(newloanStatus == 'Withdrawn'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Withdrawn_Date0__c  = DateTime.now();
        }
        if(newloanStatus == 'Denied'){
            newLoan.Loan_Status_Change_Date__c = DateTime.now();
            newLoan.Denied_Date0__c  = DateTime.now();
        }
        Logger.pop();
    }
}