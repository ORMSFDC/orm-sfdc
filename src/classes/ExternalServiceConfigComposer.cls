/**
* @description Compose External Service Config based on Custom Metadata
*
* @author Mike Gill
* @date 14th May 2018
*
* changelog: Sprint 5 - Refactor for dynamic Payload Generator & Credit Report
*
*/
public without sharing class ExternalServiceConfigComposer {
    
    /**
     * @description Returns List of custom metadata filtered by External Service Type
     * @param  esType String of Service Type (e.g. Amrock)
     * @return List of ExternalServicesObjectFieldMapping__mdt
     */
    public static List<ExternalServicesObjectFieldMapping__mdt> getExternalServiceMapping(String esType){
        return (List<ExternalServicesObjectFieldMapping__mdt>)[
           SELECT Id, DeveloperName, 
                        FieldAPIName__c,
                        ObjectAPIName__c,
                        ParentFieldAPIName__c,
                        DefaultValue__c,
                        MappingProperty__c,
                        JSON_Object_Property__c,
                        JSON_Parent_Object_Property__c,
                        Order__c,
                        SOQLWhereCriteria__c

            FROM ExternalServicesObjectFieldMapping__mdt WHERE ServiceName__c =: esType order by Order__c desc
        ];
    }

    /**
     * @description Returns List of External Service Registery
     * @param  esType String of Service Type (e.g. Amrock)
     * @return List of ExternalServiceRegistry__mdt
     */
    public static List<ExternalServiceRegistry__mdt> getExternalServices(String esType){
        return (List<ExternalServiceRegistry__mdt>)[
           SELECT Id, DeveloperName, 
                        NamedCredential__c,
                        ExternalServiceClass__c
           FROM ExternalServiceRegistry__mdt
           WHERE DeveloperName =: esType
           AND IsActive__c = TRUE
        ];
    }

     /**
    * @Description  Generate Set Field API Names ***W50-S3**** @TODO 
    */
    public static Map<String, Map<String, String>> getFieldObjectAPIs(List<ExternalServicesObjectFieldMapping__mdt> cmt, Boolean outputJSONMap){
        Logger.push('getFieldObjectAPIs', 'ExternalServiceConfigComposer');
        Map<String, Map<String, String>> mainMap = new Map<String, Map<String,String>>(); 
        
        //Generate list of field API names
        for(ExternalServicesObjectFieldMapping__mdt esc : cmt){
            
            if (esc.FieldAPIName__c!=null){

                Map<String, String> innerMap = mainMap.containsKey( esc.ObjectAPIName__c ) ? mainMap.get( esc.ObjectAPIName__c ) : new Map<String, String>();
                if (!outputJSONMap) {
                    innerMap.put( esc.FieldAPIName__c, esc.ParentFieldAPIName__c != null ? esc.ParentFieldAPIName__c :  esc.FieldAPIName__c);
                }   
                else {
                    innerMap.put( esc.FieldAPIName__c, esc.MappingProperty__c != null ? esc.MappingProperty__c :  esc.JSON_Object_Property__c);
                }
                
                mainMap.put( esc.ObjectAPIName__c, innerMap );
            
                   
            }
            
        }
        //Logger.debug('mainMap='+mainMap);
        Logger.pop();
        return mainMap;

    }

    /**
    * @Description  Generate Set Field API Names
    * @author Mike Gill
    * @param cmt List of custom metadata
    * @return Set of String for Field API names
    */
    public static Set<String> getFieldAPIs(List<ExternalServicesObjectFieldMapping__mdt> cmt){
        
        Set<String> esFieldsAPIs = new Set<String>();
        
        //Generate list of field API names
        for(ExternalServicesObjectFieldMapping__mdt esc : cmt){
            
            if (esc.FieldAPIName__c!=null){
                    esFieldsAPIs.add(esc.FieldAPIName__c);
            }
            
        }

        return esFieldsAPIs;

    }

    /**
    * @Description  Generate Query using Set of Field API names got from ExternalServicesObjectFieldMapping__mdt metadata
    * @author Mike Gill
    * @param fieldAPISs Set of Field API names
    * @param objectAPIName String of Object API Name
    * @return Returns query string (e.g. SELECT Id, CustomField__c FROM CustomObject__c)
    */
    public Static String composeQuery(Set<String> fieldAPIs, String objectAPIName){
        String queryFields;
        String query;
        for(String fieldAPI : fieldAPIs){
            if(queryFields == null){
                queryFields = fieldAPI+','; 
            }
            else{
                queryFields+=fieldAPI+',';
            }
        }
        if(queryFields != null){
            query = 'SELECT Id, '+queryFields.substring(0,queryFields.length()-1) + ' FROM ' + objectAPIName;
        }
        return query;
    }

    public static String getAllFieldQueryString(String objectAPIName){

        String[] types = new String[]{objectAPIName};
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        String queryString = '';

        for (Schema.DescribeSobjectResult res : results){

            Map<String, Schema.SObjectField> objfieldMap = res.sObjectType.getDescribe().fields.getMap();
             for(Schema.SObjectField Field : objfieldMap.Values())
                {
                    Schema.DescribeFieldResult fieldResult = Field.getDescribe();
                    queryString += fieldResult.getName() + ',';
                }
 
                queryString = queryString.substring(0, queryString.length()-1);

        }
       
       
        return queryString;

    }

     public static Map<Id, SObject> getSobjectDataFromIdList(List<Id> listOfIds){
        Logger.push('returnSobjectDataFromIdList','ExternalServiceConfigComposer');
        Schema.SObjectType objectAPIName = listOfIds[0].getSObjectType(); 
        String queryFields = ExternalServiceConfigComposer.getAllFieldQueryString(String.valueOf(objectAPIName));
        //Logger.debug(queryFields);
        String queryStr = 'SELECT ' + queryFields + ' FROM ' + objectAPIName + ' WHERE Id in: listOfIds';
        List<SObject> sobjectList = Database.query(queryStr);
        Map<Id, Sobject> sObjectMap = new Map<Id, SObject>(sobjectList);
        Logger.pop();
        return sObjectMap;
        

    }
    

    
}