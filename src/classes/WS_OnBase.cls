/**
* @description: WS_OnBase encapsulates the OnBase external (web) service
*               send http callout when external service is created for Onbase service
* @author Sahitya
* @date 6/28/2019
*
*/

public without sharing class WS_OnBase implements ExternalServiceDispatcher.DispatchHandler{

	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private static Boolean testException = FALSE;


	public static ExternalServiceDispatcher.serviceResponse invokeService( ExternalServiceDispatcher.serviceRequest serReq ) {

		System.debug( '----------------- WS_OnBase.invokeService called...------------- ' );
		Logger.push( 'invokeService', 'WS_OnBase' );
		Logger.debug( 'WS_OnBase.invokeService called...' );
		ExternalServiceDispatcher.serviceResponse serResp = new ExternalServiceDispatcher.serviceResponse();
		String serviceName = serReq.serName;
		String payloaddata = serReq.payload;
		String extId = serReq.extserId;
		System.debug( '@@@12345 '+serviceName );
		System.debug( '@@@12345 '+extId );
		NamedCredential[] namedcredurl = [SELECT Endpoint FROM NamedCredential where Developername = 'OnBaseAPI' limit 1];
    	system.debug('@@nmd'+namedcredurl);

		String credURL = namedcredurl[0].Endpoint;
    	system.debug('credurl@: '+credURL);

    	String endpoint = credURL + extId ;
		system.debug('endpoint@: '+endpoint);


		if ( serReq != NULL && String.isNotBlank( serviceName ) ) {
			// construct http request
			HttpRequest req = new HttpRequest();
			req.setEndpoint( endpoint );
			req.setHeader( 'Content-Type', 'application/json' );
			req.setHeader(Label.Scenario_client_id_label, Label.OnBase_ClientID);
        	req.setHeader(Label.Scenario_client_secret_Label, Label.OnBase_ClientSecret);
			req.setMethod( 'POST' );
			req.setBody( payloaddata );
			Http http = new Http();
			System.debug( '>>> req.getEndpoint(): ' + req.getEndpoint() );
			Logger.debug( 'req.getEndpoint(): ' + req.getEndpoint() );
			// send request
			HttpResponse res;
			try {
				System.debug( '----------------- WS_OnBase.invokeService called...------------- ' );
				res = http.send( req );
				// test class can induce artificial exceptions for coverage
				System.debug( '>>> serReq: ' + serReq );
				Logger.debug( 'serReq: ' + serReq );
				if ( testException ) {
					CalloutException e = ( CalloutException )CalloutException.class.newInstance();
					e.setMessage( 'Testing induced callout exception, please ignore.' );
					throw e;
				}
			}
			catch ( System.CalloutException ce ) {
				// catch timeout, set error message and bail out
				Logger.debugException ( ce );
				serResp.success = FALSE;
				serResp.errorMessageList = new List<String> { 'Callout Exception [' + serviceName + ']', ce.getMessage() };
				Logger.pop();
				return serResp;
			}
			System.debug( '>>> res:sc ' + res.getStatusCode() );
			// either status 200 or 202 interpreted as success 
			//Commented this code as response status is updated by mulesoft
			/*if ( res.getStatusCode() == 200 || res.getStatusCode() == 202 ) {
				if ( String.isNotBlank( res.getBody() ) ) {
					serResp.success = TRUE;
					serResp.response = '[Status=' + res.getStatus() + ', StatusCode=' + res.getStatusCode() + ']\r\n';
					serResp.response += '[Response Returned:]\r\n';
					serResp.response += res.getBody();
				}
			} else {
				serResp.success = FALSE;
				serResp.errorMessageList = new List<String> { res.getBody() };
			}*/
		} else {
			serResp.success = FALSE;
			serResp.errorMessageList = new List<String> { 'No configuration found for External Service' };
		}
		return serResp;

/*
        serResp.success = TRUE;
		System.debug( '@@@1234 '+serResp.response ); 
        serResp.response = '[Status=Published OnBase Platform Event yesss]';
		return serResp;*/
	}
}