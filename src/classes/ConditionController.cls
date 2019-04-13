public class ConditionController {
  
    @AuraEnabled
    public static List<ConditionResponse> getConditionHistory(String ConditionId) {
        List<ConditionResponse> ObjCon=new List<ConditionResponse>();
        ConditionResponse ConditionResObj=new  ConditionResponse();
        List<Condition_Log__c> obj=new List<Condition_Log__c>();
        Condition__c Conditionobj=new Condition__c();
    try
      {
            Conditionobj=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,CreatedById,LastModifiedById,LastModifiedDate,Description__c from Condition__c where id=:ConditionId ];
            ConditionResObj.Status=Conditionobj.Status__c;
            ConditionResObj.DescText=Conditionobj.Comment__c;
            
           
            string CreatedByName=[Select Name from User where Id=:Conditionobj.CreatedById].Name;
            string ModifyByname=[Select Name from User where Id=:Conditionobj.LastModifiedById].Name;            
              datetime dtC=Conditionobj.CreatedDate;   
            ConditionResObj.CreatedDate=dtC.format('MM/dd/yyyy HH:mm a', 'America/New_York');
            datetime dtM=Conditionobj.LastModifiedDate;   
            ConditionResObj.LastModifyDate=dtM.format('MM/dd/yyyy HH:mm a', 'America/New_York');
             ConditionResObj.LastModifyBy=ModifyByname;
            ConditionResObj.CreatedBy=CreatedByName;
            datetime dt=Conditionobj.LastModifiedDate;
            ConditionResObj.StatusDate=dt.format('MM/dd/yyyy');
            ObjCon.add(ConditionResObj);
            obj=[SELECT Id, Old_Status__c, New_Status__c, Old_Comments__c, New_Comments__c, Old_ModifiedDate__c, LastModifiedDate fROM Condition_Log__c where ConditionId__c=:ConditionId ORDER BY LastModifiedDate desc ];
            for(Condition_Log__c CL:obj)
            {
                ConditionResponse objres=new ConditionResponse();
                datetime dt1=CL.LastModifiedDate;
                objres.StatusDate=dt1.format('MM/dd/yyyy');  // CL.Old_ModifiedDate__c;             
                objres.Status=CL.Old_Status__c;
                objres.DescText=CL.Old_Comments__c;
                ObjCon.add(objres);
            }            
        }
        catch(Exception e)
        {
            system.debug('getConditionHistory--Exception---'+e);
        }    
        return ObjCon;
    }
    @AuraEnabled
    public static List<ConditionResponse> getLoanCondition(String LoanID) {
        List<ConditionResponse>ObjCon=new List<ConditionResponse>();
        List<Condition__c> obj=new List<Condition__c>();
        try
        {
            obj=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c,Condition_Created_Date__c  from Condition__c where Loan_Id__c=:LoanId];
            for(Condition__c ObjConc:obj)
            {
                ConditionResponse objres=new ConditionResponse();
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
               // datetime dt=ObjConc.CreatedDate;    
               // objres.CreatedDate=dt.date().format();
                //Display created date based on data upload from RV
                datetime dt1=ObjConc.Condition_Created_Date__c;  
                datetime dt2 = ObjConc.CreatedDate;               
                if(dt1!= null){                
                system.debug('###'+dt1);
                    datetime dt = dt1.addDays(1); 
                    objres.CreatedDate=dt.date().format();  
                }
                else{
                    objres.CreatedDate=dt2.date().format();  
                }
                //end
                datetime dtstatus=ObjConc.LastModifiedDate;  
                objres.StatusDate=dtstatus.date().format();
                objres.Id=ObjConc.Id;
                ObjCon.add(objres);
            }            
        }
        catch(exception e){
            system.debug('getLoanCondition--Exception---'+e);
        }
        return ObjCon;
    }
    @AuraEnabled
    public static Integer getConditionCount(string LoanId) {
        integer Count=[select count() from Condition__c where Loan_Id__c=:LoanId];
        return Count;        
    }
     @AuraEnabled
    public static string getLoanName(string LoanId) {
        string Name=[select Name from loan_new__c where id=:LoanId].Name;
        return Name;        
    }
    
    @AuraEnabled
    public static void SaveConditions(string ConditionList,String LoanId,boolean MailSendneeded ) {
        try
        {
            List<ConditionResponse >RequestList = (List<ConditionResponse>)JSON.deserialize(ConditionList, List<ConditionResponse>.class);
            List<Condition__c> CondList=new List<Condition__c>();
            for(ConditionResponse i:RequestList)
            {
                Condition__c CondData=new Condition__c();
                CondData.Comment__c=i.DescText;
                CondData.Condition_Number__c='Condition-'+i.Index;
                CondData.Description__c=i.DropDownValue;
                CondData.Status__c=i.Status;
                CondData.Loan_Id__c=LoanId;
                CondList.add(CondData);
            }
            insert CondList;
            if(MailSendneeded==true)
            {
                MailSendWhileAddCondition(LoanId);
            }
       }        
        catch(exception e){
            system.debug('SaveConditions--Exception---'+e);
        }
    }
    
    @AuraEnabled
    public static void MailSendWhileAddCondition(string LoanId ) {
        Loan_New__c obj=new Loan_New__c();
        try
        {
            string EmailTo;
            obj=[Select Name,Client_Name__c,CreatedById,LoanOfficer__c, Loan_Processor__c, Preferred_Contact_Type__c from Loan_New__c where id=:LoanId ];
            system.debug('Preferred_Contact_Type__c'+obj.Preferred_Contact_Type__c);
            //Logic for findding email
            if(obj.Preferred_Contact_Type__c !=null || obj.Preferred_Contact_Type__c !='')
            {
                string UserId=obj.Preferred_Contact_Type__c=='Loan Officer'?obj.LoanOfficer__c:obj.Loan_Processor__c;
                System.debug('obj.Preferred_Contact_Type__c '+obj.Preferred_Contact_Type__c);
                System.debug('UserId  '+UserId );
                EmailTo=[SELECT user_email_Id__c from User where Id=:UserId ].user_email_Id__c;
            }
            system.debug('EmailTo'+EmailTo);
            //End
            EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body, Markup FROM EmailTemplate where Name='Condition Add Email Alert' ];
            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();            
            sendTo.add(EmailTo);
            mail.setToAddresses(sendTo);
            // mail.setReplyTo(UserInfo.getUserEmail());
            mail.setReplyTo(System.Label.Orm_support1);
            mail.setSubject('ORMS Portal - Loan ID: '+ obj.Name+' has been conditioned.');
            mail.setOrgWideEmailAddressId(System.Label.Orm_support);
            String body =  template.HtmlValue ;    
            body =   body.replace('#Loan',obj.Name).replace('#ClientName',obj.Client_Name__c);        
            mail.setHtmlBody(body);
            mails.add(mail);Messaging.sendEmail(mails);
        }        
        catch(exception e){
            system.debug('MailSendWhileAddCondition--Exception---'+e);
        }
    }   
    
    @AuraEnabled
    public static Integer SaveEditConditions(string responseString,String LoanId,String ConditionId,boolean MailSendneeded ) {
        Integer ret=0;
        try
        {
            system.debug(responseString);
            ConditionResponse ObjResponse=(ConditionResponse)JSON.deserialize(responseString, ConditionResponse.class);
            //system.debug(ObjResponse);
            Condition__c objc=new Condition__c();
            objc.Status__c=ObjResponse.NewStatus;
            objc.Comment__c=ObjResponse.NewDescText;
            objc.Id=ConditionId;
            upsert objc;
            //Insert Into Log
            Condition_Log__c objConLog=new Condition_Log__c();
            objConLog.Loan_Id__c=LoanId;
            objConLog.ConditionId__c=ConditionId;
            objConLog.New_Comments__c=ObjResponse.NewDescText;
            objConLog.Old_Comments__c=ObjResponse.DescText;
            objConLog.New_Status__c=ObjResponse.NewStatus;
            objConLog.Old_Status__c=ObjResponse.Status;
            objConLog.Old_CreatedBy__c=ObjResponse.CreatedBy;
            objConLog.Old_CreatedDate__c=ObjResponse.CreatedDate;
            objConLog.Old_ModifiedBy__c=ObjResponse.LastModifyBy;
            objConLog.Old_ModifiedDate__c=ObjResponse.LastModifyDate;
            objConLog.Description__c=ObjResponse.DropDownValue;
            insert objConLog;
            if(MailSendneeded==true)
            {
                MailSendWhileEditCondition(LoanId,ConditionId);
            }
            ret=1;
        }
        catch(exception e){
            system.debug('SaveEditConditions--Exception---'+e);            
        }        
        return ret;
    }
    @AuraEnabled
    public static void MailSendWhileEditCondition(string LoanId ,String ConditionId) {
        Loan_New__c obj=new Loan_New__c();        
        try
        {
            string EmailTo;
            string Condition=[select Condition_Number__c from condition__c where id =: ConditionId].Condition_Number__c;
            obj=[Select Name,Client_Name__c,CreatedById,LoanOfficer__c,Loan_Processor__c,Preferred_Contact_Type__c from Loan_New__c where id=:LoanId ];
            //Logic for findding email
            if(obj.Preferred_Contact_Type__c !=null || obj.Preferred_Contact_Type__c !='')
            {
                string UserId=obj.Preferred_Contact_Type__c=='Loan Officer'?obj.LoanOfficer__c:obj.Loan_Processor__c;
                EmailTo=[SELECT user_email_Id__c from User where Id=:UserId ].user_email_Id__c;
            }
            //End
            EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body, Markup FROM EmailTemplate where Name='Condition Edit Email Alert' ];
            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add(EmailTo);
            mail.setToAddresses(sendTo);
            mail.setReplyTo(UserInfo.getUserEmail());
            mail.setSubject('ORMS Portal - Loan ID: '+obj.Name+' ['+Condition+'] has been updated.');
            String body =  template.HtmlValue ;    
            body =   body.replace('#LoanID',obj.Name).replace('#ClientName',obj.Client_Name__c).replace('#Condition', Condition);        
            mail.setHtmlBody(body);
            mails.add(mail);Messaging.sendEmail(mails);
        }        
        catch(exception e){
            system.debug('MailSendWhileEditCondition--Exception---'+e);
        }
    }    
    
    @AuraEnabled
    public static ConditionResponse  getConditionById(string ConditionId) {
        Condition__c objCon=new Condition__c();
        ConditionResponse objres=new ConditionResponse();
        try
        {            
            objCon=[SELECT Id,Comment__c,Description__c,Status__c,CreatedDate,LastModifiedDate   from Condition__c where Id=:ConditionId];
            string CreatedById=[Select CreatedById from Condition__c where Id=:ConditionId ].CreatedById;
            string ModifyById=[Select LastModifiedById  from Condition__c where Id=:ConditionId ].LastModifiedById;
            string CreatedByName=[Select Name from User where Id=:CreatedById].Name;
            string ModifyByname=[Select Name from User where Id=:ModifyById].Name;            
            objres.DescText=objCon.Comment__c;
            objres.DropDownValue=objCon.Description__c;
            objres.Status=objCon.Status__c;
            datetime dtC=objCon.CreatedDate;   
            objres.CreatedDate=dtC.format('MM/dd/yyyy HH:mm a', 'America/New_York');
            datetime dtM=objCon.LastModifiedDate;   
            objres.LastModifyDate=dtM.format('MM/dd/yyyy HH:mm a', 'America/New_York');
            objres.LastModifyBy=ModifyByname;
            objres.CreatedBy=CreatedByName;
        }
        catch(Exception ex)
        {
            system.debug(' getConditionById----Exception---'+ex);
        }
        return objres;
    }
    
    @AuraEnabled
    public static ConditionResponse getConditionCurrentStatusandCondition(String CinditionId) {
        
        Condition__c Conditionobj=new Condition__c();
        ConditionResponse ConditionResObj=new  ConditionResponse();
        try
        {
            Conditionobj=[Select Id,Condition_Number__c,Status__c from Condition__c where Id=:CinditionId];
            ConditionResObj.Status=Conditionobj.Status__c;
            ConditionResObj.Index=Conditionobj.Condition_Number__c;          
        }
        catch(Exception e)
        {
            system.debug('getConditionCurrentStatusandCondition--Exception---'+e);
        }
        return ConditionResObj;        
    }
    @AuraEnabled
    public static List<ConditionResponse> getConditionHistoryStatus(String LoanId, string conditionNumber) {
        List<ConditionResponse> ObjCon=new List<ConditionResponse>();      
        List<Condition_Log__c> obj=new List<Condition_Log__c>();        
        try
        {
            obj=[SELECT Id, Old_Status__c, New_Status__c, Old_ModifiedDate__c, LastModifiedDate FROM Condition_Log__c where Loan_Id__c =:LoanId and ConditionId__c=:conditionNumber ORDER BY LastModifiedDate desc ];
            for(Condition_Log__c CL:obj)
            {
                ConditionResponse objres=new ConditionResponse();
                datetime dt=CL.LastModifiedDate;
                objres.StatusDate=dt.format('MM/dd/yyyy');                
                objres.Status=CL.Old_Status__c;
                objres.NewStatus=CL.New_Status__c;               
                ObjCon.add(objres);
            }
            
        }
        catch(Exception e)
        {
            system.debug('getConditionHistoryStatus--Exception---'+e);
        }
        system.debug(ObjCon);
        return ObjCon;
    }
    
    @AuraEnabled
    public static List<ConditionResponsePipeline> getLoanConditionPipeline(String LoanID) {
        List<ConditionResponsePipeline>ObjConFinalListReturn=new List<ConditionResponsePipeline>();
        List<ConditionResponse>ObjConFinalList=new List<ConditionResponse>();
        List<ConditionResponse>ObjConOutstanding=new List<ConditionResponse>();
        List<ConditionResponse>ObjConRevisionRequested=new List<ConditionResponse>();
        List<ConditionResponse>ObjConCancelled =new List<ConditionResponse>();
        List<ConditionResponse>ObjConCleared =new List<ConditionResponse>();
        List<Condition__c> objOutstanding=new List<Condition__c>();
        List<Condition__c> objRevisionRequested=new List<Condition__c>();
        List<Condition__c> objCancelled =new List<Condition__c>();
        List<Condition__c> objCleared =new List<Condition__c>();
        try
        {
            objOutstanding=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c from Condition__c where Loan_Id__c=:LoanId and Status__c='Outstanding' ORDER BY LastModifiedDate desc];
            for(Condition__c ObjConc:objOutstanding)
            {
                ConditionResponse objres=new ConditionResponse();
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
                datetime dt=ObjConc.CreatedDate;    
                objres.CreatedDate=dt.date().format();
                datetime dtstatus=ObjConc.LastModifiedDate;  
                objres.StatusDate=dtstatus.date().format();
                objres.Id=ObjConc.Id;
                ObjConOutstanding.add(objres);
            }
            objRevisionRequested=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c from Condition__c where Loan_Id__c=:LoanId and Status__c='Revision Requested' ORDER BY LastModifiedDate desc];
            for(Condition__c ObjConc:objRevisionRequested)
            {
                ConditionResponse objres=new ConditionResponse();
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
                datetime dt=ObjConc.CreatedDate;    
                objres.CreatedDate=dt.date().format();
                datetime dtstatus=ObjConc.LastModifiedDate;  
                objres.StatusDate=dtstatus.date().format();
                objres.Id=ObjConc.Id;
                ObjConRevisionRequested.add(objres);
            }
            objCancelled=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c from Condition__c where Loan_Id__c=:LoanId and Status__c='Cancelled' ORDER BY LastModifiedDate desc];
            for(Condition__c ObjConc:objCancelled)
            {
                ConditionResponse objres=new ConditionResponse();
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
                datetime dt=ObjConc.CreatedDate;    
                objres.CreatedDate=dt.date().format();
                datetime dtstatus=ObjConc.LastModifiedDate;  
                objres.StatusDate=dtstatus.date().format();
                objres.Id=ObjConc.Id;
                ObjConCancelled.add(objres);
            }
            objCleared=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c from Condition__c where Loan_Id__c=:LoanId and Status__c='Cleared' ORDER BY LastModifiedDate desc];
            for(Condition__c ObjConc:objCleared)
            {
                ConditionResponse objres=new ConditionResponse();                
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
                datetime dt=ObjConc.CreatedDate;    
                objres.CreatedDate=dt.date().format();
                datetime dtstatus=ObjConc.LastModifiedDate;  
                objres.StatusDate=dtstatus.date().format();
                objres.Id=ObjConc.Id;
                ObjConCleared.add(objres);
            }
            ObjConFinalList.addAll(ObjConOutstanding);
            ObjConFinalList.addAll(ObjConRevisionRequested);
            ObjConFinalList.addAll(ObjConCancelled);
            ObjConFinalList.addAll(ObjConCleared);
            system.debug(ObjConFinalList.size());
            map<id,list<Condition_Log__c>> MapConditionLogList=new  map<id,list<Condition_Log__c>>();
            MapConditionLogList=GetConditionLog(loanID);
            for(ConditionResponse obj :ObjConFinalList){
                list<string> des=new   list<string> ();       
                
                ConditionResponsePipeline objres=new ConditionResponsePipeline();
                objres.Index=obj.Index;            
                list<Condition_log__c> cl=new list<Condition_log__c>();
                cl=MapConditionLogList.get(obj.id);
                if(cl==null)
                {                   
                    des.add(obj.DescText);
                    objres.DescText=des;
                }
                else
                {
                    des.add(obj.DescText);
                    for( Condition_log__c  logdata:cl)
                    {
                        string a=logdata.Old_Comments__c;
                        des.add(a);                        
                    }                    
                    objres.DescText=des;                    
                }
                objres.DropDownValue=obj.DropDownValue;
                objres.Status=obj.Status;                
                objres.CreatedDate=obj.CreatedDate;                
                objres.StatusDate=obj.StatusDate;
                objres.Id=obj.Id;
                ObjConFinalListReturn.add(objres);
            }
        }
        catch(exception e){
            system.debug('getLoanConditionPipeline--Exception---'+e);
        }
        return ObjConFinalListReturn;
    }
    public static map<id,list<Condition_Log__c>> GetConditionLog(string loanID)
    {
        map<id,list<Condition_Log__c>> conLogMap= new map<id,list<Condition_Log__c>>();
        list<Condition_Log__c> ConditionList =new list<Condition_Log__c> ();
        ConditionList= [select Old_Comments__c,ConditionId__c from Condition_Log__c where Loan_Id__c=: loanID  ORDER BY LastModifiedDate desc];
        for(Condition_Log__c conObj:ConditionList)
        {
            List<Condition_Log__c> l = conLogMap.get(conObj.ConditionId__c);
            if (l == null) {
                l = new List<Condition_Log__c>();
                conLogMap.put(conObj.ConditionId__c, l);
            }
            l.add(conObj);   
        }
        return conLogMap;        
    }
    
}