/**
 * @description Credit Report Domain Class
 * @author Dennis Wilson
 * @date 06/29/2018
 *
 * changelog:
 */
public without sharing class CreditReportDomainService implements ExternalServiceInterface {

	// Static Constants
	private static final String ES_PRODUCT_UPDATED = 'Product Updated';
	private static final String ES_UPDATE_ERROR = 'Error/Exception';
	private static final String LIABLIITY_CATEGORY = 'Liability';

	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private static Boolean testException = FALSE;

	/**
	 * @description Prepare & Process Response Data
	 * @param  sourceIds   External Service records from CreditReport service to process
	 */
	public void processResponses( List<ExternalService__c> esList ) {

		System.debug( '>>> esList: ' + esList );
		Logger.push( 'processResponses', 'CreditReportDomainService' );
		Logger.debug( 'Starting processing records' );
		// list of loans to update
		List<Loan_New__c> loanUpdateList = new List<Loan_New__c>();
		// list of liability records to create
		List<Liability__c> liabilityInsertList = new List<Liability__c>();
		// list of external service records to update
		List<ExternalService__c> esUpdateList = new List<ExternalService__c>();
		// iterate through incoming list of external service records
		for ( ExternalService__c es : esList ) {
			// pull values for loan from external service record
			// safe convert Id
			Id loanId;
			try { loanId = Id.valueOf( es.SourceID__c ); }
			catch ( Exception e ) {}

			// parse json payload into response object
			creditResponse cr = ( creditResponse )JSON.deserialize( es.ResponsePayload__c, creditResponse.class );
			System.debug( '>>> parsed cr: ' + cr );

			// ensure we've got everything needed
			if ( loanId != NULL && cr != NULL ) {
				// loan values to update
				Loan_New__c loan = new Loan_New__c (
					Id = loanId,
					Client_s_credit_score__c            = ( String.isNotBlank( cr.creditScore ) ? Integer.valueOf( cr.creditScore ) : NULL ),
					Credit_Report_Date__c               = ( String.isNotBlank( cr.creditReportDate ) ? Date.valueOf( cr.creditReportDate ) : NULL ),
					Confirm_Credit_Reference_Number__c  = cr.creditReferenceNumber,
					CreditIsComplete__c                 = TRUE
				);
				// build up loan and external lists in parallel so that indexing by save result is possible
				loanUpdateList.add( loan );
				esUpdateList.add( es );
				// create the related liability records
				if ( cr.creditReportLine != NULL ) {
					for ( reportLineResponse rLineResp : cr.creditReportLine ) {
						Liability__c liability = new Liability__c(
							RelatedLoan__c                  = loanId,
							Liability_Category__c           = LIABLIITY_CATEGORY,
							Account_Number__c               = rLineResp.accountNumber,
							Address__c                      = rLineResp.addressCreditor,
							Liability_Monthly_Payment__c    = Decimal.valueOf( rLineResp.monthlyPayment ),
							City__c                         = rLineResp.cityCreditor,
//						County__c                       = rLineResp.countyCreditor,
							Name_of_Company__c              = rLineResp.creditor,
							State__c                        = rLineResp.stateCreditor,
							Liability_Type__c               = ( String.isNotBlank( rLineResp.liabilityType ) ? rLineResp.liabilityType : 'Other' ),
							Liability_Unpaid_Balance__c     = Decimal.valueOf( rLineResp.balance ),
							Zip__c                          = rLineResp.zipCreditor
						);
						liabilityInsertList.add( liability );
					}
				}

				// TODO: create related ORM Document with Credit Report URL
				// json structure allows for multiple doc entries, but usually just one
				if ( cr.docs != NULL ) {
					for ( docResponse doc : cr.docs ) {
						retrieveReportPDF( loanId, doc.downloadUrl, es.RequestingUserID__c );
					}
				}
			}

		}
		// allow for partial success, and test each individual update result
		// note that ordering of save results matches order of external service update list
		System.debug( '>>> updating loanUpdateList: ' + loanUpdateList );
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
				esUpdateList[listIndex].ResponsePayload__c = (
					String.isNotBlank( currentPayload )
						? currentPayload + errorInfo
						: errorInfo
				);
			}
			// advance to the next pair of loan update result and external service record in parallel lists
			listIndex++;
		}
		// TODO: refactor this sequence to rollback entire sequence if a problem updating loan, or creating liabilities
		try {
			Database.insert( liabilityInsertList );
		}
		catch ( DmlException e ){
			System.debug( '>>> liabilityInsertList exception: ' + e );
			Logger.debugException( e );
		}
		// update the original external service records passed in
		try {
			Database.update( esUpdateList );
		}
		catch ( DmlException e ){
			Logger.debugException( e );
		}
		Logger.pop();
	}


	/*******************************************************************************************************
	* @description retrieves credit report PDF and constructs ORM Document (Attachment) related to loan
	* @param reportURL fully formed URL to use for retrieval of PDF
	* @return String:  results of retrieval
	*/
	@future( callout = TRUE )
	public static void retrieveReportPDF( String loanId, String reportURL, String userId ) {

		// retrieve file from AWS using provided URL
		// construct http request
		HttpRequest req = new HttpRequest();
		req.setEndpoint( reportURL );
		req.setMethod( 'GET' );
		Http http = new Http();
		// send request
		HttpResponse res = http.send( req );
		System.debug( '>>> retrieveReportPDF: returned response status: ' + res.getStatusCode() );
		Attachment attach = new Attachment();
		if ( res.getStatusCode() == 200 ) {
			// good response, create attachment
			attach.Body = res.getBodyAsBlob();
			// construct file name using users time zone
			attach.Name = 'Credit Report - ' + Datetime.now().format( 'yyyy-MM-dd hh:mm:ssa', System.UserInfo.getTimeZone().toString() ) + '.pdf';
			attach.ContentType = 'application/pdf';
			attach.IsPrivate = FALSE;
			attach.ParentId = loanId;
			// guard against null or malformed user id
			if ( String.isNotBlank( userId ) ) {
				Id validId;
				try {
					validId = ( Id )userId;
				} catch ( Exception e ) {}
				if ( validId != NULL ) {
					attach.OwnerId = validId;
				}
			}
			Database.insert( attach );
		} else {
		}
		// construct attachment status record to achieve a complete ORM Document
		// compatible with LoanOfficerDocument component
/*
		AttachmentStatus__c attachmentStatus = new AttachmentStatus__c(
			AttachmentID__c = attach.Id,
			LoanId__c = loanId,
			Name = attach.Name
		);
		Database.insert( attachmentStatus );
*/
	}

	/*******************************************************************************************************
	* @description inner classes used for deserializing JSON response
	*/
	class docResponse {
		String downloadUrl;
		String contentType;
		String expiresAtEpochMs;
	}

	class reportLineResponse {
		String accountNumber;
		String addressCreditor;
		String cityCreditor;
		String stateCreditor;
		String zipCreditor;
		String balance;
		String monthlyPayment;
		String creditor;
		String liabilityType;
	}

	class creditResponse {
		String status;
		List<docResponse> docs;
		List<reportLineResponse> creditReportLine;
		String creditScore;
		String creditReportDate;
		String creditReferenceNumber;
		String reference;
	}
}