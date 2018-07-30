@isTest
public with sharing class PipeLineSummaryResponseTest {
    
    
    @isTest
    public static void PipeLineSummaryResponseMethodTest()
    {
    
    PipeLineSummaryResponse objPipeLineSummary = new PipeLineSummaryResponse();
                objPipeLineSummary.LoanNumberDetails ='5566';     
            objPipeLineSummary.FullName ='test user';
        objPipeLineSummary.DateofBirth ='01/01/1991';
        objPipeLineSummary.Phone ='9876543210';
        objPipeLineSummary.Email ='jsharma@try.com';
        objPipeLineSummary.ProAppValue =100.00;
       // objPipeLineSummary.CashAvlClient =100.00;
        objPipeLineSummary.CashDueClosing =100.00;
     //   objPipeLineSummary.MonthPayAvlClient =100.00;
         objPipeLineSummary.FinancialAsstResult ='test Result';
         objPipeLineSummary.Email ='jsharma@try.com';
        objPipeLineSummary.LESA =100.00;
             objPipeLineSummary.BrokerComp =100.00;
             objPipeLineSummary.ProcAvailFirstYear = null;
objPipeLineSummary.LineOfCredit = null;
objPipeLineSummary.InitialUnpaidPriBal = null;
objPipeLineSummary.PrincipalLimit = null;
objPipeLineSummary.MandatoryObligation = null;
objPipeLineSummary.Margin = null;
objPipeLineSummary.InitialInterestRate = null;
objPipeLineSummary.ExpectedInterestRate = null;
objPipeLineSummary.RepairEstimate = null;
objPipeLineSummary.FHACaseNumber = null;
objPipeLineSummary.RepairSetAside = null;
objPipeLineSummary.BrokerOrigination = null;

objPipeLineSummary.LifeExpectancy = null;
objPipeLineSummary.ResidentialIncomeRequired = null;
objPipeLineSummary.TotalIncome = null;
objPipeLineSummary.TotalAssets = null;
objPipeLineSummary.TotalExpenses = null;
objPipeLineSummary.ResidualIncome = null;
objPipeLineSummary.TotalMonthlyPropertyCharges = null;
objPipeLineSummary.LienBalance = null;
objPipeLineSummary.LienCreditor = null;

            System.assertEquals(objPipeLineSummary.FullName, 'test user');
    }
     
}