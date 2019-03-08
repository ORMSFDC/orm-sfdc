/**
 * @description AttachmentStatus
 * @date 06/21/17      
 * @author Ravi
 * @changelog: Sahitya: 02/06/19 - Do not send upload emails to PCS but create tasks for them
 */

trigger AttachmentStatus on Attachment(after insert) {
    Attachment att = trigger.New[0];
     System.debug('att--->'+att);    
    string Attchid = att.Id;
     System.debug('Attchid--->'+Attchid);    
    string LoanId = att.ParentId;
    String sobjectType = att.ParentId.getSObjectType().getDescribe().getName();
     System.debug(sobjectType);
     System.debug('LoanId--->'+LoanId);    
    string Status = 'Upload Success';
    AttachmentStatus__c objSts = new AttachmentStatus__c();
    objSts.Name = Status;
    System.debug('objSts.Name--->'+objSts.Name);
    if(sobjectType=='Loan_New__c'){
        objSts.LoanId__c = LoanId;
    }
    System.debug('objSts.LoanId__c--->'+objSts.LoanId__c);
    objSts.AttachmentID__c = Attchid;
    System.debug('objSts.AttachmentID__c--->'+objSts.AttachmentID__c);
    objSts.Uploaded_By__c = userinfo.getName(); //added to avoid SOQL inside for loop in 'uploadcontroller class'
    System.debug('objSts.Uploaded_By__c--->'+objSts.Uploaded_By__c);
    try{
        insert objSts;
    }catch(exception ex){
        Exception_log.Log_exception(ex,'AttachmentStatus','Trigger');
    }
    try {
        Loan_New__c ln = new Loan_New__c();
    
        ln = [select Name, Related_Partner__r.Assigned_PCS__c, LoanStatus__c, Related_Partner__r.Account_Executive_Name__c,
        PCS_at_Loan_Level__c, PCS_at_Partner_Level__c, Client_Name__c, Related_Individual__c, Related_Partner__c from Loan_New__c where id =: LoanId];
    
        Profile P = [Select Name from profile Where Id =:userInfo.getProfileId()];
    
        system.debug('>>>>>>>>'+p.Name);
    
        Task t = new Task();
        //Code modified by Bala - Task and Email should be sent to AE and PCS based on Loan Statuses 4/24
        
        // For FNM file, no task ever goes to PCS and always goes to AE regardless of loan status
        if (att.Name.endsWithIgnoreCase('.fnm'))
        {
            t.OwnerId = ln.Related_Partner__r.Account_Executive_Name__c;
        }
        else if ((ln.Loanstatus__c == 'Incomplete' || ln.Loanstatus__c == 'Proposal' || ln.Loanstatus__c == 'Waiting for Full Package' || ln.Loanstatus__c == 'Application Package Received' || ln.Loanstatus__c == 'Full Application Received - Incomplete' || ln.Loanstatus__c == 'Suspended')
            && (P.Name == 'ORM Partner' || P.Name == 'ORM Partners' || P.Name == 'Partner Community Login User' || P.Name == 'Partner Community User' || P.Name == 'Portal Loan Processor' || 
                P.Name == 'Portal Loan Processors' || P.Name == 'Prospective Partner User' || P.Name == 'Prospective Partner Users')) {
            t.OwnerId = ln.Related_Partner__r.Account_Executive_Name__c;
        }
        else{
            if((ln.Loanstatus__c == 'In Processing' || ln.Loanstatus__c == 'In Underwriting Review' || ln.Loanstatus__c == 'Conditionally Approved' || ln.Loanstatus__c == 'Underwriting Clear to Close' || ln.Loanstatus__c == 'In Final HUD Review' || ln.Loanstatus__c == 'Docs out to Settlement Agent')
            && (P.Name == 'ORM Partner' || P.Name == 'ORM Partners' || P.Name == 'Partner Community Login User' || P.Name == 'Partner Community User' || P.Name == 'Portal Loan Processor' || 
                P.Name == 'Portal Loan Processors' || P.Name == 'Prospective Partner User' || P.Name == 'Prospective Partner Users')){
                t.OwnerId = ln.Related_Partner__r.Assigned_PCS__c;
            }
        }		
                  
        t.Subject = 'A Document has been uploaded for ' + ln.Client_Name__c+ ' by ' + userinfo.getfirstname() + ' ' + userinfo.getlastname();
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.WhatId = LoanId;
        t.Client_name__c = ln.Client_Name__c;
        t.Document_Link__c = Attchid;
        t.ActivityDate = Date.Today();
        t.WhoId = ln.Related_Individual__c;

        System.debug('>>>>>>> t trigger is ' + t);
        if (ln.PCS_at_Loan_Level__c != null && t.Ownerid != null && ln.PCS_at_Loan_Level__c != userinfo.getuserId()) {
            insert t;
        } else if (ln.PCS_at_Loan_Level__c == null && ln.Related_Partner__r.Assigned_PCS__c != userinfo.getuserId() && t.Ownerid != null) {
            insert t;
        }

        System.debug('>>>>>>> t trigger is afterv ' + t);

        /*******************Email sending logic**********************/

        try {
            if (t.Ownerid != null && t.Ownerid != userinfo.getuserid() || test.isRunningTest()) {
                if(ln.PCS_at_Loan_Level__c != t.ownerId && ln.Related_Partner__r.Assigned_PCS__c != t.ownerId){ /*added on 02/06*/
                    Task tt = new Task();
                    if(!Test.isRunningTest()){
                            tt = [select CreatedDate from task where id=:t.id ];
                    }
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    // mail.setTemplateId([select id from Emailtemplate where name='Document Uploaded New'].id); //Id of the Email Template
                    String HtmlBody = '';
                    try {
                    TimeZone tz = UserInfo.getTimeZone();
                    DateTime localTime = tt.CreatedDate.AddSeconds(tz.getOffset(tt.CreatedDate)/1000);
                        HtmlBody = '<li>' + ln.Name + '</li><br/><li>' + ln.Client_Name__c + '</li><br/><li>' + userinfo.getFirstName() + '</li><br/><li>' + localTime  + '</li><br/><li>' + att.Name + '</li><br/><li>' + System.URL.getSalesforceBaseURL().toExternalForm() + '/' + att.id + '</li>';
                    } catch (Exception ex) {}
                    mail.setTargetObjectId(t.ownerId); // Id of Contact or Lead or User
                    system.debug('owner id -->' + t.ownerId);
                    mail.setHtmlBody(HtmlBody);
                    mail.saveAsActivity = false;
                    system.debug('owner id -->' + ln.id);
                    mail.setSubject(t.Subject);
                    System.debug(mail);
                    if (!Test.isRunningTest()) {
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                            mail
                        });
                    }
                }
            }
        } catch (Exception ex) {
        
        Exception_log.Log_exception(ex,'AttachmentStatus','email sending logic');
        }

    } catch (Exception ex) {
    
    Exception_log.Log_exception(ex,'AttachmentStatus','LoanQuery');
    }
    
   /**************Code to send an email to Loan Preferred Contact when backend users upload any documents - Bala**************/
    
        String getUserEmailID = UserInfo.getUserEmail();
        String getUsername = UserInfo.getName();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        map<id,Profile> profilesmap = new map<id,Profile>([select id,name from profile]);
        map<id,List<Attachment>> attachmentmap = new map<id,List<Attachment>>();
    
        Set<Id> LoanIds = new Set<Id>();
        for(Attachment at :Trigger.New){
            String parentId = at.ParentId;
            system.debug('parentId-------'+parentId);
            if(parentId.startsWith('a0Q')) {
                LoanIds.add(at.ParentId);
                if(attachmentmap.containsKey(at.ParentId)){
                    attachmentmap.get(at.ParentId).add(at);
                }else{
                    attachmentmap.put(at.ParentId, new List<Attachment> {at});
                }
            }
        }
        system.debug('attachmentmap-------'+attachmentmap);
        List<Loan_New__c> loanList = [select id, Name, OwnerId, Owner.Email,Owner.Name,Preferred_Contact_Type__c,Preferred_Contact_Name__c,LoanOfficer__r.Email, Loan_Processor__r.Email,Owner.Profile.Name from Loan_New__c where id IN : LoanIds];
        
        system.debug('loanList-------'+loanList);
        List<Loan_New__c> loanUpdateList = new List<Loan_New__c>();
        for(Loan_New__c loan :loanList){    
               loanUpdateList.add(loan);   
               system.debug('@@@@@'+loan.LoanOfficer__r.Email);
           
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
                body='<html><body><div>Hello '+name1+',</div><br/><div> A document has been uploaded for Loan '+loan.Name+'.</div>';                                
                body+='<td colspan="1"></td><br/> <tr> <td colspan="1">Thank You, </td> </tr>';
                body+='<td colspan="1"><br/>'+getUsername+'.</td> </tr>';                
                mail.setHtmlBody(body);
                mails.add(mail);
                system.debug('mails-------'+mails);            
        }
        system.debug('loanUpdateList-------'+loanUpdateList);
        update loanUpdateList;
        Messaging.sendEmail(mails);    
}