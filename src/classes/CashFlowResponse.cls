public class CashFlowResponse {
    
    //For Income
    @AuraEnabled public   String HouseholdMembers { get;set; }     
    @AuraEnabled public   decimal  MonthlyAssetIncome { get;set; }
    @AuraEnabled public   decimal  MonthlyIncome { get;set; }
    
    //For Expense
    @AuraEnabled public   decimal  MonthlyExpense { get;set; }
    @AuraEnabled public  decimal  MonthlyPropertyCharge { get;set; }
    @AuraEnabled public  decimal  MonthlyMaintenance  { get;set; }
    
    //For CashFlow
    @AuraEnabled public  string  CashFlow { get;set; }
    @AuraEnabled public  Decimal  RequiredCashFlow { get;set; }
    @AuraEnabled public   string  TotalCapacity { get;set; }
    @AuraEnabled public   string  CapacityStorage { get;set; }
}