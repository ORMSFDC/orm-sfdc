/**
* @description test class for WS_CreditReport.cls
*
* @author Dennis Wilson
* @date 6/13/2018
*
* changelog:
* 06/13/2018: DWilson - initial version
*
*/

@IsTest
private class WS_CreditReport_Test {

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
		mock.setStaticResource( 'WS_CreditReportMock' );
		mock.setStatusCode( 202 );
		mock.setHeader( 'Content-Type', 'application/json' );
		Test.setMock( HttpCalloutMock.class, mock );
		ExternalServiceDispatcher.serviceResponse checkResponse = WS_CreditReport.invokeService( testSRpostive );
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
		mock.setStaticResource( 'WS_CreditReportMock' );
		mock.setStatusCode( 400 );
		mock.setHeader( 'Content-Type', 'application/json' );
		Test.setMock( HttpCalloutMock.class, mock );
		ExternalServiceDispatcher.serviceResponse checkResponse1 = WS_CreditReport.invokeService( testSRpostive );
		ExternalServiceDispatcher.serviceResponse checkResponse2 = WS_CreditReport.invokeService( testSRexceptions );
		// case of inducting a callout exception
		WS_CreditReport.testException = TRUE;
		ExternalServiceDispatcher.serviceResponse checkResponse3 = WS_CreditReport.invokeService( testSRpostive );
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
				'{ "MasterLabel" : "TestExternalService", "NamedCredential__c" : "TestExternalService", "ExternalServiceDispatcherClass__c" : "WS_CreditReport", "IsActive__c" : true }',
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