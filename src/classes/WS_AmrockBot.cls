/**
* @description WS_AmrockBot encapsulates the Amrock-Bot external (web) service
*
* @author Dennis Wilson
* @date 5/10/2018
*
* changelog:
*
*/
public without sharing class WS_AmrockBot {

	/*******************************************************************************************************
	* @description structured request to make to external service
	*/
	public class serviceRequest {
		public ExternalServiceRegistry__mdt control;
		public String payload;
//		public Boolean testing;
	}

	/*******************************************************************************************************
	* @description structured response from external service
	*/
	public class serviceResponse {
		public Boolean success;
		public String response;
		public List<String> errorMessageList;
	}

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
	public static serviceResponse invokeService( serviceRequest serReq ) {

		System.debug( '>>> WS_AmrockBot.invokeService called... ' );
		serviceResponse serResp = new serviceResponse();
		String serviceName = serReq.control.NamedCredential__c;
		// ensure enough to make request
		if ( serReq != NULL && serReq.control != NULL && String.isNotBlank( serviceName ) ) {
			// construct http request
			HttpRequest req = new HttpRequest();
			req.setEndpoint( 'callout:' + serviceName );
			req.setHeader( 'Content-Type', 'application/json' );
			req.setMethod( 'POST' );
			req.setBody( serReq.payload );
			Http http = new Http();
			System.debug( '>>> req.getEndpoint(): ' + req.getEndpoint() );
			// send request
			HttpResponse res;
			try {
				res = http.send( req );
				// test class can induce artificial exceptions for coverage
				System.debug( '>>> serReq: ' + serReq );
				if ( testException ) {
					CalloutException e = ( CalloutException )CalloutException.class.newInstance();
					e.setMessage( 'Testing induced callout exception, please ignore.' );
					throw e;
				}
			}
			catch ( System.CalloutException ce ) {
				// catch timeout, set error message and bail out
				serResp.success = FALSE;
				serResp.errorMessageList = new List<String> { 'Callout Exception [' + serviceName + ']', ce.getMessage() };
				return serResp;
			}
			System.debug( '>>> res: ' + res );
			if ( res.getStatusCode() == 200 ) {
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