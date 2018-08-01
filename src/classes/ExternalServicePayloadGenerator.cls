/**
* @description Generate External Service Payload dymanically based on custom metadata
* @dependencies https://github.com/datasert/libshare
* @author Mike Gill
* @date 14th May 2018
*
* notes: Process Builder Bug - List of Id's is not marked as Required to avoid PB UI throwing isCollection error
*
* changelog: Sprint 5 - Refactor for dynamic Payload Generator & Credit Report
* changelog: Sprint 6 - MG/QDA 16/07/18 Cast all json data types to String
*                       
*
* @todo reorganise code / review with Dennis
* @todo bulkification.
*/

public without sharing class ExternalServicePayloadGenerator {
    
    // public static collections
    public static List<ExternalServicesObjectFieldMapping__mdt> cmt = new  List<ExternalServicesObjectFieldMapping__mdt> ();
    public static List<Id> recordIdList = new List<Id>(); 

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
    
        // Iterate request & extract invocable variables
        for (Request r: request){
            
            recordIdList.addAll(r.idList);
            serviceType = r.externalServiceType;
            objectAPIName = r.objectAPIName;
    
        }

        // Get External Services Custom Metadata
        cmt = ExternalServiceConfigComposer.getExternalServiceMapping(serviceType); // Get CMT            

        // Generate Dymanic Data Maps 
        Map<String, String> objectMap = getJSONObjectToObjectMap(); // Get JSON Object to Salesforce Object Mapping
        Map<String, String> objectParentMap = getObjectToParent(); // Get Salesforce Object to Parent Mapping        
        Map<String, Object> soqlQueryMap = generateSOQLQueryMap(); // Get SOQL Query fields 
        Map<String, String> soqlWhereMap = getObjectWhereCriteria(); // Get Additional SOQL Where Criteria
        

        // Query Salesforce Data - @TODO needs bulking
        Map<String, List<sObject>> objectData = queryObjectData(objectMap, objectParentMap, soqlWhereMap, soqlQueryMap); 
        String jsonPayload = createPayload(objectData);

       
        Map<Id, String> payloadMap = new Map<Id, String>{ recordIdList[0] => jsonPayload }; 
        List<Id> externalServiceIds = insertExternalServiceRecords(payloadMap, serviceType);

        Logger.debug('INFO: End Insert of External Service Request' + request);
        Logger.pop();

        return externalServiceIds;

    }

    /**
     * createPayload Generate JSON payload to be sent to External Service Request
     * @param  List of sObject data nested inside JSON tokens
     * @return Json payload
     */
    public static String createPayload(Map<String, List<sObject>> objectData){
        
        Logger.push('createPayload','ExternalServicePayloadGenerator');

        lib.JsonMapper mapper = new lib.JsonMapper(); // Instantiate JsonMapper lib
        
    
        for (ExternalServicesObjectFieldMapping__mdt c : cmt){
            
            if (c.JSON_Object_Property__c == 'root'){
                List<sObject> rootData = (List<sObject>)objectData.get('root');
                for (  sObject s: rootData ){
                    if (c.FieldAPIName__c != null){
                        mapper.set(c.MappingProperty__c, String.valueOf( s.get(c.FieldAPIName__c) ));    
                    } else{
                        mapper.set(c.MappingProperty__c, c.DefaultValue__c);      
                    }
                    
                }
                
            } 
            else{
                 List<sObject> sData = (List<sObject>)objectData.get(c.JSON_Object_Property__c);
                 for (  sObject sobj: sData ){
                    if (c.FieldAPIName__c != null){
                        mapper.set(c.JSON_Object_Property__c + '.' + c.MappingProperty__c, String.valueOf(sobj.get(c.FieldAPIName__c)) );
                    }
                                          
                }
            }                           
        }

        Logger.debug(mapper.toJson());         
        
        Logger.pop();
        return mapper.toJson();
    }
    
    /**
     * @description Query Salesforce Data Dymanically from CMT
     * @param Map of Salesforce object > JSON Object
     * @param Map of Salesforce object > parent Salesforce field
     * @param Map of Salesforce object > SOQL where clause
     * @param Map of Salesforce Query Fields by JSON Object
     * return Nested Map with List of sObject data
     */
    public static Map<String, List<sObject>> queryObjectData(   Map<String, String> objectMap,
                                                                Map<String, String> objectParentMap,
                                                                Map<String, String> objectWhereMap,
                                                                Map<String, Object> soqlQueryMap){
        Logger.push('queryObjectData', 'ExternalServicePayloadGenerator');
        
        Map<String, List<sObject>> returnMap = new Map<String, List<sObject>>(); // empty return map
       
        for  (String objectType : soqlQueryMap.keySet()){
            
            // Build main query
            String query = 'SELECT ' + soqlQueryMap.get(objectType)  + ' Id, LastModifiedDate FROM ' + objectMap.get(objectType) + ' WHERE '
                                    +  objectParentMap.get(objectMap.get(objectType)) + ' in: recordIdList ';
            
            // Add any additional where criteria        
            if ( objectWhereMap.get(objectType) != null) { query += ' AND ' + objectWhereMap.get(objectType); }

            // Query data
            Logger.debug('Query='+query);
            System.debug('XXX Query = '+query);
            List<sObject> queryData = Database.query(query); // Query Salesforce Data        
            returnMap.put(objectType, queryData); // Add to return map

            
        }
   
        Logger.pop();
        return returnMap;

    }

    /**
    * @description Get Map of Salesforce fields to JSON mapping property
    * @params none
    * @return Map of Salesforce Field Api names to Json property
    */
    public static Map<String, String> getFieldJsonMap(){
        Logger.push('getObjectToParent', 'ExternalServicePayloadGenerator');
        Map<String, String> returnMap = new Map<String, String>();
        for (ExternalServicesObjectFieldMapping__mdt c: cmt){
                if (c.FieldAPIName__c != null){
                    returnMap.put(c.FieldAPIName__c, c.MappingProperty__c);
                }
                
        }
        Logger.pop();
        return returnMap;
    }

    /**
    * @description Get Map of Salesforce Object API name to Parent Field API Name
    * @params none
    * @return Map of Salesforce Object Api Name to Parent Field API Name
    */
    public static Map<String, String> getObjectToParent(){
        Logger.push('getObjectToParent', 'ExternalServicePayloadGenerator');
        Map<String, String> returnMap = new Map<String, String>();
        for (ExternalServicesObjectFieldMapping__mdt c: cmt){

                returnMap.put(c.ObjectAPIName__c, c.ParentFieldAPIName__c);
        }


        Logger.pop();
        return returnMap;
    }

    /**
    * @description Get Map of JSON object to SOQL where critera
    * @params none
    * @return Map of JSON Object to SOQL where criteria
    */
    public static Map<String, String> getObjectWhereCriteria(){
        Logger.push('getObjectWhereCriteria', 'ExternalServicePayloadGenerator');
        Map<String, String> returnMap = new Map<String, String>();
        for (ExternalServicesObjectFieldMapping__mdt c: cmt){
                if (c.SOQLWhereCriteria__c != null){
                    returnMap.put(c.JSON_Object_Property__c, c.SOQLWhereCriteria__c);
                }
                
        }


        Logger.pop();
        return returnMap;
    }

    /**
    * @description Get Map of JSON Object API name to Salesforce Object
    * @params none
    * @return Map of JSON Object Property to Salesforce Object API Name
    */
    public static Map<String, String> getJSONObjectToObjectMap(){
        Logger.push('getPayloadData', 'ExternalServicePayloadGenerator');
        Map<String, String> jsonObjectMap = new Map<String, String>();
        for (ExternalServicesObjectFieldMapping__mdt c: cmt){
                jsonObjectMap.put(c.JSON_Object_Property__c, c.ObjectAPIName__c);
        }
        Logger.pop();
        return jsonObjectMap;
    }

    /**
     * @description generateSOQQueryMap - generate SOQL query fields from CMT dymanically
     * @return Map of Salesforce Fields for SOQL Queries
     */
    public static Map<String, Object> generateSOQLQueryMap(){
        Logger.push('generateSOQQueryMap', 'ExternalServicePayloadGenerator');
        Map<String, Object> dataMap = new Map<String, Object>();
        String queryString = '';
        String lastObject = null;
        String currentObject = null;

        for (ExternalServicesObjectFieldMapping__mdt c: cmt){
            if (c.FieldAPIName__c != null){
                
                currentObject = c.JSON_Object_Property__c;

                if (lastObject ==null && currentObject != null){
                    lastObject = c.JSON_Object_Property__c; 
                    queryString += c.FieldAPIName__c + ',';    
                    
                } else if (currentObject == lastObject){   
                    queryString += c.FieldAPIName__c + ',';  
                    lastObject = currentObject;
                    
                } else if (currentObject != lastObject){
                    queryString = c.FieldAPIName__c +',';
                    lastObject = currentObject;
                   
                }
                  
                dataMap.put(currentObject, queryString);
                
            }
    
        }
        
        System.debug('#### dataMap='+dataMap);
        Logger.debug('dataMap='+dataMap);

        Logger.pop();
        return dataMap;
    }

   
    /**
     * @description Insert External Service records
     * @param payload JSON string payload
     * @param serviceName String of Service name
     */
    private static List<Id> insertExternalServiceRecords(Map<Id, String> jsonPayloadMap, String serviceName){
        
        Logger.push('insertPayload','ExternalServicePayloadGenerator');
        
        List<Id> externalServiceIdList = new List<Id>();

        List<ExternalService__c> externalServiceInserts = new List<ExternalService__c>();

        for (Id recordId : jsonPayloadMap.keySet()){

                String jsonPayload = jsonPayloadMap.get(recordId);

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