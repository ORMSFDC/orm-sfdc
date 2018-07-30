/**
*    File Name: DisplayTaskController.apxc
*    Description: Controller for DisplayTask Lightning Component(custom Task Comp)
*    Author: Bala Sahitya 
*    Modified By: 
***/


public without sharing class DisplayTaskController {
    @AuraEnabled
    public static List<Task> getTaskList(){

        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        system.debug('loggedInUser-----------'+loggedInUser);

        List<Task> taskList = [Select Id, Subject, ActivityDate, Status, Created_DateTime__c
                               From Task
                               Where OwnerId = :userId Limit 10
                              ];
        system.debug('taskList-----------'+taskList);

        return taskList;
    }
    
    @AuraEnabled
    public static list < Task > fetchTasks(String sortField, boolean isAsc) {
        Id userId = UserInfo.getUserId();
        User loggedInUser = [Select Id, Email, ProfileId From User Where Id = :userId];
        system.debug('loggedInUser-----------'+loggedInUser);
        String statusCompleted = 'Completed';

        String sSoql = 'SELECT Id, Subject, ActivityDate,Created_DateTime__c, Status , WhoId, WhatId, Who.Name, What.Name ';
        sSoql += 'From Task Where OwnerId = :userId And Status != \'' +String.escapeSingleQuotes(statusCompleted)+'\'';
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
        sSoql += ' LIMIT 10';

        System.debug('@Developer -->sSoql:' + sSoql);
        list <Task> lstResult;
        try {
            system.debug('The query is' + sSoql);
            lstResult = Database.query(sSoql);
            List < Task > returnTaskList = new List < Task > ();

            for (Task c: lstResult) {
                returnTaskList.add(c);
            }
            return returnTaskList;
        } catch (Exception ex) {
            return null;
        }
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
    public static List<Task> saveTaskStatus(String taskId, String status){
        system.debug('----------'+taskId);
        system.debug('----------'+status);
        Task taskRec = new Task();
        taskRec.Id = taskId;
        taskRec.Status = status;
        update taskRec;
        system.debug('----------'+taskRec);
        return fetchTasks('Created_DateTime__c', true);
    }
}