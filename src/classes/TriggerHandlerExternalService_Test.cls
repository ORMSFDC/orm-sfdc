/**
* @description test class for TriggerHandlerExternalService.cls
*
* @author Dennis Wilson
* @date 5/8/2018
*
* changelog:
*
*/

@IsTest
private class TriggerHandlerExternalService_Test {

	@TestSetup
	static void setup() {
		// Create common test data for use in all test methods
		// @TestSetup initializes test data for each method

	}

	/*******************************************************************************************************
	* @description positive test of the publishEvents method
	*/
	static testMethod void testPublishEventsPositive() {

		Test.startTest();
		TriggerHandlerExternalService.tesControlMap = testTESmdtMap;
		System.assertNotEquals( testExternalServiceGood, NULL );
		Test.stopTest();
		ExternalService__c checkExternalService = [SELECT Id, Status__c, RequestPayload__c FROM ExternalService__c LIMIT 1];
		System.debug( '>>> checkExternalService.Status__c: ' + checkExternalService.Status__c );
		System.debug( '>>> checkExternalService.RequestPayload__c: ' + checkExternalService.RequestPayload__c );
		System.assertEquals( checkExternalService.Status__c, 'Requested' );
		// strictly for coverage:
		Database.delete( testExternalServiceGood );
		Database.undelete( testExternalServiceGood );
		// force reading of real controls
		TriggerHandlerExternalService.tesControlMap = NULL;
		Map<String, TriggerExternalService__mdt> checkControlMap = TriggerHandlerExternalService.tesControlMap;

	}

	/*******************************************************************************************************
	* @description exception test of the publishEvents method
	*/
	static testMethod void testPublishEventsExceptions() {

		Test.startTest();
		TriggerHandlerExternalService.tesControlMap = testTESmdtMap;
		System.assertNotEquals( testExternalServiceBad, NULL );
		Test.stopTest();
		ExternalService__c checkExternalService = [SELECT Id, Status__c, RequestPayload__c FROM ExternalService__c LIMIT 1];
		System.debug( '>>> checkExternalService.Status__c: ' + checkExternalService.Status__c );
		System.assertEquals( checkExternalService.Status__c, 'Error/Exception' );

	}

	/***************************************************************************************************
	*						 Initialize Test Data
	*************************************************************************************************/

	private static Map<String, TriggerExternalService__mdt> testTESmdtMap {
		get {
			return new Map<String, TriggerExternalService__mdt>{
				'publishEvents' => ( TriggerExternalService__mdt ) JSON.deserialize(
					'{ "MasterLabel" : "publishEvents", "Enable__c" : true }', TriggerExternalService__mdt.class )
			};
		}
		private set;
	}

	private static ExternalService__c testExternalServiceGood {
		get {
			if ( testExternalServiceGood == NULL ) {
				testExternalServiceGood = new ExternalService__c(
					Status__c = 'New',
					RequestPayload__c = '{ "nothingHere" : "yet" }',
					ServiceName__c = 'JustTesting'
				);
				Database.insert( testExternalServiceGood );
			}
			return testExternalServiceGood;
		}
		private set;
	}

	private static ExternalService__c testExternalServiceBad {
		get {
			if ( testExternalServiceBad == NULL ) {
				testExternalServiceBad = new ExternalService__c(
					Status__c = 'New'
				);
				Database.insert( testExternalServiceBad );
			}
			return testExternalServiceBad;
		}
		private set;
	}
}