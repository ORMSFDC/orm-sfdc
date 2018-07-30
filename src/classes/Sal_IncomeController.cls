public with sharing class Sal_IncomeController {
    @AuraEnabled
    public static List <Client__c> getclientValue(string LoanId) {
        return GenericController.getAllClientList(LoanId);
    }
    
    @AuraEnabled
    public static Income__c getIncomeData(string ClientId) {
        Income__c listOfLiability=new Income__c();
        try
        {
            listOfLiability = [SELECT Id,Bonus_Income__c,OverTime_Income__c,Commissions_Income__c,
                               Dividents_Interest_Income__c,Base_Employment_Income__c,Net_Rental_Income__c,Alimony_ChildSupport_Income__c,
                               Automobile_Expense_Income__c,Boarder_Income__c,Capital_Gains__c,Disability_Income__c,Foster_Care_Income__c,Military_Base_Pay__c,
                               Military_Clothes_Allowance__c,Military_Combat_Pay__c,Military_Flight_Pay__c,Military_Hazard_Pay__c,
                               Military_Overseas_Pay__c,Military_Prop_Pay__c,Military_Quarters_Allowance__c,Military_Rations_Allowance__c,
                               Military_Variable_Housing_allowance__c,Mortgage_Credit_Certificate__c,Mortgage_Differential_Certificate__c,
                               Notes_Receivable_Installment__c,Other_Income__c,Pension_Retirement_Income__c,Social_Security_Disability_Income__c,
                               SubjectProperty_Income__c,Temporary_Leave_income__c,Trust_Income__c,
                               Unemployment_Welfare_Income__c,VA_Benefits_non_education__c
                               
                               FROM Income__c where RelatedClient__c= : ClientId and isActive__c = true limit 1];
            
        }
        catch(Exception ex)
        {
            system.debug(' getIncomeData----Exception---'+ex);
        }
        return listOfLiability;
    }
    @AuraEnabled
    public static decimal getAllIncome(string LoanId) {
        List<AggregateResult> results = new List<AggregateResult>();
        decimal Dividents,BaseEmployment,Net_Rental,AlimonyChildSupport,AutomobileExpense,Boarder,Capital_Gain,Foster_Care,
            MBasePay,MClothesAllowance,MCombatPay,MFlightPay,MHazardPay,MOverseasPay,MPropPay,MQuartersAllowance,
            MRationsAllowance,MVariableHousing,MCredit,MDifferential,NotesReceivable,OtherIncome,Pension,SocialSecurity,
            SubjectProperty,Temporary_Leave,TrustIncome,Unemployment_Welfare,VA_Benefits,Disability_Income;
                
        decimal IncomeValue=0;
        try
        {
          results = [SELECT Related_Loan__c,
                          sum(Dividents_Interest_Income__c),sum(Base_Employment_Income__c),sum(Net_Rental_Income__c),
                          sum(Alimony_ChildSupport_Income__c),sum(Automobile_Expense_Income__c),sum(Boarder_Income__c),
                          sum(Capital_Gains__c),sum(Foster_Care_Income__c),sum(Military_Base_Pay__c),
                          sum(Military_Clothes_Allowance__c),sum(Military_Combat_Pay__c),sum(Military_Flight_Pay__c),
                          sum(Military_Hazard_Pay__c),sum(Military_Overseas_Pay__c),sum(Military_Prop_Pay__c),sum(Military_Quarters_Allowance__c),
                          sum(Military_Rations_Allowance__c),sum(Military_Variable_Housing_allowance__c),sum(Mortgage_Credit_Certificate__c),
                          sum(Mortgage_Differential_Certificate__c),sum(Notes_Receivable_Installment__c),sum(Other_Income__c),sum(Pension_Retirement_Income__c),
                          sum(Social_Security_Disability_Income__c),sum(SubjectProperty_Income__c),sum(Temporary_Leave_income__c),sum(Trust_Income__c),
                          sum(Unemployment_Welfare_Income__c),sum(VA_Benefits_non_education__c),sum(Disability_Income__c)
                               
  FROM Income__c where Related_Loan__c= : LoanId and isActive__c = true group by Related_Loan__c];
                              // FROM Income__c where Related_Loan__c= : LoanId and isActive__c = true group by Id ];
            
            
            Dividents = ((decimal)results[0].get('expr0')==null?0:(decimal)results[0].get('expr0'));
            BaseEmployment = ((decimal)results[0].get('expr1')==null?0:(decimal)results[0].get('expr1'));
            Net_Rental = ((decimal)results[0].get('expr2')==null?0:(decimal)results[0].get('expr2'));
            AlimonyChildSupport = ((decimal)results[0].get('expr3')==null?0:(decimal)results[0].get('expr3'));
            AutomobileExpense = ((decimal)results[0].get('expr4')==null?0:(decimal)results[0].get('expr4'));
            Boarder = ((decimal)results[0].get('expr5')==null?0:(decimal)results[0].get('expr5'));
            Capital_Gain = ((decimal)results[0].get('expr6')==null?0:(decimal)results[0].get('expr6'));            
            Foster_Care = ((decimal)results[0].get('expr7')==null?0:(decimal)results[0].get('expr7'));
            MBasePay = ((decimal)results[0].get('expr8')==null?0:(decimal)results[0].get('expr8'));
            MClothesAllowance = ((decimal)results[0].get('expr9')==null?0:(decimal)results[0].get('expr9'));
            MCombatPay = ((decimal)results[0].get('expr10')==null?0:(decimal)results[0].get('expr10'));
            MFlightPay = ((decimal)results[0].get('expr11')==null?0:(decimal)results[0].get('expr11'));
            MHazardPay = ((decimal)results[0].get('expr12')==null?0:(decimal)results[0].get('expr12'));
            MOverseasPay = ((decimal)results[0].get('expr13')==null?0:(decimal)results[0].get('expr13'));
            MPropPay = ((decimal)results[0].get('expr14')==null?0:(decimal)results[0].get('expr14'));
            MQuartersAllowance = ((decimal)results[0].get('expr15')==null?0:(decimal)results[0].get('expr15'));
            MRationsAllowance = ((decimal)results[0].get('expr16')==null?0:(decimal)results[0].get('expr16'));
            MVariableHousing = ((decimal)results[0].get('expr17')==null?0:(decimal)results[0].get('expr17'));
            MCredit = ((decimal)results[0].get('expr18')==null?0:(decimal)results[0].get('expr18'));
            MDifferential = ((decimal)results[0].get('expr19')==null?0:(decimal)results[0].get('expr19'));
            NotesReceivable = ((decimal)results[0].get('expr20')==null?0:(decimal)results[0].get('expr20'));
            OtherIncome = ((decimal)results[0].get('expr21')==null?0:(decimal)results[0].get('expr21'));
            Pension = ((decimal)results[0].get('expr22')==null?0:(decimal)results[0].get('expr22'));
            SocialSecurity = ((decimal)results[0].get('expr23')==null?0:(decimal)results[0].get('expr23'));
            SubjectProperty = ((decimal)results[0].get('expr24')==null?0:(decimal)results[0].get('expr24'));
            Temporary_Leave = ((decimal)results[0].get('expr25')==null?0:(decimal)results[0].get('expr25'));
            TrustIncome = ((decimal)results[0].get('expr26')==null?0:(decimal)results[0].get('expr26'));
            Unemployment_Welfare = ((decimal)results[0].get('expr27')==null?0:(decimal)results[0].get('expr27'));
            VA_Benefits = ((decimal)results[0].get('expr28')==null?0:(decimal)results[0].get('expr28'));
            Disability_Income = ((decimal)results[0].get('expr29')==null?0:(decimal)results[0].get('expr29'));
            
            IncomeValue = Dividents+BaseEmployment+Net_Rental+AlimonyChildSupport+AutomobileExpense+Boarder+Capital_Gain+
            Foster_Care+MBasePay+MClothesAllowance+MCombatPay+MFlightPay+MHazardPay+MOverseasPay+MPropPay+MQuartersAllowance+
            MRationsAllowance+MVariableHousing+MCredit+MDifferential+NotesReceivable+OtherIncome+Pension+SocialSecurity+
            SubjectProperty+Temporary_Leave+TrustIncome+Unemployment_Welfare+VA_Benefits+Disability_Income;
           
        }
        catch(Exception ex)
        {
            system.debug(' getAllIncome----Exception---'+ex);
        }
        return IncomeValue;
    }
    @AuraEnabled
    public static void incomesave(Income__c ObjIncome, string ClientId,string LoanId) {
        Loan_New__c loanObj = new Loan_New__c();
        try
        {
            ObjIncome.isActive__c = true;
            ObjIncome.RelatedClient__c = ClientId;
            ObjIncome.Related_Loan__c = LoanId;
            loanObj.Id=LoanId;
            loanObj.IsIncomeFilled_Flag__c=true;
            upsert ObjIncome;
            update loanObj;
        }    
        catch(Exception ex)
        {
            system.debug(' incomesave----Exception---'+ex);
        }
    } 
}