/**
 * @description: used to display Loan Conditions in the Print PDF Conditions
 * @author: GalaxE
 * @date: 11/16/2017
 *
 * changelog:
 * 04/22/2019: Sahitya - added new criterial to display Created date in the frontend and backend
 *                       based on data upload from RV. modified UI, do not display status date for Outstanding Conditions
 */
public class PipelineConditionPDFController {
    
public static List<ConditionResponsePipeline> getdata() {
        String LoanID=ApexPages.currentPage().getParameters().get('id');
    
    	if(LoanID == null || LoanID == '')
        {
            LoanID= '12354';
        }
        
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
            objOutstanding=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c,Condition_Created_Date__c,Status_Date__c from Condition__c where Loan_Id__c=:LoanId and Status__c='Outstanding' ORDER BY LastModifiedDate desc];
            for(Condition__c ObjConc:objOutstanding)
            {
                ConditionResponse objres=new ConditionResponse();
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
                //Display created date based on data upload from RV
                datetime dt1=ObjConc.Condition_Created_Date__c;  
                datetime dt2 = ObjConc.CreatedDate;               
                if(dt1!= null){ 
                    datetime dt = dt1.addDays(1); 
                    objres.CreatedDate=dt.date().format();  
                }
                else{
                    objres.CreatedDate=dt2.date().format();  
                }
                datetime ds1=ObjConc.Status_Date__c;  
                datetime ds2=ObjConc.LastModifiedDate;
                if(ds1 != null){
                    datetime ds = ds1.addDays(1);
                    objres.StatusDate=ds.date().format();
                }
                else{
                    objres.StatusDate=ds2.date().format();
                }
                //end
                objres.Id=ObjConc.Id;
                ObjConOutstanding.add(objres);
            }
            objRevisionRequested=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c,Condition_Created_Date__c,Status_Date__c from Condition__c where Loan_Id__c=:LoanId and Status__c='Revision Requested' ORDER BY LastModifiedDate desc];
            for(Condition__c ObjConc:objRevisionRequested)
            {
                ConditionResponse objres=new ConditionResponse();
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
                //Display created date based on data upload from RV
                datetime dt1=ObjConc.Condition_Created_Date__c;  
                datetime dt2 = ObjConc.CreatedDate;               
                if(dt1!= null){ 
                    datetime dt = dt1.addDays(1); 
                    objres.CreatedDate=dt.date().format();  
                }
                else{
                    objres.CreatedDate=dt2.date().format();  
                }
                datetime ds1=ObjConc.Status_Date__c;  
                datetime ds2=ObjConc.LastModifiedDate;
                if(ds1 != null){
                    datetime ds = ds1.addDays(1);
                    objres.StatusDate=ds.date().format();
                }
                else{
                    objres.StatusDate=ds2.date().format();
                }
                //end
                objres.Id=ObjConc.Id;
                ObjConRevisionRequested.add(objres);
            }
            objCancelled=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c,Condition_Created_Date__c,Status_Date__c from Condition__c where Loan_Id__c=:LoanId and Status__c='Cancelled' ORDER BY LastModifiedDate desc];
            for(Condition__c ObjConc:objCancelled)
            {
                ConditionResponse objres=new ConditionResponse();
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
                 //Display created date based on data upload from RV
                datetime dt1=ObjConc.Condition_Created_Date__c;  
                datetime dt2 = ObjConc.CreatedDate;               
                if(dt1!= null){ 
                    datetime dt = dt1.addDays(1); 
                    objres.CreatedDate=dt.date().format();  
                }
                else{
                    objres.CreatedDate=dt2.date().format();  
                }
                datetime ds1=ObjConc.Status_Date__c;  
                datetime ds2=ObjConc.LastModifiedDate;
                if(ds1 != null){
                    datetime ds = ds1.addDays(1);
                    objres.StatusDate=ds.date().format();
                }
                else{
                    objres.StatusDate=ds2.date().format();
                }
                //end
                objres.Id=ObjConc.Id;
                ObjConCancelled.add(objres);
            }
            objCleared=[Select Id,Condition_Number__c,Comment__c,Status__c,CreatedDate,LastModifiedDate,Description__c,Condition_Created_Date__c,Status_Date__c from Condition__c where Loan_Id__c=:LoanId and Status__c='Cleared' ORDER BY LastModifiedDate desc];
            for(Condition__c ObjConc:objCleared)
            {
                ConditionResponse objres=new ConditionResponse();                
                objres.Index=ObjConc.Condition_Number__c;
                objres.DescText=ObjConc.Comment__c;
                objres.DropDownValue=ObjConc.Description__c;
                objres.Status=ObjConc.Status__c;
                 //Display created date based on data upload from RV
                datetime dt1=ObjConc.Condition_Created_Date__c;  
                datetime dt2 = ObjConc.CreatedDate;               
                if(dt1!= null){ 
                    datetime dt = dt1.addDays(1); 
                    objres.CreatedDate=dt.date().format();  
                }
                else{
                    objres.CreatedDate=dt2.date().format();  
                }
                datetime ds1=ObjConc.Status_Date__c;  
                datetime ds2=ObjConc.LastModifiedDate;
                if(ds1 != null){
                    datetime ds = ds1.addDays(1);
                    objres.StatusDate=ds.date().format();
                }
                else{
                    objres.StatusDate=ds2.date().format();
                }
                //end
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
        system.debug(ObjConFinalListReturn);
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
    
    public static List<PipelineConditionResponse> getConditiondetails() {
        String LoanID=ApexPages.currentPage().getParameters().get('id');
        string OwnerId;
        
        List<PipelineConditionResponse>ObjConFinalList=new List<PipelineConditionResponse>();
        Loan_New__c ObjLoan=new Loan_New__c();
        User user = new User();
        
        try
        {
            ObjLoan=[SELECT Client_Name__c, Name,LoanNumber__c,Application_Date__c,Id,LoanStatus__c,PCS_at_Loan_Level__c,PCS_at_Partner_Level__c,Related_Partner__r.Assigned_PCS__c,Application_Signed_Date__c
                     FROM Loan_New__c where Id=:LoanID];
            
            Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
            List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
            Map<String, String> valueLabelMap = new Map<String,String>();  
            for( Schema.PicklistEntry v : values) {
                valueLabelMap.put(v.getValue(), v.getLabel());
            }

            if (ObjLoan.PCS_at_Loan_Level__c != null) {
                OwnerId = ObjLoan.PCS_at_Loan_Level__c;
            } else {
                OwnerId = ObjLoan.Related_Partner__r.Assigned_PCS__c;
            }
            
            user = [SELECT Name,Phone,Email FROM User where Id=:OwnerId];
            
            PipelineConditionResponse objres=new PipelineConditionResponse();
            if(ObjLoan.LoanNumber__c=='' ||ObjLoan.LoanNumber__c==null)
            {
                objres.Id = ObjLoan.Name;
                 objres.LoanNumberorId = 'Loan Id:';                
            }
            else
            {
                objres.Id = ObjLoan.LoanNumber__c;
                 objres.LoanNumberorId = 'Loan Number:';  
            }
            
            objres.ClientName = ObjLoan.Client_Name__c;
            datetime dtstatus=ObjLoan.Application_Signed_Date__c;  
            if(dtstatus != null){
            datetime dt = dtstatus.addDays(1);             
            objres.ApplicationDate=dt.date().format();
            }else {
               objres.ApplicationDate= '-'; 
            }
            objres.Status = valueLabelMap.get(ObjLoan.LoanStatus__c);
            objres.PCS_Name = user.Name;
            objres.PhoneNumber = FormatPhone(user.Phone);
            objres.PCS_Email = user.Email;  
            datetime TodaysDate = system.now();
            objres.TodaysDate = TodaysDate.format('MM/dd/yyyy', 'America/New_York');
            ObjConFinalList.add(objres);
            System.debug(ObjConFinalList);
        }
        catch(exception e){
            system.debug('getLoanConditionPipeline--Exception---'+e);
        }
        return ObjConFinalList;
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
}