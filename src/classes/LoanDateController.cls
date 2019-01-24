/**
 * @description: SaNL Loan Main page, incomplete applications, 3.2 files and lender packages  
 * @author: Ravi
 * @date: 7/28/2017
 *
 * changelog:
 * 10/26/2018: Sahitya SFDC-370- Create a task and send an email to AE when Partner Uploads a Case Transfer/Other Lender Application Disclosure
 * 1/24/2019: Sahitya, changed the filedata datatype from Blob to String in getFNMData method
 */
public class LoanDateController {    
    @AuraEnabled
    public static string getFNMData(String filedata, String fileName, String base64Data, String contentType, String applicationDate,String rateType,String loanMortgageAppliedFor) {
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
        }
        catch(exception e){
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
        user u = [select contact.Account.ORM_Email__c,contact.Account.Account_Executive_Name__r.Name,contact.Account.Account_Executive_Name__r.Email, Contact.Account.Name, Contact.Account.Id from user where id=:userinfo.getUserId() ];
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        String accountId = u.Contact.Account.Id;
        String Link ='<a href='+Label.account_link+accountId+Label.account_link2+'>Link to Account</a>';           
        List<String>toAddresses = new List<String>();
        toAddresses.add(u.contact.Account.ORM_Email__c);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('A Lender Application has been uploaded');
        email.setToAddresses(toAddresses);
        Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
        //  String attName,string attBody
        efa1.setFileName(filename);
        efa1.setBody(Encodingutil.base64Decode(fileData));
        fileAttachments.add(efa1);
        email.setHtmlBody('Hi '+u.contact.Account.Account_Executive_Name__r.Name +','+'<br/>'+'<br/>'+Userinfo.getLastName()+' '+Userinfo.getFirstName()+ ' from '+ u.Contact.Account.Name + ' has uploaded a Case Transfer/Other Lender Application Disclosures at '+ System.now() +'.'+ '<br/>'+'<br/>'+Link+'' );  
        email.setFileAttachments(fileAttachments);
        emailMessages.add(email);                
        try{
            Messaging.SendEmailResult [] r = Messaging.sendEmail(emailMessages);
        }catch(Exception ex){
            system.debug('exception'+ex);
        }        
    }
    
    //SFDC-370
    @AuraEnabled
    public static string createAETask(String filename,string fileData) {        
        user u = [SELECT contactId, contact.AccountId FROM user WHERE id = :userinfo.getUserId()];
        Task t = new Task();
        Account a = new Account();
        a = [SELECT name, Account_Executive_Name__c FROM Account WHERE id = :u.contact.AccountId];
        String accname = a.Name;
        t.Subject = +userinfo.getfirstname() + ' ' + userinfo.getLastName() + ' ' + 'from Account:' + ' ' + accname + ' ' + 'has uploaded ' +filename +' Please check your email for attachment.' ;
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.WhatId = a.Id;
        t.ActivityDate = Date.Today();
        t.OwnerId = a.Account_Executive_Name__c;
        t.WhoId = u.contactId;
        insert t;
        
        return t.Id;
    }
}
