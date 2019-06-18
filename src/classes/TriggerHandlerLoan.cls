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
        system.debug('----------TriggerHandlerLoan afterInsert--------------');
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
        system.debug('----------TriggerHandlerLoan afterUpdate--------------');

        List<Loan_New__c> loanList;
        Set<Id> changeStatusIdSet;
        system.debug('RecursiveTriggerHandler.isFirstTimeCopy-------'+RecursiveTriggerHandler.isFirstTimeCopy);
        if (RecursiveTriggerHandler.isFirstTimeCopy) {
            loanList = new List<Loan_New__c>();
            changeStatusIdSet = new Set<Id>();
            Set<String> statusSet =  new Set<String>{'Waiting for Full Package', 'Application Package Received', 'Loan Submission Received- Awaiting Review', 'Docs Out to Settlement Agent'};
            Map<Id, Loan_New__c> newMap = new Map<Id, Loan_New__c>();
            newMap = (Map<Id, Loan_New__c>)Trigger.newMap;
            Map<Id, Loan_New__c> oldMap = new Map<Id, Loan_New__c>();
            oldMap = (Map<Id, Loan_New__c>)Trigger.oldMap;
            
            Loan_New__c ln = (Loan_New__c)Trigger.new[0];
            Loan_New__c lo = (Loan_New__c)Trigger.old[0];
            Loan_New__c ln1 = (Loan_New__c)Trigger.newMap.values()[0];
            Loan_New__c lo2 = (Loan_New__c)Trigger.oldMap.values()[0];
            system.debug('in loanHandler new------'+ln.LoanStatus__c);
            system.debug('in loanHandler old------'+lo.LoanStatus__c);
            system.debug('in loanHandler new------'+ln1.LoanStatus__c);
            system.debug('in loanHandler old------'+lo2.LoanStatus__c);
            
            
            for(Loan_New__c newLoan :(List<Loan_New__c>)Trigger.new){
                Loan_New__c oldLoan = oldMap.get(newLoan.Id);
                system.debug('newLoan.LoanStatus__c------'+newLoan.LoanStatus__c);
                system.debug('oldLoan.LoanStatus__c------'+oldLoan.LoanStatus__c);
                
                if(newLoan.LoanStatus__c != oldLoan.LoanStatus__c && statusSet.contains(newLoan.LoanStatus__c)){
                system.debug('in------');
                   // changeStatusIdSet.add(newLoan.id);
                    OnBaseLookups.sendKeywords((List<Loan_New__c>)Trigger.new);
                }
            }
            //system.debug('changeStatusIdSet-111-----'+changeStatusIdSet);
            RecursiveTriggerHandler.isFirstTimeCopy = false;
        }


        // Run Loan Status Tracking Hanlder
        if (testControlMap.get('trackLoanStatus') != NULL) {
			system.debug('trackLoanStatus1-----------------');
            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('trackLoanStatus').Enable__c) {

                LoanStatusHandler.trackLoanStatus((Map<Id, Loan_New__c>) Trigger.newMap, (Map<Id, Loan_New__c>) Trigger.oldMap);

                Logger.debug('QA Called LoanStatusHandler Future');
            }
        }

        // Run Loan Update Partner Fields
        if (testControlMap.get('updatePartnerFields') != NULL) {

            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('updatePartnerFields').Enable__c) {
				system.debug('updatePartnerFields2-----------------');
                String jsonNewMap = JSON.serialize((Map<Id, sObject>) Trigger.newMap);
                String jsonOldMap = JSON.serialize((Map<Id, sObject>) Trigger.oldMap);

                if (!System.isBatch()){ 
                     LoanUpdatePartnerFieldsHandler.updatePartnerFields(jsonNewMap, jsonOldMap); // Call future context safely    
                     Logger.debug('QA Called LoanUpdatePartnerFieldsHandler Future'); 
                } 
            }
        }

        // Run Loan Update Partner Fields
        if (testControlMap.get('updateLoanSharing') != NULL) {
			system.debug('updateLoanSharing3-----------------');
            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('updateLoanSharing').Enable__c) {

                String jsonNewMap = JSON.serialize((Map<Id, sObject>) Trigger.newMap);
                String jsonOldMap = JSON.serialize((Map<Id, sObject>) Trigger.oldMap);

                if (!System.isBatch()){
                    LoanSharingHandler.updateLoanSharing(jsonNewMap, jsonOldMap);
                    Logger.debug('QA Called LoanStatusHandler Future');
                }
            }
        }
        
     
        // Run Loan Update Partner Fields
      /*  if (testControlMap.get('onbaseSendKeywords') != NULL) {
            system.debug('sendKeywords4-----------------');
            //try{
            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('onbaseSendKeywords').Enable__c) {

                String jsonNewMap = JSON.serialize((Map<Id, sObject>) Trigger.newMap);
                String jsonOldMap = JSON.serialize((Map<Id, sObject>) Trigger.oldMap);
                System.debug('@@jsonnewmap---'+jsonNewMap);
                System.debug('@@jsonoldmap---'+jsonOldMap);

                string newLoanKey = jsonNewMap.substring(jsonNewMap.indexof('Loan_Status_Number__c":')+23,jsonNewMap.indexof('ORMS_AE')-2);
                system.debug('test---->'+newLoanKey);

                string oldLoanKey = jsonOldMap.substring(jsonOldMap.indexof('Loan_Status_Number__c":')+23,jsonOldMap.indexof('ORMS_AE')-2);
                system.debug('test2---->'+oldLoanKey);
                Loan_New__c ln = (Loan_New__c)Trigger.new[0];
                String loanValue = ln.loanstatus__c;

                if(newLoanKey != oldLoanKey && (loanValue != 'Proposal')){  
                    system.debug('--in here--');              
                    OnBaseLookups.sendKeywords((List<Loan_New__c>)Trigger.new);
                } 
            }
            //}catch(exception ex){ System.debug('@@after update error'+ex);}
        }*/
       
        RecursiveTriggerHandler.isFirstTime = false;
        Logger.pop();
    }
    
    public override void beforeUpdate() {
        Logger.push('beforeUpdate', 'TriggerHandlerLoan');
        System.debug('---------TriggerHandlerLoan-beforeUpdate-----------');

        // Validate required OnBase values for final send    
        if (testControlMap.get('onbaseValidateFinal') != NULL) {
            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('onbaseValidateFinal').Enable__c) {
                OnBaseLookups.validateFinalSend((List<Loan_New__c>)Trigger.new);
            }
        }
        
        // Update OnBase values
        if (testControlMap.get('onbaseTriggerFields') != NULL) {
            if (RecursiveTriggerHandler.isFirstTime && testControlMap.get('onbaseTriggerFields').Enable__c) {
                OnBaseLookups.updateFields((Map<Id, Loan_New__c>)Trigger.oldMap, (List<Loan_New__c>)Trigger.new);
            }
        }
        
        Logger.pop();
    }
}