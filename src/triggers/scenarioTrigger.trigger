/** * File Name   : scenarioTrigger.apxt
*     Description : Calling ScenarioTriggerHandler to share scenarios and also to update Account fields in backend
*     Created     : 11/18/2017
*   * @author     : prsn
* */
trigger scenarioTrigger on Scenario__c (after insert,after update, before delete, after undelete) {
    
if(![select id,Entity__r.DeveloperName ,Skip_Trigger_Execution__c from Trigger_Handler__mdt where Entity__r.DeveloperName ='Scenario'].Skip_Trigger_Execution__c )
  {
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert) ) {
        ScenarioTriggerHandler.afterHandler(trigger.oldMap,trigger.newMap);
    }
    
    // updating the Scenario fields in BusinessPartner
    
    try{
        if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert || trigger.isUndelete)){
            ScenarioTriggerHandler.updateScenarioPartnerFields(trigger.newMap);
        } 
        if(trigger.isBefore && trigger.isDelete) {
            System.debug('In Delete Trigger Event');
            ScenarioTriggerHandler.updateScenarioPartnerFields(trigger.oldMap);
        }
        
    }catch(Exception ex){
        system.debug('TriggerLoanStatusTrack--Exception2---'+ex);
    }
    
    // 
    if(trigger.isAfter && trigger.isUpdate){
    updateCountonAccount.countUpdate(trigger.old,trigger.new);
    }
    
    }
}