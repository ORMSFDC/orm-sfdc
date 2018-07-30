@isTest
public with sharing class LoanProcessorResponseTest {
    
    @isTest
    public static void LoanProcessorMethodResponseTest()
    {
        LoanProcessorResponse loanProcessorRes = new LoanProcessorResponse();
        loanProcessorRes.Id = '00P0q000000UZnHEAW';
        loanProcessorRes.LoanProcessorName = 'Test Loan Processor';
        System.assertEquals(loanProcessorRes.LoanProcessorName, 'Test Loan Processor');
    }
    
}