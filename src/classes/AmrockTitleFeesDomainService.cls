/**
 * @description Amrock Title Fees Domain Class
 * @author Mike Gill
 * @date 17th May 2018
 */
public with sharing class AmrockTitleFeesDomainService implements ExternalServiceInterface {

    // Static Constants
    private static final String ES_PRODUCT_UPDATED = 'Product Updated';
    private static final String ES_UPDATE_ERROR = 'Error/Exception';
    private static final String TOKEN_QUOTE_TITLE = 'quoteTotal';
    private static final String TOKEN_QUOTE_URL = 'pdfShortUrl';

	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private static Boolean testException = FALSE;

    /**
     * @description Prepare & Process Response Data
     * @param  sourceIds   External Service record Ids
     * @param  targetIds   Loan records
     * @param  payloadList Json responses
     * @return List of external service ids which have been updated
     */
    public List<Id> processResponse(List<Id> sourceIds, List<Id> externalServiceIds, List<String> payloadList) { 
        
        Logger.push('processResponse', 'AmrockTitleFeesDomainService');
        
        Map<Id, SObject> dataMap = ExternalServiceConfigComposer.getSobjectDataFromIdList(sourceIds);
        Map<Id, SObject> serviceDataMap = ExternalServiceConfigComposer.getSobjectDataFromIdList(externalServiceIds);
       
        Map<Id, Map<Id, String>> sourceToExternalServiceMap = new Map<Id, Map<Id, String>>();

        for (Sobject s: serviceDataMap.values()){
            
            ExternalService__c e = (ExternalService__c)s; 
            Map<Id, String> innerMap = sourceToExternalServiceMap.containsKey(e.SourceID__c) ? sourceToExternalServiceMap.get(e.SourceID__c) : new Map<Id, String>();
            innerMap.put( e.Id, e.ResponsePayload__c );            
            sourceToExternalServiceMap.put(e.SourceID__c, innerMap);
        }

    
        List<Id> processedRecordIds = processRecords(sourceToExternalServiceMap);
   
        Logger.pop();
        return new List<Id>();
         
    }

    /**
     * @description Process records based on responses
     * @param Nested map of External Service Id and Payload by Source Ids 
     * @return List of record Ids which have been processed
     */
	@testVisible
    private static List<Id> processRecords(Map<Id, Map<Id, String>> data){
        Logger.push('processRecords', 'AmrockTitleFeesDomainService');
        
        Logger.debug('Starting processing records');
        
        List<Id> listOfUpdatedIds = new List<Id>();
        List<Loan_New__c> loanUpdates = new List<Loan_New__c>();
    

        // Process Loan records
        for (Id sourceId : data.keySet()){
            
                Map<Id, String> responseMap = (Map<Id, String>)data.get(sourceId);
                Decimal quoteTotal = 0.00;
                String titleUrl = '';
                String strQuoteTotal = '';
        
                for (Id esId : responseMap.keySet()){
                        strQuoteTotal = getPayloadTokenValue(responseMap.get(esId), TOKEN_QUOTE_TITLE);
                        titleUrl = getPayloadTokenValue(responseMap.get(esId), TOKEN_QUOTE_URL);
                        quoteTotal = Decimal.valueOf(strQuoteTotal);
                }

                Loan_New__c l = new Loan_New__c (Id = sourceId, 
                                                    Other_Closing_Costs__c = quoteTotal,
                                                    Other_Closing_Costs_URL__c = titleUrl);
                loanUpdates.add(l);

        }

/*
        Database.SaveResult[] results;
        try{
            results = Database.update(loanUpdates); // Update Loan records
        } catch (Exception e){
            Logger.debugException(e);
        }
*/
		// allow for partial success, and test each individual update result
		Database.SaveResult[] results = Database.update( loanUpdates, FALSE );

        Map<Id, ExternalService__c> externalServiceUpdates = new Map<Id, ExternalService__c>();
        

        // Process Loan update results
        for (Database.SaveResult result : results) {
            
            // If Loan has been successfully updated, update the related External Service record
            Map<Id, String> esMap = data.get( result.getId() );
            if ( result.isSuccess() && !testException ) {
                
                
                for (Id esId : esMap.keySet()){
                    ExternalService__c es = new ExternalService__c (Id = esId, Status__c = ES_PRODUCT_UPDATED );
                    externalServiceUpdates.put(esId, es);

                }
                
            } else {

               
                for (Id esId : esMap.keySet()){
	                // only update external
                    ExternalService__c es = new ExternalService__c (Id = esId, Status__c = ES_UPDATE_ERROR );
                    externalServiceUpdates.put(esId, es);

                }

            }

        }

        try{
            update externalServiceUpdates.values();
        }
        catch (DmlException e){
            Logger.debugException(e);
        }
        
        listOfUpdatedIds = new List<Id>(externalServiceUpdates.keySet());

        
        Logger.pop();
        return listOfUpdatedIds;

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