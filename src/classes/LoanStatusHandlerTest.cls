/**
 * @description Apex Tests for LoanStatusHandler
 * @author Mike Gill
 * @date 28th June 2018
 *
 */

@isTest (SeeAllData=false)
private class LoanStatusHandlerTest {

    @testSetup
    static void testSetupData(){

        // Insert Skinny Loan record for testing
        Loan_New__c loan = new Loan_New__c(
                    IsActiveFlag__c= true,
                    LoanCompleteFlag__c= true,
                    LoanStatus__c ='Funded',
                    LoanNumber__c = '12345',
                    Appraisal_Received_Date__c=Date.parse('10/11/2017')
        );
        insert loan;
    }

    @isTest static void testLoanStatusHistory(){

        List<Loan_New__c> testLoans = [SELECT Id,LoanStatus__c FROM Loan_New__c];
        System.assertEquals(testLoans.size(), 1);
        List<Loan_New__c> loanUpdates = new List<Loan_New__c>();

        Test.startTest();
        for (Loan_New__c l: testLoans){
            l.LoanStatus__c = 'Incomplete';
            loanUpdates.add(l);
        }
        update loanUpdates;

        Test.stopTest();
        List<LoanStatus__c> loanStatusHistory = [SELECT Id FROM LoanStatus__c];
        System.assertEquals(loanStatusHistory.size(), 1);

    }


}