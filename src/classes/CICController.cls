/**
 * @description: used to save change in circumstances when submitted in the portal
 * @author: GalaxE
 * @date: 11/16/2017
 *
 * changelog:
 * 07/16/2019: Sahitya - added new criterial to create a new UW record for PCS, tasks for AE and send them emails
 *                        
 */
public with sharing class CICController {
    @AuraEnabled
    public static void SaveCICData(string CICFeeList,ChangeInCircumstances__c CICDataValue,String LoanId) {
        Logger.push('SaveCICData','CICController');
        try
        {
            List<CICFeeResponse>RequestList = (List<CICFeeResponse>)JSON.deserialize(CICFeeList, List<CICFeeResponse>.class);            
            CICDataValue.Loan_Id__c=LoanId;
            upsert CICDataValue;
            
            string CICId=CICDataValue.Id;
            List<FeeChangeHistory__c> FeeList=new List<FeeChangeHistory__c>();
            for(CICFeeResponse i:RequestList)
            {
                FeeChangeHistory__c FeeData=new FeeChangeHistory__c();
                FeeData.ChangeInCircumtances_Id__c=CICDataValue.Id;
                FeeData.Fee_Name__c=i.FeeName;
                FeeData.Loan_Id__c=LoanId;
                FeeData.New_Amount__c=i.NewAmount;
                FeeData.Previous_Amount__c=i.OldAmount;
                FeeList.add(FeeData);
            }
            insert FeeList;
            
            createRecordAndSendEmails(CICFeeList, CICDataValue, LoanId);            
        }
        
        catch(exception e){
            system.debug('SaveCICData--Exception---'+e);
        }
        Logger.Pop();
    }
    
    @AuraEnabled
    public static void createRecordAndSendEmails(string CICFeeList, ChangeInCircumstances__c CICDataValue, String LoanId) {  
        Logger.push('createRecordAndSendEmails','CICController');
        Loan_New__c ln = new Loan_New__c();
        ln = [select Name, Related_Partner__r.Assigned_PCS__c, LoanStatus__c, Related_Partner__r.Account_Executive_Name__c,
              PCS_at_Loan_Level__c, PCS_at_Partner_Level__c, Client_Name__c, Related_Individual__c, Related_Partner__c from Loan_New__c where id =: LoanId];
        
        String recOwner;
        
        switch on ln.Loanstatus__c {
            when 'Loan Submission Received- Awaiting Review',
                 'In Processing',
                 'In Underwriting Review',
                 'Underwriting Clear to Close'
            {
                // To PCS
                if (ln.PCS_at_Loan_Level__c != null) {
                    recOwner = ln.PCS_at_Loan_Level__c;
                }
                else if(ln.PCS_at_Loan_Level__c == null) {
                    recOwner = ln.Related_Partner__r.Assigned_PCS__c;
                }                
                
				SendEmail(LoanId, recOwner);
                createPCSRecord(CICFeeList, CICDataValue, LoanId, recOwner);
            }	
            when 'Proposal',
                 'Waiting for Full Package',
                 'Application Package Received',
                 'Full Application Received - Incomplete',
                 'Suspended'
            {
                // AE
                if (ln.Related_Partner__r.Account_Executive_Name__c != null) {
                    recOwner = ln.Related_Partner__r.Account_Executive_Name__c;
                }
				SendEmail(LoanId, recOwner);
                createPCSRecord(CICFeeList, CICDataValue, LoanId, recOwner);
            }            
            // To PCS and to AE
            when 'Conditionally Approved' 
            {                                
                // PCS
                if (ln.PCS_at_Loan_Level__c != null) {
                    recOwner = ln.PCS_at_Loan_Level__c;
                }
                else if(ln.PCS_at_Loan_Level__c == null) {
                    recOwner = ln.Related_Partner__r.Assigned_PCS__c;
                }
                
				SendEmail(LoanId, recOwner);
                createPCSRecord(CICFeeList, CICDataValue, LoanId, recOwner);
                // To AE
                if (ln.Related_Partner__r.Account_Executive_Name__c != null) {
                    recOwner = ln.Related_Partner__r.Account_Executive_Name__c;
                }      
				SendEmail(LoanId, recOwner);
                createPCSRecord(CICFeeList, CICDataValue, LoanId, recOwner);
            }            
        }
        Logger.Pop();
    }

    @AuraEnabled
    public static void createPCSRecord(string CICFeeListData, ChangeInCircumstances__c objCICDataValue, String strLoanId, String recOwner){
        Logger.push('createPCSRecord','CICController');
        Loan_New__c ln = new Loan_New__c();
            ln = [select Name, Related_Partner__r.Assigned_PCS__c, LoanStatus__c, Related_Partner__r.Account_Executive_Name__c,
                  PCS_at_Loan_Level__c, PCS_at_Partner_Level__c, Client_Name__c, Related_Individual__c, Related_Partner__c, UW__c from Loan_New__c where id =: strLoanId];  

        user u = new user();
        u = [SELECT UserRoleId from user where id =: recOwner ];
        string uId = u.UserRoleId;
        userRole r = new userRole();
        r = [SELECT Name from userRole where id =: uId];

        String pcs;
        if(ln.PCS_at_Loan_Level__c != null){
            pcs = ln.PCS_at_Loan_Level__c;
        }else{
            pcs = ln.Related_Partner__r.Assigned_PCS__c;
        }

        String underWriter;
        if(ln.UW__c != null){
            underWriter = ln.UW__c;
        }
        //Check for Adding ChekBox
            string Description='A Change in Circumstance has been submitted for the following reasons:'+'\r\n';
            if(objCICDataValue.Add_a_Non_Borrowing_Spouse__c==true)
            {
                Description=Description+'Add a Non Borrowing Spouse,';
            }
            if(objCICDataValue.Reduce_Origination_Fee__c==true)
            {
                Description=Description+' Reduce Origination Fee,';
            }
            if(objCICDataValue.Title_Fees_Received__c==true)
            {
                Description=Description+' Title Fees Received,';
            }
            if(objCICDataValue.AddRemove_Borrowe__c==true)
            {
                Description=Description+' Add/Remove Borrower,';
            }
            if(objCICDataValue.Act_of_God__c==true)
            {
                Description=Description+' Act of God, war, disaster or other emergency,';
            }
            if(objCICDataValue.Appraisal_Received__c==true)
            {
                Description=Description+' Appraisal Received,';
            }
            if(objCICDataValue.Other_Circumstance_Client_or_Transaction__c==true)
            {
                Description=Description+'Other circumstance that is particular to the client or transaction, ';
            }
            if(objCICDataValue.Other_Information_to_Client_Transaction__c==true)
            {
                Description=Description+'Other New information particular to the client or transaction, ';
            }
            if(objCICDataValue.Other__c==true)
            {
                Description=Description+'Other, ';
            }
            if(objCICDataValue.Inaccurate_Information__c==true)
            {
                Description=Description+'Inaccurate information about the client or transaction, ';
            }
            if(objCICDataValue.Adding_a_non_borrowing_resident__c==true)
            {
                Description=Description+'Adding a non-borrowing resident, ';
            }  
            if(objCICDataValue.Change_in_Employment__c==true)
            {
                Description=Description+'Change in Employment, ';                
            }  
            if(objCICDataValue.Change_in_Loan_Officer__c==true)
            {
                Description=Description+'Change in Loan Officer, ';
            }  
            if(objCICDataValue.Change_in_Requested_Payment_Plan__c==true)
            {
                Description=Description+'Change in Requested Payment Plan, ';
            }  
            if(objCICDataValue.Bring_Optional_Funds_to_Closing__c==true)
            {
                Description=Description+'Bring Optional Funds to Closing, ';
            }  
            if(objCICDataValue.Withdraw__c==true)
            {
                Description=Description+'Withdraw, ';
            }  
            if(objCICDataValue.Other_Change__c==true)
            {
                Description=Description+'Other Change, ';
            }
            Description= Description.reverse().replaceFirst(',', '.').reverse();
                system.debug('AC'+Description);
            //Check for Adding Fee Comment
            List<CICFeeResponse>RequestList = (List<CICFeeResponse>)JSON.deserialize(CICFeeListData, List<CICFeeResponse>.class); 
            if(RequestList.size()>0)
            {
                Description=Description+'\r\n'+'Fee changes have been submitted along with this change request.';
            }
            Description=Description+'\r\n'+'Please see the Change in Circumstances under Related for more information. ';
            Description=Description+'\r\n'+'Loan Id: '+ln.Name;
            Description=Description+'\r\n'+'Client Name: '+ln.Client_Name__c;
            Description=Description+'\r\n'+'Business Individual Name: '+userinfo.getname();
            Datetime dt=system.now();
            string datefordisplay=dt.format('MM/dd/yyyy HH:mm a');
            Description=Description+'\r\n'+'Date & Time: '+datefordisplay;            
        try{
            if(r.Name == 'Partner Care Specialist' || r.Name == 'Partner Care Specialist Lead'){    
                Underwriter__c uw = new Underwriter__c();
                uw.recordtypeid = Schema.SObjectType.Underwriter__c.getRecordTypeInfosByName().get('PCS Workflow').getRecordTypeId();
                uw.Loan__c = strLoanId;
                uw.Priority__c = 'Medium';
                uw.Status__c = 'Open';
                uw.Latest_Status_Change__c = DateTime.now();
                uw.Open_Date__c = DateTime.now();
                uw.AE_on_Loan__c = ln.Related_Partner__r.Account_Executive_Name__c;
                uw.PCS_at_Loan_Level__c = pcs;
                uw.Subject__c = 'Change In Circumstance';
                uw.Underwriter__c = underWriter;
                uw.OwnerId = recOwner;
		uw.PCS_Task_Bucket__c = 'CIC Request';
                uw.More_Notes__c = Description;
                insert uw;
            }else if(r.Name == 'Braveheart' || r.Name == 'wORMS' || r.Name == 'DMB - Jesse' || r.Name == 'DMB - Josh'){
                Task t = new Task();            
                t.OwnerId = recOwner;            
                t.Subject = 'Change in Circumstance submitted on ' + ln.Client_Name__c + '\'s loan by ' + userinfo.getname();
                t.WhatId = strLoanId;
                t.Client_name__c = ln.Client_Name__c;       
                t.ActivityDate = Date.Today();
                t.WhoId = ln.Related_Individual__c;
                t.Description  = Description;
                insert t;
            }
        }catch(exception e){
            system.debug('createPCSRecord--Exception---'+e);
        }
        Logger.Pop();
    }        
    
    @AuraEnabled
    public static void SendEmail(String strLoanId, String OwnerId) {
        Logger.push('SendEmail','CICController');
        try{
            string EmailTo;
            Datetime dt=system.now();
            string datefordisplay=dt.format('MM/dd/yyyy HH:mm a');
            Loan_New__c ln = new Loan_New__c();
            ln = [select Name, Related_Partner__r.Assigned_PCS__c, LoanStatus__c, Related_Partner__r.Account_Executive_Name__c,
                  PCS_at_Loan_Level__c, PCS_at_Partner_Level__c, Client_Name__c, Related_Individual__c, Related_Partner__c from Loan_New__c where id =: strLoanId];
            
            EmailTo=[SELECT user_email_Id__c from User where Id=:OwnerId ].user_email_Id__c;
            EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body, Markup FROM EmailTemplate where Name='CIC Email Template' ];
            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            
            sendTo.add( EmailTo);
            mail.setToAddresses(sendTo);
            mail.setReplyTo(UserInfo.getUserEmail());
            mail.setSubject('A new UW record has been created for you for a CIC on '+ ln.Client_Name__c+ '\'s '+' loan');
            String body =  template.HtmlValue ;    
            body =   body.replace('#BusinessIndividualName',userinfo.getName()).replace('#ClientName',ln.Client_Name__c).replace('#LoanId',ln.Name).replace('#Date',datefordisplay);        
            mail.setHtmlBody(body);
            mails.add(mail);
            Messaging.sendEmail(mails);            
        }
        catch(exception e){
            system.debug('SendEmail--Exception---'+e);
        }     
        Logger.Pop();   
    }    
}
