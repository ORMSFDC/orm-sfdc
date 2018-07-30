public class CTIServiceProviderHelperController {
    
    Public Static Boolean IsStandardObject(String sObjectName){
        Boolean IsStandard;
        try{
            // sObject types to describe
            String[] types = new String[]{sObjectName};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
            Schema.DescribeSobjectResult res = results[0];
            IsStandard =res.isCustom();
        }
        catch(Exception ex)
        {
            system.debug('catch Error'+ex.getMessage());
        }
        return IsStandard;
    }
    public static Task MakeTask() {
        Task t = new Task(); 
        t.TaskSubtype='Call';
        t.Status = 'Completed';
        t.SubjectType__c = 'Call';
        t.Priority = 'Normal';
        t.ActivityDate=System.today();
        return t;
    }
    public static Task MakeFollowUpTask() {
        Task t = new Task(); 
        t.TaskSubtype='Task';
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.ActivityDate=System.today();
        return t;
    }
    public static List < String > getselectOptions(sObject objObject, string fld) {
         List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        } 
        allOpts.sort();
        return allOpts;
    }
}