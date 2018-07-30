/***********
**Author : Ravi Kiran
**Version : 1.0
**Purpose : capture/Save the exceptions into 'Error Log' Object
**Modified By : Nausad on 01/15/2018
**Modified By : Ravi on 01/23/2018
************/

public with sharing class Exception_log{
    
    public static void Log_exception(Exception ex,String ClassName,String MethodName){
        
        Error_Log__c ec = new Error_Log__c();
        ec.Running_User__c = Userinfo.getUserId();
        ec.Exception_Message__c = ex.getMessage();
        ec.Exception_type__c = '';
        ec.Entity_Name__c = ClassName;
        ec.Action_Name__c = MethodName;
        Database.insert(ec,false);
        sendEmail(ec.id);
        
    }
    public static void Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type){
        
        Error_Log__c ec = new Error_Log__c();
        ec.Running_User__c = Userinfo.getUserId();
        ec.Exception_Message__c = Message;
        ec.Exception_type__c = Type;
        ec.Entity_Name__c = ClassName;
        ec.Action_Name__c = MethodName;
        Database.insert(ec,false); 
    }
    
    public static void create_log(String ErrorMessage,String Type){
        Error_Log__c ec = new Error_Log__c();
        ec.Running_User__c = Userinfo.getUserId();
        ec.Exception_Message__c = ErrorMessage;
        ec.Exception_type__c = Type;
        Database.insert(ec,false);
        
    }
    
    public static void  sendEmail(String recId){
      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
           // string a=Label.Request_Calculator_Package_EmailID;
            sendTo.add(System.Label.EmailError);
            mail.setToAddresses(sendTo);
           // mail.setReplyTo(a);
            mail.setSubject('Issue with the system');
            String body ;             
            body='<html><body>'; 
            body+='<div> Somehing went wrong please find more details at '+recId+' </div>'; 
            body+=  '</body> </html>';      
            mail.setHtmlBody(body);
            mails.add(mail);Messaging.sendEmail(mails);
    
    }
    
}