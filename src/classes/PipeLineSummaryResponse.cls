public class PipeLineSummaryResponse {
    //for client
 	@AuraEnabled public String LoanNumberDetails { get;set; }
    @AuraEnabled public String  FullName { get;set; }
    @AuraEnabled public string  DateofBirth { get;set; }
    @AuraEnabled public String  Phone { get;set; }
    @AuraEnabled public String  Email { get;set; }
    
    //for loan
    @AuraEnabled public decimal ProAppValue { get;set; }
    @AuraEnabled public decimal CashDueClosing { get;set; }
    @AuraEnabled public string FinancialAsstResult { get;set; }
    @AuraEnabled public decimal LESA { get;set; }
    @AuraEnabled public decimal BrokerComp { get;set; }    
    @AuraEnabled public decimal ProcAvailFirstYear {get;set;}
    @AuraEnabled public decimal LineOfCredit{get;set;}
    @AuraEnabled public decimal InitialUnpaidPriBal{get;set;}
    @AuraEnabled public decimal PrincipalLimit{get;set;}
    @AuraEnabled public decimal MandatoryObligation{get;set;}
    @AuraEnabled public string Margin{get;set;}
    @AuraEnabled public decimal InitialInterestRate{get;set;}
    @AuraEnabled public decimal ExpectedInterestRate{get;set;}
    @AuraEnabled public decimal RepairEstimate{get;set;}
    @AuraEnabled public string FHACaseNumber{get;set;}
    @AuraEnabled public decimal RepairSetAside{get;set;}
    @AuraEnabled public string BrokerOrigination{get;set;}    
    @AuraEnabled public string LifeExpectancy{get;set;}
    @AuraEnabled public decimal ResidentialIncomeRequired{get;set;}
    @AuraEnabled public decimal TotalIncome{get;set;}
    @AuraEnabled public decimal TotalAssets{get;set;}
    @AuraEnabled public decimal TotalExpenses{get;set;}
    @AuraEnabled public decimal ResidualIncome{get;set;}
    @AuraEnabled public decimal TotalMonthlyPropertyCharges{get;set;}
    @AuraEnabled public decimal LienBalance{get;set;}
    @AuraEnabled public decimal LienCreditor{get;set;}
    @AuraEnabled public decimal CashRequested{get;set;}
    @AuraEnabled public string ContactEmail{get;set;}
    
}