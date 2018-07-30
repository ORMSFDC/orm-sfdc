public class SAL_CashFlowController {   
     @AuraEnabled
    public static Loan_New__c  Capacity_TabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);
            
        }
        catch(Exception ex)
        {
            system.debug(' Capacity_TabsValidatedData----Exception---'+ex);
        }
        return objLoan;
    } 
    
    @AuraEnabled
    public static  boolean  UpdateCashFlowStatus(string loanID) 
    {
         Loan_New__c objNewLoan=new  Loan_New__c();
        try
        {
            objNewLoan.Id = loanID;
            objNewLoan.Is_CashFlow_Viewed__C= true;            
            update objNewLoan; 
        }
        catch(Exception ex)
        {
            system.debug('UpdateCashFlowStatus----Exception---'+ex);
        }
        return true;
    }
     @AuraEnabled
    public static  Loan_New__c  GetCashFlowStatus(string LoanID) 
    {
         Loan_New__c LoanDetails=new  Loan_New__c();
        try
        {
            LoanDetails =  [SELECT  Is_CashFlow_Viewed__c	  FROM Loan_New__c where id = : LoanID];
         }
        catch(Exception ex)
        {
            system.debug('GetCashFlowStatus----Exception---'+ex);
        }
        return LoanDetails;
    }
    
    @AuraEnabled
    public static CashFlowResponse getCashFlowData(String LoanID) {
        CashFlowResponse Responseobj=new CashFlowResponse();
        try{   
            //For Income
            String Householdmember=[Select Household_Members__c from loan_new__c where id=: LoanID].Household_Members__c;
            Householdmember=Householdmember==null?'':Householdmember;
            system.debug(Householdmember);
            decimal MonthlyAssetIncome=GetMonthlyAssetIncome(LoanID).setScale(2, RoundingMode.HALF_UP);
            decimal MonthlyIncome=GetTotalIncome(LoanID).setScale(2, RoundingMode.HALF_UP);
            //For Expense
            decimal  MonthlyExpense =GetTotalMonthlyPayment(LoanID).setScale(2, RoundingMode.HALF_UP);
            decimal  MonthlyPropertyCharge=GetMonthlyPropertyCharge(LoanID).setScale(2, RoundingMode.HALF_UP);
            decimal  MonthlyMaintenance =GetMonthlyMaintenance(LoanID).setScale(2, RoundingMode.HALF_UP);
            
            //For CashFlow
            //1st Start
            decimal Totalcashflow=((MonthlyAssetIncome+MonthlyIncome)-(MonthlyExpense+MonthlyPropertyCharge+MonthlyMaintenance));
            system.debug('Totalcashflow'+Totalcashflow);           
            string  CashFlow=GetFormatedValue(Totalcashflow);
            system.debug('CashFlown'+CashFlow);
            //1st end
            
            //2nd start
            Decimal  RequiredCashFlowValue=GetRequiredCashFlow(LoanID);
            //Decimal  RequiredCashFlow= RequiredCashFlowValue==0?1:RequiredCashFlowValue;
            Decimal  RequiredCashFlow= RequiredCashFlowValue ;
            system.debug('RequiredCashFlow'+RequiredCashFlow);
            //2nd end
            
            //3rd
            decimal Capacity=((Totalcashflow/RequiredCashFlow)*100).setScale(2, RoundingMode.HALF_UP);
            system.debug('Capacity'+Capacity);             
            string  TotalCapacity =GetFormatedPercentage(Capacity);
            system.debug('TotalCapacity'+TotalCapacity);
            //3rd
            
            //4th start
            decimal CapacityStrg=(Totalcashflow-RequiredCashFlow).setScale(2, RoundingMode.HALF_UP);
            system.debug('CapacityStrg'+CapacityStrg);
            string  CapacityStorage =GetFormatedValue(CapacityStrg);
            system.debug('CapacityStorage'+CapacityStorage);
            //4th end          
            
            //For Income
            Responseobj.HouseholdMembers =Householdmember; 
            Responseobj.MonthlyAssetIncome =MonthlyAssetIncome;
            Responseobj.MonthlyIncome=MonthlyIncome;
            
            //For Expense
            Responseobj.MonthlyExpense =MonthlyExpense;
            Responseobj.MonthlyPropertyCharge =MonthlyPropertyCharge;
            Responseobj.MonthlyMaintenance  =MonthlyMaintenance;
            
            //For CashFlow
            Responseobj.CashFlow=CashFlow;
            Responseobj.RequiredCashFlow =RequiredCashFlowValue;
            Responseobj.TotalCapacity=TotalCapacity;
            Responseobj.CapacityStorage=CapacityStorage;
        }
        catch(Exception ex)
        {
            system.debug(' getCashFlowData----Exception---'+ex);
        }
        system.debug(Responseobj);
        return Responseobj;
    }
    
    public static decimal GetMonthlyAssetIncome(String LoanID) {
        List<integer> DOBList=new List<integer>();
        List<date> FinalDOBList = new List<date>();
        integer LifeExpectancyYear;
        Integer LifeExpectancyAgeInMonth;
        decimal TotalAssetAgaintLoan;
        List<client__c> clientList=new List<client__c> ();
        try{
            clientList=[select DOB__c from client__c where LoanId__c=:LoanID and is_Active__c=true ];
            for(client__c clientobj:clientList )
            {             
                date dob=clientobj.DOB__c;
                Date TodayDate = System.today();
                integer  Age = (dob.monthsBetween(TodayDate) / 12);
                if(Age >61){                    
                    DOBList.add(Age);
                }
            }
            system.debug('Before DOBList'+DOBList);
            DOBList.sort();
            system.debug('fter DOBList'+DOBList);
            integer ClientAge = DOBList.get(0);
            system.debug('No of years ' + ClientAge);       
            if(ClientAge>=95)
            {
                LifeExpectancyYear=3;
            }
            else
            {
                LifeExpectancyYear=GetLifeExpectancyYearValue(ClientAge);
            }
            system.debug('LifeExpectancyYear'+LifeExpectancyYear);
            //number of months the client has until their life expectancy age
            LifeExpectancyAgeInMonth=LifeExpectancyYear*12;
            system.debug('LifeExpectancyAgeInMonth'+LifeExpectancyAgeInMonth);
            TotalAssetAgaintLoan=GetTotalAsset(LoanID);
            system.debug('TotalAssetAgaintLoan'+TotalAssetAgaintLoan);
            
        }
        catch(Exception ex)
        {
            system.debug(' GetMonthlyAssetIncome----Exception---'+ex);
        }
        system.debug('TotalAssetAgaintLoan/LifeExpectancyAgeInMonth  -->'+ TotalAssetAgaintLoan/LifeExpectancyAgeInMonth);
        return TotalAssetAgaintLoan/LifeExpectancyAgeInMonth;
    }
    
    // Method to get Life Expectancy Year
    public static integer GetLifeExpectancyYearValue(integer ClientAge)
    {        
        Map<Integer, Integer> GetLifeExpectancyYear = new Map<Integer, Integer>();
        try{
            {        
                GetLifeExpectancyYear.put(62, 21);
                GetLifeExpectancyYear.put(63, 20);
                GetLifeExpectancyYear.put(64, 19);
                GetLifeExpectancyYear.put(65, 18);
                GetLifeExpectancyYear.put(66, 18);
                GetLifeExpectancyYear.put(67, 17);
                GetLifeExpectancyYear.put(68, 16);
                GetLifeExpectancyYear.put(69, 16);
                GetLifeExpectancyYear.put(70, 15);
                //71 t0 80
                GetLifeExpectancyYear.put(71, 14);
                GetLifeExpectancyYear.put(72, 13);
                GetLifeExpectancyYear.put(73, 13);
                GetLifeExpectancyYear.put(74, 12);
                GetLifeExpectancyYear.put(75, 12);
                GetLifeExpectancyYear.put(76, 11);
                GetLifeExpectancyYear.put(77, 10);
                GetLifeExpectancyYear.put(78, 10);
                GetLifeExpectancyYear.put(79,  9);
                GetLifeExpectancyYear.put(80,  9);
                //81 to 90
                GetLifeExpectancyYear.put(81,  8);
                GetLifeExpectancyYear.put(82,  8);
                //need to verify 83
                GetLifeExpectancyYear.put(83,  7);
                //end
                GetLifeExpectancyYear.put(84,  7);
                GetLifeExpectancyYear.put(85,  6);
                GetLifeExpectancyYear.put(86,  6);
                GetLifeExpectancyYear.put(87,  6);
                GetLifeExpectancyYear.put(88,  5);
                GetLifeExpectancyYear.put(89,  5);
                GetLifeExpectancyYear.put(90,  5);
                //91 to 94
                GetLifeExpectancyYear.put(91,  4);
                GetLifeExpectancyYear.put(92,  4);
                GetLifeExpectancyYear.put(93,  4);
                GetLifeExpectancyYear.put(94,  4);
            }
        }
        catch(Exception ex)
        {
            system.debug(' GetLifeExpectancyYearValue----Exception---'+ex);
        }
        return GetLifeExpectancyYear.get(ClientAge);
    }
    
    // Method to get 85% of Total Assets 
    public static decimal GetTotalAsset(String LoanID){ 
        List<AggregateResult> results = new List<AggregateResult>();
        decimal AssetTotal=0.00;
        decimal cash = 0.00,lic = 0.00,vInterest = 0.00, NetWorth = 0.00, PreMarVAlue = 0.00, OtherAsset = 0.00;         
        try{   
            results = [SELECT sum(Cash_or_Market_Value__c)CMV,                        
                       sum(Life_Insurance_Policy_Face_Value__c)LIP,
                       sum(Vested_Interest_in_Retirement_Fund__c)VIR,
                       sum(Net_Worth_of_Business_es_Owned__c)NWB,
                       sum(Present_Market_Value__c)PMV,
                       sum(Other_Asset_Amount__c)OAA
                       FROM Asset where isActive__c= true and RelatedLoan__c =: LoanID];            
            cash 		= ((decimal)results[0].get('CMV')==null?0:(decimal)results[0].get('CMV'));
            lic 		= ((decimal)results[0].get('LIP')==null?0:(decimal)results[0].get('LIP'));
            vInterest	= ((decimal)results[0].get('VIR')==null?0:(decimal)results[0].get('VIR'));
            NetWorth 	= ((decimal)results[0].get('NWB')==null?0:(decimal)results[0].get('NWB'));
            PreMarVAlue = ((decimal)results[0].get('PMV')==null?0:(decimal)results[0].get('PMV'));
            OtherAsset 	= ((decimal)results[0].get('OAA')==null?0:(decimal)results[0].get('OAA'));
            AssetTotal 	= cash + lic + vInterest + NetWorth + PreMarVAlue + OtherAsset;
        }
        catch(Exception ex)
        {
            system.debug(' GetTotalAsset----Exception---'+ex);
        }
        system.debug('AssetTotal'+AssetTotal);
        return AssetTotal*0.85;
    }
    // Method to Get Total Income From Loan ID
    private static decimal GetTotalIncome(string LoanID) {
        List<AggregateResult> results = new List<AggregateResult>();
        decimal TotalIncome=0.00;
        List<AggregateResult> Empresults = new List<AggregateResult>();
        decimal EMPTotalIncome=0.00;
        try
        {
            results = [SELECT sum(Income_Value__c)IV FROM Income_New__c where Related_Loan__c= : LoanID 
                       and IsActive__c = true ];                              
            TotalIncome = ((decimal)results[0].get('IV')==null?0:(decimal)results[0].get('IV'));
            Empresults = [SELECT sum(IncomeValue__c)EIV FROM Employment__c where RelatedLoan__c= : LoanID 
                       and is_Active__c = true ];                              
            EMPTotalIncome = ((decimal)Empresults[0].get('EIV')==null?0:(decimal)Empresults[0].get('EIV'));
            
        }
        catch(Exception ex)
        {
            system.debug('GetTotalIncome----Exception---'+ex);
        }
        return TotalIncome+EMPTotalIncome;
    }
    //Method to get Laibilities Total Monthly Payment
    Private static Decimal GetTotalMonthlyPayment(string LoanID)
    {
        List<AggregateResult> RealStateresults = new List<AggregateResult>();
        List<AggregateResult> results = new List<AggregateResult>();
        decimal TotalRealStateMonthlyPayment,Insurance_Taxes=0.00;
        decimal Amount,JRE,LMP,TotalMonthlyPayment=0.00;
        try
        {
            results = [SELECT sum(Amount__c)Amount,sum(Job_Related_Expenses__c)JRE,sum(Liability_Monthly_Payment__c)LMP 
                       FROM Liability__c where RelatedLoan__c= : LoanID 
                       and IsActive__c = true ];
            Amount = ((decimal)results[0].get('Amount')==null?0:(decimal)results[0].get('Amount'));   
            JRE= ((decimal)results[0].get('JRE')==null?0:(decimal)results[0].get('JRE'));   
            LMP = ((decimal)results[0].get('LMP')==null?0:(decimal)results[0].get('LMP'));   
            TotalMonthlyPayment=Amount+JRE+LMP;
            RealStateresults = [SELECT sum(Mortgage_Payments__c)MP,sum(Insurance_Taxes_etc__c)IT FROM Liability__c where RelatedLoan__c= : LoanID 
                                and IsActive__c = true and Property_Status__c!='Subject Property'];  
            
            TotalRealStateMonthlyPayment = ((decimal)RealStateresults[0].get('MP')==null?0:(decimal)RealStateresults[0].get('MP'));                       
       Insurance_Taxes = ((decimal)RealStateresults[0].get('IT')==null?0:(decimal)RealStateresults[0].get('IT'));                       
       
        }
        catch(Exception ex)
        {
            system.debug('GetTotalIncome----Exception---'+ex);
        }      
        return  TotalMonthlyPayment+TotalRealStateMonthlyPayment+Insurance_Taxes;
    }
    
    
    //Method to get Monthly Property Charge
    Private static Decimal GetMonthlyPropertyCharge(string LoanID)
    {      
        Loan_New__c Obj=New Loan_New__c();
        try
        {
            Obj = [SELECT Real_Estate_Taxes__c,Hazard_Insurance__c,HOA_PUD_Condo_Fees__c FROM Loan_New__c where iD= : LoanID ];
            if(obj.HOA_PUD_Condo_Fees__c==null)
            {
                obj.HOA_PUD_Condo_Fees__c=0.0;                
            }                                
        }
        catch(Exception ex)
        {
            system.debug('GetMonthlyPropertyCharge----Exception---'+ex);
        }      
        return  obj.HOA_PUD_Condo_Fees__c+obj.Real_Estate_Taxes__c+obj.Hazard_Insurance__c;
    }
    
    //Method to get Monthly Maintenance
    Private static Decimal GetMonthlyMaintenance(string LoanID)
    {        Loan_New__c Obj=New Loan_New__c();
     decimal MonthlyMaintenance;
     
     try
     {
         Obj = [SELECT Square_Footage__c  FROM Loan_New__c where iD= : LoanID ];
         if(obj.Square_Footage__c==null || obj.Square_Footage__c=='')
         {
             MonthlyMaintenance=0.00;
         }
         else{
         MonthlyMaintenance=decimal.valueof(obj.Square_Footage__c);    
             }
     }
     catch(Exception ex)
     {
         system.debug('GetMonthlyMaintenance----Exception---'+ex);
     }      
     return  MonthlyMaintenance*0.14;
    }
    
    public static string Get_FormatedValue(decimal totalCashFlow){
        
        return GetFormatedValue(totalCashFlow);
    }
    //Method to return Formated Value based on negetive/positive
    Private static string GetFormatedValue(decimal totalCashFlow)
    {    
        //decimal totalCashFlow=-123.12;
        string FormatedCashFlow;    
        try
        {
            if(totalCashFlow<0)
            {
                Decimal a = totalCashFlow.abs(); 
                String s = (a.format().contains('.')?a.format():(a.format()+'.00'));
                FormatedCashFlow= '$('+s+')';
            }
            else{
                Decimal a = totalCashFlow; 
                String s = (a.format().contains('.')?a.format():(a.format()+'.00'));             
                FormatedCashFlow= '$'+s;
            }
            
        }
        catch(Exception ex)
        {
            system.debug('GetFormatedValue----Exception---'+ex);
        }      
        return FormatedCashFlow;
    }
    
    public static string Get_FormatedPercentage(decimal totalCashFlow){
     return GetFormatedPercentage(totalCashFlow);   
    }
    //Method to return Formated Value based on negetive/positive
    Private static string GetFormatedPercentage(decimal totalCashFlow)
    {    
        //decimal totalCashFlow=-123.12;
        string FormatedCashFlow;    
        try
        {
            if(totalCashFlow<0)
            {
                Decimal a = totalCashFlow.abs(); 
                String s = (a.format().contains('.')?a.format():(a.format()+'.00'));
                FormatedCashFlow= '('+s+')%';
            }
            else{
                Decimal a = totalCashFlow; 
                String s = (a.format().contains('.')?a.format():(a.format()+'.00'));             
                FormatedCashFlow= s+'%';
            }
            
        }
        catch(Exception ex)
        {
            system.debug('GetFormatedPercentage----Exception---'+ex);
        }      
        return FormatedCashFlow;
    }
    //Method to return 'Required Cash Flow
    public static decimal GetRequiredCashFlow(string LoanID)
    {    
        Loan_New__c Obj=New Loan_New__c();
        decimal CashFlow=0.00;
        string FamilySize;
        try
        {
            Obj = [SELECT Subject_Property_State__c,Household_Members__c  FROM Loan_New__c where iD= : LoanID ];
            string StateRegion=GetStateRegion(Obj.Subject_Property_State__c);
            system.debug('StateRegion'+StateRegion);
            if(Obj.Household_Members__c!=null)
            {
            if(integer.valueof(Obj.Household_Members__c)>3)
            {
                FamilySize='4 or more';     
            }
            else
            {
                FamilySize=Obj.Household_Members__c;
            }
            
            CashFlow= GetResidualIncome(StateRegion,FamilySize);
            system.debug(Obj.Subject_Property_State__c);
            system.debug(StateRegion);
            }
        }
        catch(Exception ex)
        {
            system.debug('GetRequiredCashFlow----Exception---'+ex);
        }      
        system.debug('CashFlow'+CashFlow);
        return CashFlow;
    }
    
    public  static string Get_StateRegion(string State){
        return GetStateRegion(State);
    }
  
    //Get State Region
    private static string GetStateRegion(string State)
    {        
        Map<string, string> getStateRegion = new Map<string, string>();
        try{
            {        
                getStateRegion.put('Alabama', 'South__c');
                getStateRegion.put('Alaska', 'West__c');
                getStateRegion.put('Arizona', 'West__c');
                getStateRegion.put('Arkansas', 'South__c');
                getStateRegion.put('California', 'West__c');
                getStateRegion.put('Colorado', 'West__c');
                getStateRegion.put('Connecticut', 'NorthEast__c');
                getStateRegion.put('Delaware', 'South__c');
                getStateRegion.put('Florida', 'South__c');
                getStateRegion.put('Georgia', 'South__c');
                getStateRegion.put('Hawaii', 'West__c');
                getStateRegion.put('Idaho', 'West__c');
                getStateRegion.put('Illinois', 'MidWest__c');
                getStateRegion.put('Indiana', 'MidWest__c');
                getStateRegion.put('Iowa', 'MidWest__c');
                getStateRegion.put('Kansas', 'MidWest__c');
                getStateRegion.put('Kentucky', 'South__c');
                getStateRegion.put('Louisiana', 'South__c');
                getStateRegion.put('Maine', 'NorthEast__c');
                getStateRegion.put('Maryland', 'South__c');
                getStateRegion.put('Massachusetts', 'NorthEast__c');
                getStateRegion.put('Michigan', 'MidWest__c');
                getStateRegion.put('Minnesota', 'MidWest__c');
                getStateRegion.put('Mississippi', 'South__c');
                getStateRegion.put('Missouri', 'MidWest__c');
                getStateRegion.put('Montana Nebraska', 'West__c');
                //getStateRegion.put('Montana', 'West__c');
                //getStateRegion.put('Nebraska', 'MidWest__c');
                getStateRegion.put('Nevada', 'West__c');
                getStateRegion.put('New Hampshire', 'NorthEast__c');
                getStateRegion.put('New Jersey', 'NorthEast__c');
                getStateRegion.put('New Mexico', 'West__c');
                getStateRegion.put('New York', 'NorthEast__c');
                getStateRegion.put('North Carolina', 'South__c');
                getStateRegion.put('North Dakota', 'MidWest__c');
                getStateRegion.put('Ohio', 'MidWest__c');
                getStateRegion.put('Oklahoma', 'South__c');
                getStateRegion.put('Oregon', 'West__c');
                getStateRegion.put('Pennsylvania', 'NorthEast__c');
                getStateRegion.put('Rhode Island', 'NorthEast__c');
                getStateRegion.put('South Carolina', 'South__c');
                getStateRegion.put('South Dakota', 'MidWest__c');
                getStateRegion.put('Tennessee', 'South__c');
                getStateRegion.put('Texas', 'South__c');
                getStateRegion.put('Utah', 'West__c');
                getStateRegion.put('Vermont', 'NorthEast__c');
                getStateRegion.put('Virginia', 'South__c');
                //getStateRegion.put('West Virginia', 'South__c');
                getStateRegion.put('Washington', 'West__c');
                getStateRegion.put('West Virginia', '');
                getStateRegion.put('Wisconsin', 'MidWest__c');
                getStateRegion.put('Wyoming', 'West__c');
                //getStateRegion.put('Puerto Rico', 'South__c');
                //getStateRegion.put('Washington DC (District of Columbia)', 'South__c');
            }
        }
        catch(Exception ex)
        {
            system.debug(' getStateRegionValue----Exception---'+ex);
        }
        return getStateRegion.get(State);
    }
    
    public  static decimal  Get_ResidualIncome(string ColoumnName,string FamilySize){
     return  GetResidualIncome( ColoumnName, FamilySize);
   
     }
    //Method to get ResidualIncome
    Private static decimal  GetResidualIncome(string ColoumnName,string FamilySize){
        system.debug('FamilySize ColoumnName'+ ColoumnName+ FamilySize);
        string Fsize = FamilySize ;
        String query = 'select ' + ColoumnName + ' from ResidualIncome__c where Family_Size__c = :Fsize';
        ResidualIncome__c record =new ResidualIncome__c();
        record=Database.query(query)  ;
        system.debug('record'+record);
        decimal value=(decimal)record.get(ColoumnName);
        system.debug(record.get(ColoumnName));
        return value;
    }
}