/**
* @description TriggerHandlerExternalService is the overall trigger handler for ExternalService.trigger
* Implements and extends interface defined in TriggerHandler.class.
* See specific method descriptions for functionality.
* Custom Metadata Type records (TriggerExternalService__mdt) control method functionality.
*
* @author Dennis Wilson
* @date 5/9/2018
*
* changelog:
*
*/
public without sharing class TriggerHandlerExternalService extends TriggerHandler {

	/*******************************************************************************************************
	* @description custom metadata types enable/disable methods
	*/
	@testVisible
	private static Map<String, TriggerExternalService__mdt> tesControlMap {
		get {
			if ( tesControlMap == NULL ) {
				tesControlMap = new Map<String, TriggerExternalService__mdt>();
				for ( TriggerExternalService__mdt tesControl : [SELECT MasterLabel, Enable__c FROM TriggerExternalService__mdt] ) {
					tesControlMap.put( tesControl.MasterLabel, tesControl );
				}
			}
			return tesControlMap;
		}
		set;
	}
	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private Boolean testException = FALSE;

	public TriggerHandlerExternalService() {

//		System.debug( '>>> tesControlMap: ' + tesControlMap );
	}

	/* context overrides */

	public override void beforeInsert() {}

	public override void beforeUpdate() {}

	public override void beforeDelete() {}

	public override void afterInsert() {
		if ( tesControlMap.get( 'publishEvents' ) != NULL ) {
			if ( tesControlMap.get( 'publishEvents' ).Enable__c ) publishEvents( Trigger.new );
		}
	}

	public override void afterUpdate() {}

	public override void afterDelete() {}

	public override void afterUndelete() {}

	/* private methods */


	/*******************************************************************************************************
	* @description publishes ExternalService__e events to Platform Events Bus
	* @param newSOList list of ExternalService__c (SObject) records to process
	*/
	private void publishEvents( List<SObject> newSOList ) {

		System.debug( '>>> executing TriggerHandlerExternalService.publishEvent() method...' );

		// need to update these ExternalService__c records, so re-query
		Map<Id, ExternalService__c> newExternalServiceMap = new Map<Id,ExternalService__c> ( [
			SELECT Id, Status__c, RequestPayload__c, ServiceName__c
			FROM ExternalService__c
			WHERE Id IN :newSOList
		] );
		// list of ExternalServiceOutbound__e events to publish
		List<ExternalServiceOutbound__e> publishExternalServiceEventList = new List<ExternalServiceOutbound__e>();
		// publish event for each external service in scope
		for ( ExternalService__c extSrvc : newExternalServiceMap.values() ) {
			// create platform event
			ExternalServiceOutbound__e newESOevent = new ExternalServiceOutbound__e(
				ExternalServiceID__c = extSrvc.Id,
				Payload__c = ExternalServiceDispatcher.fixPayloadReference( extSrvc.RequestPayload__c, extSrvc.Id ),
				ServiceName__c = extSrvc.ServiceName__c
			);
			System.debug( '>>> TriggerHandlerExternalService.publishEvents.newESOevent.Payload__c: ' + newESOevent.Payload__c );
			publishExternalServiceEventList.add( newESOevent );
		}
		// publish events and update ExternalService__c records
		// there is no way to bulkify the publishing of events, inspect results and update ExternalService__c records
		// this is because events cannot be queried after publishing
		// the only attribute available after publishing is Id returned from SaveResult.getId()
		// so there is not enough information to trace back to ExternalService__c records
		// (i.e. chicken/egg problem)
		// so for now, using non-bulkified publishing loop in order to "know" which ExternalServiceOutbound__e succeeds or fails
		for ( ExternalServiceOutbound__e eso : publishExternalServiceEventList ) {
			// publish this event
			Database.SaveResult publishSR = EventBus.publish( eso );
			// check for errors
			if ( publishSR.isSuccess() ) {
				// update ExternalService__c status to reflect success
				newExternalServiceMap.get( eso.ExternalServiceID__c ).Status__c = 'Requested';
				System.debug( 'Successfully published event: ' + publishSR.getId() );
			} else {
				// update status to reflect failure
				newExternalServiceMap.get( eso.ExternalServiceID__c ).Status__c = 'Error/Exception';
				for ( Database.Error error : publishSR.getErrors() ) {
					System.debug( 'Error returned: ' + error.getStatusCode() + ' - ' + error.getMessage());
				}
			}
		}
/*
		List<Database.SaveResult> publishResults;
		if ( !publishExternalServiceEventList.isEmpty() ) {
			publishResults = EventBus.publish( publishExternalServiceEventList );
			// check each result for any errors
			for ( Database.SaveResult sr : publishResults ) {
				if ( sr.isSuccess() ) {
					System.debug( 'Successfully published event: ' + sr.getId() );
					// todo: update appropriate ExternalService__c.Status__c
					// change status of ExternalService__c
					extSrvc.Status__c = 'Requested';
					updateExternalServiceList.add( extSrvc );

				} else {
					for ( Database.Error error : sr.getErrors() ) {

					}
				}
			}
		}
*/
		Database.update( newExternalServiceMap.values() );
	}
}