/**
 * @description: Display tasks with user required fields
 * @author: Sahitya
 * @date:  6/14/2018
 *
 * changelog:
 * 01/24/2019: Sahitya - added new method to fetch tasks based on Priority and Status
 */
public class DisplayPCSTaskController {
    //To fetch results for Created Date Time, Activity Date
    @AuraEnabled
    public static list < WrapperTaskLoanClass > fetchTasks(String sortField, boolean isAsc) {
        List<WrapperTaskLoanClass> wrapperTaskLoanClassList = new List<WrapperTaskLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        system.debug('loggedInUser-----------'+loggedInUser);
        String statusCompleted = 'Completed';
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name, Followup_Task__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\' AND Followup_Task__c = true ';
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        // set record limit to query
        sSoql += ' LIMIT 30';

        System.debug('@Developer -->sSoql:' + sSoql);
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c,Client_Name__c, Subject_Property_State__c , Anticipated_Closing_Date__c , loanstatus__c 
            FROM Loan_New__c 
        ]);
        system.debug('loanMap-----------'+loanMap);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperTaskLoanClass wrapperObj = new  WrapperTaskLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   
   public class WrapperTaskLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getTaskStatus(){
        List<String> taskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                taskStatusList.add(f.getValue());
            }
        }
        system.debug('taskStatusList-->'+ taskStatusList);
        return taskStatusList;
    }    
    
    @AuraEnabled
    public static List<WrapperTaskLoanClass> saveTaskStatus(String taskId, String status){
        system.debug('----------'+taskId);
        system.debug('----------'+status);
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        system.debug('----------'+taskRec);
        return fetchTasks('Created_DateTime__c', true);        
    }
    
    //Added to sort Due Time - New
    @AuraEnabled
    public static List<WrapperTaskLoanClass> saveTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        system.debug('$$$$-'+taskRec);
        return fetchTasks('ActivityDate', true);
    }
    
    /**********************Intitial Tasks************************************/
    
    @AuraEnabled
    public static list < WrapperInitialTaskLoanClass > fetchInitialTasks(String sortField, boolean isAsc) {
        List<WrapperInitialTaskLoanClass> wrapperTaskLoanClassList = new List<WrapperInitialTaskLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        String statusCompleted = 'Completed';
        String taskGroup = 'Conditionally Approved';
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name, Task_Grouping__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\' AND Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup)+'\' ';
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        sSoql += ' LIMIT 30';
        
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c, Subject_Property_State__c , Client_Name__c, Anticipated_Closing_Date__c , loanstatus__c 
            FROM Loan_New__c 
        ]);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperInitialTaskLoanClass wrapperObj = new  WrapperInitialTaskLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   public class WrapperInitialTaskLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getInitialTaskStatus(){
        List<String> InitialtaskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                InitialtaskStatusList.add(f.getValue());
            }
        }
        return InitialtaskStatusList;
    }    
        
    @AuraEnabled
    public static List<WrapperInitialTaskLoanClass> saveInitialTaskStatus(String taskId, String status){
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchInitialTasks('Created_DateTime__c', true);        
    }
    
    @AuraEnabled
    public static List<WrapperInitialTaskLoanClass> saveInitialTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchInitialTasks('ActivityDate', true);
    }
    
    /******************************************************Final Goals Calls*********************************************************/
    
     @AuraEnabled
    public static list < WrapperFinalTaskLoanClass > fetchFinalTasks(String sortField, boolean isAsc) {
        List<WrapperFinalTaskLoanClass> wrapperTaskLoanClassList = new List<WrapperFinalTaskLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        String statusCompleted = 'Completed';
        String taskGroup = 'UW clear to close Task';
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name, Task_Grouping__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\' AND Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup)+'\' ';
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        sSoql += ' LIMIT 30';
        
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c, Subject_Property_State__c ,Client_Name__c, Anticipated_Closing_Date__c , loanstatus__c 
            FROM Loan_New__c 
        ]);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperFinalTaskLoanClass wrapperObj = new  WrapperFinalTaskLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   public class WrapperFinalTaskLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getFinalTaskStatus(){
        List<String> FinaltaskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                FinaltaskStatusList.add(f.getValue());
            }
        }
        return FinaltaskStatusList;
    }    
        
    @AuraEnabled
    public static List<WrapperFinalTaskLoanClass> saveFinalTaskStatus(String taskId, String status){
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchFinalTasks('Created_DateTime__c', true);        
    }
    
    @AuraEnabled
    public static List<WrapperFinalTaskLoanClass> saveFinalTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchFinalTasks('ActivityDate', true);
    }
    
    /********************************************Priority Loans*****************************************************************************************/
    @AuraEnabled
    public static list < WrapperPriorityLoanClass > fetchPriorityTasks(String sortField, boolean isAsc) {
        List<WrapperPriorityLoanClass> wrapperTaskLoanClassList = new List<WrapperPriorityLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        String statusCompleted = 'Completed';
        String taskGroup1 = 'Counseling Date Expiration Task';
        String taskGroup2 = 'Appraisal Expiration Task';
        String taskGroup3 = 'FHA Case Number Expiration Task';
        String taskGroup4 = 'Payoff Expiration Task';
        String taskGroup5 = 'Credit Date Expiration Task';
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name, Task_Grouping__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\'   ';
        sSoql += ' AND  ((Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup1)+'\') OR (Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup2)+'\') OR (Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup3)+'\') OR (Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup4)+'\') OR (Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup5)+'\')) ';
        
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        sSoql += ' LIMIT 30';
        
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c, Subject_Property_State__c ,Client_Name__c, Anticipated_Closing_Date__c , loanstatus__c 
            FROM Loan_New__c 
        ]);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperPriorityLoanClass wrapperObj = new  WrapperPriorityLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   public class WrapperPriorityLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getPriorityTaskStatus(){
        List<String> PrioritytaskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                PrioritytaskStatusList.add(f.getValue());
            }
        }
        return PrioritytaskStatusList;
    }    
        
    @AuraEnabled
    public static List<WrapperPriorityLoanClass> savePriorityTaskStatus(String taskId, String status){
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchPriorityTasks('Created_DateTime__c', true);        
    }
    
    @AuraEnabled
    public static List<WrapperPriorityLoanClass> savePriorityTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchPriorityTasks('ActivityDate', true);
    }
    
    /************************Documents Uploaded Tasks**************************/
    
    @AuraEnabled
    public static list < WrapperDocTaskLoanClass > fetchDocTasks(String sortField, boolean isAsc) {
        List<WrapperDocTaskLoanClass> wrapperTaskLoanClassList = new List<WrapperDocTaskLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        String statusCompleted = 'Completed';
        String taskGroup = 'Document Task';
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name, Task_Grouping__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\' AND Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup)+'\' ';
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        sSoql += ' LIMIT 30';
        
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c, Subject_Property_State__c , Client_Name__c,Anticipated_Closing_Date__c , loanstatus__c 
            FROM Loan_New__c 
        ]);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperDocTaskLoanClass wrapperObj = new  WrapperDocTaskLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   public class WrapperDocTaskLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getDocTaskStatus(){
        List<String> DoctaskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                DoctaskStatusList.add(f.getValue());
            }
        }
        return DoctaskStatusList;
    }    
        
    @AuraEnabled
    public static List<WrapperDocTaskLoanClass> saveDocTaskStatus(String taskId, String status){
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchDocTasks('Created_DateTime__c', true);        
    }
    
    @AuraEnabled
    public static List<WrapperDocTaskLoanClass> saveDocTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchDocTasks('ActivityDate', true);
    }
    
    /****************************************Notes Task********************************************************/
    
     @AuraEnabled
    public static list < WrapperNotesTaskLoanClass > fetchNotesTasks(String sortField, boolean isAsc) {
        List<WrapperNotesTaskLoanClass> wrapperTaskLoanClassList = new List<WrapperNotesTaskLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        String statusCompleted = 'Completed';
        String taskGroup = 'Notes Task';
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name, Task_Grouping__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\' AND Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup)+'\' ';
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        sSoql += ' LIMIT 30';
        
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c, Subject_Property_State__c , Client_Name__c,Anticipated_Closing_Date__c , loanstatus__c 
            FROM Loan_New__c 
        ]);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperNotesTaskLoanClass wrapperObj = new  WrapperNotesTaskLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   public class WrapperNotesTaskLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getNotesTaskStatus(){
        List<String> NotesTaskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                NotestaskStatusList.add(f.getValue());
            }
        }
        return NotestaskStatusList;
    }    
        
    @AuraEnabled
    public static List<WrapperNotesTaskLoanClass> saveNotesTaskStatus(String taskId, String status){
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchNotesTasks('Created_DateTime__c', true);        
    }
    
    @AuraEnabled
    public static List<WrapperNotesTaskLoanClass> saveNotesTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchNotesTasks('ActivityDate', true);
    }
    
    /***************************************Condition Task*******************************************************************************/
    
    @AuraEnabled
    public static list < WrapperConditionTaskLoanClass > fetchConditionTasks(String sortField, boolean isAsc) {
        List<WrapperConditionTaskLoanClass> wrapperTaskLoanClassList = new List<WrapperConditionTaskLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        String statusCompleted = 'Completed';
        String taskGroup = 'Condition Task';
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name, Task_Grouping__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\' AND Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup)+'\' ';
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        sSoql += ' LIMIT 30';
        
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c, Subject_Property_State__c , Client_Name__c,Anticipated_Closing_Date__c , loanstatus__c 
            FROM Loan_New__c 
        ]);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperConditionTaskLoanClass wrapperObj = new  WrapperConditionTaskLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   public class WrapperConditionTaskLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getConditionTaskStatus(){
        List<String> ConditionTaskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                ConditiontaskStatusList.add(f.getValue());
            }
        }
        return ConditiontaskStatusList;
    }    
        
    @AuraEnabled
    public static List<WrapperConditionTaskLoanClass> saveConditionTaskStatus(String taskId, String status){
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchConditionTasks('Created_DateTime__c', true);        
    }
    
    @AuraEnabled
    public static List<WrapperConditionTaskLoanClass> saveConditionTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchConditionTasks('ActivityDate', true);
    }
    
    
    /************************************Aged Loans*****************************************************************/
    
    @AuraEnabled
    public static list < WrapperAgedTaskLoanClass > fetchAgedTasks(String sortField, boolean isAsc) {
        List<WrapperAgedTaskLoanClass> wrapperTaskLoanClassList = new List<WrapperAgedTaskLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        String statusCompleted = 'Completed';
        String taskGroup = 'Aged Task';
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name, Task_Grouping__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\' AND Task_Grouping__c = \'' +String.escapeSingleQuotes(taskGroup)+'\' ';
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        sSoql += ' LIMIT 30';
        
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c, Subject_Property_State__c , Client_Name__c,Anticipated_Closing_Date__c , loanstatus__c 
            FROM Loan_New__c 
        ]);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperAgedTaskLoanClass wrapperObj = new  WrapperAgedTaskLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   public class WrapperAgedTaskLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getAgedTaskStatus(){
        List<String> AgedtaskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                AgedtaskStatusList.add(f.getValue());
            }
        }
        return AgedtaskStatusList;
    }    
        
    @AuraEnabled
    public static List<WrapperAgedTaskLoanClass> saveAgedTaskStatus(String taskId, String status){
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchAgedTasks('Created_DateTime__c', true);        
    }
    
    @AuraEnabled
    public static List<WrapperAgedTaskLoanClass> saveAgedTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return fetchAgedTasks('ActivityDate', true);
    }

    /************************Sort by priority Tasks**************************/
    
    @AuraEnabled
    public static list < WrapperpriTaskLoanClass > prioritySortTasks(String sortField, boolean isAsc) {
        List<WrapperpriTaskLoanClass> wrapperTaskLoanClassList = new List<WrapperpriTaskLoanClass>();
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        String statusCompleted = 'Completed';
        
 
        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Priority, Status , WhoId, WhatId, Who.Name, What.Name, Task_Grouping__c ';
        sSoql += 'From Task Where what.type = \'Loan_New__c\' AND OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\' ';
        system.debug('sortField-->' + sortField);

        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' desc';
            } else {
                sSoql += ' asc';
            }
        }
        sSoql += ' LIMIT 30';
        
        List < Task > returnTaskList = new List < Task > ();
        returnTaskList = Database.query(sSoql);
        Set<Id> loanIdSet = new Set<Id>();
        
        Schema.DescribeFieldResult fieldResult = Loan_New__c.loanstatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }  
        
        for (Task c: returnTaskList) {
            loanIdSet.add(c.WhatId);
        }
        Map<ID, Loan_New__c> loanMap = new Map<ID, Loan_New__c>([
            SELECT Id, LoanNumber__c, Client_Name__c, loanstatus__c 
            FROM Loan_New__c 
        ]);
        for (Task c: returnTaskList) {
            if(loanMap.containsKey(c.WhatId)){
                WrapperpriTaskLoanClass wrapperObj = new  WrapperpriTaskLoanClass ();
                wrapperObj.task = c;
                wrapperObj.loan = loanMap.get(c.WhatId);                
                wrapperObj.loanStatus = valueLabelMap.get(loanMap.get(c.WhatId).loanstatus__c);
                wrapperTaskLoanClassList.add(wrapperObj);  
            }
        }        
        return wrapperTaskLoanClassList;       
   }   
   public class WrapperpriTaskLoanClass{
        @AuraEnabled public Task task{get;set;}
        @AuraEnabled public Loan_New__c loan{get;set;}
        @AuraEnabled public String loanStatus{get;set;}
    }
   
    @AuraEnabled
    public static List<String> getpriTaskStatus(){
        List<String> DoctaskStatusList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Task.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if(!f.getValue().isNumeric()) {
                DoctaskStatusList.add(f.getValue());
            }
        }
        return DoctaskStatusList;
    }    
        
    @AuraEnabled
    public static List<WrapperpriTaskLoanClass> savepriTaskStatus(String taskId, String status){
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return prioritySortTasks('Created_DateTime__c', true);        
    }
    
    @AuraEnabled
    public static List<WrapperpriTaskLoanClass> savepriTaskStatus2(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return prioritySortTasks('ActivityDate', true);
    }

    @AuraEnabled
    public static List<WrapperpriTaskLoanClass> savepriTaskStatus3(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return prioritySortTasks('Priority', true);
    }

    @AuraEnabled
    public static List<WrapperpriTaskLoanClass> savepriTaskStatus4(String taskId, String status){        
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        return prioritySortTasks('Status', true);
    }
}