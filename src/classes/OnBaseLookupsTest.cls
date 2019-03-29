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
    
    @isTest
    static void validateFinalSendTest_NoValidationErrors() {
		List<Loan_New__c> loans = 
            [SELECT
                Id,LoanStatus__c,LoanNumber__c,Client_Name__c,Purpose_of_Loan__c,Actual_Disbursement_Date__c,
                Subject_Property_Address__c,Subject_Property_City__c,Subject_Property_State__c,
                Closing_Date__c,Subject_Property_Zip_Code__c,Title_Company__c,Closing_Agent__c,
                Subject_Property_Type__c,FHACaseNumber__c,Disbursement_Amount__c,Subject_Property_County__c,
                Is_there_a_POA_Name_Representing_and__c,Trust_Required__c,FHA_Case_Number_Date__c,Maximum_Claim_Amount__c,
                PrincipalLimit__c,Client_Chosen_Title__c,Flood_Zone__c,PropertyAppraisalValue__c,
                Guardianship_Conservatorship_Required__c,Assisted_Signing__c,Remainderman_on_Loan__c,
                Initial_Disbursement_Limit__c,MandatoryObligations__c,ExpectedInterestRate__c,InitialInterestRate__c,
                Non_Borrower_Title_Holder__c,Non_Borrowing_Title_Holder_Spouse__c,POA_NonBorrowing_Title_Holder__c,ORMS__c
            FROM Loan_New__c];
        loans[0].LoanStatus__c = 'Incomplete';
        loans[0].LoanNumber__c = null;
        String actual = OnBaseLookups.validateFinalSend(loans);
        String expected = '';
        System.assertEquals(expected, actual);
    }
    
    @isTest
    static void validateFinalSendTest_AllValidationErrors() {
        List<Loan_New__c> loans = 
            [SELECT
                Id,LoanStatus__c,LoanNumber__c,Client_Name__c,Purpose_of_Loan__c,Actual_Disbursement_Date__c,
                Subject_Property_Address__c,Subject_Property_City__c,Subject_Property_State__c,
                Closing_Date__c,Subject_Property_Zip_Code__c,Title_Company__c,Closing_Agent__c,
                Subject_Property_Type__c,FHACaseNumber__c,Disbursement_Amount__c,Subject_Property_County__c,
                Is_there_a_POA_Name_Representing_and__c,Trust_Required__c,FHA_Case_Number_Date__c,Maximum_Claim_Amount__c,
                PrincipalLimit__c,Client_Chosen_Title__c,Flood_Zone__c,PropertyAppraisalValue__c,
                Guardianship_Conservatorship_Required__c,Assisted_Signing__c,Remainderman_on_Loan__c,
                Initial_Disbursement_Limit__c,MandatoryObligations__c,ExpectedInterestRate__c,InitialInterestRate__c,
                Non_Borrower_Title_Holder__c,Non_Borrowing_Title_Holder_Spouse__c,POA_NonBorrowing_Title_Holder__c,ORMS__c
            FROM Loan_New__c];
        loans[0].LoanStatus__c = 'Docs out to Settlement Agent';
        loans[0].LoanNumber__c = null;
        loans[0].Client_Chosen_Title__c = null;
        loans[0].Flood_Zone__c= null;
        
        String actual = OnBaseLookups.validateFinalSend(loans);
        String expected = 'The following value(s) must be entered before Docs out to Settlement Agent can be selected: LoanNumber,Borrower Name,Purpose of Loan,Actual Disbursement Date,Subject Property Address,Subject Property City,Subject Property State,Actual Closing Date,Subject Property Zip Code,Title Company,Closing Agent,Subject Property Type,FHA Case Number,Disbursement Amount,Subject Property County,Is there a POA?,Trust Required,FHA Case Number Ordered Date,Maximum Claim Amount,PrincipalLimit,Client Chosen Title,Flood Zone,PropertyAppraisalValue,Guardianship/Conservatorship Required,Assisted Signing,Remainderman on Loan,Initial Disbursement Limit,Mandatory Obligations,Expected Interest Rate,Initial Interest Rate,Non Borrower Title Holder,Non Borrowing Title Holder Spouse,POA NonBorrowing Title Holder,ORMS Documents';
        System.assertEquals(expected, actual);
    }
}