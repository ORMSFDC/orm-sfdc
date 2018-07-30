/**
* @description TriggerHandlerExternalServiceOutbound is the overall trigger handler for ExternalServiceOutbound.trigger
* Implements and extends interface defined in TriggerHandler.class.
* See specific method descriptions for functionality.
* Custom Metadata Type records (TriggerExternalServiceOutbound__mdt) control method functionality.
*
* @author Dennis Wilson
* @date 5/10/2018
*
* changelog:
*
*/
public without sharing class TriggerHandlerExternalServiceOutbound extends TriggerHandler {

	/*******************************************************************************************************
	* @description custom metadata types enable/disable methods
	*/
	@testVisible
	private static Map<String, TriggerExternalServiceOutbound__mdt> tesoControlMap {
		get {
			if ( tesoControlMap == NULL ) {
				tesoControlMap = new Map<String, TriggerExternalServiceOutbound__mdt>();
				for ( TriggerExternalServiceOutbound__mdt tesoControl : [SELECT MasterLabel, Enable__c FROM TriggerExternalServiceOutbound__mdt] ) {
					tesoControlMap.put( tesoControl.MasterLabel, tesoControl );
				}
			}
			return tesoControlMap;
		}
		set;
	}

	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private Boolean testException = FALSE;

	public TriggerHandlerExternalServiceOutbound() {

//		System.debug( '>>> tesoControlMap: ' + tesoControlMap );
	}

	/* context overrides */

	public override void afterInsert() {
		if ( tesoControlMap.get( 'processEvents' ) != NULL ) {
			if ( tesoControlMap.get( 'processEvents' ).Enable__c ) processEvents( Trigger.new );
		}
	}

	/* private methods */

	/*******************************************************************************************************
	* @description processes an ExternalServiceOutbound__e event published to Platform Events Bus
	* @param newExternalServiceList list of ExternalServiceOutbound__e events to process
	*/
	private void processEvents( List<ExternalServiceOutbound__e> newESOlist ) {

		// must serialize ESO objects to pass to future method
		List<String> serialESOlist = new List<String>();
		for ( ExternalServiceOutbound__e eso : newESOlist ) {
			System.debug( '>>> eso.ExternalServiceID__c: ' + eso.ExternalServiceID__c );
			System.debug( '>>> eso.Payload__c: ' + eso.Payload__c );
			System.debug( '>>> eso.ServiceName__c: ' + eso.ServiceName__c );
			System.debug( '>>> eso.ReplayId: ' + eso.ReplayId );
			String serialESO = JSON.serialize( eso );
			serialESOlist.add( serialESO );
		}
		// pass the list to dispatcher for making service callouts
		ExternalServiceDispatcher.processESOlist( serialESOlist );
	}

}