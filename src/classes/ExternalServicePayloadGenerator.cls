/**
* @description Generate External Service Payload dymanically based on custom metadata
*
* @author Mike Gill
* @date 14th May 2018
*
* notes: Process Builder Bug - List of Id's is not marked as Required to avoid PB UI throwing isCollection error
*
* changelog:
*
*/

public without sharing class ExternalServicePayloadGenerator {
    
    @InvocableMethod(label='Insert External Service Payload' description='Generates External Service Payload based on CMT')
    /**
     * @description Invocable Method will can be called from PB/Flow/Apex
     * @param  request Custom User-Defined Data Type
     * @return List of External Service Ids
     */
    public static List<Id> insertExternalService(Request[] request){
        Logger.push('insertExternalService', 'ExternalServicePayloadGenerator');
        Logger.debug('INFO: Starting Insert of External Service Request' + request);
        
        String serviceType; // Service Type
        String objectAPIName; // Object API Name
        List<Id> recordIdList = new List<Id>(); // List of Ids
        
        // Iterate request & extract invocable variables
        for (Request r: request){
            
            recordIdList.addAll(r.idList);
            serviceType = r.externalServiceType;
            objectAPIName = r.objectAPIName;
    
        }

        // Main Method Calls
        List<ExternalServicesObjectFieldMapping__mdt> cmt = ExternalServiceConfigComposer.getExternalServiceMapping(serviceType); // Get CMT
        Set<String> payloadFields = ExternalServiceConfigComposer.getFieldAPIs(cmt); // Get Fields
        List<sObject> payloadData = getPayloadData(payloadFields, objectAPIName, recordIdList); // Get Payload Data in Bulk
        Map<Id, Map<String, String>> payloadJson = generatePayload(cmt, payloadData, objectAPIName); // Generate Payload
        List<Id> externalServiceIds = insertExternalServiceRecords(payloadJson, serviceType);// Create External Service Records
        
        Logger.debug('INFO: Ending Insert of External Service Request' + externalServiceIds);
        Logger.pop();
        return externalServiceIds;

    }
 

    /**
     * @description Generate & return JSON payload required for External Service insertion
     * @param config List of custom metadata
     * @param data List of sObject data
     * @param objectAPIName String value
     * @return JSON payload as a String 
     */
    public static Map<Id, Map<String, String>> generatePayload(List<ExternalServicesObjectFieldMapping__mdt> config, List<sObject> sObjectData, String objectAPIName){
      
        Map<String, String> requestPayloadDefaultsMap = new Map<String, String>();
        Set<String> fieldAPINames = new Set<String>();

        for (ExternalServicesObjectFieldMapping__mdt cmt : config){
            if (cmt.MappingProperty__c!=null){
                requestPayloadDefaultsMap.put(cmt.MappingProperty__c, cmt.DefaultValue__c);
            }

            if (cmt.FieldAPIName__c!=null){
                fieldAPINames.add(cmt.FieldAPIName__c.toLowerCase());
            }
        }

        Map<Id, Map<String, String>> mapPayloadData = generatePayloadMap(sObjectData, objectAPIName, fieldAPINames);
        
        Map<Id, Map<String, String>> recordJsonPropertyMap = generatePayloadJsonMap(mapPayloadData, config, requestPayloadDefaultsMap);
       
        return recordJsonPropertyMap;

    }

    /**
     * @description Generate Payload JSON Map
     * @param mapPayloadData Nested Map of Payload Data
     * @param config List of Custom Metadata 
     * @return Nested map of JSON Payload Data by record Id
     */
    private static Map<Id, Map<String, String>> generatePayloadJsonMap(     Map<Id, Map<String, String>> mapPayloadData, 
                                                                            List<ExternalServicesObjectFieldMapping__mdt> config,
                                                                            Map<String, String> requestPayloadDefaultsMap){

        Logger.push('generatePayloadJsonMap', 'ExternalServicePayloadGenerator');

        Map<Id, Map<String, String>> recordJsonPropertyMap = new Map<Id, Map<String, String>>();

         for (Id recordId : mapPayloadData.keySet()){

            Map<String, String> innerMap = mapPayloadData.get(recordId);

            for (ExternalServicesObjectFieldMapping__mdt cmt: config){
                
                String defaultValue;
                String value;
                
                if (cmt.FieldAPIName__c != null){
                    value = innerMap.get(cmt.FieldAPIName__c .toLowerCase());
                } else {
                    defaultValue = requestPayloadDefaultsMap.get(cmt.MappingProperty__c);
                }

                
                Map<String, String> jsonInnerMap = recordJsonPropertyMap.containsKey(recordId) ? recordJsonPropertyMap.get(recordId) : new Map<String, String>();
                jsonInnerMap.put( cmt.MappingProperty__c, (value!=null ? value : defaultValue) );
                recordJsonPropertyMap.put(recordId, jsonInnerMap);
                

            }
            

        }

        
        Logger.pop();
        return recordJsonPropertyMap;
    }

    /**
     * @descriptiong Generate Payload Data Map
     * @param  sobjectData   List of sobject Data
     * @param  objectAPIName String value e.g. Loan_New__c
     * @param  fieldAPINames Set of field API Names
     * @return Nested Map of Payload Data by record Id
     */
    private static Map<Id, Map<String, String>> generatePayloadMap(List<sObject> sObjectData, String objectAPIName, Set<String> fieldAPINames){
        Logger.push('generatePayloadMap', 'ExternalServicePayloadGenerator');
        Map<Id, Map<String, String>> mapPayloadData = new Map<Id, Map<String, String>>();
        SObjectType payloadObject = Schema.getGlobalDescribe().get(String.valueOf(objectAPIName));
        Map<String,Schema.SObjectField> mfields = payloadObject.getDescribe().fields.getMap();

        for (SObject s: sObjectData){

            for (String fieldName: mfields.keySet()){     
                
                if (fieldAPINames.contains(fieldName)){
                    
                    Map<String, String> innerMap = mapPayloadData.containsKey( s.Id ) ? mapPayloadData.get( s.Id ) : new Map<String, String>();
                    innerMap.put( fieldName, String.valueOf(s.get(fieldName)) );
                    mapPayloadData.put( s.Id, innerMap );

                }
            }

        }
        Logger.pop();
        return mapPayloadData;

    } 

     /**
     * @description Return List of SObject records
     * @param Set of fields API Names
     * @param String value of Object API Name
     * @param List of recordIds
     * @return List of SObjects
     */
    public static List<sObject> getPayloadData (Set<String> payloadFields, String objectAPIName, List<Id> idList){
        Logger.push('getPayloadData','ExternalServicePayloadGenerator');
        
        // Compose Dymanic SOQL Query for External Service Request
        String querySelector = ExternalServiceConfigComposer.composeQuery(payloadFields, objectAPIName);
        List<Id> idSet = idList;
        querySelector += ' WHERE Id in: idSet'; // Append WHERE clause
        
        // Perform SOQL Query
        List<SObject> payloadData = new List<SObject>();
        try{
            payloadData = Database.query(querySelector);
        } catch (Exception e){
            Logger.debugException(e);
        }
        
        Logger.pop();
        return payloadData;

    }


    /**
     * @description Insert External Service records
     * @param payload JSON string payload
     * @param serviceName String of Service name
     */
    private static List<Id> insertExternalServiceRecords(Map<Id, Map<String, String>> jsonPayloadMap, String serviceName){
        
        Logger.push('insertPayload','ExternalServicePayloadGenerator');
        
        List<Id> externalServiceIdList = new List<Id>();

        List<ExternalService__c> externalServiceInserts = new List<ExternalService__c>();

        for (Id recordId : jsonPayloadMap.keySet()){

                Map<String, String> jsonMap = jsonPayloadMap.get(recordId);

                String jsonPayload = JSON.serialize(jsonMap);

                ExternalService__c es = new ExternalService__c();
                es.Status__c = 'New';
                es.SourceID__c = recordId;
                es.ServiceName__c = serviceName;
                es.RequestPayload__c = jsonPayload;
                externalServiceInserts.add(es);

        }

        
        Database.SaveResult[] results = Database.insert(externalServiceInserts);
        
        for (Database.SaveResult result : results) {

            if (result.isSuccess()) {

                externalServiceIdList.add(result.getId());

            }

        }
        

        Logger.pop();
        return externalServiceIdList;

    }

    /**
     * @description External Invocable varibables which can be set by PB/Flow/Apex
     */
    public with sharing class Request {
        
        @InvocableVariable(label='List of IDs' required=false)
        public List<Id> idList;
       
        @InvocableVariable(label='Object API Name' required=true)
        public String objectAPIName;
        
        @InvocableVariable(label='External Service Type' required=true)
        public String externalServiceType;
          
    }

}