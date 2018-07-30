/**
* @description test class for WS_AmrockBot.cls
*
* @author Dennis Wilson
* @date 5/14/2018
*
* changelog:
*
*/

@IsTest
private class WS_AmrockBot_Test {

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
		mock.setStaticResource( 'WS_AmrockBotMock' );
		mock.setStatusCode( 200 );
		mock.setHeader( 'Content-Type', 'application/json' );
		Test.setMock( HttpCalloutMock.class, mock );
		WS_AmrockBot.serviceResponse checkResponse = WS_AmrockBot.invokeService( testSRpostive );
		Test.stopTest();
		// expecting OK status
		System.assert(  checkResponse.response.contains( 'Status=OK' ) );
	}

	/*******************************************************************************************************
	* @description exceptions testing of the invokeService() method
	*/
	static testMethod void testInvokeServiceExceptions() {

		Test.startTest();
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource( 'WS_AmrockBotMock' );
		mock.setStatusCode( 400 );
		mock.setHeader( 'Content-Type', 'application/json' );
		Test.setMock( HttpCalloutMock.class, mock );
		WS_AmrockBot.serviceResponse checkResponse1 = WS_AmrockBot.invokeService( testSRpostive );
		WS_AmrockBot.serviceResponse checkResponse2 = WS_AmrockBot.invokeService( testSRexceptions );
		// case of inducting a callout exception
		WS_AmrockBot.testException = TRUE;
		WS_AmrockBot.serviceResponse checkResponse3 = WS_AmrockBot.invokeService( testSRpostive );
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
				'{ "MasterLabel" : "TestExternalService", "NamedCredential__c" : "TestExternalService" }',
				ExternalServiceRegistry__mdt.class );
			return testEScontrol;
		}
		private set;
	}

	private static WS_AmrockBot.serviceRequest testSRpostive {
		get {
			testSRpostive = new WS_AmrockBot.serviceRequest();
			testSRpostive.control = testEScontrol;
			testSRpostive.payload = '{ test : me }';
			return testSRpostive;
		}
		private set;
	}

	private static WS_AmrockBot.serviceRequest testSRexceptions {
		get {
			testSRexceptions = new WS_AmrockBot.serviceRequest();
			testSRexceptions.control = NULL;
			testSRexceptions.payload = '{ test : me }';
			return testSRexceptions;
		}
		private set;
	}

}