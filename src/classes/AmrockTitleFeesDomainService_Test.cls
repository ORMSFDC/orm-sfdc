/**
* @description test class for AmrockTitleFeesDomainService.cls
*
* @author Dennis Wilson
* @date 05/20/2018
*
* changelog:
* 06/29/2018: DWilson - revised interface to processResponse()
* 07/24/2018: DWilson - updated for exception coverage
*
*/
@IsTest
private class AmrockTitleFeesDomainService_Test {

	private static final String EXTERNAL_SERVICE_NAME = 'AmrockBot';
	private static final String EXTERNAL_SERVICE_CLASSNAME = 'AmrockTitleFeesDomainService';
	private static final String EXTERNAL_SERVICE_STATUS_RESPONSERECEIVED = 'Response Received';
	private static final Decimal EXPECTED_CLOSING_COSTS = 1234;
	private static final String EXPECTED_CLOSING_COST_URL = 'https://test.org';
	private static final String EXPECTED_STATUS = 'Error/Exception';

	@TestSetup
	static void setup() {
		// Create common test data for use in all test methods
		// @TestSetup initializes test data for each method

	}

	/*******************************************************************************************************
	* @description postive test of processResponse method
	*/
	static testMethod void testProcessResponsePositive() {

		// disable outbound external service trigger processing
		TriggerHandlerExternalServiceOutbound.tesoControlMap = testTESOmdtMap;
		Test.startTest();
		AmrockTitleFeesDomainService handler = new AmrockTitleFeesDomainService();
		handler.processResponses(
			new List<ExternalService__c>{ testExternalServiceGood }
		);
		Test.stopTest();
		// check results
		Loan_New__c checkLoan = [SELECT Id, Other_Closing_Costs__c, Other_Closing_Costs_URL__c FROM Loan_New__c LIMIT 1];
		System.debug( '>>> checkLoan.Other_Closing_Costs__c: ' + checkLoan.Other_Closing_Costs__c );
		System.debug( '>>> checkLoan.Other_Closing_Costs_URL__c: ' + checkLoan.Other_Closing_Costs_URL__c );
		// expect closing costs to be updated
		System.assertEquals( checkLoan.Other_Closing_Costs__c, EXPECTED_CLOSING_COSTS );
		// expect closing cost url to be updated
		System.assertEquals( checkLoan.Other_Closing_Costs_URL__c, EXPECTED_CLOSING_COST_URL );
	}

	/*******************************************************************************************************
	* @description test of processResponse method exceptions
	*/
	static testMethod void testProcessResponseDatabaseException() {

		// disable outbound external service trigger processing
		TriggerHandlerExternalServiceOutbound.tesoControlMap = testTESOmdtMap;
		Test.startTest();
		AmrockTitleFeesDomainService handler = new AmrockTitleFeesDomainService();
		// induce exception by probing test visible property
		handler.testException = TRUE;
		handler.processResponses(
			new List<ExternalService__c>{ testExternalServiceGood }
		);
		Test.stopTest();
		// check results
		ExternalService__c checkES = [SELECT Id, Status__c FROM ExternalService__c LIMIT 1];
		System.debug( '>>> checkES.Status__c: ' + checkES.Status__c );
		// expect an error status on external service record
		System.assertEquals( checkES.Status__c, EXPECTED_STATUS );
	}

	/*******************************************************************************************************
	* @description test of processResponse method exceptions
	*/
	static testMethod void testProcessResponseTypeException() {

		// disable outbound external service trigger processing
		TriggerHandlerExternalServiceOutbound.tesoControlMap = testTESOmdtMap;
		Test.startTest();
		AmrockTitleFeesDomainService handler = new AmrockTitleFeesDomainService();
		// induce exception by probing test visible property
		handler.testException = TRUE;
		handler.processResponses(
			new List<ExternalService__c>{ testExternalServiceBad }
		);
		Test.stopTest();

	}

