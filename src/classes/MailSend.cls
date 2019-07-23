public with sharing class MailSend {
  
    @AuraEnabled
    public static void SendMail2Partnernew(String LoanID,String getUsername, String getUserEmailID)
    {
           Logger.push('SendMail2Partnernew', 'MailSend');
        try
        {
            EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body, Markup FROM EmailTemplate where 
                                      Name='Communities Partner Email' ];
            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
           // string a=Label.Request_Calculator_Package_EmailID;
            sendTo.add(getUserEmailID);
            mail.setToAddresses(sendTo);
            mail.setReplyTo(System.Label.Orm_support1);
            mail.setSubject('Reverse Mortgage Application Submitted Successfully');
            String body =  template.HtmlValue ;    
            body =  body.replace('#name',getUsername).replace('#Loan_Id',LoanID);        
             
            mail.setHtmlBody(body);
            mails.add(mail);Messaging.sendEmail(mails);
        }        
        catch(Exception ex)
        {
             Exception_log.Create_Custom_Logs(ex.getMessage(),'Mail Send','SendMail2Partnernew','Date'+System.today());
             system.debug('SendMail2Partnernew--Exception---'+ex);
        }
        Logger.Pop();
    }
    
    
    @AuraEnabled
    public static void SendMail2ORMnew(String LoanID,String getUsername, String getUserEmailID)
    {
        try
        {
            EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body, Markup FROM EmailTemplate where Name='Communities ORM Team Template' ];
            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            string a=Label.Request_Calculator_Package_EmailID;
            sendTo.add(a);
            mail.setToAddresses(sendTo);
            mail.setReplyTo(getUserEmailID);
            mail.setSubject('Reverse Mortgage Application Submitted.');
            String body =  template.HtmlValue ;    
            body =   body.replace('#name',getUsername).replace('#Loan_Id',LoanID);        
           	mail.setHtmlBody(body);
            mails.add(mail);Messaging.sendEmail(mails);
        }        
        catch(Exception ex)
        {
            system.debug('SendMail2ORMnew--Exception---'+ex);
        }
    }
}