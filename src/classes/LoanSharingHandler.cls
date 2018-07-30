/**
 * @description Loan Sharing Handler - Async class for calling existing ORM methods
 * @author Mike Gill
 * @date 21st June 2018
 */
public without sharing class LoanSharingHandler {

    /**
    * @description Run existing code ASYNC
    * @param newLoanMap JSON String
    * @param oldLoanMap JSON String
    */
    @future
    public static void updateLoanSharing(String newLoanJSON, String oldLoanJSON) {
        Logger.push('updateLoanSharing', 'LoanSharingHandler');

        Map<Id, sObject> newMap = (Map<Id, sObject>) JSON.deserialize(newLoanJSON, Map<Id, sObject>.class);
        Map<Id, sObject> oldMap = (Map<Id, sObject>) JSON.deserialize(oldLoanJSON, Map<Id, sObject>.class);

        List<Loan_New__c > newLoanList = (List<Loan_New__c>)newMap.values();
        List<Loan_New__c > oldLoanList = (List<Loan_New__c>)oldMap.values();
        Map<Id, Loan_New__c> newLoanMap = new Map<Id, Loan_New__c>(newLoanList);
        Map<Id, Loan_New__c> oldLoanMap = new Map<Id, Loan_New__c>(oldLoanList);


        for (Loan_New__c l: newLoanList){

            if (!l.LoanCompleteFlag__c){
                Logger.debug('QA Running SAL_ApexManagedSharingController.ShareLoanRecord!');
                SAL_ApexManagedSharingController.ShareLoanRecord(oldLoanMap.get(l.Id),l); // Calling existing method
            }

            if  (l.LoanCompleteFlag__c && !oldLoanMap.get(l.Id).LoanCompleteFlag__c && ( oldLoanMap.get(l.Id).OwnerId!= l.OwnerId) ){
                Logger.debug('QA Running SAL_ApexManagedSharingController.UpdateOwnerAfterLoanSubmit!');
                SAL_ApexManagedSharingController.UpdateOwnerAfterLoanSubmit(l.Id,oldLoanMap.get(l.Id),l); // Calling existing method
            }

        }

        Logger.debug('QA Running TriggerLoanStatusTrackHandler.shareLoan!');
        TriggerLoanStatusTrackHandler.shareLoan(newLoanMap); // Call existing method

        Logger.pop();
    }

}