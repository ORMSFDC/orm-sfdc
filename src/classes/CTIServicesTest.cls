@IsTest
public with sharing class CTIServicesTest {
    
    @IsTest
    public static void doPatchTest(){
        //List<TaskUpdateRequest> Tasklst = new List<TaskUpdateRequest>();
       /* Task TaskObj = new Task();
            //TaskObj.id=TaskRow.Id;
            TaskObj.CTI_Id__c = 'sdsd';
            TaskObj.Disposition__c = 'NOANSWER';
            TaskObj.Call_Duration_In_Seconds__c = 200.20;
            TaskObj.Call_Start_Time__c = (DateTime) JSON.deserialize('"2016-03-03T01:09:36.133"', DateTime.class);//getConvertDateTime('2017-05-27T06:55:43.511Z');
            TaskObj.Call_End_Time__c = (DateTime) JSON.deserialize('"2016-03-03T01:13:31.933"', DateTime.class); 
            TaskObj.Subject='Call';
            TaskObj.Status='New';
            TaskObj.Priority='Normal';
            TaskObj.CallType='Outbound';
               insert TaskObj;*/
        
        // List<Task> Tasks = new List<Task>();
        //Tasks.add(TaskObj);
       /* for(Task TaskObjdata:TaskObj )
        {
             TaskUpdateRequest  obj = new  TaskUpdateRequest();
             TaskRequest.Id = TaskObjdata.Id;
        TaskRequest.CTI_Id = TaskObjdata.CTI_Id__c;
        TaskRequest.Disposition = TaskObjdata.Disposition__c;
        TaskRequest.Call_Duration_In_Seconds = TaskObjdata.Call_Duration_In_Seconds__c;
        TaskRequest.Call_Start_Time = TaskObjdata.Call_Start_Time__c;
        TaskRequest.Call_End_Time = TaskObjdata.Call_End_Time__c;*/
        
        
        //Tasklst.add(TaskObj);
        string aa='[{\r\n                \"CTI_Id\": \"sdsd\",\r\n                \"Disposition\": \"NOANSWER\",  \r\n                \"Call_Duration_In_Seconds\": 200.20,\r\n                \"Id\": \"00TW000000HNNvOMAX\",\r\n                \"Call_Start_Time\" : \"2001-05-27T06:55:43.511Z\",\r\n                \"Call_End_Time\" : \"2012-05-27T06:55:43.511Z\"\r\n}]\r\n';
       // string Stringfy = json.serialize(aa);
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/Task';  
        req.httpMethod = 'PATCH';
        req.requestBody = blob.valueOf(aa);
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        //string result = CTIServices.doPatch();
        String results = CTIServices.doPatch();
        system.debug('CTIresults---------------' + results);
        
        
        
        /*CTIServices CTIServ = new CTIServices();
        CTIServices.TaskUpdateRequest TaskRequest = new CTIServies.doPatch();
        TaskRequest.TaskUpdateRequest.Id = TaskObj.Id;
        TaskRequest.TaskUpdateRequest.CTI_Id = TaskObj.CTI_Id__c;
        TaskRequest.TaskUpdateRequest.Disposition = TaskObj.Disposition__c;
        TaskRequest.TaskUpdateRequest.Call_Duration_In_Seconds = TaskObj.Call_Duration_In_Seconds__c;
        TaskRequest.TaskUpdateRequest.Call_Start_Time = TaskObj.Call_Start_Time__c;
        TaskRequest.TaskUpdateRequest.Call_End_Time = TaskObj.Call_End_Time__c;
        string Stringfy = json.serialize(TaskObj);  
        
        Test.startTest();
            CTIServices.doPatch();
        Test.stopTest();*/
        
    }

}