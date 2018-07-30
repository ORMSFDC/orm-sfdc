/**
 * @description Simple Interface for External Services for dymanically instaitating class instance from CMT
 * @authoer Mike Gill
 * @date 17th May 2018
 */
public interface ExternalServiceInterface {
    /**
     * processResponse description
     * @param  sourceIds   List of ids for the requesting domain object (e.g. Loan)
     * @param  externalServiceIds List of ids for External Service record
     * @param  payloadList List of JSON payloads
     * @return List of external service Ids
     */
    List<Id> processResponse(List<Id> sourceIds, List<Id> externalServiceIds, List<String> payloadList);   
}