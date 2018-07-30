public class CICController {
    @AuraEnabled
    public static void SaveCICData(string CICFeeList,ChangeInCircumstances__c CICDataValue,String LoanId) {
        try
        {
            string TaskId='';
            //system.debug(CICFeeList);
            //system.debug(CICDataValue);
            List<CICFeeResponse>RequestList = (List<CICFeeResponse>)JSON.deserialize(CICFeeList, List<CICFeeResponse>.class);            
            CICDataValue.Loan_Id__c=LoanId;
            //system.debug('Loan id'+CICDataValue.Loan_Id__c);
            upsert CICDataValue;
            
            string CICId=CICDataValue.Id;
            //system.debug('CICId'+CICId);
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
            
            //Call for Create Task
            
            TaskId = CreateTask(CICFeeList,CICDataValue,LoanId);
            system.debug('TaskId'+TaskId);
            //End
            //call for Sending Email
            
            SendEmail(LoanId,TaskId);
            //End
            
        }
        
        catch(exception e){
            system.debug('SaveCICData--Exception---'+e);
        }
    }
    @AuraEnabled
    public static void SendEmail(String strLoanId,string TaskId) {
        try
        {
            
            string Link= '<a href='+Label.CIC_Email_Url+TaskId+'>Link to Task</a>';
            
            string OwnerId;
            string EmailTo;
            Datetime dt=system.now();
            string datefordisplay=dt.format('MM/dd/yyyy HH:mm a');
            Loan_New__c ln = new Loan_New__c();
            ln = [select Name, Related_Partner__r.Assigned_PCS__c, LoanStatus__c, Related_Partner__r.Account_Executive_Name__c,
                  PCS_at_Loan_Level__c, PCS_at_Partner_Level__c, Client_Name__c, Related_Individual__c, Related_Partner__c from Loan_New__c where id =: strLoanId];
            
            // Added new conditions - Bala
            if (ln.PCS_at_Loan_Level__c != null && (ln.Loanstatus__c == 'In Processing' || ln.Loanstatus__c == 'Conditionally Approved' || ln.Loanstatus__c == 'Underwriting Clear to Close' || ln.Loanstatus__c == 'Application Package Received' || ln.Loanstatus__c == 'Awaiting Closing' || ln.Loanstatus__c == 'Closed - Awaiting Funding')) {
                OwnerId = ln.PCS_at_Loan_Level__c;
            } else if(ln.PCS_at_Loan_Level__c == null && (ln.Loanstatus__c == 'In Processing' || ln.Loanstatus__c == 'Conditionally Approved' || ln.Loanstatus__c == 'Underwriting Clear to Close' || ln.Loanstatus__c == 'Application Package Received' || ln.Loanstatus__c == 'Awaiting Closing' || ln.Loanstatus__c == 'Closed - Awaiting Funding')) {
                OwnerId = ln.Related_Partner__r.Assigned_PCS__c;
            } else if (ln.Related_Partner__r.Account_Executive_Name__c != null && (ln.Loanstatus__c == 'Incomplete' || ln.Loanstatus__c == 'Proposal' || ln.Loanstatus__c == 'Waiting for Full Package' || ln.Loanstatus__c == 'Full Application Received - Incomplete' || ln.Loanstatus__c == 'Suspended')){
                OwnerId = ln.Related_Partner__r.Account_Executive_Name__c;
            }            
            system.debug('OwnerId'+OwnerId);
            
            EmailTo=[SELECT user_email_Id__c from User where Id=:OwnerId ].user_email_Id__c;
             //EmailTo='dkumar3@galaxe.com';
             system.debug('EmailTo'+EmailTo);
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
              //mail.setTargetObjectId(OwnerId);
            mail.setSubject('A new task has been created for you for a CIC on '+ ln.Client_Name__c+ '\'s '+' loan');
            String body =  template.HtmlValue ;    
            body =   body.replace('#BusinessIndividualName',userinfo.getName()).replace('#ClientName',ln.Client_Name__c).replace('#LoanId',ln.Name).replace('#Date',datefordisplay).replace('#Link',Link);        
            mail.setHtmlBody(body);
            mails.add(mail);
            Messaging.sendEmail(mails);
            
        }
        catch(exception e){
            system.debug('SendEmail--Exception---'+e);
        }
        
    }
    @AuraEnabled
    public static string CreateTask(string CICFeeListData,ChangeInCircumstances__c objCICDataValue,String strLoanId) {
        string TaskId;
        try {
            
            string Description='A Change in Circumstance has been submitted for the following reasons:'+'\r\n';
            Loan_New__c ln = new Loan_New__c();
            ln = [select Name, Related_Partner__r.Assigned_PCS__c, LoanStatus__c, Related_Partner__r.Account_Executive_Name__c,
                  PCS_at_Loan_Level__c, PCS_at_Partner_Level__c, Client_Name__c, Related_Individual__c, Related_Partner__c from Loan_New__c where id =: strLoanId];            
            
            Task t = new Task();
            
            // Added new conditions - Bala
            if (ln.PCS_at_Loan_Level__c != null && (ln.Loanstatus__c == 'In Processing' || ln.Loanstatus__c == 'Conditionally Approved' || ln.Loanstatus__c == 'Underwriting Clear to Close' || ln.Loanstatus__c == 'Application Package Received' || ln.Loanstatus__c == 'Awaiting Closing' || ln.Loanstatus__c == 'Closed - Awaiting Funding')) {
                t.OwnerId = ln.PCS_at_Loan_Level__c;
            } else if(ln.PCS_at_Loan_Level__c == null && (ln.Loanstatus__c == 'In Processing' || ln.Loanstatus__c == 'Conditionally Approved' || ln.Loanstatus__c == 'Underwriting Clear to Close' || ln.Loanstatus__c == 'Application Package Received' || ln.Loanstatus__c == 'Awaiting Closing' || ln.Loanstatus__c == 'Closed - Awaiting Funding')){
                t.OwnerId = ln.Related_Partner__r.Assigned_PCS__c;
            }else if (ln.Related_Partner__r.Account_Executive_Name__c != null && (ln.Loanstatus__c == 'Incomplete' || ln.Loanstatus__c == 'Proposal' || ln.Loanstatus__c == 'Waiting for Full Package' || ln.Loanstatus__c == 'Full Application Received - Incomplete' || ln.Loanstatus__c == 'Suspended')){
                t.OwnerId = ln.Related_Partner__r.Account_Executive_Name__c;
            }  
            
            t.Subject = 'Change in Circumstance submitted on ' + ln.Client_Name__c + '\'s loan by ' + userinfo.getname();
            t.WhatId = strLoanId;
            t.Client_name__c = ln.Client_Name__c;       
            t.ActivityDate = Date.Today();
            t.WhoId = ln.Related_Individual__c;
            //Check for Adding ChekBox
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
             system.debug('BC'+Description);
           // Description = Description.removeEnd(',');
            
            
             //Description=Description +'.';
           Description= Description.reverse().replaceFirst(',', '.').reverse();
             system.debug('AC'+Description);
            //Description=Description +' .';
            //End  
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
            //End
            t.Description  = Description;
            insert t;
            TaskId=t.Id;
        }
        catch(exception e){
            system.debug('CreateTask--Exception---'+e);
        }
        return TaskId;        
    }    
}