/**
* @description Establishes a trigger framework for the ExternalServiceInbound__e object
* Extension of TriggerHandler.class (virtual class) methods occurs in TriggerHandlerExternalServices.class
*
* @author Dennis Wilson
* @date 5/11/2018
*
* changelog:
*
*/

trigger ExternalServiceInbound on ExternalServiceInbound__e ( after insert ) {

	new TriggerHandlerExternalServiceInbound().run();
}