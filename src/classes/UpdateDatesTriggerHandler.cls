//Class to update dates in Business Partners object
public class UpdateDatesTriggerHandler {
    
    Private List<String> checkboxes = new List<String> {'Financials__c', 'Resumes__c', 'Formation_Documents__c', 'Exclusionary_Lists__c',
        'Reputation_Check__c', 'NMLS_ID__c', 'Corporate_Resolution__c', 'Loan_Related_Fees_and_Related_Policy__c',
        'MARI_Background_Check__c', 'Certification_and_Authorization__c', 'Broker_Agreement__c', 
        'W_9__c', 'Quality_Control_Policy__c', 'Character_Checks__c', 'Affiliated_Entities__c', 
        'Renewal_Questionnaire_Received__c', 'Updated_Financial_Received__c',
        'Addendum_Received__c', 'Recertification_Approved__c'};
            
            Private List<String> alldates = new List<String> {'Financials_Received_Date__c', 'Resumes_Received_Date__c', 'Formation_Documents_Received_Date__c',
                'Exclusionary_Lists_Received_Date__c', 'Reputation_Check_Received_Date__c', 'NMLS_ID_Received_Date__c',
                'Corporate_Resolution_Received_Date__c', 'Loan_Related_Fees_and_Related_PolicyDate__c', 'MARI_Background_Check_Received_Date__c',
                'Certification_and_Authorization_Date__c', 'Broker_Agreement_Received_Date__c', 'W_9_Received_Date__c',
                'Quality_Control_Policy_Received_Date__c', 'Character_Checks_Received_Date__c', 'Affiliated_Entities_Received_Date__c',
                'Renewal_Questionnaire_Received_Date__c', 'Updated_Financial_Received_Date__c', 'Addendum_Received_Date__c',
                'Recertification_Approval_Date__c'}; 
                    
                    //Method to update dates automatically for the respective checkboxes before update 
                    Public void UpdateDatesForPartner(List<Account> newpartner, Map<id,Account> oldpartner )
                {
                    for(Account partner: newpartner)
                    {
                        Account oldptnr = oldpartner.get(partner.id);
                        
                        for (integer i=0; i<checkboxes.size(); i++)
                        {
                            if( oldptnr.get(checkboxes[i])== False && partner.get(checkboxes[i]) == True)
                                partner.put((alldates[i]), system.today()); 
                            
                            if(oldptnr.get(checkboxes[i]) == True && partner.get(checkboxes[i]) == False)
                                partner.put((alldates[i]), Null);                       
                        }                   
                    }    
                }
    
    //Method to update dates automatically for the respective checkboxes before insert
    Public void UpdateDatesForPartner(List<Account> newpartner)
    {
        for(Account partner: newpartner)
        {
            for (integer i=0; i<checkboxes.size(); i++)
            {
                if(partner.get(checkboxes[i]) == True)
                    partner.put((alldates[i]), system.today()); 
            }                   
        }    
    }
    
    //Method to populate the date of the record type change to Approved Partners
    Public void AcocuntApproved(List<Account> newpartner, Map<id,Account> oldpartner)
    {
        for(Account partner: newpartner)
        {
            Account oldptnr = oldpartner.get(partner.id);
            if((partner.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Approved Partners').getRecordTypeId()
                || partner.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partners').getRecordTypeId()) &&
               (oldptnr.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner Leads').getRecordTypeId()
                || oldptnr.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Potential Partners').getRecordTypeId()) )
                partner.Original_Approved_Date__c  = system.today(); 
        }
    }
    //Method to check Account record type = Partner AND the Approval sub-status = Approved
    Public void AfterUpdate(Account OldAcct, Account NewAcct)
    {
        Id PartnerRecordTypeId=  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partners').getRecordTypeId();
        if(NewAcct.RecordTypeId == PartnerRecordTypeId && NewAcct.Approval_Sub_Status__c=='Approved' 
           && OldAcct.Approval_Sub_Status__c!='Approved')
        {
             ValidateAssignedTrainer(OldAcct,NewAcct);
            
        }
         
    }
    Public void ValidateAssignedTrainer(Account OldAcct, Account NewAcct)
    {
    try{
        List<opportunity> OppObj=[select Assigned_Trainer__c from opportunity where Accountid=:NewAcct.Id limit 1];
        if(!OppObj.isEmpty())
        {
        if(OppObj[0].Assigned_Trainer__c!=null)
        {
            id Assigned_TrainerID=OppObj[0].Assigned_Trainer__c;
            Id AccountID=NewAcct.id;
            SendEmail(Assigned_TrainerID,AccountID);

        }
         
        }
        
    }
    catch(exception ex){
         system.debug('ValidateAssignedTrainer--Exception---'+ex);
    }
}
     public static void SendEmail(ID Assigned_TrainerID,ID AccountID) {
        try
        {
           	String Assigned_TrainerEmailID=[Select Email from User where id=:Assigned_TrainerID].Email;
            system.debug('Assigned_TrainerEmailID'+Assigned_TrainerEmailID);
            String AEName=UserInfo.getName();
            Account Acct=[select lastmodifieddate,Name from Account where id=:AccountID];
            system.debug('Acct'+Acct);
            Datetime myDT=Acct.LastModifiedDate;
            String myTime = myDT.format('h:mm a');
            String myDate = myDT.format('MM/dd/yyyy');            
            string Link= '<a href='+Label.CIC_Email_Url+AccountID+'>Link to Partner</a>';           
            EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body, Markup FROM EmailTemplate where 
                                      Name='Email to Assigned Trainer when a Partner becomes Approved' ];
            system.debug('template'+template);
            List<Messaging.SingleEmailMessage> mails = 
            new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();            
            sendTo.add(Assigned_TrainerEmailID);
           mail.setToAddresses(sendTo);
            mail.setReplyTo(UserInfo.getUserEmail());          
            mail.setSubject(Acct.Name+ ' has been Approved');
            String body =  template.HtmlValue ;    
            body = body.replace('#BusinessPartnerName',Acct.Name).replace('#date',myDate).replace('#time',myTime).replace('#AEName',AEName).replace('#Link',Link);        
            mail.setHtmlBody(body);
            mails.add(mail);Messaging.sendEmail(mails);
            
        }
        catch(exception e){
            system.debug('SendEmail--Exception---'+e);
        }
        
    }
   
}