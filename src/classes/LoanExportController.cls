public class LoanExportController {
    public  list<LoanExportMapHelper> loanvalues{get;set;}
    public String Loan_name{get;set;}
    public LoanExportController(){
          
        String LoanId= ApexPages.currentpage().getParameters().get('id');
        loanvalues = new list<LoanExportMapHelper>();
        loanvalues = get_loandata(LoanId);
    }
    
    
    public static list<LoanFieldValueMap> getRelatedlistData(String ObjectName,String fieldsString,String LoanId){
    
        list<LoanFieldValueMap> LoanFieldValue = new list<LoanFieldValueMap>();
        string whereCon =  ' where Loan_Id__c=:LoanId';
        if(ObjectName.toLowercase() =='LoanStatus__c'.toLowercase()
         || ObjectName.toLowercase() == 'PipeLine_ReDisclosure_Reason__c'.toLowercase()
         || ObjectName.toLowercase() == 'Client__c'.toLowercase()){
        whereCon  = '';
        whereCon =  ' where LoanId__c=:LoanId';
        }
        
        if( ObjectName.toLowercase() == 'Income_New__c'.toLowercase()){
        whereCon  = '';
        whereCon =  ' where Related_Loan__c=:LoanId';
        }
        
        
        if(ObjectName.toLowercase() == 'Asset'.toLowercase()){
        whereCon  = '';
        whereCon =  ' where RelatedLoan__c=:LoanId';
        }
        
         if(ObjectName.toLowercase() == 'Employment__c'.toLowercase()){
        whereCon  = '';
        whereCon =  ' where RelatedLoan__c=:LoanId';
        }

         if(ObjectName.toLowercase() == 'Liability__c'.toLowercase()){
        whereCon  = '';
        whereCon =  ' where RelatedLoan__c=:LoanId';
        }
        
        
        
        if(ObjectName.toLowercase() == 'Declaration__C'.toLowercase()){
        whereCon  = '';
        whereCon =  ' where DeclarationLoan__c=:LoanId';
        }
       String query = 'select '+ fieldsString + ' from '+ ObjectName +whereCon ;
      system.debug('query  : '+query );
        list<sObject> records = database.query(query);
        if(records.size() == 0){
            if(!test.isRunningTest())
            return null;
        }
        list<String> LoanFieldNames = fieldsString.split(',');
        map<String,String> FieldAndLabel  = new map<String,String>();
      //  FieldAndLabel.p
        FieldAndLabel   = getAllFields(ObjectName);
    //populate headers
            list<String> values = new list<String>();
            for(sObject eachLoan:records ){
            values.add('Value');
            }
            LoanFieldValueMap header= new LoanFieldValueMap('Field', values);
           LoanFieldValue.add(header);
    
    //end of headers population
        for(String eachString :LoanFieldNames){
           // Integer i = 0;
            list<String> valuesare = new list<String>();
         //  valuesare.add('Value');
            for(sObject eachLoan:records ){
           // valuesare.add(String.valueOf(eachLoan.get(eachString)));
             if(!eachString.toLowercase().contains('__r.') && !eachString.toLowercase().contains('.name')){
            
              valuesare.add(String.valueOf(eachLoan.get(eachString)));
            }else{
            if(!eachString.toLowercase().contains('.name')){ 
                valuesare.add((String)eachLoan.getSobject(eachString.toLowercase().replace('__r.name','__r')).get('Name'));
               }else{
                valuesare.add((String)eachLoan.getSobject(eachString.toLowercase().replace('.name','')).get('Name'));
               
               } 
            }
          
            }
           //LoanFieldValueMap each = new LoanFieldValueMap(FieldAndLabel.get(eachString.toLowercase()), valuesare);
           LoanFieldValueMap each;
            if(!eachString.toLowercase().contains('__r.') && !eachString.toLowercase().contains('.name')){
             each = new LoanFieldValueMap(FieldAndLabel.get(eachString.toLowercase()), valuesare);
            }else if(eachString.toLowercase().contains('__r.')){
                 each = new LoanFieldValueMap(FieldAndLabel.get(eachString.toLowercase().replace('__r.name','__c')), valuesare);
        
            //    each = new LoanFieldValueMap((String)loanis[0].getSobject(eachString.toLowercase().replace('__r.name','__r')).get('Name'), valuesare);
           }else {
                 each = new LoanFieldValueMap(FieldAndLabel.get(eachString.toLowercase().replace('.name','id')), valuesare);
        
           }
           
           LoanFieldValue.add(each);
        }
    
        return  LoanFieldValue;
    }
    
    public list<LoanExportMapHelper>  get_loandata(String LoanId){
        
        list<LoanExportMapHelper> LoanData = new list<LoanExportMapHelper>();
         list<LoanFieldValueMap> LoanFieldValue = new list<LoanFieldValueMap>();
       
        /*
        list<sObject> loanis =  [select Advanced_Fee_disclosures__c,Alternate_Contact_full_address__c,Alternate_Contact_Name__c,Alternate_Contact_Phone_number__c,Application_Date__c,Appraisal_Delivery__c,Appraisal_Expiration_Date__c,Appraisal_Ordered_Date__c,Appraisal_Received_Date__c,Appraisal_sent_to_Client_Date__c,BrokerCompensation__c,Check_If_Title_is_also_Held_As__c,Children_Under_the_age_of_6_living_in_th__c,Client_Name__c,Client_s_credit_score__c,Closing_Date__c,Confirm_Credit_Reference_Number__c,Contact_Name__c,Contact_Phone_Number_LoanDetails__c,Counseling_Date__c,Counseling_Expiration_Date__c,Credit_Indicator__c,Credit_Reference_Number__c,Credit_Reissue_Vendor__c,Credit_Report_type__c,DocViewer_Link__c,Estimate_of_Appraised_Value__c,FHA_Case_Number_Date__c,FHA_Case_Number_Expiration__c,FinancialAssessmentResult__c,FundtoClose__c,Hazard_Insurance__c,HOA_PUD_Condo_Fees__c,HOI_Effective_Date__c,Household_Members__c,
        Legal_Description_of_Property__c,Loan_Origination_Company_Identifier__c,Loan_Origination_Company_s_AddressNew__c,Loan_Origination_Company_s_CityNew__c,Loan_Origination_Company_s_NameNew__c,Loan_Origination_Company_s_StateNew__c,Loan_Origination_Company_s_Zip_CodeNew__c,Loan_Origination_Fee__c,Loan_Origination_Fee_Calculation__c,Loan_Originator_Identifier__c,Loan_Originator_s_First_NameNew__c,Loan_Originator_s_Last_NameNew__c,Loan_Originator_s_Phone_NumberNew__c,Loan_Processor__c,LoanNumber__c,LoanOfficer__r.Name,LoanStatus__c,Margin__c,Mortgage_Applied_for__c,Name,Next_Tax_Due_Date__c,No_of_Units__c,Other_ReDisclosure_Reason__c,Other_Relationship_Alternative_Contact__c,PCS_at_Loan_Level__r.Name,PCS_at_Partner_Level__c,PipeLine_BestContact__c,PipeLine_BestContactTime__c,Preferred_Contact_Type__c,Property_Held_as__c,Property_Title_is_Held_in_These_Names__c,PropertyAppraisalValue__c,Purpose_of_Loan__c,Real_Estate_Taxes__c,Recent_Re_disclosure_Date__c,ReDisclosure_Reason__c,Related_Individual__r.Name,Related_Partner__r.Name,Relationship_to_Alternative_Contact__c,Selected_Loan_Payment_Plan__c,Square_Footage__c,Subject_Property_Address__c,Subject_Property_City__c,Subject_Property_State__c,Subject_Property_Type__c,Subject_Property_Zip_Code__c,Tell_the_story__c,This_application_was_taken_by__c,Title_Company__c,TotalLesa__c,Using_Title_Source_as_the_Closing_Agent__c, Year_Built__c from Loan_new__c where id=:LoanId];
        */
        list<sObject> loanis =  [select Account_Number__c,Closing_Date__c,Actual_Funding_Date__c,Adjusted_Discount__c,Advanced_Fee_disclosures__c,Alternate_Contact_full_address__c,Alternate_Contact_Name__c,Alternate_Contact_Phone_number__c,Amount_Of_Other_Funds__c,Anticipated_Closing_Date__c,Application_Date__c,Application_Signed_Date__c,Appraisal_Effective_Date__c,Appraisal_Expiration_Date__c,Appraisal_Ordered_Date__c,Appraisal_Received_Date__c,Appraisal_Scheduled_Date__c,Appraisal_sent_to_Client_Date__c,Assets_Amount__c,Broker_Origination__c,BrokerOrigination__c,CashAvaliabletoClient__c,Check_If_Title_is_also_Held_As__c,Children_Under_the_age_of_6_living_in_th__c,Client_s_credit_score__c,Client_Name__c,Appraisal_Delivery__c,Condominium_FHA_Approved__c,Condominium_Name__c,Confirm_Credit_Reference_Number__c,Contact_Email__c,Contact_Name__c,Contact_Phone_Number_LoanDetails__c,Contract_Closing_Date__c,Contract_Date__c,Cooling_Off_Notice_Signed_Date__c,Counseling_Date__c,Counseling_Expiration_Date__c,Credit_Indicator__c,Credit_Reference_Number__c,Credit_Reissue_Vendor__c,Credit_Report_Date__c,Credit_Report_type__c,Credit_to_Borrower__c,Current_User_is_Assigend_PCS__c,Discounted_Value__c,DocViewer_Link__c,Driver_License_and_Social_Security_Card__c,Earnest_Money_Deposit__c,Estimate_of_Appraised_Value__c,ExpectedInterestRate__c,Extend_Application_Time__c,FHACaseNumber__c,FHA_Case_Number_Date__c,FHA_Case_Number_Expiration__c,FinancialAssessmentResult__c,Flood_Ordered_Date__c,Flood_Received_Date__c,Fully_Signed_Application_Package__c,FundtoClose__c,Gift_Amount__c,Gross_Rental_Income__c,Gross_Value__c,Hazard_Insurance__c,HECM_Counseling_Certificate__c,HOA_PUD_Condo_Fees__c,HOA_Monthly_Dues__c,HOI_Effective_Date__c,Household_Members__c,If_yes_Name_of_POA__c,Income_and_Asset_Documentation__c,InitialInterestRate__c,InitialUnpaidPrincipalBalance__c,Insurance_Binder_Ordered_Date__c,Insurance_Binder_Received_Date__c,Interview_Date__c,IsActiveFlag__c,Is_Application_Filled_Flag__c,IsAssetsFilled_Flag__c,Is_CashFlow_Viewed__c,Is_Client_Exist__c,IsClientFilled_Flag__c,IsCreditInfoFilled_Flag__c,IsDeclarationFilled_Flag__c,IsEmploymentFilled_Flag__c,IsIncomeFilled_Flag__c,IsLaibilitiesFilled_Flag__c,IsLoanContactFilled_Flag__c,IsLoanCreatedByLoanProcessor__c,Is_Loan_Created_Manually__c,IsLoanDetailsFilled_Flag__c,IsLoanFilled_Flag__c,IsOrderAppraisalFlag__c,IsSubjectPropertyFilled_Flag__c,Is_there_a_POA_Name_Representing_and__c,Legal_Description_of_Property__c,Lien_Balance__c,Lien_Creditor__c,Life_Expectancy__c,LineOfCreditAfterFirstYear__c,LoanCompleteFlag__c,Loan_Number__c,LoanNumber__c,Loan_Origination_Company_Identifier__c,Loan_Origination_Company_s_AddressNew__c,Loan_Origination_Company_s_CityNew__c,Loan_Origination_Company_s_NameNew__c,Loan_Origination_Company_s_StateNew__c,Loan_Origination_Company_s_Zip_CodeNew__c,Loan_Origination_Fee__c,Loan_Origination_Fee_Calculation__c,Loan_Originator_Identifier__c,Loan_Originator_s_First_Name__c,Loan_Originator_s_First_NameNew__c,Loan_Originator_s_Last_Name__c,Loan_Originator_s_Last_NameNew__c,Loan_Originator_s_Phone_NumberNew__c,LoanStatus__c,Loan_Status_Change_Date__c,MandatoryObligations__c,Margin__c,Monthly_Flood_Insurance_Premium__c,Monthly_Ground_Rents_Amount__c,Monthly_Mortgage_Payment__c,MonthlyPaymentavailabletoClient__c,Monthly_PUD_Fees_Amount__c,Mortgage_and_Liens__c,Mortgage_Applied_for__c,Name_of_Company__c,Net_Rental_Income__c,Next_Tax_Due_Date__c,No_of_Units__c,ORMS_AE__c,Other_ReDisclosure_Reason__c,Other_Relationship_Alternative_Contact__c,Other_Source_Of_Funds__c,Paid_any_fees_to_the_partner__c,Partner_State__c,Payoff_Order_Date__c,PCS_at_Partner_Level__c,Residual_Income_Fulfilled__c,PipeLine_BestContact__c,PipeLine_BestContactTime__c,PipeLine_OtherContactFlag__c,Preferred_Contact_Name__c,Preferred_Contact_Type__c,Present_Market_Value__c,PrincipalLimit__c,ProceedsAvailableFirstYear__c,PropertyAppraisalValue__c,Property__c,Property_Held_as__c,Property_Title_is_Held_in_These_Names__c,Purchase_Price__c,Purpose_of_Loan__c,Rate__c,Rate_Type__c,Real_Estate_Taxes__c,Recent_Re_disclosure_Date__c,Re_disclosure_Date__c,ReDisclosure_Reason__c,Relationship_to_Alternative_Contact__c,RepairEstimate__c,RepairSetAside__c,Residence_Type__c,Residential_Income_Required__c,Sale_Date__c,Sale_Proceeds__c,Scheduled_Closing_Date__c,Selected_Loan_Payment_Plan__c,Source_Of_Funds__c,Square_Footage__c,Status_Of_Current_Address__c,Subject_Property_Address__c,Subject_Property_City__c,Subject_Property_County__c,SubjectPropertyFlag__c,Subject_Property_State__c,Subject_Property_Type__c,Subject_Property_Zip_Code__c,Tell_the_story__c,This_application_was_taken_by__c,Title_Company__c,Title_Ordered_Date__c,Title_Received_Date__c,Total_Assets__c,Total_Asset__c,BrokerCompensation__c,Total_Expenses__c,Total_Income__c,TotalLesa__c,Total_Monthly_Property_Charges__c,Total_Monthly_Property_Charge__c,Total_Property_Charges__c,Using_Title_Source_as_the_Closing_Agent__c,Year_Built__c,LoanOfficer__r.name,Related_Individual__r.name,Related_Partner__r.name from Loan_new__c where id=:LoanId]; 
        
        /*
        list<String> LoanFieldNames = 'Advanced_Fee_disclosures__c,Alternate_Contact_full_address__c,Alternate_Contact_Name__c,Alternate_Contact_Phone_number__c,Application_Date__c,Appraisal_Delivery__c,Appraisal_Expiration_Date__c,Appraisal_Ordered_Date__c,Appraisal_Received_Date__c,Appraisal_sent_to_Client_Date__c,BrokerCompensation__c,CashAvaliabletoClient__c,Check_If_Title_is_also_Held_As__c,Children_Under_the_age_of_6_living_in_th__c,Client_Name__c,Client_s_credit_score__c,Closing_Date__c,Confirm_Credit_Reference_Number__c,Contact_Name__c,Contact_Phone_Number_LoanDetails__c,Counseling_Date__c,Counseling_Expiration_Date__c,Credit_Indicator__c,Credit_Reference_Number__c,Credit_Reissue_Vendor__c,Credit_Report_type__c,DocViewer_Link__c,Estimate_of_Appraised_Value__c,FHA_Case_Number_Date__c,FHA_Case_Number_Expiration__c,FinancialAssessmentResult__c,FundtoClose__c,Hazard_Insurance__c,HOA_PUD_Condo_Fees__c,HOI_Effective_Date__c,Household_Members__c,If_yes_Name_of_POA__c,Is_there_a_POA_Name_Representing_and__c,Legal_Description_of_Property__c,Loan_Origination_Company_Identifier__c,Loan_Origination_Company_s_AddressNew__c,Loan_Origination_Company_s_CityNew__c,Loan_Origination_Company_s_NameNew__c,Loan_Origination_Company_s_StateNew__c,Loan_Origination_Company_s_Zip_CodeNew__c,Loan_Origination_Fee__c,Loan_Origination_Fee_Calculation__c,Loan_Originator_Identifier__c,Loan_Originator_s_First_NameNew__c,Loan_Originator_s_Last_NameNew__c,Loan_Originator_s_Phone_NumberNew__c,Loan_Processor__c,LoanNumber__c,LoanOfficer__r.Name,LoanStatus__c,Margin__c,MonthlyPaymentavailabletoClient__c,Mortgage_Applied_for__c,Name,Next_Tax_Due_Date__c,No_of_Units__c,Other_ReDisclosure_Reason__c,Other_Relationship_Alternative_Contact__c,PCS_at_Loan_Level__r.Name,PCS_at_Partner_Level__c,PipeLine_BestContact__c,PipeLine_BestContactTime__c,Preferred_Contact_Type__c,Property_Held_as__c,Property_Title_is_Held_in_These_Names__c,PropertyAppraisalValue__c,Purpose_of_Loan__c,Real_Estate_Taxes__c,Recent_Re_disclosure_Date__c,ReDisclosure_Reason__c,Related_Individual__r.Name,Related_Partner__r.Name,Relationship_to_Alternative_Contact__c,Selected_Loan_Payment_Plan__c,Square_Footage__c,Subject_Property_Address__c,Subject_Property_City__c,Subject_Property_State__c,Subject_Property_Type__c,Subject_Property_Zip_Code__c,Tell_the_story__c,This_application_was_taken_by__c,Title_Company__c,TotalLesa__c,Using_Title_Source_as_the_Closing_Agent__c,Year_Built__c'.split(',');
        */
        list<String> LoanFieldNames = 'Account_Number__c,Closing_Date__c,Actual_Funding_Date__c,Adjusted_Discount__c,Advanced_Fee_disclosures__c,Alternate_Contact_full_address__c,Alternate_Contact_Name__c,Alternate_Contact_Phone_number__c,Amount_Of_Other_Funds__c,Anticipated_Closing_Date__c,Application_Date__c,Application_Signed_Date__c,Appraisal_Effective_Date__c,Appraisal_Expiration_Date__c,Appraisal_Ordered_Date__c,Appraisal_Received_Date__c,Appraisal_Scheduled_Date__c,Appraisal_sent_to_Client_Date__c,Assets_Amount__c,Broker_Origination__c,BrokerOrigination__c,CashAvaliabletoClient__c,Check_If_Title_is_also_Held_As__c,Children_Under_the_age_of_6_living_in_th__c,Client_s_credit_score__c,Client_Name__c,Appraisal_Delivery__c,Condominium_FHA_Approved__c,Condominium_Name__c,Confirm_Credit_Reference_Number__c,Contact_Email__c,Contact_Name__c,Contact_Phone_Number_LoanDetails__c,Contract_Closing_Date__c,Contract_Date__c,Cooling_Off_Notice_Signed_Date__c,Counseling_Date__c,Counseling_Expiration_Date__c,Credit_Indicator__c,Credit_Reference_Number__c,Credit_Reissue_Vendor__c,Credit_Report_Date__c,Credit_Report_type__c,Credit_to_Borrower__c,Current_User_is_Assigend_PCS__c,Discounted_Value__c,DocViewer_Link__c,Driver_License_and_Social_Security_Card__c,Earnest_Money_Deposit__c,Estimate_of_Appraised_Value__c,ExpectedInterestRate__c,Extend_Application_Time__c,FHACaseNumber__c,FHA_Case_Number_Date__c,FHA_Case_Number_Expiration__c,FinancialAssessmentResult__c,Flood_Ordered_Date__c,Flood_Received_Date__c,Fully_Signed_Application_Package__c,FundtoClose__c,Gift_Amount__c,Gross_Rental_Income__c,Gross_Value__c,Hazard_Insurance__c,HECM_Counseling_Certificate__c,HOA_PUD_Condo_Fees__c,HOA_Monthly_Dues__c,HOI_Effective_Date__c,Household_Members__c,If_yes_Name_of_POA__c,Income_and_Asset_Documentation__c,InitialInterestRate__c,InitialUnpaidPrincipalBalance__c,Insurance_Binder_Ordered_Date__c,Insurance_Binder_Received_Date__c,Interview_Date__c,IsActiveFlag__c,Is_Application_Filled_Flag__c,IsAssetsFilled_Flag__c,Is_CashFlow_Viewed__c,Is_Client_Exist__c,IsClientFilled_Flag__c,IsCreditInfoFilled_Flag__c,IsDeclarationFilled_Flag__c,IsEmploymentFilled_Flag__c,IsIncomeFilled_Flag__c,IsLaibilitiesFilled_Flag__c,IsLoanContactFilled_Flag__c,IsLoanCreatedByLoanProcessor__c,Is_Loan_Created_Manually__c,IsLoanDetailsFilled_Flag__c,IsLoanFilled_Flag__c,IsOrderAppraisalFlag__c,IsSubjectPropertyFilled_Flag__c,Is_there_a_POA_Name_Representing_and__c,Legal_Description_of_Property__c,Lien_Balance__c,Lien_Creditor__c,Life_Expectancy__c,LineOfCreditAfterFirstYear__c,LoanCompleteFlag__c,Loan_Number__c,LoanNumber__c,Loan_Origination_Company_Identifier__c,Loan_Origination_Company_s_AddressNew__c,Loan_Origination_Company_s_CityNew__c,Loan_Origination_Company_s_NameNew__c,Loan_Origination_Company_s_StateNew__c,Loan_Origination_Company_s_Zip_CodeNew__c,Loan_Origination_Fee__c,Loan_Origination_Fee_Calculation__c,Loan_Originator_Identifier__c,Loan_Originator_s_First_Name__c,Loan_Originator_s_First_NameNew__c,Loan_Originator_s_Last_Name__c,Loan_Originator_s_Last_NameNew__c,Loan_Originator_s_Phone_NumberNew__c,LoanStatus__c,Loan_Status_Change_Date__c,MandatoryObligations__c,Margin__c,Monthly_Flood_Insurance_Premium__c,Monthly_Ground_Rents_Amount__c,Monthly_Mortgage_Payment__c,MonthlyPaymentavailabletoClient__c,Monthly_PUD_Fees_Amount__c,Mortgage_and_Liens__c,Mortgage_Applied_for__c,Name_of_Company__c,Net_Rental_Income__c,Next_Tax_Due_Date__c,No_of_Units__c,ORMS_AE__c,Other_ReDisclosure_Reason__c,Other_Relationship_Alternative_Contact__c,Other_Source_Of_Funds__c,Paid_any_fees_to_the_partner__c,Partner_State__c,Payoff_Order_Date__c,PCS_at_Partner_Level__c,Residual_Income_Fulfilled__c,PipeLine_BestContact__c,PipeLine_BestContactTime__c,PipeLine_OtherContactFlag__c,Preferred_Contact_Name__c,Preferred_Contact_Type__c,Present_Market_Value__c,PrincipalLimit__c,ProceedsAvailableFirstYear__c,PropertyAppraisalValue__c,Property__c,Property_Held_as__c,Property_Title_is_Held_in_These_Names__c,Purchase_Price__c,Purpose_of_Loan__c,Rate__c,Rate_Type__c,Real_Estate_Taxes__c,Recent_Re_disclosure_Date__c,Re_disclosure_Date__c,ReDisclosure_Reason__c,Relationship_to_Alternative_Contact__c,RepairEstimate__c,RepairSetAside__c,Residence_Type__c,Residential_Income_Required__c,Sale_Date__c,Sale_Proceeds__c,Scheduled_Closing_Date__c,Selected_Loan_Payment_Plan__c,Source_Of_Funds__c,Square_Footage__c,Status_Of_Current_Address__c,Subject_Property_Address__c,Subject_Property_City__c,Subject_Property_County__c,SubjectPropertyFlag__c,Subject_Property_State__c,Subject_Property_Type__c,Subject_Property_Zip_Code__c,Tell_the_story__c,This_application_was_taken_by__c,Title_Company__c,Title_Ordered_Date__c,Title_Received_Date__c,Total_Assets__c,Total_Asset__c,BrokerCompensation__c,Total_Expenses__c,Total_Income__c,TotalLesa__c,Total_Monthly_Property_Charges__c,Total_Monthly_Property_Charge__c,Total_Property_Charges__c,Using_Title_Source_as_the_Closing_Agent__c,Year_Built__c,LoanOfficer__r.name,PCS_at_Loan_Level__r.name,Related_Individual__r.name,Related_Partner__r.name'.split(',');

        
        
       Loan_name = [select name from Loan_New__c where id=:ApexPages.currentpage().getParameters().get('id')].Name;
        //  system.debug('Loan_name --> '+Loan_name );
        map<String,String> FieldAndLabel  =getAllFields('Loan_New__c');
        
        
         //populate headers
            list<String> values = new list<String>();
            for(sObject eachLoan:loanis ){
            values.add('Value');
            }
            LoanFieldValueMap header= new LoanFieldValueMap('Field', values);
           LoanFieldValue.add(header);
    
    //end of headers population
   
        for(String eachString :LoanFieldNames){
           // Integer i = 0;
            list<String> valuesare = new list<String>();
            for(sObject eachLoan:loanis){
            if(!eachString.toLowercase().contains('__r.') && !eachString.toLowercase().contains('.name')){
                try{
              valuesare.add(String.valueOf(eachLoan.get(eachString)));
                }catch(exception ex){}
            }else{
            if(!eachString.toLowercase().contains('.name')){
                valuesare.add((String)eachLoan.getSobject(eachString.toLowercase().replace('__r.name','__r')).get('Name'));
               }else{
                   try{
                valuesare.add((String)eachLoan.getSobject(eachString.toLowercase().replace('.name','')).get('Name'));
                   }catch(exception ex){}
               } 
            }
            }
            LoanFieldValueMap each;
            if(!eachString.toLowercase().contains('__r.') &&  !eachString.toLowercase().contains('.name')){
             each = new LoanFieldValueMap(FieldAndLabel.get(eachString.toLowercase()), valuesare);
            }else if(eachString.toLowercase().contains('__r.')){
                 each = new LoanFieldValueMap(FieldAndLabel.get(eachString.toLowercase().replace('__r.name','__c')), valuesare);
        
            //    each = new LoanFieldValueMap((String)loanis[0].getSobject(eachString.toLowercase().replace('__r.name','__r')).get('Name'), valuesare);
           }else {
                 each = new LoanFieldValueMap(FieldAndLabel.get(eachString.toLowercase().replace('.name','id')), valuesare);
        
           }
           LoanFieldValue.add(each);
        }
         LoanData.add(new LoanExportMapHelper('Loan',LoanFieldValue));
         list<LoanFieldValueMap> CICFieldValue = new list<LoanFieldValueMap>();
       
      // try{
        list<sObject> CIC = [select Act_of_God__c,Add_a_Non_Borrowing_Spouse__c,Adding_a_non_borrowing_resident__c,AddRemove_Borrowe__c,Appraisal_Received__c,Bring_Optional_Funds_to_Closing__c,change_circumstance_occurred_on__c,Change_in_Employment__c,Change_in_Loan_Officer__c,Change_in_Requested_Payment_Plan__c,CIC_RESPA__c,Additional_Loan_Explanation__c,Inaccurate_Information__c,Loan_Id__c,No_fee_changes__c,Other__c,Other_Change__c,Other_Circumstance_Client_or_Transaction__c,Other_Information_to_Client_Transaction__c,Reduce_Origination_Fee__c,Title_Fees_Received__c,Withdraw__c from ChangeInCircumstances__c where Loan_Id__c=:LoanId];
         string fields = 'Act_of_God__c,Add_a_Non_Borrowing_Spouse__c,Adding_a_non_borrowing_resident__c,Additional_Loan_Explanation__c,AddRemove_Borrowe__c,Appraisal_Received__c,Bring_Optional_Funds_to_Closing__c,change_circumstance_occurred_on__c,Change_in_Employment__c,Change_in_Loan_Officer__c,Change_in_Requested_Payment_Plan__c,CIC_RESPA__c,Inaccurate_Information__c,Loan_Id__r.Name,No_fee_changes__c,Other__c,Other_Change__c,Other_Circumstance_Client_or_Transaction__c,Other_Information_to_Client_Transaction__c,Reduce_Origination_Fee__c,Title_Fees_Received__c,Withdraw__c';
        CICFieldValue  = getRelatedlistData('ChangeInCircumstances__c' ,fields,LoanId);
       if(CICFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('CIC',CICFieldValue));
        } 
    // }catch(Exception ex){}
     
     //Condition
        list<LoanFieldValueMap> CONDITIONFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
        list<sObject> CONDITION = [select Condition_Number__c,Name,Comment__c,Description__c,Loan_Id__c,Status__c from Condition__c where Loan_Id__c=:LoanId];
         string CONDITIONFieldNames  = 'Condition_Number__c,Name,Comment__c,Description__c,Loan_Id__r.Name,Status__c';
           CONDITIONFieldValue =  getRelatedlistData('Condition__c' ,CONDITIONFieldNames,LoanId);   
       if(CONDITIONFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Condition',CONDITIONFieldValue));
        } 
     //}catch(Exception ex){}
     
     
     
     //Condition Log
        list<LoanFieldValueMap> CONDITIONLogFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
       // list<sObject> CONDITION = [select Condition_Number__c,Description__c,Loan_Id__c,Status__c from Condition__c where Loan_Id__c=:LoanId];
         string CONDITIONLogFieldNames  = 'ConditionID__c,Description__c,Loan_Id__r.Name,New_Comments__c,New_Status__c,Old_CreatedDate__c,Old_Status__c';
           CONDITIONLogFieldValue  =  getRelatedlistData('Condition_Log__c' ,CONDITIONLogFieldNames,LoanId);   
       if(CONDITIONLogFieldValue  !=null){
         LoanData.add(new LoanExportMapHelper('Condition Log',CONDITIONLogFieldValue ));
        } 
     //}catch(Exception ex){}
    
    
    
     //Feechange history
        list<LoanFieldValueMap> FeeChangeFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
       // list<sObject> CONDITION = [select Condition_Number__c,Description__c,Loan_Id__c,Status__c from Condition__c where Loan_Id__c=:LoanId];
         string FeeChangeFieldNames  = 'ChangeInCircumtances_Id__c,Fee_Name__c,Loan_Id__r.Name,Name,New_Amount__c,Previous_Amount__c';
           FeeChangeFieldValue =  getRelatedlistData('FeeChangeHistory__c' ,FeeChangeFieldNames,LoanId);   
       if(FeeChangeFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Fee Change History',FeeChangeFieldValue ));
        } 
     //}catch(Exception ex){}
     
     
     //Loan Status
        list<LoanFieldValueMap> LoanStatusFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string LoanStatusFieldNames  = 'LoanId__r.Name,Name,PreviousStatus__c';
           LoanStatusFieldValue  =  getRelatedlistData('LoanStatus__C' ,LoanStatusFieldNames,LoanId);   
       if(LoanStatusFieldValue  !=null){
         LoanData.add(new LoanExportMapHelper('Loan Status',LoanStatusFieldValue ));
        } 
     //}catch(Exception ex){}
     
     
     //pipeline
        list<LoanFieldValueMap> PipeLineFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string PipeLineFieldNames  = 'LoanId__r.Name,NewReDisclosurer_Date__c,OldReDisclosurer_Date__c,ReDisclosure_Reason__c';
           PipeLineFieldValue =  getRelatedlistData('PipeLine_ReDisclosure_Reason__c' ,PipeLineFieldNames  ,LoanId);   
       if(PipeLineFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('PipeLine ReDisclosure Reason',PipeLineFieldValue ));
        } 
     //}catch(Exception ex){}
     
     
     //Client
        list<LoanFieldValueMap> ClientFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string ClientFieldNames  = 'Address_Mailing__c,Address_Same_As_SubjectProperty__c,Check_if_Mailing_Address_is_similar_to_P__c,City__c,City_Mailing__c,Client_Address_Same_As_Primary_Client__c,Client_State__c,DOB__c,Email_Optional__c,First_Name__c,Home_Phone__c,is_Active__c,Last_Name__c,LoanId__r.Name,Marital_Status__c,Middle_Name__c,Name,Non_Borrowing_Date_of_Birth__c,Non_Borrowing_Relation__c,Non_Borrowing_Spouse__c,Non_Borrowing_Spouse_Addres__c,Non_Borrowing_Spouse_City__c,Non_Borrowing_Spouse_Name__c,Non_Borrowing_Spouse_Phone_Number__c,Non_Borrowing_Spouse_State__c,Non_Borrowing_Spouse_Zip__c,Number_of_years__c,Phone_Number__c,Primary_Client_for_the_Loan__c,Property_type__c,Residence__c,Social_Security_Number__c,Spouse_Mailing_Address_same_as_client__c,State_Mailing__c,Street_Address__c,Zip__c,Zip_Mailing__c';
           ClientFieldValue  =  getRelatedlistData('Client__c' ,ClientFieldNames  ,LoanId);   
       if(ClientFieldValue  !=null){
         LoanData.add(new LoanExportMapHelper('Client',ClientFieldValue ));
        } 
     //}catch(Exception ex){}
     
     
     
     
     //Income
        list<LoanFieldValueMap> IncomeFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string IncomeFieldNames  = 'Income_Source__c,Income_Types__c,Income_Value__c,IsActive__c,Name,Related_Loan__r.Name,RelatedClient__r.Name';
          IncomeFieldValue =  getRelatedlistData('Income_New__c' ,IncomeFieldNames  ,LoanId);   
       if(IncomeFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Income ',IncomeFieldValue ));
        } 
     //}catch(Exception ex){}
     
     
     
     //Assets
        list<LoanFieldValueMap> AssetFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string AssetFieldNames  = 'Account_Number__c,Account.Name,Cash_or_Market_Value__c,Cash_or_Market_Value_for_Stocks_or_Bonds__c,Category__c,Contact.Name,Description,Financial_Institution_Address__c,Financial_institution_City__c,Financial_Institution_Zip_Code__c,Finanical_Institution_State__c,isActive__c,Life_Insurance_Policy_Face_Value__c,Name,Name_of_Institution__c,Net_Worth_of_Business_es_Owned__c,Other_Asset_Amount__c,Other_Assets_Type__c,Present_Market_Value__c,RelatedClient__r.Name,RelatedLoan__r.Name,Retirement_Funds__c,Schedule_of_REO_Address_Line_2__c,Schedule_of_REO_City__c,Schedule_of_REO_Property_Address__c,Schedule_of_REO_State__c,Schedule_of_REO_Zip_Code__c,Source_Name__c,Type__c,Type_of_Account__c,Vested_Interest_in_Retirement_Fund__c';
          AssetFieldValue =  getRelatedlistData('Asset' ,AssetFieldNames  ,LoanId);   
       if(AssetFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Assets',AssetFieldValue ));
        } 
     //}catch(Exception ex){}
     
     
         //Declarations
        list<LoanFieldValueMap> DeclarationFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string DeclarationFieldNames  = 'Bankruptcy__c,Bankruptcy_Reason__c,CashtoClose__c,CashtoClose_Borrowed_Money__c,Declaration_Reason__c,Declaration_Remarks__c,DeclarationClient__r.Name,DeclarationLoan__r.Name,Delinquent__c,Delinquent_Address__c,Delinquent_Date_of_the_Debt__c,Delinquent_FHA_VA_Case__c,Delinquent_Name__c,Delinquent_Reason__c,Endorser__c,Enrolled_tribe__c,Ethnicity_New__c,FHA_Acc_No__c,FHA_Amount__c,FHA_Creditor__c,FHA_Insured_Loan__c,FHA_Property_Address__c,FHA_Unpaid_Loan__c,IsActive__c,Lawsuit__c,Name,Outstanding_Judgments__c,Permanent_Resident__c,Primary_Residence__c,Race__c,ReverseMortgage__c,ReverseMortgage_Cost__c,ReverseMortgage_finproduct__c,Sex_New__c,US_Citizen__c';
          DeclarationFieldValue =  getRelatedlistData('Declaration__c',DeclarationFieldNames,LoanId);   
       if(DeclarationFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Declarations',DeclarationFieldValue ));
        } 
     //}catch(Exception ex){}

     //Liabilities
      list<LoanFieldValueMap> liabilitiesFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string liabilitiesFieldValues  = 'Account_Number__c,Additional_Remarks__c,Address__c,Alimony_Type__c,Amount__c,Annual_Hazard_Insurance__c,Liability_Category__c,Check_If_Title_is_also_Held_As__c,City__c,Condominium_FHA_Approved__c,County__c,Gross_Rental_Income__c,HOA_Monthly_Dues__c,Insurance_Taxes_etc__c,isActive__c,IsJoint__c,Is_Liability_Validated__c,Job_Expense_Type__c,Job_Related_Expenses__c,Legal_Description_of_Property__c,Type__c,Liability_willBeClosed_by_paying__c,Liability_will_be_closed_by_paying__c,Liability_will_be_closed_by_Paying_RES__c,Liability_will_be_closed_by_payingThis__c,Monthly_Flood_Insurance_Premium__c,Monthly_Ground_Rents_Amount__c,Liability_Monthly_Payment__c,Monthly_PUD_Fees_Amount__c,Mortgage_Liens__c,Mortgage_Payments__c,Name_of_Company__c,Net_Rental_Income_RealEstate__c,Other_Expense__c,Payments_Owed_to__c,Present_Mortgage_Value__c,Property_Address__c,Property_Address2__c,Property_City__c,Property_State__c,Property_States__c,Property_Type__c,Property_ZIP__c,Property_County__c,Property_Held_as__c,Property_Status__c,Property_Title_is_Held_in_These_Names__c,Real_Estate_Liability__c,Real_Estate_Taxes_Monthly__c,RelatedClient__c,RelatedLoan__c,RemainingMonths__c,Remaining_months__c,Square_Footage__c,State__c,Liability_Type__c,Liability_Unpaid_Balance__c,Year_Built__c,Zip__c';
          liabilitiesFieldValue =  getRelatedlistData('Liability__c',liabilitiesFieldValues  ,LoanId);   
       if(liabilitiesFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Liabilities',liabilitiesFieldValue ));
        } 
     //}catch(Exception ex){}
     
     
     //conditions
      list<LoanFieldValueMap> conditionsFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string conditionsFieldNames  = 'Comment__c,Condition_Number__c,Description__c,Loan_Id__c,Status__c';
          conditionsFieldValue =  getRelatedlistData('Condition__c',conditionsFieldNames  ,LoanId);   
       if(conditionsFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Conditions',conditionsFieldValue ));
        } 
     //}catch(Exception ex){}
     
     
      //Employment
      list<LoanFieldValueMap> EmploymentFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string EmploymentFieldNames  = 'CurrentPosition__c,EmployerAddress__c,City__c,EmployerName__c,EmployerPhone__c,State__c,Zip__c,Income_Type__c,IncomeCategory__c,IncomeType__c,IncomeValue__c,is_Active__c,Is_Employment_Validated__c,Months__c,PositionTitle__c,Primary_Employment__c,Client_id__c,RelatedLoan__c,SelfEmployment__c,YearEmployedinProfession__c,Years__c';
          EmploymentFieldValue =  getRelatedlistData('Employment__c',EmploymentFieldNames  ,LoanId);   
       if(EmploymentFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Employments',EmploymentFieldValue ));
     
        } 
     //}catch(Exception ex){}
     
      //Non-Borrowing Resident
      list<LoanFieldValueMap> BorrowingFieldValue = new list<LoanFieldValueMap>();
      
    //  try{
         string BorrowingFieldNames  = 'IsActiveNBR__c,Loan_Id__c,Non_Borrowing_Resident_Name__c,Date_of_Birth__c,Monthly_Income__c,Relationship_to_Client__c';
          BorrowingFieldValue =  getRelatedlistData('Non_Borrowing_Resident__c',BorrowingFieldNames  ,LoanId);   
       if(BorrowingFieldValue !=null){
         LoanData.add(new LoanExportMapHelper('Non_Borrowing_Residents',BorrowingFieldValue ));
        } 
     //}catch(Exception ex){}
     

     
        return LoanData;
    }
    
    



      public static map<String,String> getAllFields(String ObjIs){
        
           
map<String,String> AllFields = new map<String,String>();
   //use GlobalDecribe to get a list of all available Objects
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Set<String> objectKeys = gd.keySet();
        for(String objectKey: objectKeys)
    {
            //Iterate through all objects to locate ACCOUNT Object
            if (objectKey == ObjIs  ) 
            {
                Schema.SObjectType systemObjectType = gd.get(objectKey);
                Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
                Map<String, Schema.SObjectField> M = r.fields.getMap();
                Set<String> fieldNames = M.keySet();

                             
        
                //iterate through all fields of the object to locate the field
                for(String fieldName: fieldNames)
                {
       
             
               Schema.SObjectField field = M.get(fieldName);
                Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                //extract the picklist valuee
                System.debug(fieldDesc.getPicklistValues() + ' ::::::::::::::::::::::::::::::::::: ') ;
                String AllPickVals = '' ;
                if(fieldDesc.getPicklistValues().size() != 0){
                    for(Schema.PicklistEntry eac:fieldDesc.getPicklistValues()){
                    
                           AllPickVals += eac.getValue() +',';
                    }
                
                }
                    //AllObjmap.get(s).getDescribe().getLabel()
                AllFields.put(fieldName.toLowercase(),fieldDesc.getLabel());
            
            }
    }
  
  }

       return AllFields; 
        
    }

}