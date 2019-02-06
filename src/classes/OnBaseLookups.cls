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
}