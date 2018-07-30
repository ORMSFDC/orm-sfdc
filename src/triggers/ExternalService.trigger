/**
* @description Establishes a trigger framework for the ExternalService__c object.
* Extension of TriggerHandler.class (virtual class) methods occurs in TriggerHandlerExternalService.class
*
* @author Dennis Wilson
* @date 5/8/2018
*
* changelog:
*
*/

trigger ExternalService on ExternalService__c (
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	new TriggerHandlerExternalService().run();
}