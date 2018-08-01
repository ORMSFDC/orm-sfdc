/**
* @description TriggerHandlerLoan is the overall trigger handler for Loan.trigger
* Implements and extends interface defined in TriggerHandler.class.
* See specific method descriptions for functionality.
* Custom Metadata Type records (TriggerLoan__mdt) control method functionality.
*
* @author Mike Gill
* @date 6/19/2018
*
* changelog:
* QDA/MG 07/03/2018 Added Context Check isBatch
*
*/
public without sharing class TriggerHandlerLoan extends TriggerHandler {


    /**
    * @description custom metadata types enable/disable methods
    */
    @testVisible
    private static Map<String, TriggerLoan__mdt> testControlMap {
        get {
            if (testControlMap == NULL) {
                testControlMap = new Map<String, TriggerLoan__mdt>();
                for (TriggerLoan__mdt tesControl : [SELECT MasterLabel, Enable__c FROM TriggerLoan__mdt]) {
                    testControlMap.put(tesControl.MasterLabel, tesControl);
                }
            }
            return testControlMap;
        }
        set;
    }

    /**
     * @description After Update dispatcher method - used to sequence call domain/service class handler
     */
    public override void afterInsert() {
        Logger.push('afterInsert', 'TriggerHandlerLoan');

        // Run Loan Update Partner Fields

        if (testControlMap.get('updatePartnerFields') != NULL) {


            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('updatePartnerFields').Enable__c) {

                String jsonNewMap = JSON.serialize((Map<Id, sObject>) Trigger.newMap);
                Logger.debug('afterInsert is firing');
                LoanUpdatePartnerFieldsHandler.updatePartnerFields(jsonNewMap, null);

                Logger.debug('QA Called LoanUpdatePartnerFieldsHandler Future from afterInsert');

            }

        }
        Logger.pop();
    }

    public override void afterUndelete() {
        // Do nothing - Recommend this as no loans should be deleted and therefore this would not be fired
    }

    /**
     * @description After Update dispatcher method - used to sequence call domain/service class handler
     */
    public override void afterUpdate() {
        Logger.push('afterUpdate', 'TriggerHandlerLoan');


        // Run Loan Status Tracking Hanlder
        if (testControlMap.get('trackLoanStatus') != NULL) {

            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('trackLoanStatus').Enable__c) {
                // Track loan status 
                LoanStatusHandler.trackLoanStatus((Map<Id, Loan_New__c>) Trigger.newMap, (Map<Id, Loan_New__c>) Trigger.oldMap);
            
            }

        }

        // Run Loan Update Partner Fields
        if (testControlMap.get('updatePartnerFields') != NULL) {


            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('updatePartnerFields').Enable__c) {

                String jsonNewMap = JSON.serialize((Map<Id, sObject>) Trigger.newMap);
                String jsonOldMap = JSON.serialize((Map<Id, sObject>) Trigger.oldMap);
                
                // Skip this call when Loan is updated via DeactivatePipelineLoan batch (change of loan status to withdraw)
                if (!System.isBatch()){
                    LoanUpdatePartnerFieldsHandler.updatePartnerFields(jsonNewMap, jsonOldMap); // Call future context safely   
                    //Logger.debug('QA Called LoanUpdatePartnerFieldsHandler Future');
                }
               
            }

        }

        // Run Loan Update Partner Fields
        if (testControlMap.get('updateLoanSharing') != NULL) {


            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('updateLoanSharing').Enable__c) {

                String jsonNewMap = JSON.serialize((Map<Id, sObject>) Trigger.newMap);
                String jsonOldMap = JSON.serialize((Map<Id, sObject>) Trigger.oldMap);
                
                // Skip this call when Loan is updated via DeactivatePipelineLoan batch (change of loan status to withdraw)
                if (!System.isBatch()){
                    LoanSharingHandler.updateLoanSharing(jsonNewMap, jsonOldMap);
                    //Logger.debug('QA Called LoanStatusHandler Future');
                }
            
            }

        }


        RecursiveTriggerHandler.isFirstTime = false;
        Logger.pop();

    }


}