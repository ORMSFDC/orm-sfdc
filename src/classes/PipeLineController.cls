/** * File Name   : PipeLineController.cls
*     Description : This is to display loans in Pipeline based on statuses, and generate history
*     Created     : 7/28/2017
*     Modified    : 1/31: Sahitya, added new Loanstatuses for all the pipelines
*     Modified    : 4/12: Sahitya, Updated ResidentialIncomeRequired mapping
* */
public class PipeLineController {
    @AuraEnabled
    public static integer IsDataAvailable() {
        integer count=[select count()   FROM Loan_New__c where IsActiveFlag__c=: true and LoanCompleteFlag__c=: true and  LoanStatus__c!='Incomplete'];
        return count;
    }
    @AuraEnabled
    public static List<PipelineResponse> getLoanOrigination() {
        List<PipelineResponse> objRes=new List<PipelineResponse> ();
        List<Loan_New__c> obj=new List<Loan_New__c>();
        List<Client__c> objallclient=new List<Client__c>();
        List<Loan_New__c> objLoanid=new List<Loan_New__c>();  
        try{
            
            //          objLoanid=[SELECT Id FROM Loan_New__c where IsActiveFlag__c=: true and LoanCompleteFlag__c=: true and OwnerId=: userinfo.getUserId() and LoanStatus__c in('Proposal','Waiting for Full Package') ];
            objLoanid=[SELECT Id FROM Loan_New__c where IsActiveFlag__c=: true and LoanCompleteFlag__c=: true and LoanStatus__c in('Proposal','Waiting for Full Package') ];
            //          obj=  [SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c where IsActiveFlag__c=: true and LoanCompleteFlag__c=: true and OwnerId=: userinfo.getUserId() and LoanStatus__c in('Proposal','Waiting for Full Package') ORDER BY LoanStatus__c];            
            obj=  [SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c where IsActiveFlag__c=: true and LoanCompleteFlag__c=: true and LoanStatus__c in('Proposal','Waiting for Full Package') ORDER BY LoanStatus__c];
            objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where Primary_Client_for_the_Loan__c =: true and LoanId__c IN:objLoanid  ];
            
            /* to display the Picklist Label instead of API - Bala */ 
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }  
            
