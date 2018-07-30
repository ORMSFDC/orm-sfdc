/**
* @description test class for ExternalServiceConfigComposer.cls
*
* @author Dennis Wilson
* @date 05/20/2018
*
* changelog:
*
*/
@IsTest
private class ExternalServiceConfigComposer_Test {

	private static final String EXTERNAL_SERVICENAME = 'AmrockBot';
	private static final String OBJECT_APINAME = 'Loan_New__c';
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
	* @description postive test of getExternalServiceMapping method
	*/
	static testMethod void testGetExternalServiceMapping() {

		Test.startTest();
		List<ExternalServicesObjectFieldMapping__mdt> checkESOFMmdtList = ExternalServiceConfigComposer.getExternalServiceMapping( EXTERNAL_SERVICENAME );
		Test.stopTest();
		for ( ExternalServicesObjectFieldMapping__mdt ESOFMmdt : checkESOFMmdtList ) {
			System.debug( '>>> ESOFMmdt: ' + ESOFMmdt );
		}
	}

	/*******************************************************************************************************
	* @description postive test of getExternalServices method
	*/
	static testMethod void testGetExternalServices() {

		Test.startTest();
		List<ExternalServiceRegistry__mdt> checkESRmdtList = ExternalServiceConfigComposer.getExternalServices( EXTERNAL_SERVICENAME );
		Test.stopTest();
		for ( ExternalServiceRegistry__mdt ESRmdt : checkESRmdtList ) {
			System.debug( '>>> ESRmdt: ' + ESRmdt );
		}
	}

	/*******************************************************************************************************
	* @description postive test of getFieldAPIs method
	*/
	static testMethod void testGetFieldAPIs() {

		Test.startTest();
		Set<String> checkAPINameSet = ExternalServiceConfigComposer.getFieldAPIs( testESOFMlist );
		Test.stopTest();
		for ( String APIName : checkAPINameSet ) {
			System.debug( '>>> APIName: ' + APIName );
		}
	}

	/*******************************************************************************************************
	* @description postive test of composeQuery method
	*/
	static testMethod void testComposeQuery() {

		Test.startTest();
		Set<String> testAPINameSet = ExternalServiceConfigComposer.getFieldAPIs( testESOFMlist );
		String checkQuery = ExternalServiceConfigComposer.composeQuery( testAPINameSet, OBJECT_APINAME );
		Test.stopTest();
		System.debug( '>>> checkQuery: ' + checkQuery );
		System.assert( checkQuery.contains( 'SELECT' ) );
	}

	/*******************************************************************************************************
	* @description postive test of getAllFieldQueryString method
	*/
	static testMethod void testGetAllFieldQueryString() {

		Test.startTest();
		String checkQuery = ExternalServiceConfigComposer.getAllFieldQueryString( OBJECT_APINAME );
		Test.stopTest();
		System.debug( '>>> checkQuery: ' + checkQuery );
	}

	/*******************************************************************************************************
	* @description postive test of getSobjectDataFromIdList method
	*/
	static testMethod void testGetSobjectDataFromIdList() {

		// disable outbound external service trigger processing
		TriggerHandlerExternalServiceOutbound.tesoControlMap = testTESOmdtMap;
		Test.startTest();
		Map<Id, SObject> checkIdSObjectMap = ExternalServiceConfigComposer.getSobjectDataFromIdList( new List<Id>{ testLoan.Id } );
		Test.stopTest();
		System.debug( '>>> checkIdSObjectMap: ' + checkIdSObjectMap );
		Loan_New__c checkLoan = ( Loan_New__c )checkIdSObjectMap.get( testLoan.Id );
		System.assertEquals( checkLoan.Subject_Property_Zip_Code__c, LOAN_PROPERTY_ZIP );
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

	private static List<ExternalServicesObjectFieldMapping__mdt> testESOFMlist {
		get {
			return new List<ExternalServicesObjectFieldMapping__mdt>{
				( ExternalServicesObjectFieldMapping__mdt )JSON.deserialize(
					'{ ' +
						'"MasterLabel" : "Amrock_Subject_Property_Type", ' +
						'"DefaultValue__c" : "Single Family", ' +
						'"FieldAPIName__c" : "Subject_Property_Type__c", ' +
						'"MappingProperty__c" : "propertyType", ' +
						'"ObjectAPIName__c" : "Loan_New__c", ' +
						'"ServiceName__c" : "' + EXTERNAL_SERVICENAME + '"' +
						' }', ExternalServicesObjectFieldMapping__mdt.class ),
				( ExternalServicesObjectFieldMapping__mdt )JSON.deserialize(
					'{ ' +
						'"MasterLabel" : "Amrock_estAppraisedValue", ' +
						'"DefaultValue__c" : "", ' +
						'"FieldAPIName__c" : "Estimate_of_Appraised_Value__c", ' +
						'"MappingProperty__c" : "estAppraisedValue", ' +
						'"ObjectAPIName__c" : "Loan_New__c", ' +
						'"ServiceName__c" : "' + EXTERNAL_SERVICENAME + '"' +
						' }', ExternalServicesObjectFieldMapping__mdt.class )
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


}