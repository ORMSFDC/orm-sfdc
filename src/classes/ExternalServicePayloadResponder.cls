/**
* @description Process Payloads responses back into the Business Domain (Loan or related objects)
*
* @author Mike Gill
* @date 17th May 2018
*
* notes: Process Builder Bug - List of Id's is not marked as Required to avoid PB UI throwing isCollection error
*
* changelog:
* 06/27/2018: Dennis W. - refactor to use list of external service records
*
* @TODO Hardening/deeper exception handling
*/
public without sharing class ExternalServicePayloadResponder {

	/*******************************************************************************************************
	* @description custom metadata types for the parameters of external services
	*/
	@TestVisible
	private static Map<String, ExternalServiceRegistry__mdt> esrControlMap {
		get {
			if ( esrControlMap == NULL ) {
				esrControlMap = new Map<String, ExternalServiceRegistry__mdt>();
				for ( ExternalServiceRegistry__mdt esrControl : [
					SELECT MasterLabel, NamedCredential__c, ExternalServiceClass__c
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

	/**
	 * @description invocable method callable from PB/Flow/Apex
	 * @param  esIdList List<Id> of ExternalService__c records to process
	 */
	@InvocableMethod( Label='Process External Service Responses' Description='Process External Service responses and update business records' )
	public static void updateDomainRecords( List<Id> esIdList ) {		
		system.debug('updateDomainRecords--------------'+esIdList);
		// query and organize external service record by map of record list
		// map key = service name
		// map value = list of external service records
		Map<String, List<ExternalService__c>> serviceNameESlistMap = new Map<String, List<ExternalService__c>>();
		for ( ExternalService__c es : [
			SELECT
				ReplayID__c,
				RequestPayload__c,
				ResponsePayload__c,
				ServiceName__c,
				SourceID__c,
				Status__c,
				RequestingUserID__c
			FROM ExternalService__c
			WHERE Id IN :esIdList
		]) {
			System.debug('es.ServiceName__c---------------'+es.ServiceName__c);
			if ( !serviceNameESlistMap.containsKey( es.ServiceName__c ) ) {
				serviceNameESlistMap.put( es.ServiceName__c, new List<ExternalService__c>() );
			}
			serviceNameESlistMap.get( es.ServiceName__c ).add( es );
		}
		System.debug('serviceNameESlistMap---------------'+serviceNameESlistMap);
		// for each service referenced instantiate interface indicated by matching registry entry
		for ( String serviceName : serviceNameESlistMap.keySet() ) {
			System.debug('esrControlMap---------------'+esrControlMap);
			if ( esrControlMap.get( serviceName ) != NULL  ) {
				// registry entry found, get handler class name
				String extServiceClass = esrControlMap.get( serviceName ).ExternalServiceClass__c;
				System.debug( '>>> ExternalServicePayloadResponder.updateDomainRecords.extServiceClass: ' + extServiceClass );
				if ( String.isNotBlank( extServiceClass ) ) {
					// create instance of handler class
					Type t = Type.forName( String.valueOf( extServiceClass ) );
					if ( t != NULL ) {
						// handler class found
						ExternalServiceInterface esHandler = ( ExternalServiceInterface )t.newInstance();
						// call handler with list of external service records
						esHandler.processResponses( serviceNameESlistMap.get( serviceName ) );
					}
				}
			}
		}
	}
}