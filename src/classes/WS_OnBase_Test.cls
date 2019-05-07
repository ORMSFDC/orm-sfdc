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
		ExternalServiceDispatcher.serviceResponse checkResponse = WS_OnBase.invokeService( new ExternalServiceDispatcher.serviceRequest() );
		Test.stopTest();

		System.assertEquals('[Status=Published OnBase Platform Event]', checkResponse.response);
	}
}