public class LoanDateController {
    
    @AuraEnabled
    public static string getFNMData(Blob filedata, String fileName, String base64Data, String contentType, String applicationDate,String rateType,String loanMortgageAppliedFor) {
        id loanid;
         try{
        //Call fannie mae parser and map response details to loan object
        FNMResponse fnmResponse = FNMParseService.parseFNM(filedata);
        //Code Modified by Dev4 for ORMSFDC-1471
        system.debug('Date.valueOf(applicationDate)' +Date.valueOf(applicationDate));
        Loan_New__c loan = FNMMapperService.createLoanFromFNMResponse(fnmResponse, Date.valueOf(applicationDate),rateType,loanMortgageAppliedFor);
        //Code Ended by Dev4 for ORMSFDC-1471
        loanid = loan.id;
        String LoanIDName = [select Name from Loan_New__c where id=: loanid].Name;
        //MailSend.SendMail2ORM(LoanIDName);
        //MailSend.SendMail2Partner(LoanIDName);
       
         }
        
        catch(exception e)
{
system.debug('getFNMData--Exception---'+e);

} 
         saveTheFile(loanid, fileName,  base64Data,  contentType);return loanid;
    }
    
    @AuraEnabled
    public static  void saveTheFile(Id LoanID, String fileName, String base64Data, String contentType) {
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Attachment a = new Attachment();
            a.parentId = LoanID;
            a.Body = EncodingUtil.base64Decode(base64Data);
            a.Name = fileName;
            a.ContentType = contentType;
            insert a;
        }
        catch(exception e){ system.debug('saveTheFile--Exception---'+e);}
    }
    
    @AuraEnabled
    public static void sendEmail(String filename,string fileData){
        System.debug('fileData '+fileData);
       user u = [select contact.Account.ORM_Account_Executive_Email__c,contact.Account.Account_Executive_Name__r.Name,contact.Account.Account_Executive_Name__r.Email from user where id=:userinfo.getUserId() ];
      List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
                      
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();

                    List<String>toAddresses = new List<String>();
               toAddresses.add(u.contact.Account.ORM_Account_Executive_Email__c);
        toAddresses.add(System.Label.Orm_support1);
            System.debug('userinfo.getUserId()  -->'+userinfo.getUserId());
                      
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setSubject('An existing package has been uploaded');
                    email.setToAddresses(toAddresses);
            
                   Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
                  //  String attName,string attBody
                   
                   efa1.setFileName(filename);
        
                   efa1.setBody(Encodingutil.base64Decode(fileData));
                   fileAttachments.add(efa1);
                      
                    email.setHtmlBody('Dear  '+u.contact.Account.Account_Executive_Name__r.Name +'<br/>'+'<br/>'+Userinfo.getLastName()+' '+Userinfo.getFirstName()+' has uploaded an existing package on '+ System.now());  
                    email.setFileAttachments(fileAttachments);
              
                    emailMessages.add(email);
                
        try{
                Messaging.SendEmailResult [] r = Messaging.sendEmail(emailMessages);
        }catch(Exception ex){} 
        
    }
}