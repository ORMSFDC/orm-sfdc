@RestResource(urlMapping='/Task/*')
global with sharing class CTIServices {
    @HttpPatch
    global static string doPatch() {
        String ResponeString;
        Set<Id> TaskIds = new Set<Id>();
        List<Task> TaskList = new List<Task>(); 
        list<TaskResponse> res=new list<TaskResponse>();
        //try{ 
        List<TaskUpdateRequest>  TaskUpdateRequestList = (List<TaskUpdateRequest>)JSON.deserializeStrict(
            RestContext.request.requestBody.toString(), List<TaskUpdateRequest>.class);
        for(TaskUpdateRequest TaskRow:TaskUpdateRequestList)
        {
            Task TaskObj = new Task();
            TaskObj.id=TaskRow.Id;
            TaskObj.CTI_Id__c = TaskRow.CTI_Id;
            TaskObj.Disposition__c = TaskRow.Disposition;
            TaskObj.Call_Duration_In_Seconds__c = TaskRow.Call_Duration_In_Seconds;
            TaskObj.Call_Start_Time__c = TaskRow.Call_Start_Time;
            TaskObj.Call_End_Time__c = TaskRow.Call_End_Time; 
            TaskList.add(TaskObj);
        }
        Database.SaveResult[] srList = Database.update(TaskList, false); 
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    TaskResponse resobj=new TaskResponse();
                    string ErrorMessage= err.getMessage();
                    resobj.Id=sr.getId();
                    resobj.Success=false;
                    resobj.Message=ErrorMessage; 
                    res.add(resobj);
                }
            }
            else{
                TaskResponse resobj=new TaskResponse();
                resobj.Id=sr.getId();
                resobj.Success=true;
                resobj.Message='Success'; 
                res.add(resobj);
            } 
        } 
        ResponeString = json.serialize(res);
        /* }
        catch(exception ex)
        {
        TaskResponse resobj=new TaskResponse();
        resobj.Id='';
        resobj.Success=false;
        resobj.Message='Parsing error';
        res.add(resobj);
        ResponeString = json.serialize(res);
        }*/
        return ResponeString;
    }
    
   global with sharing  class TaskUpdateRequest
    {
        public ID Id{get;set;}
        public string CTI_Id{get;set;}
        public string Disposition{get;set;}
        public decimal Call_Duration_In_Seconds{get;set;}
        public Datetime Call_Start_Time{get;set;}
        public Datetime Call_End_Time{get;set;}
    }
    public class TaskResponse
    {
        public ID Id{get;set;}
        public boolean Success{get;set;}
        public string Message{get;set;}
        
    }
}