            for(Loan_New__c lc:obj)            
            {                
                PipelineResponse obj1=new PipelineResponse();
                obj1.Loanid=lc.ID;
                if(lc.LoanNumber__c ==null || lc.LoanNumber__c =='')
                {
                    obj1.LoanNumber=lc.Name;
                }
                else
                {
                    obj1.LoanNumber=lc.LoanNumber__c;
                }
                
                for(Client__c c:objallclient)  
                {
                    if(c.LoanId__c==lc.ID)
                    {
                        obj1.FullName= c.Name;
                    }
                }
                obj1.LoanStatus = valueLabelMap.get(lc.LoanStatus__c); //Bala
                //obj1.LoanStatus=lc.LoanStatus__c;
                obj1.LoanDate=lc.LastModifiedDate.date().format();
                objRes.add(obj1);
            }
        }
        catch(exception e){
            system.debug('getLoanOrigination--Exception---'+e);
        }
        return objRes;  
    }
    
    @AuraEnabled
    public static List<PipelineResponse> getLoanProcessing() {
        List<PipelineResponse> objRes=new List<PipelineResponse> ();
        List<Loan_New__c> obj=new List<Loan_New__c>();
        List<Client__c> objallclient=new List<Client__c>();
        List<Loan_New__c> objLoanid=new List<Loan_New__c>();  
        try
        {
            obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Application Package Received','In Processing','Full Application Received - Incomplete','Loan Submission Received- Awaiting Review') ORDER BY LoanStatus__c ];   
            objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Application Package Received','In Processing','Full Application Received - Incomplete','Loan Submission Received- Awaiting Review')];
            objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];
            
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe(); //Bala
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            } 
            
            for(Loan_New__c lc:obj)            
            {
                PipelineResponse obj1=new PipelineResponse();
                obj1.Loanid=lc.ID;
                if(lc.LoanNumber__c ==null || lc.LoanNumber__c =='')
                {
                    obj1.LoanNumber=lc.Name;
                }
                else
                {
                    obj1.LoanNumber=lc.LoanNumber__c;
                }
                for(Client__c c:objallclient)  
                {
                    if(c.LoanId__c==lc.ID)
                    {
                        obj1.FullName= c.Name;
                    }
                }
                
                obj1.LoanStatus = valueLabelMap.get(lc.LoanStatus__c); //Bala
               // obj1.LoanStatus=lc.LoanStatus__c;
                obj1.LoanDate=lc.LastModifiedDate.date().format();
                objRes.add(obj1);
            }
        }
        catch(exception e){
            system.debug('getLoanProcessing--Exception---'+e); 
        }
        return objRes;
    }
    
    @AuraEnabled
    public static List<PipelineResponse> getLoanUnderWriting() {
        List<PipelineResponse> objRes=new List<PipelineResponse> ();
        List<Loan_New__c> obj=new List<Loan_New__c>();
        List<Client__c> objallclient=new List<Client__c>();
        List<Loan_New__c> objLoanid=new List<Loan_New__c>(); 
        try
        {
            obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Conditionally Approved','Underwriting clear to close','In Underwriting Review') ORDER BY LoanStatus__c ];   
            objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Conditionally Approved','Underwriting clear to close','In Underwriting Review')];
            objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];
            
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe(); //Bala
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }         
            
            for(Loan_New__c lc:obj)            
            {            
                PipelineResponse obj1=new PipelineResponse();
                obj1.Loanid=lc.ID;
                if(lc.LoanNumber__c ==null || lc.LoanNumber__c =='')
                {
                    obj1.LoanNumber=lc.Name;
                }
                else
                {
                    obj1.LoanNumber=lc.LoanNumber__c;
                }    
                for(Client__c c:objallclient)  
                {
                    if(c.LoanId__c==lc.ID)
                    {
                        obj1.FullName= c.Name;
                    }
                }
                //Client__c objClient=new Client__c();
                //objClient=[SELECT First_Name__c, Last_Name__c FROM Client__c where LoanId__c=:lc.Id and Primary_Client_for_the_Loan__c =: true];
                //obj1.FullName= objClient.First_Name__c+' '+ objClient.Last_Name__c;
                obj1.LoanStatus = valueLabelMap.get(lc.LoanStatus__c); //Bala
                //obj1.LoanStatus=lc.LoanStatus__c;
                obj1.LoanDate=lc.LastModifiedDate.date().format();
                objRes.add(obj1);
            }           
        }
        catch(exception e){
            system.debug('getLoanUnderWriting--Exception---'+e);
        }
        return objRes;
    }
    
    @AuraEnabled
    public static List<PipelineResponse> getLoanSuspended() {
        List<PipelineResponse> objRes=new List<PipelineResponse> ();
        List<Loan_New__c> obj=new List<Loan_New__c>();
        List<Client__c> objallclient=new List<Client__c>();
        List<Loan_New__c> objLoanid=new List<Loan_New__c>(); 
        try
        {
           //    obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true and OwnerId=: userinfo.getUserId() and LoanStatus__c in('Suspended') ORDER BY LoanStatus__c ];   
        //    objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true and OwnerId=: userinfo.getUserId() and LoanStatus__c in('Suspended')];
        //    objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];
            obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Suspended') ORDER BY LoanStatus__c ];   
            objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Suspended')];
         objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];
            
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }  //Bala 
            
            for(Loan_New__c lc:obj)            
            {
                
                PipelineResponse obj1=new PipelineResponse();
                obj1.Loanid=lc.ID;
                if(lc.LoanNumber__c ==null || lc.LoanNumber__c =='')
                {
                    obj1.LoanNumber=lc.Name;
                }
                else
                {
                    obj1.LoanNumber=lc.LoanNumber__c;
                }
                for(Client__c c:objallclient)  
                {
                    if(c.LoanId__c==lc.ID)
                    {
                        obj1.FullName= c.Name;
                    }
                }
                //Client__c objClient=new Client__c();
                // objClient=[SELECT First_Name__c, Last_Name__c FROM Client__c where LoanId__c=:lc.Id and Primary_Client_for_the_Loan__c =: true];
                //obj1.FullName= objClient.First_Name__c+' '+ objClient.Last_Name__c;
                obj1.LoanStatus = valueLabelMap.get(lc.LoanStatus__c); //Bala                
                //obj1.LoanStatus=lc.LoanStatus__c;
                obj1.LoanDate=lc.LastModifiedDate.date().format();
                objRes.add(obj1);
            }           
        }
        catch(exception e){
            system.debug('getLoanSuspended--Exception---'+e);
        }
        return objRes;
    }
    
    @AuraEnabled
    public static List<PipelineResponse> getLoanClosing() {
        List<PipelineResponse> objRes=new List<PipelineResponse> ();
        List<Loan_New__c> obj=new List<Loan_New__c>();
        List<Client__c> objallclient=new List<Client__c>();
        List<Loan_New__c> objLoanid=new List<Loan_New__c>(); 
        try
        {
             //   obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true and OwnerId=: userinfo.getUserId() and LoanStatus__c in('Awaiting Closing','Closed - Awaiting Funding') ORDER BY LoanStatus__c ];   
         //   objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true and OwnerId=: userinfo.getUserId() and LoanStatus__c in('Awaiting Closing','Closed - Awaiting Funding')];
         //   objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];
            obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Awaiting Closing','Closed - Awaiting Funding','In final HUD Review','Docs Out to Settlement Agent') ORDER BY LoanStatus__c ];   
            objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Awaiting Closing','Closed - Awaiting Funding','In final HUD Review','Docs Out to Settlement Agent')];
            objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];
            
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }  //Bala 
            
            for(Loan_New__c lc:obj)            
            {
                
                PipelineResponse obj1=new PipelineResponse();
                obj1.Loanid=lc.ID;
                if(lc.LoanNumber__c ==null || lc.LoanNumber__c =='')
                {
                    obj1.LoanNumber=lc.Name;
                }
                else
                {
                    obj1.LoanNumber=lc.LoanNumber__c;
                }
                for(Client__c c:objallclient)  
                {
                    if(c.LoanId__c==lc.ID)
                    {
                        obj1.FullName= c.Name;
                    }
                }
                // Client__c objClient=new Client__c();
                //objClient=[SELECT First_Name__c, Last_Name__c FROM Client__c where LoanId__c=:lc.Id and Primary_Client_for_the_Loan__c =: true];
                //obj1.FullName= objClient.First_Name__c+' '+ objClient.Last_Name__c;
                obj1.LoanStatus = valueLabelMap.get(lc.LoanStatus__c); //Bala                
                //obj1.LoanStatus=lc.LoanStatus__c;
                obj1.LoanDate=lc.LastModifiedDate.date().format();
                objRes.add(obj1);
            }
        }
        catch(exception e){
            system.debug('getLoanClosing--Exception---'+e);
        }
        return objRes;
    }
    
    @AuraEnabled
    public static List<PipelineResponse> getLoanFunded() {
        List<PipelineResponse> objRes=new List<PipelineResponse> ();
        List<Loan_New__c> obj=new List<Loan_New__c>();
        List<Client__c> objallclient=new List<Client__c>();
        List<Loan_New__c> objLoanid=new List<Loan_New__c>(); 
        try
        {
           //   obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true and OwnerId=: userinfo.getUserId() and LoanStatus__c in('Funded') ORDER BY LoanStatus__c ];   
         //   objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true and OwnerId=: userinfo.getUserId() and LoanStatus__c in('Funded')];
         //   objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];

            obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Funded') ORDER BY LoanStatus__c ];   
            objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true and LoanStatus__c in('Funded')];
          objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];
            
             Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }  //Bala
            
            for(Loan_New__c lc:obj)            
            {
                PipelineResponse obj1=new PipelineResponse();
                obj1.Loanid=lc.ID;
                if(lc.LoanNumber__c ==null || lc.LoanNumber__c =='')
                {
                    obj1.LoanNumber=lc.Name;
                }
                else
                {
                    obj1.LoanNumber=lc.LoanNumber__c;
                }
                for(Client__c c:objallclient)  
                {
                    if(c.LoanId__c==lc.ID)
                    {
                        obj1.FullName= c.Name;
                    }
                }
                //Client__c objClient=new Client__c();
                //objClient=[SELECT First_Name__c, Last_Name__c FROM Client__c where LoanId__c=:lc.Id and Primary_Client_for_the_Loan__c =: true];
                //obj1.FullName= objClient.First_Name__c+' '+ objClient.Last_Name__c;

                obj1.LoanStatus = valueLabelMap.get(lc.LoanStatus__c); //Bala                               
                //obj1.LoanStatus=lc.LoanStatus__c;
                obj1.LoanDate=lc.LastModifiedDate.date().format();
                objRes.add(obj1);
            }
        }
        catch(exception e){
            system.debug('getLoanFunded--Exception---'+e);
        }
        return objRes;
    }
    
    @AuraEnabled
    public static List<PipelineResponse> getLoanCancelled() {
        List<PipelineResponse> objRes=new List<PipelineResponse> ();
        List<Loan_New__c> obj=new List<Loan_New__c>();
        List<Client__c> objallclient=new List<Client__c>();
        List<Loan_New__c> objLoanid=new List<Loan_New__c>(); 
        try
        {
            obj=[SELECT Id,Name,LoanNumber__c,LoanStatus__c ,LastModifiedDate FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true and LoanStatus__c in('Denied', 'Withdrawn','Loan Rescinded','Application Approved but Not Accepted','File Closed for Incompleteness' ) ORDER BY LoanStatus__c ];   
            objLoanid=[SELECT Id FROM Loan_New__c  where IsActiveFlag__c=:true and LoanCompleteFlag__c=: true  and LoanStatus__c in('Denied','Withdrawn','Loan Rescinded','Application Approved but Not Accepted','File Closed for Incompleteness')];
            objallclient=[SELECT Name,First_Name__c, Last_Name__c,LoanId__c FROM Client__c where LoanId__c IN:objLoanid and Primary_Client_for_the_Loan__c =: true];
            
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }  //Bala 
            
            for(Loan_New__c lc:obj)            
            {
                PipelineResponse obj1=new PipelineResponse();
                obj1.Loanid=lc.ID;
                if(lc.LoanNumber__c ==null || lc.LoanNumber__c =='')
                {
                    obj1.LoanNumber=lc.Name;
                }
                else
                {
                    obj1.LoanNumber=lc.LoanNumber__c;
                }
                for(Client__c c:objallclient)  
                {
                    if(c.LoanId__c==lc.ID)
                    {
                        obj1.FullName= c.Name;
                    }
                }
                //Client__c objClient=new Client__c();
                //objClient=[SELECT First_Name__c, Last_Name__c FROM Client__c where LoanId__c=:lc.Id and Primary_Client_for_the_Loan__c =: true];
                //obj1.FullName= objClient.First_Name__c+' '+ objClient.Last_Name__c;
                obj1.LoanStatus = valueLabelMap.get(lc.LoanStatus__c); //Bala
                //obj1.LoanStatus=lc.LoanStatus__c;
                obj1.LoanDate=lc.LastModifiedDate.date().format();
                objRes.add(obj1);
            }
        }
        catch(exception e){
            system.debug('getLoanCancelled--Exception---'+e);
        }
        return objRes;
    }
    
    @AuraEnabled
    public static List<PipeLineReDisclouserHistoryResponse> GetDisclouserHistory(String LoanID) {
        List<PipeLineReDisclouserHistoryResponse> objResponse=new List<PipeLineReDisclouserHistoryResponse> ();
        List<PipeLine_ReDisclosure_Reason__c> obj=new List<PipeLine_ReDisclosure_Reason__c>();
        try
        {
            obj=[SELECT NewReDisclosurer_Date__c,OldReDisclosurer_Date__c,ReDisclosure_Reason__c,LastModifiedDate from 
                 PipeLine_ReDisclosure_Reason__c where LoanId__c=:LoanID ORDER BY LastModifiedDate DESC];
            for(PipeLine_ReDisclosure_Reason__c oReDisc:obj)
            {
                PipeLineReDisclouserHistoryResponse objRes=new PipeLineReDisclouserHistoryResponse();
                objRes.CurrentDisclouserDate=oReDisc.NewReDisclosurer_Date__c !=null?oReDisc.NewReDisclosurer_Date__c.format():'';
                objRes.oldDisclouserDate=oReDisc.OldReDisclosurer_Date__c !=null?oReDisc.OldReDisclosurer_Date__c.format():'';
                objRes.DisclouserReason=oReDisc.ReDisclosure_Reason__c;
                objRes.ReasonChangeDate=oReDisc.LastModifiedDate !=null?oReDisc.LastModifiedDate.format():'';
                objResponse.add(objRes);
                system.debug(objResponse);
            }
            
        }
        catch(exception e){
            system.debug('GetDisclouserHistory--Exception---'+e);
        }
        return objResponse;
    }
    @AuraEnabled
    public static List<PipeLineStatusChangeResponse> GetLoanStatusHistory(String LoanID) {
        List<PipeLineStatusChangeResponse> objRes=new List<PipeLineStatusChangeResponse> ();
        List<LoanStatus__c> obj=new List<LoanStatus__c>();
        
        
        try
        {
            obj=[SELECT Id,Name,PreviousStatus__c,LastModifiedDate FROM LoanStatus__c  where LoanId__c=:LoanID ORDER BY LastModifiedDate DESC ];   
            
            
            //objRes.add(objr);
            for(LoanStatus__c lcStatus:obj)            
            {
                PipeLineStatusChangeResponse obj1=new PipeLineStatusChangeResponse();
                obj1.LoanCurrentStatus=lcStatus.Name;
                obj1.LoanPrevioustatus=lcStatus.PreviousStatus__c; 
                datetime dt=lcStatus.LastModifiedDate;               
                obj1.LoanStatusChangeDate=dt.date().format();
                objRes.add(obj1);
            }
        }
        catch(exception e){
            system.debug('GetLoanStatusHistory--Exception---'+e);
        }
        return objRes;
    }
    
    @AuraEnabled
    public static PipeLineDateResponse getLoanDate(String LoanID) {
        PipeLineDateResponse objdate=new PipeLineDateResponse();
        try
        {
            Loan_New__c obj1=new Loan_New__c();
            obj1=[SELECT Id,Application_Date__c, Application_Signed_Date__c, Closing_Date__c,Counseling_Date__c,FHA_Case_Number_Date__c,
                  Next_Tax_Due_Date__c,Anticipated_Closing_Date__c,Actual_Funding_Date__c,Scheduled_Closing_Date__c,
                  
                  Payoff_Order_Date__c,Credit_Report_Date__c,Appraisal_Ordered_Date__c,Appraisal_Scheduled_Date__c,
                  Appraisal_Received_Date__c,Appraisal_Effective_Date__c,Title_Ordered_Date__c,Title_Received_Date__c,
                  Flood_Ordered_Date__c,Flood_Received_Date__c,Insurance_Binder_Ordered_Date__c,Insurance_Binder_Received_Date__c,
                  
                  Re_disclosure_Date__c,ReDisclosure_Reason__c,Other_ReDisclosure_Reason__c,
                  Cooling_Off_Notice_Signed_Date__c ,Subject_Property_State__c from Loan_New__c where id=: LoanID limit 1];
            
            objdate.ApplicationDate=obj1.Application_Date__c !=null?obj1.Application_Date__c.format():'';
            objdate.ApplicationSignedDate=obj1.Application_Signed_Date__c !=null?obj1.Application_Signed_Date__c.format():'';   //added by Bala
            //objdate.AppraisalExpirationDate=obj1.Appraisal_Expiration_Date__c !=null?obj1.Appraisal_Expiration_Date__c.format():'';
            objdate.AppraisalOrderDate=obj1.Appraisal_Ordered_Date__c !=null?obj1.Appraisal_Ordered_Date__c.format():'';
            objdate.AppraisalReceivedDate=obj1.Appraisal_Received_Date__c !=null?obj1.Appraisal_Received_Date__c.format():'';
            //objdate.AppraisalSenttoClientDate=obj1.Appraisal_sent_to_Client_Date__c !=null?obj1.Appraisal_sent_to_Client_Date__c.format():'';
            objdate.CounselingDate=obj1.Counseling_Date__c !=null?obj1.Counseling_Date__c.format():'';
            objdate.FHACaseNaumberDate=obj1.FHA_Case_Number_Date__c !=null?obj1.FHA_Case_Number_Date__c.format():'';
            //objdate.HOIEffectiveDate=obj1.HOI_Effective_Date__c !=null?obj1.HOI_Effective_Date__c.format():'';
            objdate.NextTaxDueDate=obj1.Next_Tax_Due_Date__c !=null?obj1.Next_Tax_Due_Date__c.format():'';
            objdate.ReDiscloserDate=obj1.Re_disclosure_Date__c !=null?obj1.Re_disclosure_Date__c.format():'';
            objdate.ClosingDate=obj1.Closing_Date__c !=null?obj1.Closing_Date__c.format():'';
            objdate.ReDiscloserReason=obj1.ReDisclosure_Reason__c =='Other'?obj1.Other_ReDisclosure_Reason__c:obj1.ReDisclosure_Reason__c;
            
            objdate.AnticipatedClosingDate=obj1.Anticipated_Closing_Date__c !=null?obj1.Anticipated_Closing_Date__c.format():'';
            objdate.ScheduledClosingDate=obj1.Scheduled_Closing_Date__c !=null?obj1.Scheduled_Closing_Date__c.format():'';
            objdate.ActualFundingDate=obj1.Actual_Funding_Date__c !=null?obj1.Actual_Funding_Date__c.format():'';
            
            objdate.PayoffOrderDate=obj1.Payoff_Order_Date__c !=null?obj1.Payoff_Order_Date__c.format():'';
            objdate.CreditReportDate=obj1.Credit_Report_Date__c !=null?obj1.Credit_Report_Date__c.format():'';
            objdate.AppraisalScheduledDate=obj1.Appraisal_Scheduled_Date__c !=null?obj1.Appraisal_Scheduled_Date__c.format():'';
            objdate.AppraisalEffectiveDate=obj1.Appraisal_Effective_Date__c !=null?obj1.Appraisal_Effective_Date__c.format():'';
            objdate.TitleOrderedDate=obj1.Title_Ordered_Date__c !=null?obj1.Title_Ordered_Date__c.format():'';
            objdate.TitleReceivedDate=obj1.Title_Received_Date__c !=null?obj1.Title_Received_Date__c.format():'';
            objdate.FloodOrderedDate=obj1.Flood_Ordered_Date__c !=null?obj1.Flood_Ordered_Date__c.format():'';
            objdate.FloodReceivedDate=obj1.Flood_Received_Date__c !=null?obj1.Flood_Received_Date__c.format():'';
            objdate.InsuranceBinderOrderedDate=obj1.Insurance_Binder_Ordered_Date__c !=null?obj1.Insurance_Binder_Ordered_Date__c.format():'';
            objdate.InsuranceBinderReceivedDate=obj1.Insurance_Binder_Received_Date__c !=null?obj1.Insurance_Binder_Received_Date__c.format():'';
            objdate.CoolingOffNoticeSignedDate=obj1.Cooling_Off_Notice_Signed_Date__c !=null?obj1.Cooling_Off_Notice_Signed_Date__c.format():'';
            objdate.LoanOriginationState=obj1.Subject_Property_State__c !=null?obj1.Subject_Property_State__c:'';
            
            
        }
        catch(Exception ex){
            system.debug('getLoanDate--Exception---'+ex);
        }
        // system.debug('objdate'+objdate);
        return objdate;
    }
    
    @AuraEnabled
    public static PipeLineDetailsResponse getLoanDetails(String LoanID) {       
        PipeLineDetailsResponse objPinew=new PipeLineDetailsResponse();
        try{
            Loan_New__c objl=new Loan_New__c();
            
            objl = [SELECT Id,LoanStatus__c,LoanNumber__c,LastModifiedDate,Application_Date__c,
                    Subject_Property_Address__c,Subject_Property_City__c,Subject_Property_State__c,
                    Subject_Property_Zip_Code__c,Contact_Email__c FROM Loan_New__c where id=: LoanID limit 1];
            Client__c clientObj=new Client__c();
            clientObj = [SELECT Name,First_Name__c, Last_Name__c,Email_Optional__c,DOB__c,  
                         Home_Phone__c,Client_State__c,Street_Address__c,Zip__c,City__c from Client__c where LoanId__c=: objl.Id and Primary_Client_for_the_Loan__c =: true limit 1];
            
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }  //Bala 
            
            user AeUser=GetAEAndPhone();
            if(AeUser !=null)
            {
                objPinew.CreatedBy=AeUser.Name; 
                objPinew.Phone=AeUser.Phone;
            }
            
            
            objPinew.LoanNumberDetails=objl.LoanNumber__c;
            objPinew.FullName=clientObj.Name;
            objPinew.LoanStatus = valueLabelMap.get(objl.LoanStatus__c);   //Bala         
            //objPinew.LoanStatus=objl.LoanStatus__c;          
            objPinew.Address=objl.Subject_Property_Address__c+', '+objl.Subject_Property_City__c +', '+ objl.Subject_Property_State__c +', '+objl.Subject_Property_Zip_Code__c;
            objPinew.Email=clientObj.Email_Optional__c;
            objPinew.ContactEmail = objl.Contact_Email__c;
           
            if(objl.LastModifiedDate != null)
            {
                objPinew.LoanDate=objl.Application_Date__c.format();
            }
            
            
            objPinew.CPhone=clientObj.Home_Phone__c;
            if(clientObj.DOB__c != null)
            {
                datetime dt=clientObj.DOB__c;
                objPinew.DOB=dt.date().format();
            }
        }
        catch(Exception ex){
            system.debug('getLoanDetails--Exception---'+ex);
        }
        return objPinew;
    }
    
    @AuraEnabled    
    public static PipeLineSummaryResponse getLoanSummary(ID LoanID) {  
        PipeLineSummaryResponse objSummary=new PipeLineSummaryResponse();
        try
        {
            Loan_New__c objl=new Loan_New__c();//prsn
            objl = [SELECT Id, LoanNumber__c,FundtoClose__c,PropertyAppraisalValue__c,
                    FinancialAssessmentResult__c ,TotalLesa__c ,BrokerCompensation__c,
                    
                    ProceedsAvailableFirstYear__c,LineOfCreditAfterFirstYear__c,InitialUnpaidPrincipalBalance__c,
                    PrincipalLimit__c,Margin__c,MandatoryObligations__c,InitialInterestRate__c,ExpectedInterestRate__c,
                    RepairEstimate__c,FHACaseNumber__c,RepairSetAside__c,Broker_Origination__c,Residual_Income_Required__c,                    
                    Lien_Balance__c,Lien_Creditor__c,Life_Expectancy__c,Residual_Income_Fulfilled__c,Residential_Income_Required__c,
                    Total_Asset__c,Total_Expenses__c,Total_Income__c,Total_Monthly_Property_Charge__c,Contact_Email__c
                    
                    FROM Loan_New__c where id=: LoanID limit 1];
            Client__c clientObj=new Client__c();
            try{
            clientObj = [SELECT First_Name__c, Last_Name__c,Email_Optional__c,DOB__c,   
                         Phone_Number__c,Client_State__c,Street_Address__c,Zip__c,City__c from Client__c where LoanId__c=: objl.Id and Primary_Client_for_the_Loan__c =: true limit 1];
            }catch(exception ex){}
                if(test.isRunningTest()){
                clientObj = new Client__c();
                clientObj.DOB__c = system.today();
            }
            objSummary.LoanNumberDetails=objl.LoanNumber__c;
            objSummary.FullName=clientObj.First_Name__c +' '+ clientObj.Last_Name__c;
            if(clientObj.DOB__c != null)
            {
                datetime dt=clientObj.DOB__c;
                objSummary.DateofBirth=dt.date().format();
            }
            objSummary.Phone=clientObj.Phone_Number__c;
            objSummary.Email=clientObj.Email_Optional__c;
            objSummary.CashDueClosing=objl.FundtoClose__c;
            //objSummary.CashAvlClient=objl.CashAvaliabletoClient__c;
            objSummary.ProAppValue=objl.PropertyAppraisalValue__c;
            objSummary.LESA=objl.TotalLesa__c;
            objSummary.BrokerComp=objl.BrokerCompensation__c;
            //objSummary.MonthPayAvlClient=objl.MonthlyPaymentavailabletoClient__c;
            objSummary.FinancialAsstResult=objl.FinancialAssessmentResult__c;
            objSummary.ProcAvailFirstYear=objl.ProceedsAvailableFirstYear__c;
            objSummary.LineOfCredit=objl.LineOfCreditAfterFirstYear__c;
            objSummary.InitialUnpaidPriBal=objl.InitialUnpaidPrincipalBalance__c;
            objSummary.PrincipalLimit=objl.PrincipalLimit__c;
            objSummary.MandatoryObligation=objl.MandatoryObligations__c;
            objSummary.Margin=objl.Margin__c;
            objSummary.InitialInterestRate=objl.InitialInterestRate__c;
            objSummary.ExpectedInterestRate=objl.ExpectedInterestRate__c;
            objSummary.RepairEstimate=objl.RepairEstimate__c;
            objSummary.FHACaseNumber=objl.FHACaseNumber__c;
            objSummary.RepairSetAside=objl.RepairSetAside__c;
            objSummary.BrokerOrigination=String.valueOf(objl.Broker_Origination__c) ;
            
            objSummary.LifeExpectancy=objl.Life_Expectancy__c;
            objSummary.ResidentialIncomeRequired=objl.Residual_Income_Required__c;
            objSummary.TotalIncome=objl.Total_Income__c;
            objSummary.TotalAssets=objl.Total_Asset__c;//prsn
            objSummary.TotalExpenses=objl.Total_Expenses__c;
            objSummary.ResidualIncome=objl.Residual_Income_Fulfilled__c;
            objSummary.TotalMonthlyPropertyCharges=objl.Total_Monthly_Property_Charge__c;//prsn
            
            objSummary.LienBalance=objl.Lien_Balance__c;
           objSummary.LienCreditor=Decimal.valueOf(objl.Lien_Creditor__c);
            
            objSummary.ContactEmail=objl.Contact_Email__c;
            
            
        }
        catch(Exception ex){
            system.debug('getLoanSummary--Exception---'+ex);
        }
        return objSummary;
    }
    
    @AuraEnabled    
    public static PipeLineEmailResponse getEmailData(ID LoanID) {  
        Loan_New__c objl=new Loan_New__c();
        PipeLineEmailResponse objSummary=new PipeLineEmailResponse();
        try
        {
            objl = [SELECT Id,LoanNumber__c,LoanStatus__c,PipeLine_BestContact__c,PipeLine_BestContactTime__c,
                    PipeLine_OtherContactFlag__c,IsOrderAppraisalFlag__c,CreatedDate,Income_and_Asset_Documentation__c,
                    Driver_License_and_Social_Security_Card__c,HECM_Counseling_Certificate__c,
                    Fully_Signed_Application_Package__c,Related_Individual__c,Client_Name__c,LoanOfficer__c,ORMS_AE__c
                    FROM Loan_New__c where id=: LoanID limit 1];
            
            string AccountId=[SELECT AccountId from User where Id=:Userinfo.getUserId()].AccountId;
            
            string username=[SELECT Name from Account where Id=:AccountId].Name;
            
            Client__c clientObj=new Client__c();
            
            clientObj = [SELECT Name,First_Name__c, Last_Name__c,Email_Optional__c,DOB__c,  
                         Phone_Number__c,Client_State__c,Street_Address__c,Zip__c,City__c from Client__c where LoanId__c=: objl.Id  and Primary_Client_for_the_Loan__c =: true limit 1];
            
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }  //Bala
            
            objSummary.LoanNumberDetails=objl.LoanNumber__c;
            objSummary.BorrowerName=clientObj.Name; 
            //datetime dt=objl.PipeLine_BestContactTime__c;   
            // string dttest=dt.format('MM/dd/yyyy HH:mm a', 'America/New_York');
            
            objSummary.ContactTime=objl.PipeLine_BestContactTime__c;
            objSummary.Phone=clientObj.Phone_Number__c;
            //objSummary.LoanOfficerName=objl.Loan_Originator_s_First_Name__c+' '+objl.Loan_Originator_s_Last_Name__c;
            objSummary.partnerName=username;
            objSummary.LoanStatus = valueLabelMap.get(objl.LoanStatus__c); //Bala
            //objSummary.LoanStatus=objl.LoanStatus__c;
            objSummary.OrderAppFlag=objl.IsOrderAppraisalFlag__c;
            objSummary.BestContact=objl.PipeLine_BestContact__c;
            objSummary.BestContactList=getBestContactList(LoanID);           
            objSummary.OtherContactFlag=objl.PipeLine_OtherContactFlag__c;
            objSummary.Fully_Signed_Application_Package = objl.Fully_Signed_Application_Package__c;
            objSummary.HECM_Counseling_Certificate = objl.HECM_Counseling_Certificate__c;
            objSummary.Driver_License_and_Social_Security_Card  = objl.Driver_License_and_Social_Security_Card__c;
            objSummary.Income_and_Asset_Documentation = objl.Income_and_Asset_Documentation__c;
            objSummary.ClientName = objl.Client_Name__c;
            objSummary.Individual = objl.Related_Individual__c;
            objSummary.LoanOfficer = objl.LoanOfficer__c;
            objSummary.AccountExecutive = objl.ORMS_AE__c;
            
            if(objl.PipeLine_OtherContactFlag__c==true)
            {
                objSummary.BestContact='New/Other';
                String bestcontact=objl.PipeLine_BestContact__c;
                String[] arrContact = bestcontact.split('\\,');
                
                objSummary.OtherContactName=arrContact[0];
                objSummary.OtherContactPhone=arrContact[1];
            }
            else
            {
                objSummary.BestContact=objl.PipeLine_BestContact__c;
                objSummary.OtherContactName='';
                objSummary.OtherContactPhone='';
            }
        }
        catch(Exception ex){
            system.debug('getEmailData--Exception---'+ex);
        }
        return objSummary;
    }
    
    @AuraEnabled 
    public static  integer UpdateLoanPipeLineEmail(string responseString,string LoanID)
    {
        PipeLineEmailResponse response = (PipeLineEmailResponse)JSON.deserialize(responseString, PipeLineEmailResponse.class);
        //system.debug(response);
        //  system.debug(LoanID);
        
        Loan_new__c objloan=new loan_new__c();
        objloan.Id=LoanID;
        if(response.BestContact=='New/Other')
        {
            objloan.PipeLine_BestContact__c=response.OtherContactName+', '+response.OtherContactPhone;
            objloan.PipeLine_OtherContactFlag__c=true;
        }
        else
        {
            objloan.PipeLine_BestContact__c=response.BestContact;
            response.OtherContactName='';
            response.OtherContactPhone='';
            objloan.PipeLine_OtherContactFlag__c=false;
        }
        
        objloan.PipeLine_BestContactTime__c=response.ContactTime;
        upsert objloan;
        return 1;
        
    }
    
    
    @AuraEnabled  
    public static void  sendMail(String BorrowerName,String Email,String LoanNumber,string PhoneNumber,string PartnerName,string LoanOfficerName,string ContactTime,string LoanId)
    {
        try
        {
            if(LoanOfficerName ==null || LoanOfficerName==' ')
            {
                LoanOfficerName='';
            }        
            if(LoanNumber ==null || LoanNumber==' ')
            { 
                LoanNumber='';
            }
            
            String getUserEmailID =UserInfo.getUserEmail();
            String getUsername =UserInfo.getName();
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
            
            // Step 3: Set who the email is sent from
            mail.setReplyTo(getUserEmailID);
            mail.setSubject('Appraisal Order Needed:');
            String body ;
            
            body='<html><body><table><tr><td colspan="1">Hello ORM Supprort,</td></tr><br></br> <tr><td>Loan Number: </td>';
            body+='<td>'+LoanNumber+'</td> </tr> <tr> <td> Contact Time : </td>';
            body+='<td>'+ContactTime+'</td> </tr> <tr> <td>Borrower Name : </td>';
            body+='<td>'+BorrowerName+'</td> </tr> <tr> <td> Loan Officer Name : </td>';
            body+='<td>'+LoanOfficerName+'</td> </tr> <tr> <td> Partner Name : </td>';
            body+='<td>'+PartnerName+'</td> </tr> <tr> <td> Phone Number : </td>';
            body+='<td>'+PhoneNumber+'</td> </tr> <tr><td colspan="1"></td></tr> <td colspan="1"></td></tr> <tr> <td colspan="1">Thanks, </td> </tr> <tr>'; 
            body+='<td colspan="1">'+PartnerName+'</td> </tr>'; 
            body+=  ' </table> </body> </html>';
            
            mail.setHtmlBody(body);
            
            // Step 5. Add your email to the master list
            mails.add(mail);
            // Step 6: Send all emails in the master list        
            
            Messaging.sendEmail(mails);
            Loan_New__c obj=new Loan_New__c();
            obj.id=LoanId;
            obj.IsOrderAppraisalFlag__c=true;
            upsert obj;
        }
        catch(Exception ex){
            system.debug('sendMail--Exception---'+ex);
        }
    }
    public static String FormatPhone(String Phone) {
        try{
            string nondigits = '[^0-9]';
            string PhoneDigits;
            
            // remove all non numeric
            PhoneDigits = Phone.replaceAll(nondigits,'');
            
            // 10 digit: reformat with dashes
            if (PhoneDigits.length() == 10) 
                return '('+PhoneDigits.substring(0,3) + ') ' +
                PhoneDigits.substring(3,6) + '-' +
                PhoneDigits.substring(6,10);
        }
        catch(exception e)
        {
            system.debug('FormatPhone--Exception---'+ e);
        }
        return(Phone);
    }
    
    public static User GetAEAndPhone() {
        user objuser=new user();
        try
        {
            List<user> Accid=new  List<user>();
            Accid=[Select AccountId from user where id=: Userinfo.getUserId()];
            
            if(Accid != null && Accid.size() > 0)
            {
                List<Account>AEId=[Select Account_Executive_Name__c from Account where id=: Accid[0].AccountId];
                // system.debug(AEId);
                if(AEId != null && AEId.size() > 0) {
                    return objuser=[SELECT Id, Name, Phone, MobilePhone FROM User where Id=: AEId[0].Account_Executive_Name__c];
                    //system.debug('user'+objuser);
                }else {
                    return objuser = null;
                }  
            }
            else
            {
                return objuser=null;
            }
        }
        catch(Exception ex){
            system.debug('GetAEAndPhone---'+ex);
            return objuser=null;
        }
        
    }
    
    public static List<string> getBestContactList(ID LoanID)
    {
        List<String>BestContact=new  List<String>();
        //String BestContactdata;
        Loan_New__c objl=new Loan_New__c();
        objl=[Select Alternate_Contact_Name__c,Alternate_Contact_Phone_number__c from Loan_New__c where id=:LoanID];
        Client__c clientObj=new Client__c();
        clientObj=[Select Home_Phone__c, First_Name__c, Last_Name__c from Client__c where LoanId__c=:  LoanID and Primary_Client_for_the_Loan__c =: true];
        BestContact.Add(clientObj.First_Name__c+' '+clientObj.Last_Name__c+', '+FormatPhone(clientObj.Home_Phone__c));
        BestContact.Add(objl.Alternate_Contact_Name__c+', '+FormatPhone(objl.Alternate_Contact_Phone_number__c));        
        BestContact.Add('New/Other');
        
        return BestContact;
        
    }
    
    @AuraEnabled
    public static void UpdatePipeline(Loan_New__c Objloan,string LoanId) {
        try{
            Loan_New__c ObjL = [SELECT Id from Loan_New__c where Id=: LoanId];
            
            if(ObjL != Null)
            {
               Objloan.Id = LoanId;
               upsert Objloan;
            }
        }
        catch(Exception ex)
        {
            system.debug(' Save----Exception---'+ex);
        }
    }
    
     @AuraEnabled //Bala - A task will be created for PCS/AE based on LoanStatus, when an Appraisal is requested -- 4/20
    public static void createTask(String LoanID){
        
        List<Loan_New__c> ls = new List<Loan_New__c>();
        
        System.debug('>>>'+LoanID);
         ls =  [SELECT Id, Name, LoanStatus__c
               FROM Loan_New__c 
               where Id = :LoanID
               and IsActiveFlag__c=: true 
               and LoanCompleteFlag__c=: true               
               ORDER BY LoanStatus__c];           
        user u = [SELECT contactId, contact.AccountId FROM user WHERE id=:userinfo.getUserId()];        
        system.debug('###'+u.ContactId);
        
        Account a = new Account();
        a = [SELECT name, Account_Executive_Name__c, Assigned_PCS__r.id  FROM Account WHERE id =:u.contact.AccountId ];        
        system.debug('$$$$' +a.Account_Executive_Name__c);        
        
         // Only create a task for PCS if these loan statuses
         if(ls.size() > 0 && a != null && (ls[0].LoanStatus__c == 'Loan Submission Received- Awaiting Review' || ls[0].LoanStatus__c == 'In Processing' || ls[0].LoanStatus__c == 'In Underwriting Review' || ls[0].LoanStatus__c == 'Conditionally Approved' ))
         {   
              Task t = new Task();
              t.OwnerId = a.Assigned_PCS__r.id;
              t.Subject = 'An Appraisal has been requested by this Partner';
              t.Status = 'Open';
              t.Priority = 'Normal';                
              t.WhatId = Loanid;
              t.ActivityDate = Date.Today();                
              t.WhoId = u.ContactId;    
              insert t; 
         }

         // Always create a task for AE regardless of loan status
		 Task tAE = new Task();
         tAE.OwnerId = a.Account_Executive_Name__c;
         tAE.Subject = 'An Appraisal has been requested by the Partner';              
         tAE.Status = 'Open';
         tAE.Priority = 'Normal';                
         tAE.WhatId = Loanid;
         tAE.ActivityDate = Date.Today();                
         tAE.WhoId = u.ContactId;    
         insert tAE;                    
    }   
   
    
     @AuraEnabled //Bala - A task will be created for PCS/AE based on LoanStatus, when Full Application is submitted  4/20
    public static string createLoanTask(String LoanID){
        
        List<Loan_New__c> ls = new List<Loan_New__c>();
        
        System.debug('###'+LoanID);
         ls =  [SELECT Id, Name, LoanStatus__c
               FROM Loan_New__c 
               where Id = :LoanID
               and IsActiveFlag__c=: true 
               and LoanCompleteFlag__c=: true               
               ORDER BY LoanStatus__c];               
        
        user u = [SELECT contactId, contact.AccountId FROM user WHERE id=:userinfo.getUserId()];        
        
        Account a = new Account();
        a = [SELECT name, Account_Executive_Name__c, Assigned_PCS__r.id  FROM Account WHERE id =:u.contact.AccountId ];
        
        // Always create a task for AE regardless of loan status
        // Do not create one for PCS
        Task t = new Task();
        t.OwnerId = a.Account_Executive_Name__c;
        t.Subject = 'Full Package Application has been Submitted';    
        t.Status = 'Open';
        t.Priority = 'Normal';                
        t.WhatId = Loanid;
        t.ActivityDate = Date.Today();                
        t.WhoId = u.ContactId;    
        insert t;
        return t.id;                      
    }
    
    // Update the Loan Status after Full Package has been submitted for Loan
    @AuraEnabled
    public static void updateFullPackageLoanStatus(String loanId) {
        Loan_New__c loan = [SELECT Id, LoanStatus__c FROM Loan_New__c WHERE Id = :loanId];
        
        switch on loan.LoanStatus__c {
            when 'Incomplete',                // Application Incomplete
                 'Proposal',                  // Application Requested
                 'Waiting for Full Package'   // Waiting for Full Package
            {
                // Update to Submitted to Lender
                loan.LoanStatus__c = 'Application Package Received';
                update loan;
            }
            when else {
                // Do not update for other loan statuses
            }
        }        
    }
    
   /* @AuraEnabled  //Commented by Bala - 4/20
    public static void SaveTask(Loan_New__c Objloan,string LoanId, string ClientName, Id IndividualId, string LoanOfficer, string AccountExecutive)
    {
        try
        {
            string Description='A full package has been submitted for';
            
            Task t = new Task();
            User objUser = new User();
            User objAE = new User();
            
            objUser = [Select Name from User Where Id =: LoanOfficer];
            objAE = [Select Id from User Where Name =: AccountExecutive];
                
            Exception_log.Create_Custom_Logs(objUser.Name,'User','save','by Latika');
            Description = Description+'\r\n Client Name :' +  ClientName;
            Description = Description+'\r\n Loan Officer :' +  objUser.Name;
            Description = Description+'\r\n Loan ID :' +  LoanId;
            
            t.Subject = 'A full package has been submitted for ' + ClientName + '\'s loan'; 
            t.Client_name__c = ClientName;       
            t.ActivityDate = Date.Today();
            t.WhatId = LoanId;
            t.Description  = Description;
            t.Priority = 'Normal';
            t.Status = 'Open';
            t.OwnerId = objAE.Id;
            insert t;
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'pipe line','save Lead','if Else Part');
            system.debug('CreateTask--Exception---'+ex);
        }
    } */
}
