/**
* @description Establishes a trigger framework for the ExternalServiceOutbound__e object
* Extension of TriggerHandler.class (virtual class) methods occurs in TriggerHandlerExternalServices.class
*
* @author Dennis Wilson
* @date 5/8/2018
*
* changelog:
*
*/

trigger ExternalServiceOutbound on ExternalServiceOutbound__e ( after insert ) {

	new TriggerHandlerExternalServiceOutbound().run();
}