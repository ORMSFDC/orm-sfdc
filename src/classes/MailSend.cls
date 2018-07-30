public class MailSend {
  
    @AuraEnabled
    public static void SendMail2Partnernew(String LoanID,String getUsername, String getUserEmailID)
    //public static void SendMail2Partnernew(String LoanID)
    {
        try
        {
            EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body, Markup FROM EmailTemplate where 
                                      Name='Communities Partner Email' ];
            
            //String getUsername =UserInfo.getName();    
            //String getUserEmailID =UserInfo.getUserEmail();
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
           mail.setOrgWideEmailAddressId(System.Label.Orm_support);
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
    }
    
    //new mrthods//
    
    @AuraEnabled
    public static void SendMail2ORMnew(String LoanID,String getUsername, String getUserEmailID)
   // public static void SendMail2ORMnew(String LoanID)
    {
        try
        {
            //String getUsername =UserInfo.getName();    
            //String getUserEmailID =UserInfo.getUserEmail();
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