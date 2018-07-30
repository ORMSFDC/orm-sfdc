@isTest
public with sharing class LoanOfficerResponseTest {
    
    @isTest
    public static void LoanOfficerMethodResponseTest()
    {
        LoanOfficerResponse loanOfficerRes = new LoanOfficerResponse();
        loanOfficerRes.Id = '00P0q000000UZnHEAW';
        loanOfficerRes.LoanofficerName = 'Test Loan Officer';
        System.assertEquals(loanOfficerRes.LoanofficerName, 'Test Loan Officer');
    }
    
}