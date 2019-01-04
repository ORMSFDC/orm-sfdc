/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ParentUtil implements rh2.PS_Rollup_Engine {
    global static Boolean rhxInstalled;
    global ParentUtil() {

    }
    global static void UpsertRollupTestRecords(List<SObject> sourceList) {

    }
    global List<SObject> enterRollupHelperWithCorrectContext(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, List<String> objNames) {
        return null;
    }
    global List<SObject> enterRollupHelperWithCorrectContext(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, String objName) {
        return null;
    }
    global List<String> getAllActiveRollupSettingsForTargetObject(String targetObjectType) {
        return null;
    }
    global SObject getOrgDefaultSettings() {
        return null;
    }
    global String getRollupSetting(Map<String,Object> params) {
        return null;
    }
    global Map<String,SObject> getRollupSettings() {
        return null;
    }
    global List<rh2.PS_Rollup_Context> getRollups(List<String> sourceObjs) {
        return null;
    }
    global Boolean isString(String fieldType) {
        return null;
    }
    global static List<SObject> performRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap) {
        return null;
    }
    global static List<SObject> performRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, Boolean async) {
        return null;
    }
    global List<SObject> performTriggerRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, Boolean async) {
        return null;
    }
    global List<SObject> performTriggerRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, List<String> objNames, Boolean async) {
        return null;
    }
    global List<SObject> performTriggerRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, String objName, Boolean async) {
        return null;
    }
    global void prepareTriggerRollups(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, List<String> objNames, Boolean async) {

    }
    global Boolean rollupSettingsExist() {
        return null;
    }
    global static List<SObject> setParentValues(List<SObject> recs) {
        return null;
    }
    global void setRollupSetting(String targetField, String sourceField, String relField, String rangeField, String logic) {

    }
    global void setRollupSettingCondition(rh2__Date_Sync__c ds, String field, String logic, String parameter) {

    }
    global Map<String,rh2__Date_Sync__c> setRollupSettings(Map<String,rh2__Date_Sync__c> insertMe) {
        return null;
    }
}
