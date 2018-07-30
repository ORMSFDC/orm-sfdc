/**
 * @description LoanStatusHandler
 * @author Mike Gill
 * @date 28th June 2018
 * @changelog 
 * 07/18/18 MG/QDA Add new Status Picklist field to aid Executive Reporting filtering SFDC-103
 *
 */
public without sharing class LoanStatusHandler {


    public static void trackLoanStatus(Map<Id, Loan_New__c> newMap, Map<Id, Loan_New__c> oldMap ){
        Logger.push('TrackLoanStatus','LoanStatusHandler');

            List<LoanStatus__c> loanStatusRecords = new List<LoanStatus__c>();

            for (Loan_New__c l : newMap.values()){

                // If loan status is changing

                if (l.LoanStatus__c != oldMap.get(l.Id).LoanStatus__c){
            
                    //Logger.debug('Loan Status has changed, tracking changes...');
                    LoanStatus__c loanStatusRecord = new LoanStatus__c();
                    loanStatusRecord.Name = l.LoanStatus__c;
                    loanStatusRecord.Status__c = l.LoanStatus__c;
                    loanStatusRecord.LoanId__c = l.Id;
                    loanStatusRecord.PreviousStatus__c=oldMap.get(l.Id).LoanStatus__c;
                    loanStatusRecords.add(loanStatusRecord);

                }

            }

            try{
                insert loanStatusRecords;
            } catch (Exception ex){
                Logger.debugException(ex);
            }

        Logger.pop();
    }



}