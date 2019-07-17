/**
 * @description: used to create an attachment status record and create UW record when documents are uploaded
 *               and send email to Portal user when backen user uploads documents
 * @author: GalaxE
 * @date: 11/16/2017
 *
 * changelog:
 * 07/16/2019: Sahitya - added new criterial to create a new UW record for AE/PCS and send emails to portal users
 *                        
 */
public with sharing class attachmentTriggerHandler {
    public static void createRecordandEmail(String attachmentId, List<Attachment> attachments){
        Logger.push('createRecordandEmail','attachmentTriggerHandler');
        Attachment att = [SELECT Id, Name, ParentId
                          FROM Attachment
                          WHERE id = :attachmentId];
        string Attchid = att.Id;
        string LoanId = att.ParentId;
        String sobjectType = att.ParentId.getSObjectType().getDescribe().getName();
        string Status = 'Upload Success';
        AttachmentStatus__c objSts = new AttachmentStatus__c();
        objSts.Name = Status;
        if(sobjectType=='Loan_New__c'){
            objSts.LoanId__c = LoanId;
        }
        objSts.AttachmentID__c = Attchid;
        objSts.Uploaded_By__c = userinfo.getName(); 
        try{
            insert objSts;
        }catch(exception ex){
            Exception_log.Log_exception(ex,'AttachmentStatus','Trigger');
        }
        try {
        Loan_New__c ln = new Loan_New__c();
    
        ln = [select Name, Related_Partner__r.Assigned_PCS__c, LoanStatus__c, Related_Partner__r.Account_Executive_Name__c, UW__c,
        PCS_at_Loan_Level__c,PCS_at_Loan_Level__r.id, PCS_at_Partner_Level__c, Client_Name__c, Related_Individual__c, Related_Partner__c from Loan_New__c where id =: LoanId];
    
        Profile P = [Select Name from profile Where Id =:userInfo.getProfileId()];
        String underWriter;
        if(ln.UW__c != null){
            underWriter = ln.UW__c;
        }
        String pcs;
        if(ln.PCS_at_Loan_Level__c != null){
            pcs = ln.PCS_at_Loan_Level__c;
        }else{
            pcs = ln.Related_Partner__r.Assigned_PCS__c;
        }
       /* Task t = new Task();*/
        Underwriter__c uw = new Underwriter__c();
        // For FNM file, no task ever goes to PCS and always goes to AE regardless of loan status
        if (att.Name.endsWithIgnoreCase('.fnm'))
        {
            uw.OwnerId = ln.Related_Partner__r.Account_Executive_Name__c;
        }
        else if ((ln.Loanstatus__c == 'Incomplete' || ln.Loanstatus__c == 'Proposal' || ln.Loanstatus__c == 'Waiting for Full Package' || ln.Loanstatus__c == 'Application Package Received' || 
                  ln.Loanstatus__c == 'Full Application Received - Incomplete' || ln.Loanstatus__c == 'Suspended')
            && (P.Name == 'ORM Partner' || P.Name == 'ORM Partners' || P.Name == 'Partner Community Login User' || P.Name == 'Partner Community User' || P.Name == 'Portal Loan Processor' || 
                P.Name == 'Portal Loan Processors' || P.Name == 'Prospective Partner User' || P.Name == 'Prospective Partner Users')) {
            uw.OwnerId = ln.Related_Partner__r.Account_Executive_Name__c;
            uw.recordtypeid = Schema.SObjectType.Underwriter__c.getRecordTypeInfosByName().get('AE').getRecordTypeId();
        }
        else{
            if((ln.Loanstatus__c == 'In Processing' || ln.Loanstatus__c == 'In Underwriting Review' || ln.Loanstatus__c == 'Conditionally Approved' || ln.Loanstatus__c == 'Underwriting Clear to Close' || 
                ln.Loanstatus__c == 'In Final HUD Review' || ln.Loanstatus__c == 'Docs out to Settlement Agent')
            && (P.Name == 'ORM Partner' || P.Name == 'ORM Partners' || P.Name == 'Partner Community Login User' || P.Name == 'Partner Community User' || P.Name == 'Portal Loan Processor' || 
                P.Name == 'Portal Loan Processors' || P.Name == 'Prospective Partner User' || P.Name == 'Prospective Partner Users')
            && (ln.PCS_at_Loan_Level__c != null)    ){
                uw.OwnerId = ln.PCS_at_Loan_Level__r.id;
                uw.recordtypeid = Schema.SObjectType.Underwriter__c.getRecordTypeInfosByName().get('PCS Workflow').getRecordTypeId();
            }
        }               
        
        uw.Loan__c = LoanId;
        uw.Priority__c = 'Medium';
        uw.Status__c = 'Open';
        uw.Latest_Status_Change__c = DateTime.now();
        uw.Open_Date__c = DateTime.now();
        uw.AE_on_Loan__c = ln.Related_Partner__r.Account_Executive_Name__c;
        uw.PCS_at_Loan_Level__c = pcs;
        uw.Subject__c = 'Document Upload';
        uw.Underwriter__c = underWriter;
        uw.Notes__c = 'A Document has been uploaded for ' + ln.Client_Name__c+ ' by ' + userinfo.getfirstname() + ' ' + userinfo.getlastname();
        
        if (ln.PCS_at_Loan_Level__c != null && uw.Ownerid != null && ln.PCS_at_Loan_Level__c != userinfo.getuserId()) {
            insert uw;
        } else if (ln.PCS_at_Loan_Level__c == null && ln.Related_Partner__r.Assigned_PCS__c != userinfo.getuserId() && uw.Ownerid != null) {
            insert uw;
        }
    } catch (Exception ex) {
    
    Exception_log.Log_exception(ex,'AttachmentStatus','LoanQuery');
    }
    
   /**************Code to send an email to Loan Preferred Contact when backend users upload any documents**************/
    
        String getUserEmailID = UserInfo.getUserEmail();
        String getUsername = UserInfo.getName();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Profile P = [Select Name from profile Where Id =:userInfo.getProfileId()];
        Loan_New__c loan = new Loan_New__c();
        loan = [select id, Name, OwnerId, LoanNumber__c, Owner.Email,Owner.Name,Preferred_Contact_Type__c,Preferred_Contact_Name__c,LoanOfficer__r.Email, Loan_Processor__r.Email,Owner.Profile.Name from Loan_New__c where id =: LoanId];
        String loanNumber;
        if(loan.LoanNumber__c == null){
            loanNumber = loan.Name;
        }else{
            loanNumber = loan.LoanNumber__c;
        }

        if(P.Name == 'System Administrator' || P.Name == 'Account Executive/PCS' || P.Name == 'Underwriter'){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                String name1;
                   If(loan.Preferred_Contact_Type__c == 'Loan Officer' && loan.LoanOfficer__r.Email != null && loan.LoanOfficer__c != null ){
                       sendTo.add(loan.LoanOfficer__r.Email);   
                       name1 = loan.Preferred_Contact_Name__c;                    
                   }
                   else if(loan.Preferred_Contact_Type__c == 'Loan Processor' && loan.Loan_Processor__r.Email != null && loan.Loan_Processor__c != null ){
                       sendTo.add(loan.Loan_Processor__r.Email);
                       name1 = loan.Preferred_Contact_Name__c;
                   }
                   else{
                       sendTo.add(loan.owner.Email);
                       name1 = loan.Owner.name;                       
                   }
                mail.setToAddresses(sendTo);
                mail.setReplyTo(getUserEmailID);
                mail.setSubject('ORMS - Loan Update');
                String body ;                
                body='<html><body><div>Hello '+name1+',</div><br/><div> A document has been uploaded for Loan '+loanNumber+'.</div>';                                
                body+='<td colspan="1"></td><br/> <tr> <td colspan="1">Thank You, </td> </tr>';
                body+='<td colspan="1"><br/>'+getUsername+'.</td> </tr>';                
                mail.setHtmlBody(body);
                mails.add(mail);      
        Messaging.sendEmail(mails);    
        }
        Logger.Pop();
    }
    
}