/**
 * @description Simple Interface for External Services for dymanically instaitating class instance from CMT
 * @authoer Mike Gill
 * @date 17th May 2018
 *
 * changelog:
 * 06/27/2018: Dennis W. - refactor to use list of external service records
 *
 */
public interface ExternalServiceInterface {
	/**
	 * processResponse description
	 * @param  esList   List of external service records to process
	 */
	void processResponses( List<ExternalService__c> esList );

}