	/*******************************************************************************************************
	* @description test of getPayloadTokenValue method exceptions
	*/
	static testMethod void testGetPayloadTokenValueException() {

		Test.startTest();
		// pass an impossible to parse JSON payload
		String badPayload = '{ "bad" :  }';
		String checkTokenValue = AmrockTitleFeesDomainService.getPayloadTokenValue( badPayload, 'doesNotExist' );
		Test.stopTest();
		System.debug( '>>> checkTokenValue: ' + checkTokenValue );
		System.assertEquals( checkTokenValue, NULL );
	}

	/***************************************************************************************************
	*						 Initialize Test Data
	*************************************************************************************************/

	private static Map<String, TriggerExternalServiceOutbound__mdt> testTESOmdtMap {
		get {
			return new Map<String, TriggerExternalServiceOutbound__mdt>{
				'processEvents' => ( TriggerExternalServiceOutbound__mdt ) JSON.deserialize(
					'{ "MasterLabel" : "processEvents", "Enable__c" : false }', TriggerExternalServiceOutbound__mdt.class )
			};
		}
		private set;
	}

	private static Map<String, ExternalServiceRegistry__mdt> testESRcontrolMap {
		get {
			testESRcontrolMap = new Map<String, ExternalServiceRegistry__mdt> {
				EXTERNAL_SERVICE_NAME => ( ExternalServiceRegistry__mdt ) JSON.deserialize(
					'{ "MasterLabel" : "' + EXTERNAL_SERVICE_NAME +
						'", "NamedCredential__c" : "' + EXTERNAL_SERVICE_NAME +
						'", "ExternalServiceClass__c" : "' + EXTERNAL_SERVICE_CLASSNAME +
						'" }',
					ExternalServiceRegistry__mdt.class )
			};
			return testESRcontrolMap;
		}
		private set;
	}

	private static Loan_New__c testLoan {
		get {
			if ( testLoan == NULL ) {
				testLoan = new Loan_New__c(

				);
				Database.insert( testLoan );
			}
			return testLoan;
		}
		private set;
	}

	private static ExternalService__c testExternalServiceGood{
		get {
			if ( testExternalServiceGood == NULL ) {
				Map<String, String> testResponseMap = new Map<String, String>{
					'pdfUrl'        => EXPECTED_CLOSING_COST_URL,
					'pdfShortUrl'   => EXPECTED_CLOSING_COST_URL,
					// note the stripping of commas from the quoteTotal token value!!!
					'quoteTotal'    => EXPECTED_CLOSING_COSTS.format().replaceAll( ',', '' )
				};
				System.debug( '>>> JSON.serialize( testResponseMap ): ' + JSON.serialize( testResponseMap ) );
				testExternalServiceGood = new ExternalService__c(
					ReplayID__c = '1',
					ServiceName__c = EXTERNAL_SERVICE_NAME,
					SourceID__c = testLoan.Id,
					Status__c = EXTERNAL_SERVICE_STATUS_RESPONSERECEIVED,
					ResponsePayload__c = JSON.serialize( testResponseMap )
				);
				Database.insert( testExternalServiceGood );
			}
			return testExternalServiceGood;
		}
		private set;
	}

	private static ExternalService__c testExternalServiceBad{
		get {
			if ( testExternalServiceBad == NULL ) {
				Map<String, String> testResponseMap = new Map<String, String>{
					'pdfUrl'        => EXPECTED_CLOSING_COST_URL,
					'pdfShortUrl'   => EXPECTED_CLOSING_COST_URL,
					'quoteTotal'    => 'ThisIsBadData'
				};
				System.debug( '>>> JSON.serialize( testResponseMap ): ' + JSON.serialize( testResponseMap ) );
				testExternalServiceBad = new ExternalService__c(
					ReplayID__c = '1',
					ServiceName__c = EXTERNAL_SERVICE_NAME,
					SourceID__c = 'BadId',
					Status__c = EXTERNAL_SERVICE_STATUS_RESPONSERECEIVED,
					ResponsePayload__c = JSON.serialize( testResponseMap )
				);
				Database.insert( testExternalServiceBad );
			}
			return testExternalServiceBad;
		}
		private set;
	}
}