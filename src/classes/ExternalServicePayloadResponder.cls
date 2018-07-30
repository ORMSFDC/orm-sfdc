/**
* @description Process Payloads responses back into the Business Domain (Loan or related objects)
*
* @author Mike Gill
* @date 17th May 2018
*
* notes: Process Builder Bug - List of Id's is not marked as Required to avoid PB UI throwing isCollection error
*
* changelog:
*
* @TODO Hardening/deeper exception handling
*/
public without sharing class ExternalServicePayloadResponder {

    /*******************************************************************************************************
	* @description custom metadata types for the parameters of external services
	*/
    @testVisible
    private static Map<String, ExternalServiceRegistry__mdt> esrControlMap {
        get {
            if ( esrControlMap == NULL ) {
                esrControlMap = new Map<String, ExternalServiceRegistry__mdt>();
                for ( ExternalServiceRegistry__mdt esrControl : [
                    SELECT MasterLabel, NamedCredential__c, ExternalServiceClass__c
                    FROM ExternalServiceRegistry__mdt
                ] ) {
                    esrControlMap.put( esrControl.MasterLabel, esrControl );
                }
            }
            return esrControlMap;
        }
        set;
    }


     @InvocableMethod(label='Process External Service Responses' description='Process External Service responses and update business records')
    /**
     * @description Invocable Method will can be called from PB/Flow/Apex
     * @param  request Custom User-Defined Data Type
     * @return List of External Service Ids
     */
    public static List<Id> updateDomainRecords(Request[] request){

        Logger.push('updateDomainRecords', 'ExternalServicePayloadResponder');
        
        String serviceType; // Service Type
        String objectAPIName; // Object API Name
        List<Id> recordIdList = new List<Id>(); // List of Ids
        List<String> payloadList = new List<String>(); // List of Ids
        List<Id> sourceIdList = new List<Id>(); // List of Source Ids
        
        // Iterate request & extract invocable variables
        for (Request r: request){
            
            // Variable
            payloadList.addAll(r.payloadResponseList);
            sourceIdList.addAll(r.sourceIdList);
            recordIdList.addAll(r.idList);

            // Static
            serviceType = r.externalServiceType;
            objectAPIName = String.valueOf(r.objectAPIName);
    
        }

//        List<ExternalServiceRegistry__mdt> serviceRegistry = ExternalServiceConfigComposer.getExternalServices(serviceType); // Get CMT

//      @mike:  not sure why you are returning list of ExternalServiceRegistry__mdt here
//      because it appears (to me) this invocable method handles only one serviceType per invocation
//      I'm just continuing your pattern by constructing a "list" (with one element) to keep code changes to a minimum

        List<ExternalServiceRegistry__mdt> serviceRegistry = new List<ExternalServiceRegistry__mdt>{
	        esrControlMap.get( serviceType )
        };

        List<Id> processedExternalServiceId = new List<Id>();
        for (ExternalServiceRegistry__mdt services: serviceRegistry){

                Type t = Type.forName(String.valueOf(services.ExternalServiceClass__c));
                ExternalServiceInterface es = (ExternalServiceInterface)t.newInstance();
                processedExternalServiceId =  es.processResponse(sourceIdList,recordIdList, payloadList);       
         }

        // Main methods
        

        Logger.pop();
        return processedExternalServiceId;
    }

    /**
     * @description External Invocable varibables which can be set by PB/Flow/Apex
     */
    public with sharing class Request {
        
        @InvocableVariable(label='List of IDs' required=false)
        public List<Id> idList;

        @InvocableVariable(label='List of Source IDs' required=false)
        public List<Id> sourceIdList;

        @InvocableVariable(label='List of Payload Responses' required=false)
        public List<String> payloadResponseList;
           
        @InvocableVariable(label='Object API Name' required=true)
        public String objectAPIName;
        
        @InvocableVariable(label='External Service Type' required=true)
        public String externalServiceType;
          
    }

}