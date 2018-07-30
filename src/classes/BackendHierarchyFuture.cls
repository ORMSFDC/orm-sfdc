/** * File Name   : BackendHierarchyFuture.cls
*     Description : Async Class invoked from UserTriggerHandler class to perform DML operation on non-setup objects
*     Created     : 11/06/2017
*     Copyright   :  
*   * @author     : Prsn
* */

global class BackendHierarchyFuture {
    @future
    public static void updateSharingFuture(Set<Id> idSet, String sObjectType) {
        if(sObjectType == 'Loan_New__c') {
            List<Loan_New__c> loanList = [Select Id,Name from Loan_New__c where Id in: idSet];
            update loanList;
        }
        if(sObjectType == 'Scenario__c') {
            List<Scenario__c> scenarioList = [Select Id, Name From Scenario__c Where Id in: idSet];
            update scenarioList;
        }
    }
    @future
    public static void updateDeleteSharingFuture(Set<Id> userIdSet, Set<Id> idSet, String sObjectType) {
        if(sObjectType == 'Loan_New__c') {
            if(userIdSet.size() > 0 ) {
                List<Loan_New__share> loanShareList = [Select Id from Loan_New__share where UserOrGroupId in: userIdSet AND (RowCause = 'Manager__c' OR RowCause = 'Executive__c')];
                delete loanShareList;
            }
            if(idSet.size() > 0) {
                List<Loan_New__c> loanList = [Select Id,Name from Loan_New__c where Id in: idSet];
                update loanList;
            }
        }
        
        if(sObjectType == 'Scenario__c') {
             if(userIdSet.size() > 0 ) {
                List<Scenario__share> scenarioShareList = [Select Id from Scenario__share where UserOrGroupId in: userIdSet AND (RowCause = 'Manager__c' OR RowCause = 'Executive__c')];
                System.debug('scenarioShareList = '+scenarioShareList);
                 delete scenarioShareList;
            }
            if(idSet.size() > 0) {
                List<Scenario__c> scenarioList = [Select Id,Name from Scenario__c where Id in: idSet];
                update scenarioList;
            }
        }
    }
}