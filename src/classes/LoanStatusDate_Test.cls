@isTest
private class LoanStatusDate_Test{

    @isTest
    static void loanDateTest(){
 
        Loan_New__c loanStatus1 = new Loan_New__c(
            LoanStatus__c = 'Proposal'
        );         
        insert loanStatus1;
        
        Loan_New__c loanStatus2 = new Loan_New__c(
            LoanStatus__c = 'Waiting for Full Package',LoanNumber__c = '12345990', Id=loanStatus1.Id
        );                
        loanStatus1.LoanStatus__c = 'Waiting for Full Package';
        update loanStatus2;
                
        Loan_New__c loanStatus3 = new Loan_New__c(
            LoanStatus__c = 'Full Application Received - Incomplete',LoanNumber__c = '12345991', Id=loanStatus2.Id
        );                     
        loanStatus2.LoanStatus__c = 'Full Application Received - Incomplete';   
        update loanStatus3;

        Loan_New__c loanStatus4 = new Loan_New__c(
            LoanStatus__c = 'Application Package Received',LoanNumber__c = '12345992', Id=loanStatus3.Id
        );                     
        loanStatus3.LoanStatus__c = 'Application Package Received';   
        update loanStatus4;

        Loan_New__c loanStatus5 = new Loan_New__c(
            LoanStatus__c = 'In Processing',LoanNumber__c = '12345993', Id=loanStatus4.Id
        );                     
        loanStatus4.LoanStatus__c = 'In Processing';   
        update loanStatus5;

        Loan_New__c loanStatus6 = new Loan_New__c(
            LoanStatus__c = 'In final HUD Review',LoanNumber__c = '12345994', Id=loanStatus5.Id
        );                     
        loanStatus5.LoanStatus__c = 'In final HUD Review';   
        update loanStatus6;

        Loan_New__c loanStatus7 = new Loan_New__c(
            LoanStatus__c = 'Docs Out to Settlement Agent',LoanNumber__c = '12345994', Id=loanStatus6.Id
        );                     
        loanStatus6.LoanStatus__c = 'Docs Out to Settlement Agent';   
        update loanStatus7;

        Loan_New__c loanStatus8 = new Loan_New__c(
            LoanStatus__c = 'Closed - Awaiting Funding',LoanNumber__c = '12345994', Id=loanStatus7.Id
        );                     
        loanStatus7.LoanStatus__c = 'Closed - Awaiting Funding';   
        update loanStatus8;

        Loan_New__c loanStatus9 = new Loan_New__c(
            LoanStatus__c = 'Funded',LoanNumber__c = '12345994', Id=loanStatus8.Id
        );                     
        loanStatus8.LoanStatus__c = 'Funded';   
        update loanStatus9;

        Loan_New__c loanStatus10 = new Loan_New__c(
            LoanStatus__c = 'Funded',LoanNumber__c = '12345994', Id=loanStatus9.Id
        );                     
        loanStatus9.LoanStatus__c = 'Funded';   
        update loanStatus10;

        Loan_New__c loanStatus11 = new Loan_New__c(
            LoanStatus__c = 'Loan Rescinded',LoanNumber__c = '12345994', Id=loanStatus10.Id
        );                     
        loanStatus10.LoanStatus__c = 'Loan Rescinded';   
        update loanStatus11;

        Loan_New__c loanStatus12 = new Loan_New__c(
            LoanStatus__c = 'Application Approved but Not Accepted',LoanNumber__c = '12345994', Id=loanStatus11.Id
        );                     
        loanStatus11.LoanStatus__c = 'Application Approved but Not Accepted';   
        update loanStatus12;

        Loan_New__c loanStatus13 = new Loan_New__c(
            LoanStatus__c = 'File Closed for Incompleteness',LoanNumber__c = '12345994', Id=loanStatus12.Id
        );                     
        loanStatus12.LoanStatus__c = 'File Closed for Incompleteness';   
        update loanStatus13;

        Loan_New__c loanStatus14 = new Loan_New__c(
            LoanStatus__c = 'Suspended',LoanNumber__c = '12345994', Id=loanStatus13.Id
        );                     
        loanStatus13.LoanStatus__c = 'Suspended';   
        update loanStatus14;

        Loan_New__c loanStatus15 = new Loan_New__c(
            LoanStatus__c = 'Withdrawn',LoanNumber__c = '123459946',  Withdrawn_Reason__c = 'Client not Interested', 
            How_was_the_Withdrawn_status_captured__c = 'ORMS Partner', Who_Requested_the_Withdraw__c = 'test'
        );                     
        loanStatus1.LoanStatus__c = 'Withdrawn';   
        loanStatus1.Withdrawn_Reason__c = 'Client not Interested';  
        loanStatus1.How_was_the_Withdrawn_status_captured__c = 'ORMS Partner';
        loanStatus1.Who_Requested_the_Withdraw__c = 'test';
        insert loanStatus15;

        Loan_New__c loanStatus16 = new Loan_New__c(
            LoanStatus__c = 'Proposal',LoanNumber__c = '1234599456', Id=loanStatus15.Id
        );                     
        loanStatus15.LoanStatus__c = 'Proposal';   
        update loanStatus16;

        Test.startTest();
            LoanStatusDate.updateDates(loanStatus1, loanStatus2);
            LoanStatusDate.updateDates(loanStatus1, loanStatus3);
            LoanStatusDate.updateDates(loanStatus1, loanStatus4);
            LoanStatusDate.updateDates(loanStatus1, loanStatus5);
            LoanStatusDate.updateDates(loanStatus1, loanStatus6);
            LoanStatusDate.updateDates(loanStatus1, loanStatus7);
            LoanStatusDate.updateDates(loanStatus1, loanStatus8);
            LoanStatusDate.updateDates(loanStatus1, loanStatus9);
            LoanStatusDate.updateDates(loanStatus1, loanStatus10);
            LoanStatusDate.updateDates(loanStatus1, loanStatus11);
            LoanStatusDate.updateDates(loanStatus1, loanStatus12);
            LoanStatusDate.updateDates(loanStatus1, loanStatus13);
            LoanStatusDate.updateDates(loanStatus1, loanStatus14);
            LoanStatusDate.updateDates(loanStatus1, loanStatus15);
            LoanStatusDate.updateDates(loanStatus15, loanStatus16);
        Test.stopTest();
    }
}