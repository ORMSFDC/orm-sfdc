public with sharing class SAL_NewIncomeController {
    @AuraEnabled
    public static List <Client__c> getclientValue(string LoanId) {
        return GenericController.getAllClientList(LoanId);
    }    
    
     @AuraEnabled
    public static Loan_New__c  Income_TabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);
            
        }
        catch(Exception ex)
        {
            system.debug(' Income_TabsValidatedData----Exception---'+ex);
        }
        return objLoan;
    }  
     @AuraEnabled
    public static Income_New__c  getOneIncome(string IncomeId) {
        Income_New__c objIncome= new Income_New__c();
        try
        {
          objIncome = [SELECT Id,Income_Source__c,Income_Types__c,Income_Value__c,RelatedClient__c,Related_Loan__c
                               FROM Income_New__c where Id= : IncomeId and IsActive__c =: true];  
        }
        catch(Exception ex)
        {
            system.debug(' getOneIncome----Exception---'+ex);
        }
        return objIncome;
    }
    @AuraEnabled
    public static decimal getAllIncome(string LoanId) {
        List<AggregateResult> results = new List<AggregateResult>();
        List<AggregateResult> resultsEmp = new List<AggregateResult>();
        decimal IncomeTotal=0.00;
        decimal EmpTotal=0.00;
        try
        {
            results = [SELECT Related_Loan__c,
                     sum(Income_Value__c) FROM Income_New__c where Related_Loan__c= : LoanId and IsActive__c = true group by Related_Loan__c];
            resultsEmp = [SELECT RelatedLoan__c,
                          sum(IncomeValue__c) FROM Employment__c where RelatedLoan__c= : LoanId and is_Active__c = true group by RelatedLoan__c];
            if(!results.isEmpty())
            {
                IncomeTotal = ((decimal)results[0].get('expr0')==null?0:(decimal)results[0].get('expr0'));   
            }
            else
            {
                IncomeTotal=0.00;   
            }
            if(!resultsEmp.isEmpty())
            {
                EmpTotal = ((decimal)resultsEmp[0].get('expr0')==null?0:(decimal)resultsEmp[0].get('expr0'));   
            }
            else
            {
                EmpTotal=0.00;   
            }
                                   
                                   
        }
        catch(Exception ex)
        {
            system.debug(' getAllIncome----Exception---'+ex);
        }
        return IncomeTotal+EmpTotal;
    }
    @AuraEnabled
    public static void incomesave(Income_New__c ObjIncome, string ClientId,string LoanId) {
        Loan_New__c loanObj = new Loan_New__c();
        try
        {
            ObjIncome.IsActive__c = true;
            ObjIncome.RelatedClient__c = ClientId;
            ObjIncome.Related_Loan__c = LoanId;
            ObjIncome.Is_Income_Validated__c=true; 
            upsert ObjIncome;
            GenericController.UpdateIncomeFlag(LoanId);
            GenericController.UpdateEmploymentFlag(LoanId);
        }    
        catch(Exception ex)
        {
            system.debug(' incomesave----Exception---'+ex);
        }
    } 
    @AuraEnabled
    public static void DeleteIncome(String RecordId) {
        Income_New__c objIncome = new Income_New__c();
        try
        {
            objIncome= [Select Id,Income_Value__c from Income_New__c where Id = :RecordId];
            objIncome.isActive__c=false;
            objIncome.Income_Value__c=0.00;
            upsert ObjIncome;
             String loanID=[select Related_Loan__c from Income_New__c where id=:RecordId limit 1].Related_Loan__c;       
             GenericController.UpdateIncomeFlagAfterDelete(loanID);
              GenericController.UpdateEmploymentFlagAfterDelete(loanID);
            
        }    
        catch(Exception ex)
        {
            system.debug(' DeleteIncome----Exception---'+ex);
        }
    } 
    @AuraEnabled
    public static  void  SaveEmployment(Employment__c objEmp,string ClientId,string LoanId) 
    {
        try
        {
            objEmp.Client_id__c =ClientId;
            objEmp.is_Active__c = true;
            objEmp.RelatedLoan__c=LoanId;
            objEmp.Is_Employment_Validated__c=true;
        }
        catch(Exception ex)
        {
            system.debug(' SaveEmployment----Exception---'+ex);
        }
        upsert objEmp;
        GenericController.UpdateIncomeFlag(LoanId);
        GenericController.UpdateEmploymentFlag(LoanId);
    }
    @AuraEnabled
    public static void DeleteEmployment(String RecordId) {
        Employment__c objEmp = new Employment__c();
        try
        {
            objEmp= [Select Id,IncomeValue__c from Employment__c where Id = :RecordId];
            objEmp.is_Active__c=false;
            objEmp.IncomeValue__c=0.00;
            upsert objEmp;
             String loanID=[select RelatedLoan__c from Employment__c where id=:RecordId limit 1].RelatedLoan__c;
                GenericController.UpdateIncomeFlagAfterDelete(loanID);
              GenericController.UpdateEmploymentFlagAfterDelete(loanID);
        }    
        catch(Exception ex)
        {
            system.debug(' DeleteEmployment----Exception---'+ex);
        }
    }
    @AuraEnabled
    public static Employment__c  getEmploymentById(string RecordId) {
        Employment__c objEmp = new Employment__c(); 
        try
        {    
            objEmp = [SELECT Id, EmployerName__c, EmployerPhone__c, Zip__c, State__c, City__c, PositionTitle__c,
                     EmployerAddress__c,Income_Type__c ,YearEmployedinProfession__c,
                     IncomeCategory__c,IncomeValue__c,Years__c, Months__c,Client_id__c FROM Employment__c  
                      where Id=: RecordId];
        }
        catch(Exception ex)
        {
            system.debug(' getEmploymentById----Exception---'+ex);
        }
        return objEmp;
    }
    
      @AuraEnabled
    public static List<IncomeEmpResponse> getAllIncomeEmp(String LoanID)
    {
        List<IncomeEmpResponse> mainReslist=new List<IncomeEmpResponse>();
        //IncomeEmpResponse mainRes=new IncomeEmpResponse();
        List<Client__c> clientObj= new List<Client__c>();
        clientObj=GenericController.getAllClientList(LoanID);
         map<id,list<IncomeEmpListResponse>> MapIncomeEmpList=new  map<id,list<IncomeEmpListResponse>>();
          MapIncomeEmpList=GetClient_IncomeEmpList(LoanID);
        for(Client__c obj :clientObj){
            
            IncomeEmpResponse objRes=new IncomeEmpResponse();
            list<IncomeEmpListResponse> iel=new list<IncomeEmpListResponse>();
            iel=MapIncomeEmpList.get(obj.id);
            
            objRes.ClientId=obj.Id;
            objRes.ClientName=obj.Name;
            objRes.IncomeEmpList=iel;
           
            objRes.TotalIncome=getClient_IncomeEmp(obj.id);
           mainReslist.add(objRes);
        }
       return mainReslist;
    }
     @AuraEnabled
    public static map<id,list<IncomeEmpListResponse>> GetClient_IncomeEmpList(string LoanId)
    {
        map<id,list<IncomeEmpListResponse>> conIncomeEmpMap= new map<id,list<IncomeEmpListResponse>>();
        list<IncomeEmpListResponse> ResList =new list<IncomeEmpListResponse> ();
        List <Income_New__c> listOfIncome =new List <Income_New__c>(); 
        List <Employment__c> listOfEmployment =new List <Employment__c>(); 
        
        
        listOfIncome = [SELECT Id,Is_Income_Validated__c,Income_Source__c,Income_Types__c,Income_Value__c,RelatedClient__c,Related_Loan__c
                        FROM Income_New__c where Related_Loan__c= : LoanId and IsActive__c =: true];
        if(!listOfIncome.isEmpty())
        {
            for(Income_New__c obj :listOfIncome)
            {
                IncomeEmpListResponse ResIncome = new IncomeEmpListResponse();
                ResIncome.ClientId=obj.RelatedClient__c;
                ResIncome.IncomeType = obj.Income_Types__c;
                ResIncome.SourceName = obj.Income_Source__c;
                ResIncome.MonthlyIncomeValue = obj.Income_Value__c;
                ResIncome.IsValidated=obj.Is_Income_Validated__c;
                ResIncome.RecordID = obj.Id;
                ResIncome.ObjectType = 'Income';
                ResList.add(ResIncome);
            }   
        }
        
        listOfEmployment = [SELECT Id,IncomeCategory__c,Is_Employment_Validated__c,Income_Type__c   ,IncomeValue__c,Client_id__c,RelatedLoan__c
                            ,EmployerName__c FROM Employment__c where RelatedLoan__c= : LoanId
                            and is_Active__c =: true]; 
        if(!listOfEmployment.isEmpty())
        {
            for(Employment__c obj :listOfEmployment)
            {
                IncomeEmpListResponse ResEmployment = new IncomeEmpListResponse();
                ResEmployment.ClientId=obj.Client_id__c;
                ResEmployment.IncomeType = obj.Income_Type__c;
                ResEmployment.SourceName = obj.EmployerName__c;
                ResEmployment.IsValidated=obj.Is_Employment_Validated__c;
                ResEmployment.MonthlyIncomeValue = obj.IncomeValue__c;
                ResEmployment.RecordID = obj.Id;
                ResEmployment.ObjectType = 'Employment';
                ResList.add(ResEmployment);
            }    
        }        
        
        for(IncomeEmpListResponse resObj:ResList)
        {
            List<IncomeEmpListResponse> l = conIncomeEmpMap.get(resObj.ClientId);
            if (l == null) {
                l = new List<IncomeEmpListResponse>();
                conIncomeEmpMap.put(resObj.ClientId, l);
            }
            l.add(resObj);   
        }
        system.debug('conIncomeEmpMap'+conIncomeEmpMap);
        return conIncomeEmpMap;        
    }
     @AuraEnabled
    public static decimal getClient_IncomeEmp(string ClientId) {
        List<AggregateResult> results = new List<AggregateResult>();
        List<AggregateResult> resultsEmp = new List<AggregateResult>();
        decimal IncomeTotal=0.00;
        decimal EmpTotal=0.00;
        try
        {
            results = [SELECT RelatedClient__c,
                     sum(Income_Value__c) FROM Income_New__c where RelatedClient__c= : ClientId and IsActive__c = true group by RelatedClient__c];
            resultsEmp = [SELECT Client_id__c,
                          sum(IncomeValue__c) FROM Employment__c where Client_id__c= : ClientId and is_Active__c = true group by Client_id__c];
            
            if(!results.isEmpty())
            {
                IncomeTotal = ((decimal)results[0].get('expr0')==null?0:(decimal)results[0].get('expr0'));    
            }
            else
            {
                IncomeTotal=0.00;    
            }
            if(!resultsEmp.isEmpty())
            {
                EmpTotal = ((decimal)resultsEmp[0].get('expr0')==null?0:(decimal)resultsEmp[0].get('expr0'));    
            }
            else
            {
                EmpTotal=0.00;    
            }
                                   
                                   
        }
        catch(Exception ex)
        {
            system.debug(' getClient_IncomeEmp----Exception---'+ex);
        }       
        return IncomeTotal+EmpTotal;
    }
}