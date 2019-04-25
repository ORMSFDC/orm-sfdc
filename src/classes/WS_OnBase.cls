/**
* @description WS_OnBase encapsulates the OnBase external (web) service
*/
public without sharing class WS_OnBase implements ExternalServiceDispatcher.DispatchHandler{

	/*******************************************************************************************************
	* @description used to induce exception coverage by test methods
	*/
	@TestVisible
	private static Boolean testException = FALSE;


	public static ExternalServiceDispatcher.serviceResponse invokeService( ExternalServiceDispatcher.serviceRequest serReq ) {
		System.debug( '>>> WS_OnBase.invokeService called... ' );
		Logger.push( 'invokeService', 'WS_OnBase' );
		Logger.debug( 'WS_OnBase.invokeService called...' );
		ExternalServiceDispatcher.serviceResponse serResp = new ExternalServiceDispatcher.serviceResponse();
		
        serResp.success = TRUE;
        serResp.response = '[Status=Published OnBase Platform Event]';
		return serResp;
	}
}