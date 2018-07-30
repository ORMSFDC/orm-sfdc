/**
 * @description Loan Update Partner Fields Handler - Async class for calling existing ORM methods
 * @author Mike Gill
 * @date 21st June 2018
 */
public without sharing class LoanUpdatePartnerFieldsHandler {


    /**
     * @description Run existing code ASYNC
     * @param newLoanMap JSON String
     * @param oldLoanMap JSON String
     */
    @future
    public static void updatePartnerFields(String newLoanJSON, String oldLoanJSON) {
        Logger.push('updatePartnerFields', 'LoanUpdatePartnerFieldsHandler');


        Map<Id, sObject> newMap = (Map<Id, sObject>) JSON.deserialize(newLoanJSON, Map<Id, sObject>.class);
        if (oldLoanJSON!=null){
            Map<Id, sObject> oldMap = (Map<Id, sObject>) JSON.deserialize(oldLoanJSON, Map<Id, sObject>.class);
        }

        List<Loan_New__c > newLoanList = (List<Loan_New__c>) newMap.values();
        Map<Id, Loan_New__c> newLoanMap = new Map<Id, Loan_New__c>(newLoanList);

        Logger.debug('QA Running TriggerLoanStatusTrackHandler.updatePartnerFields!');
        TriggerLoanStatusTrackHandler.updatePartnerFields(newLoanMap);

        Logger.pop();
    }


}