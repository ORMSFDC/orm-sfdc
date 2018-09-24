/**
 * @description ScenarioExportUtil - Generate data for BayDocs Scenario package
 * @author GalaxE
 * @date 08/03/18 (MG/QDA)
 * @changelog Limited Refactoring, Added Logging Framework Hooks, Split out logic into new methods
 * @todo see inline
 * 9/04/2018: Sahitya: Added Margin for HELO
 * 9/20/2018: Sahitya: SFDC-289 - Added 3rd Tier
 */

global class ScenarioExportUtil {

    /**
     *
     * @description get Data for Scenario
     * @param scenarioId
     * @return ScenarioWithRelatedObjects
     * @todo Unnecessary/duplicate  SOQL out of here entirely and pass in the data from lookupController
     */
    public static ScenarioWithRelatedObjects getExportForscenarioId(String scenarioId) {
        Logger.push('ScenarioWithRelatedObjects', 'ScenarioExportUtil');

        scenarioWithRelatedObjects ScenarioExport = new scenarioWithRelatedObjects();
        ScenarioExport.BayDocs = BAYDOC_FIELDS;

        Scenario__c loanlead1 = [SELECT  RateType__c,
        HeloMargin__c,
        Margin__c,
        Estimated_home_value__c,
        PartnerId__c,
        PartnerId__r.ContactId,
        PartnerId__r.Contact.Name,
        PartnerId__r.Contact.AccountId,
        PartnerId__r.Contact.Account.Name,
        PartnerId__r.Contact.Contact_NMLS__c,
        PartnerId__r.Contact.Office_Phone__c,
        PartnerId__r.Contact.Email,
        PartnerId__r.Contact.Account.Premier_Partner__c,
        PartnerId__r.Contact.Account.BillingStreet,
        PartnerId__r.Contact.Account.BillingState,
        PartnerId__r.Contact.Account.BillingCity,
        PartnerId__r.Contact.Account.BillingPostalcode,
        PartnerId__r.Contact.Account.Phone,
        PartnerId__r.Contact.Account.Company_NMLS_ID__c
        FROM Scenario__c
        WHERE  Id = :scenarioId];
    
        String Loanrate;
        if (loanlead1.RateType__c == 'Adjust') { 
            Loanrate = '103'; 
        }     //Helo Fix
        else if(loanlead1.RateType__c == 'Fixed') { 
            Loanrate = '9'; 
        }else{
            Loanrate = '162';
        }
        
        ScenarioExport.BayDocs.put('LoanType', Loanrate);
        Scenario__c loanlead = Database.query('SELECT ' + joinKeys(SCENARIO_FIELDS) + ' FROM Scenario__c WHERE Id = :scenarioId');

        ScenarioExport.loanlead = objectToMap(loanlead, SCENARIO_FIELDS, loanlead);

        ScenarioExport.loanlead.put('Individual_id', loanlead1.PartnerId__r.ContactId);
        ScenarioExport.loanlead.put('Partner_id', loanlead1.PartnerId__r.Contact.AccountId);
        ScenarioExport.loanlead.put('Individual_Name', loanlead1.PartnerId__r.Contact.Name);
        ScenarioExport.loanlead.put('Individual_Phone', loanlead1.PartnerId__r.Contact.Office_Phone__c);
        ScenarioExport.loanlead.put('Individual_Email', loanlead1.PartnerId__r.Contact.Email);
        ScenarioExport.loanlead.put('Contact_NMLS', loanlead1.PartnerId__r.Contact.Contact_NMLS__c);
        ScenarioExport.loanlead.put('Company_NMLS', loanlead1.PartnerId__r.Contact.Account.Company_NMLS_ID__c);
        ScenarioExport.loanlead.put('Partner_Name', loanlead1.PartnerId__r.Contact.Account.Name);


        if (loanlead1.PartnerId__r.Contact.Account.BillingStreet != null) {
            // Get Billing Street and remove carriage returns if street is multi-line
            ScenarioExport.loanlead.put('Partner_Street', (loanlead1.PartnerId__r.Contact.Account.BillingStreet).replace('\r\n', ' '));
        }

        ScenarioExport.loanlead.put('Partner_City', loanlead1.PartnerId__r.Contact.Account.BillingCity);
        ScenarioExport.loanlead.put('Partner_State', loanlead1.PartnerId__r.Contact.Account.BillingState);
        ScenarioExport.loanlead.put('Partner_ZipCode', loanlead1.PartnerId__r.Contact.Account.BillingPostalcode);
        ScenarioExport.loanlead.put('Partner_Phone', loanlead1.PartnerId__r.Contact.Account.Phone);
        //Helo margin fix
        if(loanlead1.RateType__c == 'Helo'){
            ScenarioExport.loanlead.put('Margin', loanlead1.HeloMargin__c);
        }else{
            ScenarioExport.loanlead.put('Margin', loanlead1.Margin__c);            
        }
        
        Map<String, Decimal> dataExportIs = getDataExportIds(loanlead1);
        if (!dataExportIs.isEmpty()){
            ScenarioExport.loanlead.put('origFees', dataExportIs);
        }
        Logger.pop();
        return ScenarioExport;
    }

    /*
    * @description Get Data Export Ids & HUD Calculation
    * @param Scenario object instance
    * @return Map Data Export Points
     */
    private static Map<String, Decimal> getDataExportIds (Scenario__c s){

        Logger.push('getDataExportIds','ScenarioExportUtils');
        Map<String, Decimal> dataExportIs = new Map<String, Decimal>(); // Empty Map

        //HUD Calculation
        Decimal firstValue = 0;// = (200000 * 0.02);
        Decimal secondValue = 0;
        Decimal i_ev = s.Estimated_home_value__c ;
        if (i_ev <= 200000) {
            firstValue = (i_ev * 0.02);

        } else {
            //if i_ev >200K
            firstValue = (200000 * 0.02);
            secondValue = ((i_ev - 200000) * 0.01);

        }
        Decimal HUDis = firstValue + secondValue;
        HUDis = (HUDis > 6000) ? 6000 : HUDis;

        //Get rate and Originaed orm fee ino JSON String from custom metadata        
        // Get Account Premier Type value
        //SFDC - 289
        String partnerType = [select id,Contact.AccountId,Contact.Account.Partner_Type__c from user where id=:userinfo.getUserId()].Contact.Account.Partner_Type__c;
        
        // Determine source CMT object
        String MetaDataTableFixed = '';
        if(partnerType == 'Non Premier'){                
                MetaDataTableFixed = 'Fixed_Price_Tier1__mdt';                
            }
            else if(partnerType == 'Premier'){
                MetaDataTableFixed = 'Fixed_Price_Tier2__mdt';
            }
            else if(partnerType == 'Premier Plus'){
                MetaDataTableFixed = 'Fixed_Price_Tier3__mdt';
            }       

        // Build cmt query string
        String metadataQuery = 'SELECT Id, DeveloperName,  Origination_to_ORM__c, Rate__c FROM ' + MetaDataTableFixed;
        List<sObject> metadataResults = database.query(metadataQuery); // run cmt query


        // Iterate cmt results
        for (sObject eachsObject : metadataResults) {
            decimal mapingValue = (HUDis < Decimal.valueOf(String.valueOf(eachsObject.get('Origination_to_ORM__c'))))
                    ? HUDis : Decimal.valueOf(String.valueOf(eachsObject.get('Origination_to_ORM__c')));
            Decimal keyIs = Decimal.valueOf(String.valueOf(eachsObject.get('Rate__c'))).setScale(2);
            Decimal roundedkeyIs = Math.round(keyIs * 100) / 100.0;

            system.debug(roundedkeyIs);

            Decimal valueIs = Decimal.valueOf(String.valueOf(mapingValue)).setScale(2);
            Decimal roundedvalueIs = Math.round(valueIs * 100) / 100.0;
            system.debug(Decimal.valueOf(string.valueOf(valueIs).replace('.00', '')) + ' >>>> <<<< ' + roundedvalueIs);

            dataExportIs.put(String.valueOf(roundedkeyIs), valueIs);//Decimal.valueOf(string.valueOf(valueIs)));

        }

        Logger.pop();
        return dataExportIs;
    }

    /*
     * @description builds string of keys with comma separator
     */
    private static String joinKeys(Map<String, String> fields) {
        Logger.push('joinKeys','ScenarioExportUtil');
        List<String> keys = new List<String>(fields.keySet());
        Logger.pop();
        return String.join(keys, ',');
    }


    private static Map<String, Object> objectToMap(sObject sobj, Map<String, String> fields, Scenario__c sce) {

        Logger.push('objectToMap','ScenarioExportUtil');
        Map<String, Object> output = new Map<String, Object>();


        for (String key : fields.keySet()) {

            if (key != 'Client_Lead__r.Id'
                    && key != 'Client_Lead__r.DOB__c'
                    && key != 'RecordTypeId'
                    && key != 'Client_Lead__r.Name'
                    && key != 'Client_Lead__r.Firstname'
                    && key != 'Client_Lead__r.Lastname'
                    && key != 'Client_Lead__r.City'
                    && key != 'Client_Lead__r.Email'
                    && key != 'Client_Lead__r.Phone'
                    && key != 'Client_Lead__r.Street'
                    && key != 'Client_Lead__r.State'
                    && key != 'Client_Lead__r.Postalcode'


                    ) {
                output.put(fields.get(key), sobj.get(key));

            } else if (key == 'Client_Lead__r.Id') {
                output.put(fields.get(key), sce.Client_Lead__r.Id);

            } else if (key == 'Client_Lead__r.DOB__c') {
                output.put(fields.get(key), sce.Client_Lead__r.DOB__c);

            } else if (key == 'Client_Lead__r.Name') {
                output.put(fields.get(key), sce.Client_Lead__r.Name);

            } else if (key == 'Client_Lead__r.Firstname') {
                output.put(fields.get(key), sce.Client_Lead__r.Firstname);

            } else if (key == 'Client_Lead__r.Lastname') {
                output.put(fields.get(key), sce.Client_Lead__r.Lastname);

            } else if (key == 'Client_Lead__r.City') {
                output.put(fields.get(key), sce.Client_Lead__r.City);

            } else if (key == 'Client_Lead__r.Email') {
                output.put(fields.get(key), sce.Client_Lead__r.Email);

            } else if (key == 'Client_Lead__r.Phone') {
                output.put(fields.get(key), sce.Client_Lead__r.Phone);

            } else if (key == 'Client_Lead__r.Street') {
                output.put(fields.get(key), sce.Client_Lead__r.Street);

            } else if (key == 'Client_Lead__r.State') {
                output.put(fields.get(key), getStateCode(sce.Client_Lead__r.State));

            } else if (key == 'Client_Lead__r.Postalcode') {
                output.put(fields.get(key), sce.Client_Lead__r.Postalcode);

            }
        }
        Logger.pop();
        return output;
    }

    // wrapper class for loan export data
    global class scenarioWithRelatedObjects {
        public Map<String, Object> BayDocs { get; set; }//Added by Ravi
        public Map<String, Object> loanlead { get; set; }

        scenarioWithRelatedObjects() {
            BayDocs = new map<string, object>();
        }
    }

    private static final Map<String, String> SCENARIO_FIELDS = new Map<String, String>{
            'BayDocsOrderNumber__c' => 'BayDocsOrderNumber',
            'Average_Growth_Rate__c' => 'Average_Growth_Rate',
            'Cash_Flow_12_months_Amount__c' => 'Cash_Flow_12_months_Amount',
            'Cash_Flow_2_Month_Number__c' => 'Cash_Flow_2_Month_Number',
            'Cash_Flow_60_months_Amount__c' => 'Cash_Flow_60_months_Amount',
            'Cash_Flow_Remaining_Month__c' => 'Cash_Flow_Remaining_Month',
            'Cash_Flow_Remaining_months_Amount__c' => 'Cash_Flow_Remaining_months_Amount',
            'ClientId__c' => 'ClientId',
            'Current_Mortgage_Balance__c' => 'Current_Mortgage_Balance',
            'Current_Mortgage_Interest_Rate__c' => 'Current_Mortgage_Interest_Rate',
            'Date_of_birth__c' => 'Date_of_birth',
            'Estimated_home_value__c' => 'Estimated_home_value',
            'Home_Value_10_years__c' => 'Home_Value_10_years',
            'Index__c' => 'Index',
            'Initial_Growth_Rate__c' => 'Initial_Growth_Rate',
            'MIP__c' => 'MIP',
            //'Margin__c' => 'Margin',
            'Monthly_Mortgage_Payment__c' => 'Monthly_Mortgage_Payment',
            'PartnerId__c' => 'PartnerId',
            'Priority__c' => 'Priority',
            'Request_Scenario_Package_Count__c' => 'Request_Scenario_Package_Count',
            'Principal_Limit__c' => 'Principal_Limit',
            'Loan__c' => 'Loan',
            'is_Converted__c' => 'is_Converted',
            'ORMS_Number_of_Scenarios_Run__c' => 'ORMS_Number_of_Scenarios_Run',
            'Line_of_Credit__c' => 'Line_of_Credit',
            'ORM_AE__c' => 'ORM_AE',
            'Scenario_Type__c' => 'Mortgage_Type',
            'RateType__c' => 'Rate_Type',
            'EOF__c' => 'Adjustable_Desired_Origination_Origination_to_ORM',
            'Client_Lead__r.Id' => 'id',
            'Client_Lead__r.DOB__c' => 'DOB',
            'Client_Lead__r.Name' => 'Name',
            'Client_Lead__r.Firstname' => 'First Name',
            'Client_Lead__r.Lastname' => 'Last Name',
            'Client_Lead__r.City' => 'City',
            'Client_Lead__r.Email' => 'Email',
            'Client_Lead__r.Phone' => 'Phone Number',
            'Client_Lead__r.Street' => 'Street Address',
            'Client_Lead__r.State' => 'State',
            'Client_Lead__r.Postalcode' => 'ZipCode'
    };


    //Added by Ravi
    private static final Map<String, String> BAYDOC_FIELDS = new Map<String, String>{

            'UserID' => '4738',
            'XMLPassword' => 'lR7i61T74c3h0746Q8S7zC2Nt1DF1m16',
            'SubmitOrderForProcessing' => 'true',
            'WaitForPDF' => 'true',
            'LenderID' => '2364',
            //   'LoanType'                  => '103',
            'PackageType' => '430'


    };
    public static string getStateCode(String stateName) {

        Logger.push('getStateCode','ScenarioExportUtil');

        map<String, String> StateAndCode = new map<String, String>();
        for (States_And_Shortcodes__mdt eachState : [SELECT Id,developerName, MasterLabel, Language, NamespacePrefix, Label FROM States_And_Shortcodes__mdt]) {

            StateAndCode.put(eachState.MasterLabel.toLowercase(), eachState.developerName);
        }
        if (stateName != '' && stateName != null)
            return StateAndCode.get(stateName.toLowercase());

        Logger.pop();
        return '';

    }

}