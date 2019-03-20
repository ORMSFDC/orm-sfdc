public class OnBaseLookups {
    
    public static String getPropertyStateKeyword(String state)
    {
        Logger.push('getPropertyStateKeyword','OnBaseLookups');
        
        // Returned keyword will be null if no matches found in lookups
        String keyword;
        
        // Look up the property state details by state
        List<Lookup_PropertyState_State__mdt> detail = [select Community__c, Dower__c, Homestead__c from Lookup_PropertyState_State__mdt 
                                                        where State__c = :state];        
        if (detail != null && detail.size() > 0)
        {
            Boolean community = detail[0].Community__c;
            Boolean dower = detail[0].Dower__c;
            Boolean homestead = detail[0].Homestead__c;
			System.debug('Lookup State> ' + state + ' ' + community + dower + homestead );
        
        	// Look up the keyword by property state details
        	List<Lookup_PropertyState_Keyword__mdt> detailKeyword = [select Keyword__c from Lookup_PropertyState_Keyword__mdt where
                                                         Community__c = :community AND
                                                         Dower__c = :dower AND
                                                         Homestead__c = :homestead];
            if (detailKeyword != null && detailKeyword.size() > 0)
            {
                // Found the keyword
                keyword = detailKeyword[0].Keyword__c;
                // Handle the empty case to differentiate since null means lookup not found
                // Returning blank is valid keyword
                if (keyword == null) keyword = '';				
            }
        }
        
        System.debug('PropertyState Keyword> ' + state + ' ' + keyword);
        Logger.pop();        
        return keyword;
    }
    
    @AuraEnabled
    public static String getPropertyStateKeywordWrapper(String state) {
        String keyword = OnBaseLookups.getPropertyStateKeyword(state);
        if (keyword == null) {
            keyword = String.format('PropertyState Lookup was not found for state [{0}]', new String[]{state});
        }
        return keyword;
    }
    
    public static String getProductKeyword(String productType, String mortgageAppliedFor, String rateType)
    {
        Logger.push('getProductKeyword','OnBaseLookups');
        
        // Returned keyword will be null if no matches found in lookup
        String keyword;
        
        // Look up the product keyword        
        List<Lookup_Product_Keyword__mdt> detailKeyword = [select Keyword__c from Lookup_Product_Keyword__mdt where
                                                                 Product_Type__c = :productType AND
                                                                 Mortgage_Applied_for__c = :mortgageAppliedFor AND
                                                                 Rate_Type__c = :rateType];
        if (detailKeyword != null && detailKeyword.size() > 0)
        {
            // Found the keyword
            keyword = detailKeyword[0].Keyword__c;
            // Handle the empty case to differentiate since null means lookup not found
            // Returning blank is valid keyword
            if (keyword == null) keyword = '';            
        }
        
        System.debug('Product keyword> ' + keyword);
        Logger.pop();        
        return keyword;
    }
    
    @AuraEnabled
    public static String getProductKeywordWrapper(String productType, String mortgageAppliedFor, String rateType) {
        String keyword = OnBaseLookups.getProductKeyword(productType, mortgageAppliedFor, rateType);
        if (keyword == null) {
            keyword = String.format('Product Lookup was not found for product type [{0}], mortgage applied for [{1}], rate type [{2}]',
                                    new String[]{productType, mortgageAppliedFor, rateType});
        }
        return keyword;
    }
    
    public static String getPurposeOfRefinanceKeyword(String productType, String mortgageAppliedFor, String rateType)
    {
        Logger.push('getPurposeOfRefinanceKeyword','OnBaseLookups');
        
        // Returned keyword will be null if no matches found in lookup
        String keyword;
        
        // Look up the Purpose of Refinance keyword        
        List<Lookup_Purpose_of_Refinance_Keyword__mdt> detailKeyword = [select Keyword__c from Lookup_Purpose_of_Refinance_Keyword__mdt where
                                                                 Product_Type__c = :productType AND
                                                                 Mortgage_Applied_for__c = :mortgageAppliedFor AND
                                                                 Rate_Type__c = :rateType];
        if (detailKeyword != null && detailKeyword.size() > 0)
        {
            // Found the keyword
            keyword = detailKeyword[0].Keyword__c;
            // Handle the empty case to differentiate since null means lookup not found
            // Returning blank is valid keyword
            if (keyword == null) keyword = '';            
        }
        
        System.debug('PurposeOfRefinance keyword> ' + keyword);
        Logger.pop();
        return keyword;
    }
    
    @AuraEnabled
    public static String getPurposeOfRefinanceKeywordWrapper(String productType, String mortgageAppliedFor, String rateType) {
        String keyword = OnBaseLookups.getPurposeOfRefinanceKeyword(productType, mortgageAppliedFor, rateType);
        if (keyword == null) {
            keyword = String.format('PurposeOfRefinance Lookup was not found for product type [{0}], mortgage applied for [{1}], rate type [{2}]',
                                    new String[]{productType, mortgageAppliedFor, rateType});
        }
        return keyword;
    }

    public static String getClosingProviderKeyword(String amRockAgent)
    {
        Logger.push('getClosingProviderKeyword','OnBaseLookups');
        
        // Returned keyword will be null if no matches found in lookup
        String keyword;
        
        // Look up the Closing Provider keyword
        switch on amRockAgent {
            when 'Yes' {
                keyword = 'AMROCK';
            }
            when 'No' {
                keyword = '';
            }
            when else {
                // Value not set, so null
            }
        }
        
        System.debug('getClosingProviderKeyword keyword> ' + keyword);
        Logger.pop();
        return keyword;
    }
    
    public static String getLoanStatusKeyword(String loanStatus)
    {
        Logger.push('getLoanStatusKeyword','OnBaseLookups');
        
        // Returned keyword will be null if no matches found in lookup
        String keyword;
        
        /*
        // Look up the Closing Provider keyword
        switch on amRockAgent {
            when 'Yes' {
                keyword = 'AMROCK';
            }
            when 'No' {
                keyword = '';
            }
            when else {
                // Value not set, so null
            }
        }
		*/
        keyword = loanStatus + '(T)';
        
        System.debug('getLoanStatusKeyword keyword> ' + keyword);
        Logger.pop();
        return keyword;
    }
    
    public static string validateFinalSend(List<Loan_New__c> loans)
    {
        Logger.push('validateFinalSend','OnBaseLookups');
        
        // For testing
        String displayString = '';
        
        for (Loan_New__c loan: loans)
        {
            if(loan.LoanStatus__c == 'Docs out to Settlement Agent')
            {
                Boolean hasError = false;
                String requiredFields = '';
                
				if(String.isEmpty(loan.LoanNumber__c)) {
                    hasError = true;
                    requiredFields += 'LoanNumber,';
                }
                
                if(String.isEmpty(loan.Client_Name__c)) {
                    hasError = true;
                    requiredFields += 'Borrower Name,';
                }
                
                if(String.isEmpty(loan.Purpose_of_Loan__c)) {
                    hasError = true;
                    requiredFields += 'Purpose of Loan,';
                }
                
                if(loan.Actual_Disbursement_Date__c == null) {
                    hasError = true;
                    requiredFields += 'Actual Disbursement Date,';
                }
                
                if(String.isEmpty(loan.Subject_Property_Address__c)) {
                    hasError = true;
                    requiredFields += 'Subject Property Address,';
                }
                
                if(String.isEmpty(loan.Subject_Property_City__c)) {
                    hasError = true;
                    requiredFields += 'Subject Property City,';
                }
                
                if(String.isEmpty(loan.Subject_Property_State__c)) {
                    hasError = true;
                    requiredFields += 'Subject Property State,';
                }
                
                if(loan.Actual_Closing_Date__c == null) {
                    hasError = true;
                    requiredFields += 'Actual Closing Date,';
                }                
                
                if(String.isEmpty(loan.Subject_Property_Zip_Code__c)) {
                    hasError = true;
                    requiredFields += 'Subject Property Zip Code,';
                }

				if(String.isEmpty(loan.Title_Company__c)) {
                    hasError = true;
                    requiredFields += 'Title Company,';
                }                
                
                if(String.isEmpty(loan.Closing_Agent__c)) {
                    hasError = true;
                    requiredFields += 'Closing Agent,';
                }
                
                if(String.isEmpty(loan.Subject_Property_Type__c)) {
                    hasError = true;
                    requiredFields += 'Subject Property Type,';
                }
				
                //TODO: Lien Type does not have a Salesforce mapping

    			if(String.isEmpty(loan.FHACaseNumber__c )) {
                    hasError = true;
                    requiredFields += 'FHA Case Number,';
                }
                
    			if(loan.Disbursement_Amount__c == null) {
                    hasError = true;
                    requiredFields += 'Disbursement Amount,';
                }
                
                if(String.isEmpty(loan.Subject_Property_County__c)) {
                    hasError = true;
                    requiredFields += 'Subject Property County,';
                }
                
				if(String.isEmpty(loan.Is_there_a_POA_Name_Representing_and__c)) {
                    hasError = true;
                    requiredFields += 'Is there a POA?,';
                }
                
                if(String.isEmpty(loan.Trust_Required__c)) {
                    hasError = true;
                    requiredFields += 'Trust Required,';
                }
                
                if(loan.FHA_Case_Number__c == null) {
                    hasError = true;
                    requiredFields += 'FHA Case Number (date),';
                }                    

                if(loan.Maximum_Claim_Amount__c == null) {
                    hasError = true;
                    requiredFields += 'Maximum Claim Amount,';
                }
                
    			if(loan.PrincipalLimit__c == null) {
                    hasError = true;
                    requiredFields += 'PrincipalLimit,';
                }
                
				if(String.isEmpty(loan.Client_Chosen_Title__c)) {
                    hasError = true;
                    requiredFields += 'Client Chosen Title,';
                }

    			if(String.isEmpty(loan.Flood_Zone__c)) {
                    hasError = true;
                    requiredFields += 'Flood Zone,';
                }
                
    			if(loan.PropertyAppraisalValue__c == null) {
                    hasError = true;
                    requiredFields += 'PropertyAppraisalValue,';
                }

    			if(String.isEmpty(loan.Guardianship_Conservatorship_Required__c)) {
                    hasError = true;
                    requiredFields += 'Guardianship/Conservatorship Required,';
                }
                
				if(String.isEmpty(loan.Assisted_Signing__c)) {
                    hasError = true;
                    requiredFields += 'Assisted Signing,';
                }

                if(String.isEmpty(loan.Remainderman_on_Loan__c)) {
                    hasError = true;
                    requiredFields += 'Remainderman on Loan,';
                }
                
    			if(loan.Initial_Disbursement_Limit__c == null) {
                    hasError = true;
                    requiredFields += 'Initial Disbursement Limit,';
                }

                if(loan.MandatoryObligations__c == null) {
                    hasError = true;
                    requiredFields += 'Mandatory Obligations,';
                }

                if(String.isEmpty(loan.ExpectedInterestRate__c)) {
                    hasError = true;
                    requiredFields += 'Expected Interest Rate,';
                }

    			if(String.isEmpty(loan.InitialInterestRate__c)) {
                    hasError = true;
                    requiredFields += 'Initial Interest Rate,';
                }
                
    			if(String.isEmpty(loan.Non_Borrower_Title_Holder__c)) {
                    hasError = true;
                    requiredFields += 'Non Borrower Title Holder,';
                }
                
    			if(String.isEmpty(loan.Non_Borrowing_Title_Holder_Spouse__c)) {
                    hasError = true;
                    requiredFields += 'Non Borrowing Title Holder Spouse,';
                }
                
    			if(String.isEmpty(loan.POA_NonBorrowing_Title_Holder__c)) {
                    hasError = true;
                    requiredFields += 'POA NonBorrowing Title Holder,';
                }
                
				if(String.isEmpty(loan.ORMS__c)) {
                    hasError = true;
                    requiredFields += 'ORMS Documents,';
                }
                
                
                if(hasError) {
                    displayString = 'The following value(s) must be entered before Docs out to Settlement Agent can be selected: ' + requiredFields.removeEnd(',');
                    loan.addError(displayString);
                }
            }
        }
        
        Logger.pop();
        return displayString;
    }
}