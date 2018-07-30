/**
* @description test class for ExternalServiceDispatcher.cls
*
* @author Dennis Wilson
* @date 5/14/2018
*
* changelog:
*
*/

@IsTest
private class ExternalServiceDispatcher_Test {

	private static final String EXTERNAL_SERVICE_NAME = 'TestExternalService';

	@TestSetup
	static void setup() {
		// Create common test data for use in all test methods
		// @TestSetup initializes test data for each method

	}

	/*******************************************************************************************************
	* @description postive test of processESOlist method
	*/
	static testMethod void testProcessESOlistPositive() {

		// override and disable trigger on external service after insert
		TriggerHandlerExternalService.tesControlMap = testTESmdtMap;
		// overide dispatcher controls to register test external service
		ExternalServiceDispatcher.esrControlMap = testEScontrolMap;
		Test.startTest();
		// setup mock response for callout
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource( 'WS_AmrockBotMock' );
		mock.setStatusCode( 200 );
		mock.setHeader( 'Content-Type', 'application/json' );
		Test.setMock( HttpCalloutMock.class, mock );
		// call dispatcher with list of ESOs
		ExternalServiceDispatcher.processESOlist( testSerialESOlist );
		Test.stopTest();
	}

	/*******************************************************************************************************
	* @description exception testing the processESOlist method
	*/
	static testMethod void testProcessESOlistExceptions1() {

		Test.startTest();
		// override and disable trigger on external service after insert
		TriggerHandlerExternalService.tesControlMap = testTESmdtMap;
		// overide dispatcher controls to register test external service
		ExternalServiceDispatcher.esrControlMap = testEScontrolMap;
		// setup mock response for callout
		// exception:  bad status code returned from callout
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource( 'WS_AmrockBotMock' );
		mock.setStatusCode( 400 );
		mock.setHeader( 'Content-Type', 'application/json' );
		Test.setMock( HttpCalloutMock.class, mock );
		// call dispatcher with list of ESOs
		ExternalServiceDispatcher.processESOlist( testSerialESOlist );
		Test.stopTest();
	}

	/*******************************************************************************************************
	* @description exception testing the processESOlist method
	*/
	static testMethod void testProcessESOlistExceptions2() {

		Test.startTest();
		// override and disable trigger on external service after insert
		TriggerHandlerExternalService.tesControlMap = testTESmdtMap;
		// overide dispatcher controls to register test external service
		ExternalServiceDispatcher.esrControlMap = NULL;
		// setup mock response for callout
		// exception:  bad status code returned from callout
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource( 'WS_AmrockBotMock' );
		mock.setStatusCode( 200 );
		mock.setHeader( 'Content-Type', 'application/json' );
		Test.setMock( HttpCalloutMock.class, mock );
		// call dispatcher with list of ESOs
		ExternalServiceDispatcher.processESOlist( testSerialESOlist );
		Test.stopTest();
	}

	/*******************************************************************************************************
	* @description testing fixPayloadReference() and getPayloadReference() methods
	*/
	static testMethod void testPayloads() {

		Test.startTest();
		// override and disable trigger on external service after insert
		TriggerHandlerExternalService.tesControlMap = testTESmdtMap;
		// with reference token
		String checkPayload1 = ExternalServiceDispatcher.fixPayloadReference( testPayloadWithReference, testExternalService.Id );
		String checkRefValue1 = ExternalServiceDispatcher.getPayloadReference( checkPayload1 );
		// without reference token
		String checkPayload2 = ExternalServiceDispatcher.fixPayloadReference( testPayloadWithoutReference, testExternalService.Id );
		String checkRefValue2 = ExternalServiceDispatcher.getPayloadReference( checkPayload2 );
		// malformed json (throws exception)
		String checkRefValue3 = ExternalServiceDispatcher.getPayloadReference( testPayloadMalformed );
		// malformed json (throws exception)
		String fixPayloadReferenceNull = ExternalServiceDispatcher.fixPayloadReference( NULL, testExternalService.Id );
		String getPayloadReferenceNull = ExternalServiceDispatcher.getPayloadReference( NULL );
		Test.stopTest();
		// round trip through injection/extraction should result in an id replacement
		System.assertNotEquals( checkRefValue1, 'JustTesting' );
		System.assertEquals( checkRefValue2, NULL );
		System.assertEquals( checkRefValue3, NULL );
		System.assertEquals( checkRefValue3, NULL );
		System.assertEquals( fixPayloadReferenceNull, NULL );
		System.assertEquals( getPayloadReferenceNull, NULL );
	}

	/***************************************************************************************************
	*						 Initialize Test Data
	*************************************************************************************************/

	private static Map<String, TriggerExternalService__mdt> testTESmdtMap {
		get {
			return new Map<String, TriggerExternalService__mdt>{
				'publishEvents' => ( TriggerExternalService__mdt ) JSON.deserialize(
					'{ "MasterLabel" : "publishEvents", "Enable__c" : false }', TriggerExternalService__mdt.class )
			};
		}
		private set;
	}

	private static Map<String, ExternalServiceRegistry__mdt> testEScontrolMap {
		get {
			testEScontrolMap = new Map<String, ExternalServiceRegistry__mdt> {
				EXTERNAL_SERVICE_NAME => ( ExternalServiceRegistry__mdt ) JSON.deserialize(
					'{ "MasterLabel" : "' + EXTERNAL_SERVICE_NAME + '", "NamedCredential__c" : "' + EXTERNAL_SERVICE_NAME + '" }',
					ExternalServiceRegistry__mdt.class )
			};
			return testEScontrolMap;
		}
		private set;
	}

	private static ExternalService__c testExternalService {
		get {
			if ( testExternalService == NULL ) {
				System.debug( '>>> creating testExternalService...' );
				testExternalService = new ExternalService__c(
					Status__c = 'New',
					RequestPayload__c = '{ "nothingHere" : "yet" }',
					ServiceName__c = EXTERNAL_SERVICE_NAME
				);
				Database.insert( testExternalService );
			}
			return testExternalService;
		}
		private set;
	}

	private static List<String> testSerialESOlist {
		get {
			if ( testSerialESOlist == NULL ) {
				testSerialESOlist = new List<String>();
				List<ExternalServiceOutbound__e> testESOlist = new List<ExternalServiceOutbound__e>{
					new ExternalServiceOutbound__e(
						ExternalServiceID__c = testExternalService.Id,
						Payload__c = '{ "just" : "testing", "reference" : "JustTesting" }',
						ServiceName__c = EXTERNAL_SERVICE_NAME
					),
					new ExternalServiceOutbound__e(
						ExternalServiceID__c = testExternalService.Id,
						Payload__c = '{ "just" : "testing" }',
						ServiceName__c = EXTERNAL_SERVICE_NAME
					)
				};
				for ( ExternalServiceOutbound__e eso : testESOlist ) {
					String serialESO = JSON.serialize( eso );
					testSerialESOlist.add( serialESO );
				}
			}
			return testSerialESOlist;
		}
		private set;
	}

	private static String testPayloadWithReference {
		get {
			return '{ "just" : "testing", "reference" : "JustTesting" }';
		}
		private set;
	}

	private static String testPayloadWithoutReference {
		get {
			return '{ "just" : "testing" }';
		}
		private set;
	}

	private static String testPayloadMalformed {
		get {
			return '{ "just" : "testing" ';
		}
		private set;
	}

}