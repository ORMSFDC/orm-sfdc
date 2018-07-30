@IsTest
public class  CashFlowResponseTest {

     @isTest
    public static void LoanOfficerMethodResponseTest()
    {
        CashFlowResponse CashFlowRes = new CashFlowResponse();
        
        CashFlowRes.HouseholdMembers = '4';
        CashFlowRes.MonthlyAssetIncome = 0.00;
        CashFlowRes.MonthlyIncome = 12400.53;
        
       CashFlowRes.MonthlyExpense = 300.23;
       CashFlowRes.MonthlyPropertyCharge = 245.33;
       CashFlowRes.MonthlyMaintenance = 150.00;
        
       CashFlowRes.CashFlow = '12,135.78';
       CashFlowRes.RequiredCashFlow = 1500.00;
       CashFlowRes.TotalCapacity = '1,046.19';
       CashFlowRes.CapacityStorage = '10,975.78';
        
        
        System.assertEquals(CashFlowRes.HouseholdMembers, '4');
    }
    
}