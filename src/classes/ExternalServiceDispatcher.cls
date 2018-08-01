/**
* @description ExternalServiceDispatcher processes ExternalServiceOutbound__e events by calling out
* to the appropriate external service
*
* @author Dennis Wilson
* @date 5/10/2018
*
* changelog:
* 06/04/2018: DWilson - refactored to define handler interface
*
*/
public without sharing class ExternalServiceDispatcher {

	/*******************************************************************************************************
	* @description custom metadata types for the parameters of external services
	*/
	@TestVisible
	private static Map<String, ExternalServiceRegistry__mdt> esrControlMap {
		get {
			if ( esrControlMap == NULL ) {
				esrControlMap = new Map<String, ExternalServiceRegistry__mdt>();
				for ( ExternalServiceRegistry__mdt esrControl : [
					SELECT
						MasterLabel,
						ExternalServiceDispatcherClass__c,
						NamedCredential__c,
						AuthorizationHeaderToken__c,
						AuthorizationHeaderValue__c
					FROM ExternalServiceRegistry__mdt
					WHERE IsActive__c = TRUE
				] ) {
					esrControlMap.put( esrControl.MasterLabel, esrControl );
				}
			}
			return esrControlMap;
		}
		set;
	}

	/*******************************************************************************************************
	* @description structured request to an external service
	*/
	public class serviceRequest {
		public ExternalServiceRegistry__mdt control;
		public String payload;
	}

	/*******************************************************************************************************
	* @description structured response from an external service
	*/
	public class serviceResponse {
		public Boolean success;
		public String response;
		public List<String> errorMessageList;
	}


	public interface DispatchHandler {

		serviceResponse invokeService( serviceRequest serReq );
	}

	/*******************************************************************************************************
	* @description sends requests to appropriate external services
	* @param esoList the list of ExternalServiceOutbound__e events to process
	*/
	@Future( Callout=TRUE )
	public static void processESOlist( List<String> serialESOlist ) {

		System.debug( '>>> ExternalServiceDispatcher.processESOlist called...' );
		// deserialize list of ESO objects
		List<ExternalServiceOutbound__e> esoList = new List<ExternalServiceOutbound__e>();
		for ( String serialESO : serialESOlist ) {
			ExternalServiceOutbound__e eso = ( ExternalServiceOutbound__e )JSON.deserialize( serialESO, ExternalServiceOutbound__e.class );
			esoList.add( eso );
		}
		System.debug( 'ExternalServiceDispatcher.processESOlist:  processing list: ' + esoList );
		// collect the ExternalService__c records referenced by this events into map
		Set<Id> esIdSet = new Set<Id>();
		for ( ExternalServiceOutbound__e eso : esoList ) {
			esIdSet.add( eso.ExternalServiceID__c );
		}
		Map<Id, ExternalService__c> esIdMap = new Map<Id, ExternalService__c>( [
			SELECT Id, Status__c
			FROM ExternalService__c
			WHERE Id IN :esIdSet
		] );

		// loop through ESOs...
		for ( ExternalServiceOutbound__e eso : esoList ) {
			// dispatch to appropriate service
			ExternalServiceRegistry__mdt esrControl = esrControlMap.get( eso.ServiceName__c );
			// fetch original referenced external service record
			ExternalService__c es = esIdMap.get( eso.ExternalServiceID__c );
			// ensure controls and external service record are present
			System.debug( 'ExternalServiceDispatcher.processESOlist.esrControl: ' + esrControl );
			if ( esrControl != NULL && String.isNotBlank( esrControl.ExternalServiceDispatcherClass__c ) && es != NULL ) {
				// todo:  use interface https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_type.htm
				es.ReplayID__c = eso.ReplayId;
				// instantiate the appropriate dispatch handler class
				Type handlerType = Type.forName( esrControl.ExternalServiceDispatcherClass__c );
				DispatchHandler handler = ( DispatchHandler )handlerType.newInstance();
				// setup callout to service
				serviceRequest newRequest = new serviceRequest();
				newRequest.control = esrControl;
				newRequest.payload = eso.Payload__c;
				// make callout
				serviceResponse resp = handler.invokeService( newRequest );
				if ( resp.success ) {
					// good response, update external service record
					es.Status__c = 'Request Sent';
					es.ResponsePayload__c = resp.response;
				} else {
					// bad response, capture error message to external service record
					es.Status__c = 'Error/Exception';
					es.ResponsePayload__c = String.join( resp.errorMessageList, ',' );
				}
			} else if ( es != NULL ) {
				// config missing for this external service
				es.Status__c = 'Error/Exception';
				es.ResponsePayload__c = 'External Service configuration missing for: ' + eso.ServiceName__c;
				System.debug( 'External Service configuration missing for: ' + eso.ServiceName__c );
			}
		}
		Database.update( esIdMap.values() );
	}

	/*******************************************************************************************************
	* @description replaces whatever value is JSON "reference" property with supplied ExternalService__c.Id
	* if reference property/value not present, returns same payload back
	* @param payload the current JSON payload
	* @param externalServiceId the Id (typically of ExternalService__c record) to inject into payload
	* @return modified JSON payload with Id substituted for "reference" property value
	*/
	public static String fixPayloadReference( String payload, String externalServiceId ) {

		// returned payload
		String replacedPayload;
		// deserialize json into map of strings/objects
		Map<String, Object> deserialStringObjectMap = new Map<String, Object>();
			try {
			deserialStringObjectMap = ( Map<String, Object> )JSON.deserializeUntyped( payload );
		}
		// problem injecting, return same payload
		catch ( Exception e ) {}
		// replace reference token value with esId
		if ( deserialStringObjectMap.get( 'reference' ) != NULL ) {
			// token found, replace
			deserialStringObjectMap.put( 'reference', externalServiceId );
			// reserialize back into json
			replacedPayload = JSON.serialize( deserialStringObjectMap );
		} else {
			// token not found, return original
			replacedPayload = payload;
		}
		return replacedPayload;
	}

	/*******************************************************************************************************
	* @description retrieves value in JSON "reference" property (typically the ExternalService__c.Id
	* if reference property/value not present, returns NULL
	* assumes response payload has only one "reference" token
	* does not care about the structure of the payload JSON
	* @param payload the current JSON payload
	* @return modified JSON payload with Id substituted for "reference" property value
	*/
	public static String getPayloadReference( String payload ) {

		// returned reference property value
		String referenceValue;
		// parse json to find reference property
		try {
			JSONParser parser = JSON.createParser( payload );
			while ( parser.nextToken() != NULL ) {
				if ( parser.getCurrentName() == 'reference' ) {
					parser.nextValue();
					referenceValue = parser.getText();
					break;
				}
			}
		}
		// basically swallow exception without complaint, return NULL
		catch ( Exception e ) {}
		return referenceValue;
	}
}