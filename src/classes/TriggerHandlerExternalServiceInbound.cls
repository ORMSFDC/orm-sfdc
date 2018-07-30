/**
* @description TriggerHandlerExternalServiceInbound is the overall trigger handler for ExternalServiceInbound.trigger
* Implements and extends interface defined in TriggerHandler.class.
* See specific method descriptions for functionality.
* Custom Metadata Type records (TriggerExternalServiceInbound__mdt) control method functionality.
*
* @author Dennis Wilson
* @date 5/11/2018
*
* changelog:
*
*/
public without sharing class TriggerHandlerExternalServiceInbound extends TriggerHandler {

	/*******************************************************************************************************
	* @description custom metadata types enable/disable methods
	*/
	@testVisible
	private static Map<String, TriggerExternalServiceInbound__mdt> tesiControlMap {
		get {
			if ( tesiControlMap == NULL ) {
				tesiControlMap = new Map<String, TriggerExternalServiceInbound__mdt>();
				for ( TriggerExternalServiceInbound__mdt tesiControl : [SELECT MasterLabel, Enable__c FROM TriggerExternalServiceInbound__mdt] ) {
					tesiControlMap.put( tesiControl.MasterLabel, tesiControl );
				}
			}
			return tesiControlMap;
		}
		set;
	}

	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private Boolean testException = FALSE;

	public TriggerHandlerExternalServiceInbound() {

//		System.debug( '>>> tesiControlMap: ' + tesiControlMap );
	}

	/* context overrides */

	public override void afterInsert() {
		if ( tesiControlMap.get( 'processEvents' ) != NULL ) {
			if ( tesiControlMap.get( 'processEvents' ).Enable__c ) processEvents( Trigger.new );
		}
	}

	/* private methods */

	/*******************************************************************************************************
	* @description processes an ExternalServiceInbound__e event published to Platform Events Bus
	* @param newExternalServiceList list of ExternalServiceInbound__e events to process
	*/
	private void processEvents( List<ExternalServiceInbound__e> newESIlist ) {

		// gather up ExternalService__c Ids from inbound events
		Set<Id> esIdSet = new Set<Id>();
		for ( ExternalServiceInbound__e esi : newESIlist ) {
			String esId = ExternalServiceDispatcher.getPayloadReference( esi.Payload__c );
			System.debug( '>>> TriggerHandlerExternalServiceInbound.processEvents.esi.Payload__c: ' + esi.Payload__c );
			System.debug( '>>> TriggerHandlerExternalServiceInbound.processEvents.esId: ' + esId );
			if ( String.isNotBlank( esId ) && esId instanceof Id ) {
				esIdSet.add( esId );
			}
		}
		// create map of ExternalService__c records to update
		Map<Id, ExternalService__c> updateESIdMap = new Map<Id, ExternalService__c>( [
			SELECT Id, Status__c
			FROM ExternalService__c
			WHERE Id IN :esIdSet
		] );
		if ( !updateESIdMap.isEmpty() ) {
			System.debug( '>>> TriggerHandlerExternalServiceInbound.processEvents:  updating ESI...' );
			for ( ExternalServiceInbound__e esi : newESIlist ) {
				Id esId = ExternalServiceDispatcher.getPayloadReference( esi.Payload__c );
				if ( esId != NULL ) {
					ExternalService__c updateES = updateESIdMap.get( esId );
					updateES.Status__c = 'Response Received';
					updateES.ResponsePayload__c = esi.Payload__c;
				}
			}
			Database.update( updateESIdMap.values() );
		}
	}
}