global class CTIServiceProviderController {
    @AuraEnabled
    public static String getUserName() {
        return userinfo.getName();
    }
    @auraenabled
    public static List<String> getPickList(){
        sObject objName=new Task();
        List<String> objResults = new List<String>();
        objResults=CTIServiceProviderHelperController.getselectOptions(objName , 'Status');
        return objResults;
    }
    
     @auraenabled
    public static List<String> getSubjectTypePickList(){
        sObject objName=new Task();
        List<String> objResults = new List<String>();
        objResults=CTIServiceProviderHelperController.getselectOptions(objName , 'SubjectType__c');
        return objResults;
    }
    
    @auraenabled
    public static void UpdateTaskDetails(ID RecordID,String TaskId,String TaskData) {
        try{
            CTIRequestData  CTIReqObj = (CTIRequestData)JSON.deserialize(TaskData, CTIRequestData.class);
             Task tsk =  new Task(); 
            tsk.Id=TaskId;
            tsk.Subject=CTIReqObj.Subject;
             if(CTIReqObj.SubjectType=='' || CTIReqObj.SubjectType==null)
                {}
                else{
                     tsk.SubjectType__c=CTIReqObj.SubjectType;
                }
           
            tsk.Description=CTIReqObj.Comments;
            tsk.Create_Follow_up_task__c=CTIReqObj.CreateFollowUp_Task;
            if(CTIReqObj.CreateFollowUp_Task=='NO'){
                tsk.Note__c= CTIReqObj.FollowUp_Notes;
            }
            else{tsk.Note__c='';}
            update tsk;
            if(CTIReqObj.CreateFollowUp_Task=='YES'){
                Task followUptsk = CTIServiceProviderHelperController.MakeFollowUpTask();
                if(CTIReqObj.FollowUp_DueDate!=null)
                {
                    followUptsk.ActivityDate=CTIReqObj.FollowUp_DueDate;
                }
                followUptsk.Subject=CTIReqObj.FollowUp_Subject;
                if(CTIReqObj.FollowUp_Status=='' || CTIReqObj.FollowUp_Status==null)
                {}
                else{
                    followUptsk.Status=CTIReqObj.FollowUp_Status;
                }
                followUptsk.Description=CTIReqObj.FollowUp_Comments;
                followUptsk.IsReminderSet=CTIReqObj.FollowUp_Reminder;
                followUptsk.ReminderDateTime=CTIReqObj.FollowUp_ReminderDatetime;
                 CTIResponse FollowCTIResponse=GenerateTask(RecordID,followUptsk);
            }
            
        }
        catch(Exception ex)
        {
            system.debug('catch Error'+ex.getMessage());
        }
    }
    @auraenabled
    public static String getTaskDetails(ID RecordID) {
        CTIResponse returndata = new CTIResponse();
        Task tsk = CTIServiceProviderHelperController.MakeTask();
        returndata=GenerateTask(RecordID,tsk);
         return JSON.serializePretty(returndata, true);
    }
    //Generate Task 
    public static CTIResponse GenerateTask(ID RecordID,Task tsk) {
        CTIResponse result = new CTIResponse();
        String sObjName;
        try{
            sObjName = RecordID.getSObjectType().getDescribe().getName();
            if(sObjName!=''){
                If(CTIServiceProviderHelperController.IsStandardObject(sObjName))
                {
                    //generic task for Custom Object(WhatID)
                    result.TaskID =GenericTask_ForWhatID(RecordID,tsk);
                }
                //Sandard Object
                else{
                    //For whoID
                    if(sObjName.toLowerCase()=='lead' || sObjName.toLowerCase()=='contact' )
                    {
                        result.TaskID = GenericTask_ForWhoID(RecordID,sObjName,tsk);
                    }
                    else if(sObjName.toLowerCase()=='opportunity' )
                    {
                        result.TaskID = OpportunityTask(RecordID,tsk);
                    } 
                    //generic task for Standard Object(WhatID) 
                    else
                    {
                        result.TaskID = GenericTask_ForWhatID(RecordID,tsk);
                    }
                    
                }
                
            }
        }
        catch(Exception ex)
        {
            system.debug('catch Error'+ex.getMessage());
        }
        return  result;
    }
    //End Generate Task
    // Create Task for Standard Object and Custom Object (WhatId)
    public static String GenericTask_ForWhatID(String WhatId,Task tskObj) {
        Task tsk = tskObj;
        try{
            tsk.WhatId=WhatId; 
            insert tsk;
        }
        catch(Exception ex)
        {
            system.debug('catch Error'+ex.getMessage());
        }
        return tsk.Id;
    } 
    // Create Task for Lead and contact (whoId)
    public static String GenericTask_ForWhoID(String WhoId,String sObjName,Task tskObj) {
        Task tsk = tskObj;
        try{
            tsk.WhoId=WhoId;  
            if(sObjName.toLowerCase()=='contact')
            {
                tsk.WhatId=[select accountId from contact where id=:WhoId].Accountid;
            }
            insert tsk;
        }
        catch(Exception ex)
        {
            system.debug('catch Error'+ex.getMessage());
        }
        return tsk.Id;
    } 
    //Set Task for Opportunity Object
    public  static String OpportunityTask(String RecordID,Task tskObj) {
        Task tsk = tskObj;
        try{
            ID opportunityRecordTypeID_Loan_Officer = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Portal User Onboarding').getRecordTypeId();
            opportunity obj= [SELECT Loan_Officer_Name__c, recordtypeid FROM Opportunity WHERE Id = :RecordID];
            If(opportunityRecordTypeID_Loan_Officer==obj.recordtypeid)
            { 
                 if(!String.isEmpty(obj.Loan_Officer_Name__c))
                {
                    tsk.Loan_Officer__c=obj.Loan_Officer_Name__c;
                }          
            } 
            tsk.WhatId =RecordID ; 
            insert tsk;
        }
        
        catch(Exception ex)
        {
            system.debug('catch Error'+ex.getMessage());
        }
        return tsk.Id;
    } 
}