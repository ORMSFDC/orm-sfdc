/**
* @description test class for TriggerHandlerExternalServiceInbound.cls
*
* @author Dennis Wilson
* @date 5/15/2018
*
* changelog:
*
*/
@IsTest
private class TriggerHandlerExternalServiceInbnd_Test {

	private static final String EXTERNAL_SERVICE_NAME = 'TestExternalService';

	@TestSetup
	static void setup() {
		// Create common test data for use in all test methods
		// @TestSetup initializes test data for each method

	}

	/*******************************************************************************************************
	* @description positive test of the processEvents() method
	*/
	static testMethod void testProcessEventsPositive() {

		Test.startTest();
		// disable trigger handler for ExternalService__c
		TriggerHandlerExternalService.tesControlMap = testTESmdtMap;
		// enable processing on insert of ExternalServiceInbound__e
		TriggerHandlerExternalServiceInbound.tesiControlMap = testTESImdtMap;
		// publish an incoming event
		ExternalServiceInbound__e testESIevent = new ExternalServiceInbound__e(
			ExternalServiceID__c = testExternalService.Id,
			Payload__c = ExternalServiceDispatcher.fixPayloadReference( testExternalService.RequestPayload__c, testExternalService.Id ),
			ServiceName__c = testExternalService.ServiceName__c
		);
		Database.SaveResult publishSR = EventBus.publish( testESIevent );
		System.assertNotEquals( publishSR.getId(), NULL );
		// strictly for coverage
		TriggerHandlerExternalServiceInbound.tesiControlMap = NULL;
		Map<String, TriggerExternalServiceInbound__mdt> checkControlMap = TriggerHandlerExternalServiceInbound.tesiControlMap;
		Test.stopTest();
	}

	/***************************************************************************************************
	*						 Initialize Test Data
	*************************************************************************************************/

	private static Map<String, TriggerExternalServiceInbound__mdt> testTESImdtMap {
		get {
			return new Map<String, TriggerExternalServiceInbound__mdt>{
				'processEvents' => ( TriggerExternalServiceInbound__mdt ) JSON.deserialize(
					'{ "MasterLabel" : "processEvents", "Enable__c" : true }', TriggerExternalServiceInbound__mdt.class )
			};
		}
		private set;
	}

	private static Map<String, TriggerExternalService__mdt> testTESmdtMap {
		get {
			return new Map<String, TriggerExternalService__mdt>();
		}
		private set;
	}

	private static ExternalService__c testExternalService {
		get {
			if ( testExternalService == NULL ) {
				System.debug( '>>> creating testExternalService...' );
				testExternalService = new ExternalService__c(
					Status__c = 'New',
					RequestPayload__c = '{ "reference" : "FixMe" }',
					ServiceName__c = EXTERNAL_SERVICE_NAME
				);
				Database.insert( testExternalService );
			}
			return testExternalService;
		}
		private set;
	}



}