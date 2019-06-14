/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface PS_Rollup_Engine {
    SObject getOrgDefaultSettings();
    List<SObject> performTriggerRollups(Map<Id,SObject> param0, Map<Id,SObject> param1, Boolean param2);
    void setRollupSetting(String param0, String param1, String param2, String param3, String param4);
}
