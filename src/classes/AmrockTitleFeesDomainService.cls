/**
 * @description Amrock Title Fees Domain Class
 * @author Mike Gill
 * @date 17th May 2018
 *
 * changelog:
 * 06/21/2018: DWilson - fix to guard failing Loan_New__c update
 * 07/11/2018: DWilson - added update to TitleFeeIsComplete__c status field
 * 07/24/2018: DWilson - added update to TitleFeeEstimateResponse__c status field
 */
public without sharing class AmrockTitleFeesDomainService implements ExternalServiceInterface {

	/*******************************************************************************************************
	* @description constants for ExternalService__c status and JSON tokens to parse
	*/
    private static final String ES_PRODUCT_UPDATED = 'Product Updated';
    private static final String ES_UPDATE_ERROR = 'Error/Exception';
    private static final String TOKEN_QUOTE_TOTAL = 'quoteTotal';
    private static final String TOKEN_QUOTE_URL = 'pdfShortUrl';

	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private Boolean testException = FALSE;

	/*******************************************************************************************************
	* @description custom exception for error situations
	*/
	public class AmrockTitleFeesDomainServiceException extends Exception {}

	/**
	 * @description Prepare & Process Response Data
	 * @param  sourceIds   External Service records from AmrockBot service to process
	 */
	public void processResponses( List<ExternalService__c> esList ) {

		System.debug( '>>> esList: ' + esList );
		Logger.push( 'processResponses', 'AmrockTitleFeesDomainService' );
		Logger.debug( 'Starting processing records' );
		// list of loans to update
		List<Loan_New__c> loanUpdateList = new List<Loan_New__c>();
		// list of external service records to update
		List<ExternalService__c> esUpdateList = new List<ExternalService__c>();
		// iterate through incoming list of external service records
		for ( ExternalService__c es : esList ) {
			// pull values for loan from external service record
			// safe convert Id
			Id loanId;
			try { loanId = Id.valueOf( es.SourceID__c ); }
			catch ( Exception e ) {}
			// safe convert quote total
			String strQuoteTotal = getPayloadTokenValue( es.ResponsePayload__c, TOKEN_QUOTE_TOTAL );
			Decimal quoteTotal;
			try { quoteTotal = Decimal.valueOf( strQuoteTotal ); }
			catch ( Exception e ) {}
			String titleUrl = getPayloadTokenValue( es.ResponsePayload__c, TOKEN_QUOTE_URL );
			// ensure we've got everything needed
			if ( loanId != NULL && quoteTotal != NULL && String.isNotBlank( titleUrl ) ) {
				// loan values to update
				Loan_New__c loan = new Loan_New__c (
					Id = loanId,
					Other_Closing_Costs__c = quoteTotal,
					Other_Closing_Costs_URL__c = titleUrl,
					TitleFeeIsComplete__c = TRUE,
					TitleFeeEstimateResponse__c = es.ResponsePayload__c
				);
				loanUpdateList.add( loan );
				esUpdateList.add( es );
			}
		}
		// allow for partial success, and test each individual update result
		// note that ordering of save results matches order of external service update list
		List<Database.SaveResult> saveResultList = Database.update( loanUpdateList, FALSE );
		// iterate through results, update external service appropriately
		Integer listIndex = 0;
		for ( Database.SaveResult result : saveResultList ) {
			if ( result.isSuccess() && !testException ) {
				// update es with success
				esUpdateList[listIndex].Status__c = ES_PRODUCT_UPDATED;
			} else {
				// update es with failure
				esUpdateList[listIndex].Status__c = ES_UPDATE_ERROR;
				String errorInfo ='\r\n[Loan Update Errors:]\r\n' + String.join( result.getErrors(), ', ' );
				String currentPayload = esUpdateList[listIndex].ResponsePayload__c;
				// protect against null payload
				esUpdateList[listIndex].ResponsePayload__c = ( String.isNotBlank( currentPayload ) ? currentPayload + errorInfo : errorInfo );
			}
			// advance to the next pair of loan update result and external service record in parallel lists
			listIndex++;
		}
		try {
			if ( saveResultList.size() > 0 ) {
				Database.update( esUpdateList );
			} else {
				throw new AmrockTitleFeesDomainServiceException( 'No Loan Records Updated.' );
			}
		}
		catch ( Exception e ){
			Logger.debugException( e );
		}
	}

    /*******************************************************************************************************
	* @description Retrieves a token value in a JSON payload.
	* If token or token value not present, returns NULL.
	* Does not care about the structure of the payload JSON.
	* @param payload the current JSON payload
	* @param token the current JSON payload
	* @return String value of requested token
	*/
	public static String getPayloadTokenValue( String payload, String token ) {

		// returned token value
		String tokenValue;
		// parse json to find reference property
		try {
			JSONParser parser = JSON.createParser( payload );
			while ( parser.nextToken() != NULL ) {
				if ( parser.getCurrentName() == token ) {
					parser.nextValue();
					tokenValue = parser.getText();
					break;
				}
			}
		}
		// basically swallow exception without complaint, return NULL
		catch ( Exception e ) {}
		return tokenValue;
	}
}