@isTest
private class OnBaseLookupsTest {
  
    @testSetup
    static void setupTestData()
    {
        Loan_New__c loan = new Loan_New__c(
            LoanNumber__c = '54321'
        );
        insert loan;
    } 
    
    @isTest
    static void getPropertyStateKeywordTest_Null()
    {        
        String state = 'Does not match';
        String expected = null;
        
        String keyword = OnBaseLookups.getPropertyStateKeyword(state);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getPropertyStateKeywordTest_CommunityHomestead()
    {        
        String state = 'Washington';
        String expected = 'Community-Homestead';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Subject_Property_State__c = state;
        update loan;
        
        String keyword = OnBaseLookups.getPropertyStateKeyword(loan.Subject_Property_State__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getPropertyStateKeywordTest_DowerHomestead()
    {        
        String state = 'Ohio';
        String expected = 'Dower-Homestead';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Subject_Property_State__c = state;
        update loan;
        
        String keyword = OnBaseLookups.getPropertyStateKeyword(loan.Subject_Property_State__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getPropertyStateKeywordTest_Homestead()
    {        
        String state = 'Alaska';
        String expected = 'Homestead';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Subject_Property_State__c = state;
        update loan;
        
        String keyword = OnBaseLookups.getPropertyStateKeyword(loan.Subject_Property_State__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getPropertyStateKeywordTest_None()
    {        
        String state = 'Colorado';
        String expected = '';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Subject_Property_State__c = state;
        update loan;
        
        String keyword = OnBaseLookups.getPropertyStateKeyword(loan.Subject_Property_State__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getPropertyStateKeywordWrapperTest_Null() {
        String state = 'Does not match';
        String expected = 'PropertyState Lookup was not found for state';
        
        String keyword = OnBaseLookups.getPropertyStateKeywordWrapper(state);
        
        System.assert(keyword.contains(expected));
    }
    
    @isTest
    static void getPropertyStateKeywordWrapperTest_Found()
    {        
        String state = 'Alaska';
        String expected = 'Homestead';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Subject_Property_State__c = state;
        update loan;
        
        String keyword = OnBaseLookups.getPropertyStateKeywordWrapper(loan.Subject_Property_State__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getProductKeywordTest_HFCH_HECM_FIXED()
    {        
        String productType = 'HECM';
        String mortgageAppliedFor = 'FHA Traditional HECM';
        String rateType = 'FIXED';
        String expected = 'HFCH - HECM FIXED';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Product_Type__c = productType;
        loan.Mortgage_Applied_for__c = mortgageAppliedFor;
        loan.Rate_Type__c = rateType;
        update loan;
        
        String keyword = OnBaseLookups.getProductKeyword(loan.Product_Type__c, loan.Mortgage_Applied_for__c, loan.Rate_Type__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getProductKeywordTest_HLAH_HECM_LIBOR_ANNUAL()
    {        
        String productType = 'HECM';
        String mortgageAppliedFor = 'HECM to HECM Refinance';
        String rateType = 'ARM';
        String expected = 'HLAH - HECM LIBOR ANNUAL';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Product_Type__c = productType;
        loan.Mortgage_Applied_for__c = mortgageAppliedFor;
        loan.Rate_Type__c = rateType;
        update loan;
        
        String keyword = OnBaseLookups.getProductKeyword(loan.Product_Type__c, loan.Mortgage_Applied_for__c, loan.Rate_Type__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getProductKeywordTest_HELO_FIXED_HOME_EQUITY_LOAN_OPTIMIZER()
    {        
        String productType = 'HELO';
        String mortgageAppliedFor = 'HECM to HECM Refinance';
        String rateType = 'FIXED';
        String expected = 'HELO FIXED – HOME EQUITY LOAN OPTIMIZER';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Product_Type__c = productType;
        loan.Mortgage_Applied_for__c = mortgageAppliedFor;
        loan.Rate_Type__c = rateType;
        update loan;
        
        String keyword = OnBaseLookups.getProductKeyword(loan.Product_Type__c, loan.Mortgage_Applied_for__c, loan.Rate_Type__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getProductKeywordTest_Null()
    {      
        String productType = 'Does not match';
        String mortgageAppliedFor = 'Does not match';
        String rateType = 'Does not match';
        String expected = null;
        
        String keyword = OnBaseLookups.getProductKeyword(productType, mortgageAppliedFor, rateType);
        
        System.assertEquals(expected, keyword);  
    }
    
    @isTest
    static void getPurposeOfRefinanceKeywordTest_Null()
    {      
        String productType = 'Does not match';
        String mortgageAppliedFor = 'Does not match';
        String rateType = 'Does not match';
        String expected = null;
        
        String keyword = OnBaseLookups.getPurposeOfRefinanceKeyword(productType, mortgageAppliedFor, rateType);
        
        System.assertEquals(expected, keyword);  
    }
    
    @isTest
    static void getClosingProviderKeywordTest_Null()
    {      
        String amRockAgent = 'Does not match';
        String expected = null;
        
        String keyword = OnBaseLookups.getClosingProviderKeyword(amRockAgent);
        
        System.assertEquals(expected, keyword);  
    }
    
    @isTest
    static void getClosingProviderKeywordTest_AMROCK()
    {      
        String amRockAgent = 'Yes';
        String expected = 'AMROCK';
        
        String keyword = OnBaseLookups.getClosingProviderKeyword(amRockAgent);
        
        System.assertEquals(expected, keyword);  
    }
    
    @isTest
    static void getClosingProviderKeywordTest_None()
    {      
        String amRockAgent = 'No';
        String expected = '';
        
        String keyword = OnBaseLookups.getClosingProviderKeyword(amRockAgent);
        
        System.assertEquals(expected, keyword);  
    }
    
    @isTest
    static void getPurposeOfRefinanceKeywordTest_None()
    {        
        String productType = 'HECM';
        String mortgageAppliedFor = 'HECM for Purchase';
        String rateType = 'ARM';
        String expected = '';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Product_Type__c = productType;
        loan.Mortgage_Applied_for__c = mortgageAppliedFor;
        loan.Rate_Type__c = rateType;
        update loan;
        
        String keyword = OnBaseLookups.getPurposeOfRefinanceKeyword(productType, mortgageAppliedFor, rateType);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getPurposeOfRefinanceKeywordTest_REVERSE_Refinance()
    {        
        String productType = 'HECM';
        String mortgageAppliedFor = 'FHA Traditional HECM';
        String rateType = 'FIXED';
        String expected = 'REVERSE Refinance';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Product_Type__c = productType;
        loan.Mortgage_Applied_for__c = mortgageAppliedFor;
        loan.Rate_Type__c = rateType;
        update loan;
        
        String keyword = OnBaseLookups.getPurposeOfRefinanceKeyword(loan.Product_Type__c, loan.Mortgage_Applied_for__c, loan.Rate_Type__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getPurposeOfRefinanceKeywordTest_Streamline_HECM_to_HECM()
    {        
        String productType = 'HECM';
        String mortgageAppliedFor = 'HECM to HECM Refinance';
        String rateType = 'FIXED';
        String expected = 'Streamline(HECM to HECM)';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Product_Type__c = productType;
        loan.Mortgage_Applied_for__c = mortgageAppliedFor;
        loan.Rate_Type__c = rateType;
        update loan;
        
        String keyword = OnBaseLookups.getPurposeOfRefinanceKeyword(loan.Product_Type__c, loan.Mortgage_Applied_for__c, loan.Rate_Type__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getProductKeywordWrapperTest_Null() {
        String productType = 'Does not match';
        String mortgageAppliedFor = 'Does not match';
        String rateType = 'Does not match';
        String expected = 'Product Lookup was not found';
        
        String keyword = OnBaseLookups.getProductKeywordWrapper(productType, mortgageAppliedFor, rateType);
        
        System.assert(keyword.contains(expected));
    }
    
    @isTest
    static void getProductKeywordWrapperTest_Found()
    {        
        String productType = 'HELO';
        String mortgageAppliedFor = 'HECM to HECM Refinance';
        String rateType = 'FIXED';
        String expected = 'HELO FIXED – HOME EQUITY LOAN OPTIMIZER';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Product_Type__c = productType;
        loan.Mortgage_Applied_for__c = mortgageAppliedFor;
        loan.Rate_Type__c = rateType;
        update loan;
        
        String keyword = OnBaseLookups.getProductKeywordWrapper(loan.Product_Type__c, loan.Mortgage_Applied_for__c, loan.Rate_Type__c);
        
        System.assertEquals(expected, keyword);   
    }
    
    @isTest
    static void getPurposeOfRefinanceKeywordWrapperTest_Null() {
        String productType = 'Does not match';
        String mortgageAppliedFor = 'Does not match';
        String rateType = 'Does not match';
        String expected = 'PurposeOfRefinance Lookup was not found';
        
        String keyword = OnBaseLookups.getPurposeOfRefinanceKeywordWrapper(productType, mortgageAppliedFor, rateType);
        
        System.assert(keyword.contains(expected));
    }
    
    @isTest
    static void getPurposeOfRefinanceKeywordWrapperTest_Found()
    {        
        String productType = 'HECM';
        String mortgageAppliedFor = 'HECM to HECM Refinance';
        String rateType = 'ARM';
        String expected = 'Streamline(HECM to HECM)';
        
        Loan_New__c loan = [SELECT Id from Loan_New__c LIMIT 1];
        loan.Product_Type__c = productType;
        loan.Mortgage_Applied_for__c = mortgageAppliedFor;
        loan.Rate_Type__c = rateType;
        update loan;
        
        String keyword = OnBaseLookups.getPurposeOfRefinanceKeywordWrapper(loan.Product_Type__c, loan.Mortgage_Applied_for__c, loan.Rate_Type__c);
        
        System.assertEquals(expected, keyword);   
    }
    
}