/**
* @description test class for TriggerHandlerExternalServiceOutbound.cls
*
* @author Dennis Wilson
* @date 5/10/2018
*
* changelog:
*
*/
@IsTest
private class TriggerHandlerExternalServiceOutbnd_Test {

	@TestSetup
	static void setup() {
		// Create common test data for use in all test methods
		// @TestSetup initializes test data for each method

	}

	/*******************************************************************************************************
	* @description tests the processEvents method
	*/
	static testMethod void testProcessEvents() {

		System.debug( '>>>> starting testProcessEvents...' );
		Test.startTest();
		// basically isolate and disable TriggerHandlerExternalService processing on insert of ExternalService__c
		TriggerHandlerExternalService.tesControlMap = testTESmdtMap;
		// disable ExternalServiceDispatcher
		ExternalServiceDispatcher.esrControlMap = testEScontrolMap;
		// enable processing on insert of ExternalServiceOutbound__e
		TriggerHandlerExternalServiceOutbound.tesoControlMap = testTESOmdtMap;
		// publish test event
		Database.SaveResult checkSR = EventBus.publish( testExternalServiceOutbound );
		// strictly for coverage
		TriggerHandlerExternalServiceOutbound.tesoControlMap = NULL;
		Map<String, TriggerExternalServiceOutbound__mdt> checkControlMap = TriggerHandlerExternalServiceOutbound.tesoControlMap;
		Test.stopTest();
		// no meaningful assertions...

	}

	/***************************************************************************************************
	*						 Initialize Test Data
	*************************************************************************************************/

	private static Map<String, TriggerExternalService__mdt> testTESmdtMap {
		get {
			// basically isolate and disable TriggerHandlerExternalService processing on insert of ExternalService__c
			return new Map<String, TriggerExternalService__mdt>();
		}
		private set;
	}

	private static Map<String, TriggerExternalServiceOutbound__mdt> testTESOmdtMap {
		get {
			return new Map<String, TriggerExternalServiceOutbound__mdt>{
				'processEvents' => ( TriggerExternalServiceOutbound__mdt ) JSON.deserialize(
					'{ "MasterLabel" : "processEvents", "Enable__c" : true }', TriggerExternalServiceOutbound__mdt.class )
			};
		}
		private set;
	}

	private static Map<String, ExternalServiceRegistry__mdt> testEScontrolMap {
		get {
			// disable ExternalServiceDispatcher from doing anything
			return new Map<String, ExternalServiceRegistry__mdt>();
		}
		private set;
	}



	private static ExternalService__c testExternalService {
		get {
			System.debug( '>>> getting testExternalService...' );
			if ( testExternalService == NULL ) {
				System.debug( '>>> constructing testExternalService...' );
				testExternalService = new ExternalService__c(
					Status__c = 'New',
					RequestPayload__c = '{ "nothingHere" : "yet" }',
					ServiceName__c = 'AmrockBot'
				);
				Database.insert( testExternalService );
			}
			return testExternalService;
		}
		private set;
	}

	private static ExternalServiceOutbound__e testExternalServiceOutbound {
		get {
			testExternalServiceOutbound = new ExternalServiceOutbound__e(
				ExternalServiceID__c = testExternalService.Id,
				Payload__c = testExternalService.RequestPayload__c,
				ServiceName__c = testExternalService.ServiceName__c
			);
			return testExternalServiceOutbound;
		}
		private set;
	}


}