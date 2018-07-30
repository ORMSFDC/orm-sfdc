/**
* @description test class for ExternalServicePayloadResponder.cls
*
* @author Dennis Wilson
* @date 05/20/2018
*
* changelog:
*
*/
@IsTest
private class ExternalServicePayloadResponder_Test {

	private static final String EXTERNAL_SERVICE_NAME = 'AmrockBot';
	private static final String EXTERNAL_SERVICE_CLASSNAME = 'AmrockTitleFeesDomainService';
	private static final String EXTERNAL_SERVICE_STATUS_RESPONSERECEIVED = 'Response Received';
	private static final Decimal EXPECTED_CLOSING_COSTS = 1234;
	private static final String EXPECTED_CLOSING_COST_URL = 'https://test.org';

	@TestSetup
	static void setup() {
		// Create common test data for use in all test methods
		// @TestSetup initializes test data for each method

	}

	/*******************************************************************************************************
	* @description postive test of processESOlist method
	*/
	static testMethod void testUpdateDomainRecordsPositive() {

		// disable outbound external service trigger processing
		TriggerHandlerExternalServiceOutbound.tesoControlMap = testTESOmdtMap;
		Test.startTest();
		// override any ExternalServiceRegistry__mdt entries for ExternalServicePayloadResponder
		ExternalServicePayloadResponder.esrControlMap = testESRcontrolMap;
		// call invocable with request list
		ExternalServicePayloadResponder.updateDomainRecords( testRequestList );
		Test.stopTest();
		// check results
		Loan_New__c checkLoan = [SELECT Id, Other_Closing_Costs__c, Other_Closing_Costs_URL__c FROM Loan_New__c LIMIT 1];
		System.debug( '>>> checkLoan.Other_Closing_Costs__c: ' + checkLoan.Other_Closing_Costs__c );
		System.debug( '>>> checkLoan.Other_Closing_Costs_URL__c: ' + checkLoan.Other_Closing_Costs_URL__c );
		// expect closing costs to be updated
		System.assertEquals( checkLoan.Other_Closing_Costs__c, EXPECTED_CLOSING_COSTS );
		// expect closing cost url to be updated
		System.assertEquals( checkLoan.Other_Closing_Costs_URL__c, EXPECTED_CLOSING_COST_URL );
		// just for coverage
		ExternalServicePayloadResponder.esrControlMap = NULL;
		System.assertNotEquals( ExternalServicePayloadResponder.esrControlMap, NULL );
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

	private static ExternalService__c testExternalService {
		get {
			if ( testExternalService == NULL ) {
				Map<String, String> testResponseMap = new Map<String, String>{
					'pdfUrl'        => EXPECTED_CLOSING_COST_URL,
					'pdfShortUrl'   => EXPECTED_CLOSING_COST_URL,
					// note the stripping of commas from the quoteTotal token value!!!
					'quoteTotal'    => EXPECTED_CLOSING_COSTS.format().replaceAll( ',', '' )
				};
				System.debug( '>>> JSON.serialize( testResponseMap ): ' + JSON.serialize( testResponseMap ) );
				testExternalService = new ExternalService__c(
					ReplayID__c = '1',
					ServiceName__c = EXTERNAL_SERVICE_NAME,
					SourceID__c = testLoan.Id,
					Status__c = EXTERNAL_SERVICE_STATUS_RESPONSERECEIVED,
					ResponsePayload__c = JSON.serialize( testResponseMap )
				);
				Database.insert( testExternalService );
			}
			return testExternalService;
		}
		private set;
	}

	// request passed to ExternalServicePayloadResponder.updateDomainRecords() invocable method
	private static List<ExternalServicePayloadResponder.Request> testRequestList{
		get {
			ExternalServicePayloadResponder.Request testRequest = new ExternalServicePayloadResponder.Request();
			testRequest.idList = new List<Id>{ testExternalService.Id };
			testRequest.sourceIdList = new List<Id>{ testExternalService.SourceID__c };
			testRequest.payloadResponseList = new List<String>{ testExternalService.ResponsePayload__c };
			testRequest.objectAPIName = 'Loan_New__c';
			testRequest.externalServiceType = EXTERNAL_SERVICE_NAME;
			return new List<ExternalServicePayloadResponder.Request>{ testRequest };
		}
		private set;
	}
}