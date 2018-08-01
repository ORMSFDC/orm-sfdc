/**
* @description test class for CreditReportDomainService.cls
*
* @author Dennis Wilson
* @date 06/29/2018
*
* changelog:
*
*/
@IsTest
private class CreditReportDomainService_Test {

	private static final String EXTERNAL_SERVICE_NAME = 'reos_credit_service';
	private static final String EXTERNAL_SERVICE_CLASSNAME = 'CreditReportDomainService';
	private static final String EXTERNAL_SERVICE_STATUS_RESPONSERECEIVED = 'Response Received';
	private static final Decimal EXPECTED_CLOSING_COSTS = 1234;
	private static final String EXPECTED_CLOSING_COST_URL = 'https://test.org';

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
		CreditReportDomainService handler = new CreditReportDomainService();
		handler.processResponses(
			new List<ExternalService__c>{ testExternalService }
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
	* @description test of processRecords method exceptions
	*/
/*
	static testMethod void testProcessRecordsException() {

		// disable outbound external service trigger processing
		TriggerHandlerExternalServiceOutbound.tesoControlMap = testTESOmdtMap;
		Test.startTest();
		// create nested maps as per processRecords arg:  Map<Id, Map<Id, String>>
		// outermap:  [key = ExternalService__c.SourceID__c] [value = innermap]
		// innermap:  [key = ExternalService__c.Id] [value = ExternalService__c.ResponsePayload__c
		Map<Id, Map<Id, String>> testMap = new Map<Id, Map<Id, String>>{
			testExternalService.SourceID__c => new Map<Id, String> {
				testExternalService.Id => testExternalService.ResponsePayload__c
			}
		};
		// induce exception handling logic through use of embedded static variable
		AmrockTitleFeesDomainService.testException = TRUE;
		AmrockTitleFeesDomainService.processRecords( testMap );
		Test.stopTest();
		// check results
		ExternalService__c checkES = [SELECT Id, ResponsePayload__c FROM ExternalService__c WHERE Id = :testExternalService.Id];
		System.debug( '>>> checkES.ResponsePayload__c: ' + checkES.ResponsePayload__c );
	}
*/
	/*******************************************************************************************************
	* @description test of getPayloadTokenValue method exceptions
	*/
/*
	static testMethod void testGetPayloadTokenValueException() {

		Test.startTest();
		// pass an impossible to parse JSON payload
		String badPayload = '{ "bad" :  }';
		String checkTokenValue = CreditReportDomainService.getPayloadTokenValue( badPayload, 'doesNotExist' );
		System.debug( '>>> checkTokenValue: ' + checkTokenValue );
		System.assertEquals( checkTokenValue, NULL );
		Test.stopTest();
	}
*/
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
						'", "IsActive__c" : true' +
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

/*
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
*/

}