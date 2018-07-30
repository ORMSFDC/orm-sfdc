/** * File Name   : userTrigger.apxt
*     Description : trigger invoked whenever a User record is Created/Edited
*     Created     : 11/06/2017
*     Copyright   :  
*   * @author     : Prsn
* */

trigger userTrigger on User (After insert, After update) {
    if(trigger.isInsert && trigger.isAfter) {
   
        UserTriggerHandler.handleAfterInsert(trigger.newMap);
         
    }
    if(trigger.isUpdate && trigger.isAfter) {
        UserTriggerHandler.handleAfterUpdate(trigger.newMap,trigger.oldMap);
    }
}