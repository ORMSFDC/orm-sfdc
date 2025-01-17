/**
* @description WS_AmrockBot encapsulates the Amrock-Bot external (web) service
*
* @author Dennis Wilson
* @date 5/10/2018
*
* changelog:
* 06/04/2018: DWilson - refactored to implement interface
* 06/15/2018: DWilson - added Logger
*
*/
public without sharing class WS_AmrockBot implements ExternalServiceDispatcher.DispatchHandler{

	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private static Boolean testException = FALSE;

	/*******************************************************************************************************
	* @description performs callout to AmrockBot service
	* @param serReq structured request
	* @return structured response (serviceResponse)
	*/
	public static ExternalServiceDispatcher.serviceResponse invokeService( ExternalServiceDispatcher.serviceRequest serReq ) {

		System.debug( '>>> WS_AmrockBot.invokeService called... ' );
		Logger.push( 'invokeService', 'WS_AmrockBot' );
		Logger.debug( 'WS_AmrockBot.invokeService called...' );
		ExternalServiceDispatcher.serviceResponse serResp = new ExternalServiceDispatcher.serviceResponse();
		String serviceName = serReq.control.NamedCredential__c;
		// ensure enough to make request
		if ( serReq != NULL && serReq.control != NULL && String.isNotBlank( serviceName ) ) {
			// construct http request
			HttpRequest req = new HttpRequest();
			req.setEndpoint( 'callout:' + serviceName );
			req.setHeader( 'Content-Type', 'application/json' );
			// only use authorization header if configured
			if ( String.isNotBlank( serReq.control.AuthorizationHeaderToken__c ) && String.isNotBlank( serReq.control.AuthorizationHeaderValue__c ) ) {
				req.setHeader( serReq.control.AuthorizationHeaderToken__c, serReq.control.AuthorizationHeaderValue__c );
			}
			req.setMethod( 'POST' );
			req.setBody( serReq.payload );
			Http http = new Http();
			System.debug( '>>> req.getEndpoint(): ' + req.getEndpoint() );
			Logger.debug( 'req.getEndpoint(): ' + req.getEndpoint() );
			// send request
			HttpResponse res;
			try {
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
			System.debug( '>>> res: ' + res );
			// either status 200 or 202 interpreted as success
			if ( res.getStatusCode() == 200 || res.getStatusCode() == 202 ) {
				if ( String.isNotBlank( res.getBody() ) ) {
					serResp.success = TRUE;
					serResp.response = '[Status=' + res.getStatus() + ', StatusCode=' + res.getStatusCode() + ']\r\n';
					serResp.response += '[Response Returned:]\r\n';
					serResp.response += res.getBody();
				}
			} else {
				serResp.success = FALSE;
				serResp.errorMessageList = new List<String> { res.getBody() };
			}
		} else {
			serResp.success = FALSE;
			serResp.errorMessageList = new List<String> { 'No configuration found for External Service' };
		}
		return serResp;
	}
}