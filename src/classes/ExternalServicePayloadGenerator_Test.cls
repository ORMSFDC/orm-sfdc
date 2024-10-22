/**
* @description test class for ExternalServicePayloadGenerator.cls
*
* @author Dennis Wilson
* @date 05/20/2018
*
* changelog:
* 06/04/2018: DWilson - changed to private class declaration
*
*/
@IsTest
private with sharing class ExternalServicePayloadGenerator_Test {

	private static final String EXTERNAL_SERVICE_NAME = 'AmrockBot';
	private static final String LOAN_STATUS_APPLICATIONREQUESTED = 'Proposal';
	private static final String LOAN_PROPERTY_TYPE = 'Single Family';
	private static final String LOAN_PROPERTY_ZIP = '90202';
	private static final Decimal LOAN_APPRAISED_VALUE = 500000;

	@TestSetup
	static void setup() {
		// Create common test data for use in all test methods
		// @TestSetup initializes test data for each method

	}

	/*******************************************************************************************************
	* @description postive test of insertExternalService method
	*/
	static testMethod void testInsertExternalServicePositive() {

		// disable outbound external service trigger processing
		TriggerHandlerExternalServiceOutbound.tesoControlMap = testTESOmdtMap;
		Test.startTest();
		ExternalServicePayloadGenerator.insertExternalService( testRequestList );
		Test.stopTest();
		// check if JSON payload was generated properly
		ExternalService__c checkExternalService = [SELECT Id, RequestPayload__c FROM ExternalService__c LIMIT 1];
		Map<String, Object> checkPayloadMap = ( Map<String, Object> )JSON.deserializeUntyped( checkExternalService.RequestPayload__c );
		System.debug( '>>> checkExternalService.RequestPayload__c: ' + checkExternalService.RequestPayload__c );
		String checkZip = ( String )checkPayloadMap.get( 'zipCode' );
		System.assertEquals( checkZip, LOAN_PROPERTY_ZIP );
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

	private static Account testPartnerAccount {
		get {
			if ( testPartnerAccount == NULL ) {
				testPartnerAccount = new Account(
					Name = 'Test Partner Account'
				);
				Database.insert( testPartnerAccount );
			}
			return testPartnerAccount;
		}
		private set;
	}

	private static Loan_New__c testLoan {
		get {
			if ( testLoan == NULL ) {
				testLoan = new Loan_New__c(
					Related_Partner__c = testPartnerAccount.Id,
					LoanStatus__c = LOAN_STATUS_APPLICATIONREQUESTED,
					Subject_Property_Type__c = LOAN_PROPERTY_TYPE,
					Subject_Property_Zip_Code__c = LOAN_PROPERTY_ZIP,
					Estimate_of_Appraised_Value__c = LOAN_APPRAISED_VALUE,
					Other_Closing_Costs__c = NULL
				);
				Database.insert( testLoan );
			}
			return testLoan;
		}
		private set;
	}

	// request passed to ExternalServicePayloadGenerator.insertExternalService() invocable method
	private static List<ExternalServicePayloadGenerator.Request> testRequestList{
		get {
			ExternalServicePayloadGenerator.Request testRequest = new ExternalServicePayloadGenerator.Request();
			testRequest.idList = new List<Id>{ testLoan.Id };
			testRequest.objectAPIName = 'Loan_New__c';
			testRequest.externalServiceType = EXTERNAL_SERVICE_NAME;
			return new List<ExternalServicePayloadGenerator.Request>{ testRequest };
		}
		private set;
	}


}