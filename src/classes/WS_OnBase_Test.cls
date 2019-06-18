@IsTest
private class WS_OnBase_Test {
    
	@TestSetup
	static void setup() {
		// Create common test data for use in all test methods
		// @TestSetup initializes test data for each method

	}

	/*******************************************************************************************************
	* @description positive test of the invokeService() method
	*/
	static testMethod void testInvokeServicePositive() {

		Test.startTest();
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		Test.setMock(HttpCalloutMock.class, new WS_OnBaseMockResponse());
		ExternalServiceDispatcher.serviceResponse checkResponse = WS_OnBase.invokeService( testSRpostive );
		Test.stopTest();
	}

	
	/*******************************************************************************************************
	* @description exceptions testing of the invokeService() method
	*/
	static testMethod void testInvokeServiceExceptions() {

		Test.startTest();
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource( 'WS_OnBaseMock' );
		mock.setStatusCode( 400 );
		mock.setHeader( 'Content-Type', 'application/json' );
		
		Test.setMock( HttpCalloutMock.class, mock );	

		ExternalServiceDispatcher.serviceResponse checkResponse1 = WS_OnBase.invokeService( testSRpostive );
		ExternalServiceDispatcher.serviceResponse checkResponse2 = WS_OnBase.invokeService( testSRexceptions );
		// case of inducting a callout exception
		WS_OnBase.testException = TRUE;
		ExternalServiceDispatcher.serviceResponse checkResponse3 = WS_OnBase.invokeService( testSRpostive );
		Test.stopTest();
		// expecting error messages
		System.assert( checkResponse1.errorMessageList.size() > 0 );
		System.assert( checkResponse2.errorMessageList.size() > 0 );
		System.assert( checkResponse3.errorMessageList.size() > 0 );
	}

	/***************************************************************************************************
	*						 Initialize Test Data
	*************************************************************************************************/

	private static ExternalServiceRegistry__mdt testEScontrol {
		get {
			testEScontrol = ( ExternalServiceRegistry__mdt ) JSON.deserialize(
				'{ "MasterLabel" : "OnBase", "NamedCredential__c" : "OnBase", "ExternalServiceDispatcherClass__c" : "WS_OnBase", "IsActive__c" : true }',
				ExternalServiceRegistry__mdt.class );
			return testEScontrol;
		}
		private set;
	}

	private static ExternalServiceDispatcher.serviceRequest testSRpostive {
		get {
			testSRpostive = new ExternalServiceDispatcher.serviceRequest();
			testSRpostive.control = testEScontrol;
			testSRpostive.payload = '{ test : me }';
			testSRpostive.serName = 'OnBase';
			testSRpostive.extserId = 'OnBase';

			return testSRpostive;
		}
		private set;
	}

	private static ExternalServiceDispatcher.serviceRequest testSRexceptions {
		get {
			testSRexceptions = new ExternalServiceDispatcher.serviceRequest();
			testSRexceptions.control = NULL;
			testSRexceptions.payload = '{ test : me }';
			return testSRexceptions;
		}
		private set;
	}
}