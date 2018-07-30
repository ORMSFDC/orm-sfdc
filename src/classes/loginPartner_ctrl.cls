/****Logic to create a task for AE whenever a user logs into Portal*****/

public without sharing class  loginPartner_ctrl {
    
    @AuraEnabled
    public static string create_task(){
               
      LoginHistory tsk = [SELECT Id,UserId,Logintime 
                          FROM LoginHistory 
                          WHERE  UserId=:userinfo.getUserId() 
                          ORDER BY LoginTime 
                          DESC limit 1];       
      
      user u =[SELECT contactId,contact.AccountId 
               FROM user 
               WHERE  id=:userinfo.getUserId()];
      
      Integer TaskCount = [SELECT count() 
                           FROM Task 
                           WHERE  userLoginId__c=:tsk.id]; //this count will limit the task creation
      
       
     Task t = new Task();

          if(TaskCount == 0 ){
               Account a  = new Account();
               try{  
                   a  = [SELECT name,Account_Executive_Name__c,Primary_Contact_Email__c,Primary_Contact_Phone_Number__c 
                         FROM Account 
                         WHERE id=:u.contact.AccountId];  
                }catch(Exception ex){}
                            
            String Partner_Name = a.Name;
            
            t.Subject = userinfo.getfirstname() + ' ' + userinfo.getlastname() +' from '+Partner_Name+' has logged into the portal' ;
            t.Status = 'Open';
            t.Priority = 'Normal';
            t.WhatId = a.id;
            t.userLoginId__c =  tsk.id;
            t.ActivityDate = Date.Today();
            t.OwnerId = a.Account_Executive_Name__c;
            t.WhoId = u.contactId;
            t.Last_login_Time__c = tsk.LoginTime;
            t.Description = userinfo.getfirstname() + ' ' + 'logged into Portal'+ ' ' + 'on' + ' ' + tsk.Logintime.format('MMMM d, yyyy')+ ' ' + 'at'
                            + ' ' + tsk.Logintime.format('hh:mm a')  + ('\n') + 'Primary Contact Email: ' + ' ' +  a.Primary_contact_Email__c + ('\n') + 
                            'Primary Contact Phone:' + ' ' + a.Primary_Contact_Phone_Number__c  ;
            insert t;
               
            }
            return t.id;
     }
}