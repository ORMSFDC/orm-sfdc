public with sharing class SAL_CreditInfoController {
    public class ButtonEnableResponse{
        @AuraEnabled public   Boolean  CompleteStatus { get;set; }
        @AuraEnabled public   Boolean  IsLoancreatedMAnually { get;set; }
    }   
    @AuraEnabled
    public static Loan_New__c  CreditInfo_TabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);           
        }
        catch(Exception ex)
        {
            system.debug(' CreditInfo_TabsValidatedData----Exception---'+ex);
        }
        return objLoan;
        
    } 
    @AuraEnabled
    public static ButtonEnableResponse GetButtonEnableFlag(Id LoanID)
    {
        ButtonEnableResponse BtnResponese=new ButtonEnableResponse();
        boolean IsLoancreatedManuallyStatus=[select Is_Loan_Created_Manually__c from Loan_New__c where id=:LoanID].Is_Loan_Created_Manually__c;
        boolean ReturnValue=false;
        integer count=0;
        try
        {
            count=[SELECT count() FROM Loan_New__c  where IsLoanFilled_Flag__c=:true and
                   IsSubjectPropertyFilled_Flag__c=:true and  IsClientFilled_Flag__c=:true and
                   IsEmploymentFilled_Flag__c=:true and IsAssetsFilled_Flag__c=:true and
                   IsIncomeFilled_Flag__c=:true and  IsLaibilitiesFilled_Flag__c=:true and 
                   IsDeclarationFilled_Flag__c=:true  and IsLoanDetailsFilled_Flag__c=:true and
                   Is_CashFlow_Viewed__C=:true and IsLoanContactFilled_Flag__c=:true and  Id=:LoanID];
            if(count>0)
                //True means Tabs Validated
                ReturnValue=true;            
        }
        catch(Exception ex)
        {
            system.debug('GetButtonenableFlag--Exception---'+ex);
        } 
        //True means Loan created MAnually
        BtnResponese.IsLoancreatedMAnually=IsLoancreatedManuallyStatus;
        //True means Tabs Validated
        BtnResponese.CompleteStatus=ReturnValue;
        return BtnResponese;
        
    }
    @AuraEnabled
    public static Loan_New__c GetcreditInfoById(string LoanID)
    {
        Loan_New__c CreditInfo=new Loan_New__c();
        try
        {
            CreditInfo =  [SELECT Id,Is_Application_Filled_Flag__c, Client_s_credit_score__c, Credit_Indicator__c,Credit_Report_type__c, Credit_Reissue_Vendor__c, Credit_Reference_Number__c, 
                           Confirm_Credit_Reference_Number__c, LoanStatus__c  FROM Loan_New__c where Id = :LoanId];
        }
        catch(Exception ex)
        {
            system.debug('GetcreditInfoById--Exception---'+ex);
        } 
        return CreditInfo;
    }  
      
    @AuraEnabled
    public static  void  SaveCreditInfo(Loan_New__c ObjCreditInfo,string loanID) 
    {
        try
        {
            ObjCreditInfo.IsCreditInfoFilled_Flag__c = true;
            ObjCreditInfo.Is_Application_Filled_Flag__c = true;
            ObjCreditInfo.Id=loanID;
            ObjCreditInfo.LoanCompleteFlag__c = true;
            ObjCreditInfo.LoanStatus__c = 'Proposal';
            Loan_New__C loanObj  = [Select id,Name, IsLoanCreatedByLoanProcessor__c, LoanCompleteFlag__c, Originating_Loan_Officer__c 
                                    from Loan_New__C Where Id =: LoanID];
           If(loanObj.IsLoanCreatedByLoanProcessor__c )
            {
                ObjCreditInfo.ownerid=loanObj.Originating_Loan_Officer__c;
            }
            else{
                 ID LoanCreatorID=[select createdbyid from loan_new__c where id=:loanID ].createdbyid;
             ObjCreditInfo.Originating_Loan_Officer__c=LoanCreatorID;
            }
            upsert ObjCreditInfo; 
           // Publish completed loan event
           LoanAppSubmitted__e appSubmittedEvent = new LoanAppSubmitted__e(LoanId__c=loanID);
            Database.SaveResult sr = EventBus.publish(appSubmittedEvent);
            if (sr.isSuccess()) {
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                }
            }  
           // This could be moved into an event handler that listens to the platform event above.
            //MailSend.SendMail2Partnernew(LoanName);
            //MailSend.SendMail2ORMnew(LoanName);      
        }
        catch(Exception ex)
        {
             //Exception_log.Log_exception(ex,'SAL_CreditInfoController','SaveCreditInfo');
            system.debug('SaveCreditInfo--Exception---'+ex);
        }        
    }
    @AuraEnabled
    public static integer  GetAllClientByLoanId(string LoanID)
    {
        List<Client__c> AllClientByLoanId=new List<Client__c>();
        try
        {
            AllClientByLoanId =  [SELECT Id, Name,First_Name__c,Last_Name__c, LoanId__c FROM Client__c 
                                  where  is_Active__c  = true and LoanId__c = :LoanId  ];
        }
        catch(Exception ex)
        {
            system.debug('GetAllClientByLoanId--Exception---'+ex);
        } 
        return AllClientByLoanId.size();
    }
    
    @AuraEnabled //Balaa, A task will be created for AE when Application Package is requested - 4/20
        public static string createAETask(String LoanID){
            
            List<Loan_New__c> ls= new List<Loan_New__c>();
            ls =  [SELECT Id,LoanStatus__c FROM Loan_New__c WHERE Id =:LoanID and IsActiveFlag__c=: true and LoanCompleteFlag__c=: true               
                   ORDER BY LoanStatus__c];
                            
            user u = [SELECT contactId, contact.AccountId FROM user WHERE id=:userinfo.getUserId()];
            
            Task t = new Task();
                    Account a = new Account();
                    a = [SELECT name, Account_Executive_Name__c,Assigned_PCS__r.id FROM Account WHERE id =:u.contact.AccountId ];
                    t.Subject = 'An Application has been requested by the Partner';
                    t.Status = 'Open';
                    t.Priority = 'Normal';
                    t.WhatId = LoanID;
                    system.debug('###' +LoanID);
                    t.ActivityDate = Date.Today();
                    t.OwnerId = a.Account_Executive_Name__c;                    
                    t.WhoId = u.contactId;        
                    insert t;               
            return t.id;
        }   
}