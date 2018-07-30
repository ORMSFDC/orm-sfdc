/** * File Name   : scenarioPackageTrigger.apxt
*     Description : Calling ScenarioPackageTriggerHandler to update Account fields in backend
*     Created     : 11/23/2017
*   * @author     : prsn
* */
trigger scenarioPackageTrigger on ClientInfo__c (after insert,after update, before delete, after undelete) {
    
    try{
        if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert || trigger.isUndelete)) {
            ScenarioPackageTriggerHandler.updateScenarioPackagePartnerFields(trigger.newMap);
        } 
        if(trigger.isBefore && trigger.isDelete) {
            ScenarioPackageTriggerHandler.updateScenarioPackagePartnerFields(trigger.oldMap);
        }
        
    } catch(Exception Ex) {
        System.debug('Exception Occured'+Ex);
    }
    
}