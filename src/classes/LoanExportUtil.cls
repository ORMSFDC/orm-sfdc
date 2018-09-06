/**
* @description  LoanExportUtil - Used to generate JSON Payload for Baydocs
*               Not Released to production
* @author GalaxE (original) / Updated by MG/QDA
* @date 16th July - Sprint 6

* changelog:
* 07/26/2018: DWilson SFDC-213 construct fees section from captured title fee response: Loan_New__c.TitleFeeEstimateResponse__c
* 02/08/2018: MGill SFDC-226 Change Baydocs Param to not return Doc/PDF'SubmitOrderForProcessing'=> '0',
*             MGill SFDC-216 Condominium name is not in the JSON when requesting app package
*             MGill SFDC-227 Remove Liabilities from BayDocs JSON entirely
*
*             @TODO SOQL Query Consolidation
* 09/06/2018: Sahitya: Add LoanType for HELO
*/
global class LoanExportUtil {

    /**
     * @description getExportForLoanIdNew description
     * @param  loanId string
     * @return return instance of LoanWithRelatedObjects_fnl
     */
    public static LoanWithRelatedObjects_fnl getExportForLoanIdNew(String loanId) {
        Logger.push('LoanWithRelatedObjects_fnl','LoanExportUtil');

        LoanWithRelatedObjects_fnl LoanFnl = new LoanWithRelatedObjects_fnl();
        LoanFnl.eventPayload = getExportForLoanId(loanId);
        LoanFnl.eventName= 'LoanAppSubmitted';

        Logger.pop();
        return LoanFnl;

    }

    /**
     * @description Main data retrieval method
     * @param  Loan Id string
     * @return Instance of LoanWithRelatedObjects (wrapper)
     * @todo reviewing / replace with Mike's CMT mapper
     * @todo Review record types Line 150 - why?
     */
    public static LoanWithRelatedObjects getExportForLoanId(String loanId) {
        Logger.push('LoanWithRelatedObjects','LoanExportUtil');

        LoanWithRelatedObjects loanExport = new LoanWithRelatedObjects(); // Instantiate Wrapper Class

        loanExport.BayDocs = BAYDOC_FIELDS; // Set fields

        // Get Loan Rate Type
        // @TODO MG/QDA Any changes for HELO/Private?
        Loan_New__c loanRateType = [select Rate_Type__c,Product_Type__c from Loan_New__c WHERE Id = :loanId]; // Query to get Rate_Type
        String loanType;

        if (loanRateType.Rate_Type__c=='ARM' && loanRateType.Product_Type__c == 'HECM'){
            loanType = '103';
            Logger.debug('loanType='+loanType);
        }else if(loanRateType.Rate_Type__c=='FIXED' && loanRateType.Product_Type__c == 'HECM' )  {
            loanType = '9';
            Logger.debug('loanType='+loanType); 
        }else if(loanRateType.Product_Type__c == 'HELO'){
            loanType = '162';
            Logger.debug('loanType='+loanType); 
        }
        // End

        loanExport.BayDocs.put('LoanType',loanType);

        Loan_New__c loan = Database.query('SELECT ' + joinKeys(LOAN_FIELDS) + ' FROM Loan_New__c WHERE Id = :loanId');
        loanExport.loan = objectToMap(loan, LOAN_FIELDS);

        // @TODO Could be combined with loanRateTypeQuery
        Loan_New__c loan2 = [SELECT Related_Individual__c,
                                    Related_Individual__r.Contact_NMLS__c,
                                    Loan_Originator_s_First_NameNew__c,
                                    Loan_Originator_s_Last_NameNew__c,
                                    TitleFeeEstimateResponse__c
                                FROM Loan_New__c WHERE Id = :loanId];

        // Process related individual if Loan has one
        if (loan2!=null && loan2.Related_Individual__c !=null){
            loanExport.loan.put('loan_officer_nmls', loan2.Related_Individual__r.Contact_NMLS__c);
            String relatedIndividualId = loan2.Related_Individual__c;

            // @TODO Could be combined with loanRateTypeQuery
            Contact relatedIndividual = [SELECT Email,
                    MailingStreet,
                    MailingCity,
                    MailingCountry,
                    MailingPostalCode,
                    MailingState,
                    Account.Phone ,
                    Account.Account_Executive_Name__c,
                    Account.Company_NMLS_ID__c,
                    Account.Holding_Company_Federal_Tax_ID_Number_EI__c
            FROM Contact WHERE Id = :relatedIndividualId];

            if (relatedIndividual != null){
                loanExport.loan.put('account_executive_id', relatedIndividual.Account.Account_Executive_Name__c);
                loanExport.loan.put('company_nmls_id', relatedIndividual.Account.Company_NMLS_ID__c);
                loanExport.loan.put('Holding_Company_Federal_Tax_ID_Number_EI', relatedIndividual.Account.Holding_Company_Federal_Tax_ID_Number_EI__c);
                loanExport.loan.put('Loan_Originator_Full_Name', loan2.Loan_Originator_s_First_NameNew__c+' '+loan2.Loan_Originator_s_Last_NameNew__c);
                loanExport.loan.put('Individual_City', relatedIndividual.MailingCity);
                loanExport.loan.put('Individual_Country', relatedIndividual.MailingCountry);
                loanExport.loan.put('Individual_Postal_Code', relatedIndividual.MailingPostalCode);
                loanExport.loan.put('Individual_State', relatedIndividual.MailingState);
                loanExport.loan.put('Individual_Street_Address', relatedIndividual.MailingStreet);
                loanExport.loan.put('Individual_EmailAddress', relatedIndividual.email);
                loanExport.loan.put('Individual_EmailAddress', relatedIndividual.email);
                loanExport.loan.put('Partner_PhoneNumber', relatedIndividual.Account.phone);
            }

        }


        // add ORM account executive ID



        // SFDC-213 add title fees section from cached response on loan record
        // only attempt to process if appears well-formed
        if ( String.isNotBlank( loan2.TitleFeeEstimateResponse__c )
            && loan2.TitleFeeEstimateResponse__c.contains( AMROCK_TITLEFEE_SUMMARY )
            && loan2.TitleFeeEstimateResponse__c.contains( AMROCK_TITLEFEE_REQUIRED ) ) {
            // deserialize title fee payload
            Map<String, Object> titleFeeResponseMap = ( Map<String, Object> )JSON.deserializeUntyped( loan2.TitleFeeEstimateResponse__c );
            // extract the summary section -- only if it exists
            if ( titleFeeResponseMap.containsKey( AMROCK_TITLEFEE_SUMMARY ) ) {
                Map<String, Object> summarySectionMap = ( Map<String, Object> )titleFeeResponseMap.get( AMROCK_TITLEFEE_SUMMARY );
                // extract the required section -- only if it exists
                if ( summarySectionMap.containsKey( AMROCK_TITLEFEE_REQUIRED ) ) {
                    List<Object> requiredList = ( List<Object> )summarySectionMap.get( AMROCK_TITLEFEE_REQUIRED );
                    for ( Object obj : requiredList ) {
                        loanExport.fees.add( obj );
                    }
                }
            }
        }

        List<Client__c> clients = Database.query('SELECT ' + joinKeys(CLIENT_FIELDS) + ' FROM Client__c WHERE LoanId__c = :loanId');
        for (Client__c client : clients) {
            loanExport.clients.add(objectToMap(client, CLIENT_FIELDS));
        }


        for ( Client__c c : clients){
            try{

                String s1 = c.Non_Borrowing_Spouse_Name__c;
                String s2 = s1.substringAfter(' ');
                String s3= s2.substringAfter(' ');

            }catch(exception ex){}
        }


        List<Non_Borrowing_Resident__c> nonBorrowingResidents = Database.query('SELECT ' + joinKeys(NON_BORROWING_FIELDS) + ' FROM Non_Borrowing_Resident__c WHERE Loan_Id__c = :loanId');
        for (Non_Borrowing_Resident__c resident : nonBorrowingResidents) {
            loanExport.nonBorrowingResidents.add(objectToMap(resident, NON_BORROWING_FIELDS));
        }

        List<Income_New__c> incomes = Database.query('SELECT ' + joinKeys(INCOME_FIELDS) + ' FROM Income_New__c WHERE Related_Loan__c = :loanId');
        for (Income_New__c income : incomes) {
            loanExport.incomes.add(objectToMap(income, INCOME_FIELDS));
        }

        List<Asset> assets = Database.query('SELECT ' + joinKeys(ASSET_FIELDS) + ' FROM Asset WHERE RelatedLoan__c = :loanId');
        for (Asset asset : assets) {
            loanExport.assets.add(objectToMap(asset, ASSET_FIELDS));
        }

        /* SFDC-227
        List<Liability__c> liabilities = Database.query('SELECT ' + joinKeys(LIABILITY_FIELDS) + ' FROM Liability__c WHERE RelatedLoan__c = :loanId');
        for (Liability__c liability : liabilities) {
            loanExport.liabilities.add(objectToMap(liability, LIABILITY_FIELDS));
        }
        */

        List<Declaration__c> declarations = Database.query('SELECT ' + joinKeys(DECLARATION_FIELDS) + ' FROM Declaration__c WHERE DeclarationLoan__c = :loanId');
        for (Declaration__c declaration : declarations) {
            loanExport.declarations.add(objectToMap(declaration, DECLARATION_FIELDS));
        }

        //Employment__c data
        //new code added by Ravi
        List<Employment__c> employments = Database.query('SELECT ' + joinKeys(EMPLOYMENT_FIELDS) + ' FROM Employment__c WHERE RelatedLoan__c = :loanId');
        for (Employment__c employment : employments ) {
            loanExport.employments.add(objectToMap(employment, EMPLOYMENT_FIELDS));
        }


        //License__c data
        //new code Added by Ravi
        // @TODO SOQL Query Consolidation Required
        Loan_New__C ln = [select Related_Partner__c,Subject_property_state__c,Originating_Loan_Officer__r.contactId from Loan_New__c where id=:loanId limit 1];
        String AccId = ln.Related_Partner__c ;
        string stateis = ln.Subject_property_state__c;
        string rlid = ln.Originating_Loan_Officer__r.contactId;

        String partner = '01239000000EGWM'; // record Types?
        String individual = '01239000000EGWL'; // @TODO MG/QDA check these

        List<License__c> licenses = Database.query('SELECT ' + joinKeys(STATE_LICENCES_FIELDS ) + ' FROM License__c WHERE Related_Account__c = :AccId and  State__c = :stateis and recordtypeId=:partner limit 1');
        if(null!=rlid){
            List<License__c> licensesCustom =  Database.query('SELECT ' + joinKeys(STATE_LICENCES_FIELDS ) + ' FROM License__c WHERE Related_Account__c = :AccId and  State__c=:stateis  and Related_Contact__c=:rlid and recordtypeId=:individual limit 1');
            licenses.addAll(licensesCustom);
        }
        for (License__c license: licenses ) {
            loanExport.statelicenses.add(objectToMap(license, STATE_LICENCES_FIELDS ));
        }
        //New code End
        Logger.pop();
        return loanExport;
    }

    // builds string of keys with comma separator
    private static String joinKeys(Map<String, String> fields) {
        Logger.push('joinKeys','LoanExportUtil');
        List<String> keys = new List<String>(fields.keySet());
        Logger.pop();
        return String.join(keys, ',');
    }

    // converts sobject to map using renamed property names from field map
    private static Map<String, Object> objectToMap(sObject sobj, Map<String, String> fields) {
        Logger.push('objectToMap','LoanExportUtil');
        Map<String, Object> output = new Map<String, Object>();
        for (String key : fields.keySet()) {
            if(key!='Subject_Property_State__c'
                && key!='State__c'
                && key!='Property_States__c'
                && key!='Client_State__c'
                && key!='Non_Borrowing_Spouse_State__c'
                && key!='Property_State__c'
                //  && key!='Loan_Origination_Company_s_StateNew__c'
                && key!='Finanical_Institution_State__c'
                && key!='Schedule_of_REO_State__c' && key!='RecordTypeId' ){
                output.put(fields.get(key), sobj.get(key));
            }else if(key!='RecordTypeId'){
                output.put(fields.get(key), getStateCode(String.ValueOf(sobj.get(key))));

            }else{
                string idIs= ''+sobj.get(key);
                string recName = [SELECT Id, Name, DeveloperName FROM RecordType where id=:idIs].Name;

                output.put(fields.get(key), recName );
            }
        }

        Logger.pop();
        return output;

    }
    // final wrapper class for loan export data
    global class LoanWithRelatedObjects_fnl {
        public String eventName{get;set;}
        public object eventPayload{get;set;}

    }
    // wrapper class for loan export data
    global class LoanWithRelatedObjects {
        public Map<String, Object> BayDocs{get; set;}//Added by Ravi
        public Map<String, Object> loan {get; set;}
        public List<Map<String, Object>> clients {get; set;}
        public List<Map<String, Object>> nonBorrowingResidents {get; set;}
        public List<Map<String, Object>> incomes {get; set;}
        public List<Map<String, Object>> assets {get; set;}
        /* SFDC-227  public List<Map<String, Object>> liabilities {get; set;} */
        public List<Map<String, Object>> declarations {get; set;}
        public List<Map<String, Object>> statelicenses{get; set;}//Added by Ravi
        public List<Map<String, Object>> employments{get; set;}//Added by Ravi
        public List<Object> fees { get; set; }


        LoanWithRelatedObjects() {
            clients = new List<Map<String, Object>>();
            nonBorrowingResidents = new List<Map<String, Object>>();
            incomes = new List<Map<String, Object>>();
            assets = new List<Map<String, Object>>();
            /* SFDC-227 liabilities = new List<Map<String, Object>>(); */
            declarations = new List<Map<String, Object>>();
            statelicenses= new List<Map<String, Object>>();//Added by Ravi
            employments= new List<Map<String, Object>>();//Added by Ravi
            BayDocs = new map<string, object>();
            fees = new List<Object>();
        }
    }

    private static final Map<String, String> LOAN_FIELDS = new Map<String, String>{
        'BayDocsOrderNumber__c'                       => 'BayDocsOrderNumber',
        'Advanced_Fee_disclosures__c'                 => 'advanced_fee_disclosures',
        'Alternate_Contact_full_address__c'           => 'alternate_contact_full_address',
        'Alternate_Contact_Name__c'                   => 'alternate_contact_name',
        'Alternate_Contact_Phone_number__c'           => 'alternate_contact_phone_number',
        'Application_Date__c'                         => 'application_date',
        'Appraisal_Delivery__c'                       => 'appraisal_delivery',
        'Appraisal_Expiration_Date__c'                => 'appraisal_expiration_date',
        'Appraisal_Ordered_Date__c'                   => 'appraisal_ordered_date',
        'Appraisal_Received_Date__c'                  => 'appraisal_received_date',
        'Appraisal_sent_to_Client_Date__c'            => 'appraisal_sent_to_client_date',
        'BrokerCompensation__c'                       => 'broker_compensation',
        'CashAvaliabletoClient__c'                    => 'cash_avaliable_to_client',
        'Check_If_Title_is_also_Held_As__c'           => 'check_if_title_is_also_held_as_trust',
        'Children_Under_the_age_of_6_living_in_th__c' => 'children_under_the_age_of_6',
        'Client_Name__c'                              => 'client_name',
        'Client_s_credit_score__c'                    => 'client_credit_score',
        'Closing_Date__c'                             => 'closing_date',
        'Confirm_Credit_Reference_Number__c'          => 'confirm_credit_reference_number',
        'Contact_Name__c'                             => 'contact_name',
        'Contact_Phone_Number_LoanDetails__c'         => 'contact_phone_number_loandetails',
        'Counseling_Date__c'                          => 'counseling_date',
        'Counseling_Expiration_Date__c'               => 'counseling_expiration_date',
        'Credit_Indicator__c'                         => 'credit_indicator',
        'Credit_Reference_Number__c'                  => 'credit_reference_number',
        'Credit_Reissue_Vendor__c'                    => 'credit_reissue_vendor',
        'Credit_Report_type__c'                       => 'credit_report_type',
        'Estimate_of_Appraised_Value__c'              => 'estimate_of_appraised_value',
        'ExpectedInterestRate__c'                     => 'ExpectedInterestRate',
        'FinancialAssessmentResult__c'                => 'financial_assessment_result',
        'FundtoClose__c'                              => 'funds_to_close',
        'Hazard_Insurance__c'                         => 'hazard_insurance',
        'HOA_Monthly_Dues__c'                         => 'hoa_monthly_dues',
        'HOI_Effective_Date__c'                       => 'hoi_effective_date',
        'Household_Members__c'                        => 'household_members',
        'Id'                                          => 'id',
        'If_yes_Name_of_POA__c'                       => 'if_yes_name_of_poa',
        'InitialInterestRate__c'                      => 'InitialInterestRate',
        'Is_Client_Exist__c'                          => 'is_client_exist',
        'Is_there_a_POA_Name_Representing_and__c'     => 'is_there_a_poa_name_representing',
        'Legal_Description_of_Property__c'            => 'legal_description_of_property',
        'Loan_Origination_Company_Identifier__c'      => 'loan_origination_company_identifier',
        'Loan_Origination_Company_s_AddressNew__c'    => 'loan_origination_company_address',
        'Loan_Origination_Company_s_CityNew__c'       => 'loan_origination_company_city',
        'Loan_Origination_Company_s_NameNew__c'       => 'loan_origination_company_name',
        'Loan_Origination_Company_s_StateNew__c'      => 'loan_origination_company_state',
        'Loan_Origination_Company_s_Zip_CodeNew__c'   => 'loan_origination_company_zip_code',
        'Loan_Origination_Fee__c'                     => 'loan_origination_fee',
        'Loan_Origination_Fee_Calculation__c'         => 'loan_origination_fee_calculation',
        'Loan_Originator_Identifier__c'               => 'loan_originator_identifier',
        'Loan_Originator_s_First_NameNew__c'          => 'loan_originator_first_name',
        'Loan_Originator_s_Last_NameNew__c'           => 'loan_originator_last_name',
        'Loan_Originator_s_Phone_NumberNew__c'        => 'loan_originator_phone_number',
        'Loan_Processor__c'                           => 'loan_processor',
        'LoanNumber__c'                               => 'loan_number',
        'Margin__c'                                   => 'margin',
        'MonthlyPaymentavailabletoClient__c'          => 'monthly_payment_available_to_client',
        'Monthly_Flood_Insurance_Premium__c'          => 'monthly_flood_insurance_premium',
        'Monthly_Ground_Rents_Amount__c'              => 'monthly_ground_rents_amount',
        'Monthly_PUD_Fees_Amount__c'                  => 'monthly_pud_fees_amount',
        'Mortgage_Applied_for__c'                     => 'mortgage_applied_for',
        'Name'                                        => 'name',
        'No_of_Units__c'                              => 'no_of_units',
        'Other_ReDisclosure_Reason__c'                => 'other_redisclosure_reason',
        'Other_Relationship_Alternative_Contact__c'   => 'other_relationship_alternative_contact',
        'PCS_at_Loan_Level__c'                        => 'pcs_at_loan_level',
        'PipeLine_BestContact__c'                     => 'pipeline_best_contact',
        'PipeLine_BestContactTime__c'                 => 'pipeline_best_contact_time',
        'Preferred_Contact_Type__c'                   => 'preferred_contact_type',
        'Property_Held_as__c'                         => 'property_held_as',
        'Property_Title_is_Held_in_These_Names__c'    => 'property_title_is_held_in_these_names',
        'PropertyAppraisalValue__c'                   => 'property_appraisal_value',
        'Purchase_Price__c'                           => 'Purchase_Price',
        'Purpose_of_Loan__c'                          => 'purpose_of_loan',
        'Rate__c'                                     => 'Rate',
        'Rate_Type__c'                                => 'Rate_Type',
        'Re_disclosure_Date__c'                       => 're_disclosure_date',
        'Real_Estate_Taxes__c'                        => 'real_estate_taxes',
        'Recent_Re_disclosure_Date__c'                => 'recent_re_disclosure_date',
        'ReDisclosure_Reason__c'                      => 'redisclosure_reason',
        'Related_Individual__c'                       => 'loan_officer_id',
        'Related_Partner__c'                          => 'related_partner_id',
        'Relationship_to_Alternative_Contact__c'      => 'relationship_to_alternative_contact',
        'Selected_Loan_Payment_Plan__c'               => 'selected_loan_payment_plan',
        'Square_Footage__c'                           => 'square_footage',
        'Subject_Property_Address__c'                 => 'subject_property_address',
        'Subject_Property_City__c'                    => 'subject_property_city',
        'Subject_Property_County__c'                  => 'subject_property_county',
        'Subject_Property_State__c'                   => 'subject_property_state',
        'Subject_Property_Zip_Code__c'                => 'subject_property_zip_code',
        'Subject_Property_Type__c'                    => 'subject_property_type',
        'Condominium_Name__c'                         => 'subject_condominium_name',
        'Tell_the_story__c'                           => 'tell_the_story',
        'This_application_was_taken_by__c'            => 'this_application_was_taken_by',
        'Title_Company__c'                            => 'title_company',
        'TotalLesa__c'                                => 'total_lesa',
        'Using_Title_Source_as_the_Closing_Agent__c'  => 'using_title_source_as_the_closing_agent',
        'Loan_Payment_Plan_Term__c'                   => 'Loan_Payment_Plan_Term',
        'Year_Built__c'                               => 'year_built'
    };

    private static final Map<String, String> CLIENT_FIELDS = new Map<String, String>{
        'Address_Mailing__c'                          => 'address_mailing',
        'Address_Same_As_SubjectProperty__c'          => 'address_same_as_subject_property',
        'Check_if_Mailing_Address_is_similar_to_P__c' => 'mailing_address_equals_present_address',
        'City__c'                                     => 'city',
        'City_Mailing__c'                             => 'city_mailing',
        'Client_Address_Same_As_Primary_Client__c'    => 'client_address_same_as_primary_client',
        'Client_State__c'                             => 'client_state',
        'DOB__c'                                      => 'dob',
        'Email_Optional__c'                           => 'email',
        'FHA_Insured_Loan__c'                         => 'fha_insured_loan',
        'First_Name__c'                               => 'first_name',
        'Home_Phone__c'                               => 'home_phone',
        'Id'                                          => 'id',
        'is_Active__c'                                => 'is_active',
        'Is_there_a_POA__c'                           => 'is_there_a_poa_name_representing',
        'If_yes_Name_of_POA__c'                       => 'if_yes_name_of_poa',
        'Last_Name__c'                                => 'last_name',
        'LoanId__c'                                   => 'loan_id',
        'Marital_Status__c'                           => 'marital_status',
        'Middle_Name__c'                              => 'middle_name',
        'Name'                                        => 'name',
        'Non_Borrowing_Date_of_Birth__c'              => 'non_borrowing_date_of_birth',
        'Non_Borrowing_Relation__c'                   => 'non_borrowing_relation',
        'Non_Borrowing_Spouse__c'                     => 'non_borrowing_spouse',
        'Non_Borrowing_Spouse_Addres__c'              => 'non_borrowing_spouse_addres',
        'Non_Borrowing_Spouse_City__c'                => 'non_borrowing_spouse_city',
        'Non_Borrowing_Spouse_Name__c'                => 'non_borrowing_spouse_name',
        'Non_Borrowing_Spouse_Phone_Number__c'        => 'non_borrowing_spouse_phone_number',
        'Non_Borrowing_Spouse_State__c'               => 'non_borrowing_spouse_state',
        'Non_Borrowing_Spouse_Zip__c'                 => 'non_borrowing_spouse_zip',
        'Number_of_years__c'                          => 'number_of_years',
        'Phone_Number__c'                             => 'phone_number',
        'Place_of_Celebration__c'                     => 'place_of_celebration',
        'Primary_Client_for_the_Loan__c'              => 'primary_client_for_the_loan',
        'Property_type__c'                            => 'property_type',
        'Residence__c'                                => 'residence',
        'Social_Security_Number__c'                   => 'social_security_number',
        'Spouse_Mailing_Address_same_as_client__c'    => 'spouse_mailing_address_same_as_client',
        'State__c'                                    => 'state',
        'State_Mailing__c'                            => 'state_mailing',
        'Street_Address__c'                           => 'street_address',
        'Zip__c'                                      => 'zip',
        'Zip_Mailing__c'                              => 'zip_mailing'
    };

    private static final Map<String, String> NON_BORROWING_FIELDS = new Map<String, String>{
        'Client_Id__c'                   => 'client_id',
        'IsActiveNBR__c'                 => 'is_active_nbr',
        'LastModifiedById'               => 'last_modified_by_id',
        'Loan_Id__c'                     => 'loan_id',
        'Non_Borrowing_Resident_Name__c' => 'non_borrowing_resident_name',
        'Date_of_Birth__c'               => 'date_of_birth',
        'Monthly_Income__c'              => 'monthly_income',
        'Name'                           => 'name',
        'Relationship_to_Client__c'      => 'relationship_to_client'
    };

    private static final Map<String, String> INCOME_FIELDS = new Map<String, String>{
        'Id'               => 'id',
        'Income_Source__c' => 'income_source',
        'Income_Types__c'  => 'income_type',
        'Income_Value__c'  => 'income_value',
        'IsActive__c'      => 'is_active',
        'Name'             => 'name',
        'RelatedClient__c' => 'client_id',
        'Related_Loan__c'  => 'loan_id'
    };

    private static final Map<String, String> ASSET_FIELDS = new Map<String, String>{
        'Account_Number__c'                           => 'account_number',
        'AccountId'                                   => 'account_id',
        'Cash_or_Market_Value__c'                     => 'cash_or_market_value',
        'Cash_or_Market_Value_for_Stocks_or_Bonds__c' => 'cash_or_market_value_for_stocks_or_bonds',
        'Category__c'                                 => 'category',
        'Description'                                 => 'description',
        'Financial_Institution_Address__c'            => 'financial_institution_address',
        'Financial_institution_City__c'               => 'financial_institution_city',
        'Financial_Institution_Zip_Code__c'           => 'financial_institution_zip_code',
        'Finanical_Institution_State__c'              => 'finanical_institution_state',
        'Id'                                          => 'id',
        'isActive__c'                                 => 'is_active',
        'Life_Insurance_Policy_Face_Value__c'         => 'life_insurance_policy_face_value',
        'Name'                                        => 'name',
        'Name_of_Institution__c'                      => 'name_of_institution',
        'Net_Worth_of_Business_es_Owned__c'           => 'net_worth_of_business_es_owned',
        'Other_Asset_Amount__c'                       => 'other_asset_amount',
        'Other_Assets_Type__c'                        => 'other_assets_type',
        'Present_Market_Value__c'                     => 'present_market_value',
        'RelatedClient__c'                            => 'client_id',
        'RelatedLoan__c'                              => 'loan_id',
        'Retirement_Funds__c'                         => 'retirement_funds',
        'Schedule_of_REO_Address_Line_2__c'           => 'schedule_of_reo_address2',
        'Schedule_of_REO_City__c'                     => 'schedule_of_reo_city',
        'Schedule_of_REO_Property_Address__c'         => 'schedule_of_reo_address',
        'Schedule_of_REO_State__c'                    => 'schedule_of_reo_state',
        'Schedule_of_REO_Zip_Code__c'                 => 'schedule_of_reo_zip_code',
        'Source_Name__c'                              => 'source_name',
        'Type__c'                                     => 'type',
        'Type_of_Account__c'                          => 'type_of_account',
        'Vested_Interest_in_Retirement_Fund__c'       => 'vested_interest_in_retirement_fund'
    };

    /* SFDC-227
    private static final Map<String, String> LIABILITY_FIELDS = new Map<String, String>{
        'Account_Number__c'                         => 'account_number',
        'Additional_Remarks__c'                     => 'additional_remarks',
        'Address__c'                                => 'address',
        'Alimony_Type__c'                           => 'alimony_type',
        'Amount__c'                                 => 'amount',
        'City__c'                                   => 'city',
        'County__c'                                 => 'county',
        'Gross_Rental_Income__c'                    => 'gross_rental_income',
        'Id'                                        => 'id',
        'Insurance_Taxes_etc__c'                    => 'insurance_taxes_etc',
        'isActive__c'                               => 'is_active',
        'Job_Expense_Type__c'                       => 'job_expense_type',
        'Job_Related_Expenses__c'                   => 'job_related_expenses',
        'Liability_Category__c'                     => 'liability_category',
        'Liability_Monthly_Payment__c'              => 'liability_monthly_payment',
        'Liability_Type__c'                         => 'liability_type',
        'Liability_Unpaid_Balance__c'               => 'liability_unpaid_balance',
        'Liability_will_be_closed_by_paying__c'     => 'liability_will_be_closed_by_paying',
        'Liability_will_be_closed_by_Paying_RES__c' => 'liability_will_be_closed_by_paying_res',
        'Liability_will_be_closed_by_payingThis__c' => 'liability_will_be_closed_by_paying_this',
        'Liability_willBeClosed_by_paying__c'       => 'liability_will_be_closed_by_paying_alimony',
        'Mortgage_Liens__c'                         => 'mortgage_liens',
        'Mortgage_Payments__c'                      => 'mortgage_payments',
        'Name'                                      => 'name',
        'Name_of_Company__c'                        => 'name_of_company',
        'Net_Rental_Income_RealEstate__c'           => 'net_rental_income_real_estate',
        'Other_Expense__c'                          => 'other_expense',
        'Payments_Owed_to__c'                       => 'payments_owed_to',
        'Present_Mortgage_Value__c'                 => 'present_mortgage_value',
        'Property_Address__c'                       => 'property_address',
        'Property_Address2__c'                      => 'property_address2',
        'Property_City__c'                          => 'property_city',
        'Property_State__c'                         => 'property_state',
        'Property_States__c'                        => 'property_states',
        'Property_Status__c'                        => 'property_status',
        'Property_Type__c'                          => 'property_type',
        'Property_ZIP__c'                           => 'property_zip',
        'Real_Estate_Liability__c'                  => 'real_estate_liability',
        'RelatedClient__c'                          => 'client_id',
        'RelatedLoan__c'                            => 'loan_id',
        'RemainingMonths__c'                        => 'remaining_months',
        'State__c'                                  => 'state',
        'Type__c'                                   => 'type',
        'Zip__c'                                    => 'zip'
    };
    */

    private static final Map<String, String> DECLARATION_FIELDS = new Map<String, String>{
        'Bankruptcy__c'                             => 'bankruptcy',
        'Bankruptcy_Reason__c'                      => 'bankruptcy_reason',
        'CashtoClose__c'                            => 'cash_to_close',
        'CashtoClose_Borrowed_Money__c'             => 'cash_to_close_borrowed_money',
        'Declaration_Reason__c'                     => 'declaration_reason',
        'Declaration_Remarks__c'                    => 'declaration_remarks',
        'DeclarationClient__c'                      => 'client_id',
        'DeclarationLoan__c'                        => 'loan_id',
        'Delinquent__c'                             => 'delinquent',
        'Delinquent_Address__c'                     => 'delinquent_address',
        'Delinquent_Date_of_the_Debt__c'            => 'delinquent_date_of_the_debt',
        'Delinquent_FHA_VA_Case__c'                 => 'delinquent_fha_va_case',
        'Delinquent_Name__c'                        => 'delinquent_name',
        'Delinquent_Reason__c'                      => 'delinquent_reason',
        'Endorser__c'                               => 'endorser',
        'Enrolled_tribe__c'                         => 'enrolled_tribe',
        'Ethnicity__c'                              => 'Ethnicity',
        'Ethnicity_New__c'                          => 'Sub-Ethnicity',
        'FHA_Acc_No__c'                             => 'fha_acc_no',
        'FHA_Amount__c'                             => 'fha_amount',
        'FHA_Creditor__c'                           => 'fha_creditor',
        'FHA_Insured_Loan__c'                       => 'fha_insured_loan',
        'FHA_Property_Address__c'                   => 'fha_property_address',
        'FHA_Unpaid_Loan__c'                        => 'fha_unpaid_loan',
        'Id'                                        => 'id',
        'IsActive__c'                               => 'is_active',
        'IsDeclaration_Filled_From_Tab__c'          => 'is_declaration_filled_from_tab',
        'Lawsuit__c'                                => 'lawsuit',
        'Name'                                      => 'name',
        'Outstanding_Judgments__c'                  => 'outstanding_judgments',
        'Permanent_Resident__c'                     => 'permanent_resident',
        'Primary_Residence__c'                      => 'primary_residence',
        'Race__c'                                   => 'race',
        'ReverseMortgage__c'                        => 'reverse_mortgage',
        'ReverseMortgage_Cost__c'                   => 'reverse_mortgage_cost',
        'ReverseMortgage_finproduct__c'             => 'reverse_mortgage_finproduct',
        'Sex_New__c'                                => 'sex',
        'US_Citizen__c'                             => 'us_citizen'
    };

    //Added by Ravi
    private static final Map<String, String> STATE_LICENCES_FIELDS = new Map<String, String>{
        'CreatedById'                                       => 'createdbyid',
        'LastModifiedById'                                  => 'lastmodifiedbyid',
        'License_Expiration__c'                             => 'license_expiration',
        'Name'                                              => 'licenceid',
        'License_Issued_Date__c'                            => 'license_issued_dat',
        'License_Number__c'                                 => 'license_number',
        'License_Type__c'                                   => 'license_type',
        'OwnerId'                                           => 'ownerid',
        'RecordTypeId'                                      => 'recordtypename',
        'Related_Branch__c'                                 => 'related_branch',
        'Related_Contact__c'                                => 'related_contact',
        'Related_Account__c'                                => 'related_account',
        'State__c'                                          => 'state'

    };

    //Added by Ravi
    private static final Map<String, String> EMPLOYMENT_FIELDS = new Map<String, String>{
        'CurrentPosition__c'                =>                        'CurrentPosition',
        'City__c'                           =>                        'Employer_City',
        'State__c'                          =>                        'Employer_State',
        'Zip__c'                            =>                        'Employer_Zip',
        'EmployerAddress__c'                =>                        'EmployerAddress',
        'EmployerName__c'                   =>                        'EmployerName',
        'EmployerPhone__c'                  =>                        'EmployerPhone',
        'Name'                              =>                        'Employment ID',
        'Income_Type__c'                    =>                        'Income_Type',
        'IncomeCategory__c'                 =>                        'IncomeCategory',
        'IncomeType__c'                     =>                        'IncomeType',
        'IncomeValue__c'                    =>                        'IncomeValue',
        'is_Active__c'                      =>                        'is_Active',
        'Is_Employment_Validated__c'        =>                        'Is_Employment_Validated',
        'Months__c'                         =>                        'Months',
        'PositionTitle__c'                  =>                        'PositionTitle',
        'Primary_Employment__c'             =>                        'Primary_Employment',
        'Client_id__c'                      =>                        'RelatedClient',
        'RelatedLoan__c'                    =>                        'RelatedLoan',
        'SelfEmployment__c'                 =>                        'SelfEmployment',
        'YearEmployedinProfession__c'       =>                        'YearEmployedinProfession',
        'Years__c'                          =>                        'Years'
    };

    //Added by Ravi
    private static final Map<String, String> BAYDOC_FIELDS = new Map<String, String>{

        'UserID'=> '4738 ',
        'XMLPassword'=> 'lR7i61T74c3h0746Q8S7zC2Nt1DF1m16',
        'SubmitOrderForProcessing'=> '0',
        'WaitForPDF'=> '1',
        'LenderID'=> '2364',
        //  'LoanType'=> '103',
        //    'LoanType'=> 'LoanType1',
        'PackageType'=> '1',
        'CalcAmortTalcTila'=> '1'

    };

    /*******************************************************************************************************
    * @description constants used for parsing the cached Amrock TitleFee response
    */
    private static final String AMROCK_TITLEFEE_SUMMARY = 'summary';
    private static final String AMROCK_TITLEFEE_REQUIRED = 'required';

    public static string getStateCode(String stateName){

        Logger.push('getStateCode','LoanExportUtil');

        map<String,String> StateAndCode =new map<String,String>();
        for(States_And_Shortcodes__mdt eachState : [SELECT Id,developerName, MasterLabel, Language, NamespacePrefix, Label FROM States_And_Shortcodes__mdt]){

            StateAndCode.put(eachState.MasterLabel.toLowercase(),eachState.developerName);
        }
        if(stateName!='' && stateName !=null)
            return  StateAndCode.get(stateName.toLowercase());

        Logger.pop();
        return ''; // @TODO MG/QDA why is this returning empty string > could just be void?

    }

}