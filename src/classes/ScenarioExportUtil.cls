global class ScenarioExportUtil {

    public static ScenarioWithRelatedObjects getExportForscenarioId(String scenarioId) {
 //      System.debug('Building loan export for loanId ' + scenarioId + '...'); 

         scenarioWithRelatedObjects ScenarioExport = new scenarioWithRelatedObjects(); 
         ScenarioExport.BayDocs = BAYDOC_FIELDS;

         Scenario__c loanlead1 = [select PartnerId__c,RateType__c,Estimated_home_value__c from Scenario__c WHERE Id = :scenarioId];
        user u = new user();   
        try{
        u = [select id,contact.id from user where id=:loanlead1.PartnerId__c];
        }catch(exception ex){
              u = [select id,contact.id from user limit 1];
        }
        contact cnt = new contact();
        try{    
         cnt = [select id,name, accountid,Contact_NMLS__c,Account.Name,Account.BillingPostalcode,Account.Phone,Account.BillingState,Account.Company_NMLS_ID__c,Account.BillingStreet,Office_Phone__c,Email,Account.BillingCity from contact where id=:u.contact.id];
        }catch(exception ex){
             cnt = [select id,name, accountid,Contact_NMLS__c,Account.Name,Account.BillingPostalcode,Account.Phone,Account.BillingState,Account.Company_NMLS_ID__c,Account.BillingStreet,Office_Phone__c,Email,Account.BillingCity from contact limit 1];
        }

            string Loanrate;
            if(loanlead1.RateType__c=='Adjust'){
            Loanrate='103';
            }else{
                Loanrate ='9';
            }
            ScenarioExport.BayDocs.put('LoanType',Loanrate);


       Scenario__c loanlead = Database.query('SELECT ' + joinKeys(SCENARIO_FIELDS) + ' FROM Scenario__c WHERE Id = :scenarioId');
       ScenarioExport.loanlead = objectToMap(loanlead, SCENARIO_FIELDS,loanlead );

            //       ScenarioExport.loanlead.put('LoanType_rate',loanlead1.RateType__c);
                   ScenarioExport.loanlead.put('Individual_id',cnt.id);
                   ScenarioExport.loanlead.put('Partner_id',cnt.accountid);
                   ScenarioExport.loanlead.put('Individual_Name',cnt.Name);
                   ScenarioExport.loanlead.put('Individual_Phone',cnt.Office_Phone__c);
                   ScenarioExport.loanlead.put('Individual_Email',cnt.Email);
                   ScenarioExport.loanlead.put('Contact_NMLS',cnt.Contact_NMLS__c);
                   ScenarioExport.loanlead.put('Company_NMLS',cnt.Account.Company_NMLS_ID__c);
                    ScenarioExport.loanlead.put('Partner_Name',cnt.Account.Name);
                    if(null!=cnt.Account.BillingStreet){
                    ScenarioExport.loanlead.put('Partner_Street',(cnt.Account.BillingStreet).replace('\r\n',' '));
                   }else{
                   
                        ScenarioExport.loanlead.put('Partner_Street',(cnt.Account.BillingStreet)); 
                   ScenarioExport.loanlead.put('Partner_Street',(cnt.Account.BillingStreet).replace('\r\n',' ')); 
                   }
                    ScenarioExport.loanlead.put('Partner_City',cnt.Account.BillingCity);
                    ScenarioExport.loanlead.put('Partner_State',cnt.Account.BillingState);
                    ScenarioExport.loanlead.put('Partner_ZipCode',cnt.Account.BillingPostalcode);
                    ScenarioExport.loanlead.put('Partner_Phone',cnt.Account.Phone);
                    
                     
                    
                    
                       //HUD calculation
        decimal firstValue = 0;// = (200000 * 0.02);
        decimal secondValue = 0;
        decimal i_ev = loanlead1.Estimated_home_value__c ;
        if(i_ev<=200000){
             firstValue = (i_ev * 0.02);
            
        }else{
            //if i_ev >200K
             firstValue = (200000 * 0.02);
            secondValue = ((i_ev - 200000 ) * 0.01);
            
        }
        decimal HUDis = firstValue + secondValue;
        HUDis = (HUDis > 6000)?6000:HUDis;
 
 //write metadata rate and Originaed orm fee ino JSON String
        boolean isAccPremier = [select id,Contact.AccountId,Contact.Account.Premier_Partner__c from user where id=:userinfo.getUserId()].Contact.Account.Premier_Partner__c;
         String MetaDataTableFixed = isAccPremier?'Fixed_Price_Tier2__mdt':'Fixed_Price_Tier1__mdt';
         String metadataQuery = 'SELECT Id, DeveloperName,  Origination_to_ORM__c, Rate__c FROM '+MetaDataTableFixed;      
         
 
        list<sObject>metadataResults = database.query(metadataQuery);
   map<String,decimal> dataExportIs = new map<string,decimal>();
   for(sObject eachsObject:metadataResults){
       decimal mapingValue  = (HUDis < Decimal.valueOf(String.valueOf(eachsObject.get('Origination_to_ORM__c'))))?HUDis:Decimal.valueOf(String.valueOf(eachsObject.get('Origination_to_ORM__c')));
  Decimal keyIs= Decimal.valueOf(String.valueOf(eachsObject.get('Rate__c'))).setScale(2);    
Decimal roundedkeyIs = Math.round(keyIs * 100) / 100.0;
system.debug(roundedkeyIs );
  
  Decimal valueIs= Decimal.valueOf(String.valueOf(mapingValue)).setScale(2);    
Decimal roundedvalueIs = Math.round(valueIs* 100) / 100.0;
system.debug(Decimal.valueOf(string.valueOf(valueIs).replace('.00',''))+' >>>> <<<< '+roundedvalueIs );
 
  dataExportIs.put(String.valueOf(roundedkeyIs),valueIs);//Decimal.valueOf(string.valueOf(valueIs)));
 
  //dataExportIs.put(String.valueOf(Decimal.valueOf(String.valueOf(eachsObject.get('Rate__c'))).setScale(2)),Decimal.valueOf(String.valueOf(mapingValue)).setScale(2));
   }
                ScenarioExport.loanlead.put('origFees',dataExportIs );//.getAsString().replace('\n','').replace('\"','"'));
              system.debug('ScenarioExportdataExportIs '+dataExportIs);        
              system.debug('ScenarioExport '+ScenarioExport);        
        return ScenarioExport;
    }
// builds string of keys with comma separator
    private static String joinKeys(Map<String, String> fields) {
    //    system.debug('fields  --> '+ fields);
        List<String> keys = new List<String>(fields.keySet());
      //  system.debug('keys  --> '+ keys);
        return String.join(keys, ',');
    }
    
     private static Map<String, Object> objectToMap(sObject sobj, Map<String, String> fields,Scenario__c  sce) {
        Map<String, Object> output = new Map<String, Object>();
       
     
        for (String key : fields.keySet()) {
            system.debug('key  --->'+key);
        if(key!='Client_Lead__r.Id'
        && key!='Client_Lead__r.DOB__c'
        && key!='RecordTypeId'
        && key!='Client_Lead__r.Name'
        && key!='Client_Lead__r.Firstname'
        && key!='Client_Lead__r.Lastname'
        && key!='Client_Lead__r.City'
        && key!='Client_Lead__r.Email'
        && key!='Client_Lead__r.Phone'
        && key!='Client_Lead__r.Street'
        && key!='Client_Lead__r.State'
        && key!='Client_Lead__r.Postalcode'
       
        
         ){
            output.put(fields.get(key), sobj.get(key));
                    
         }else if(key=='Client_Lead__r.Id'){
                output.put(fields.get(key),sce.Client_Lead__r.Id);
                       
         }else if( key=='Client_Lead__r.DOB__c'){
             output.put(fields.get(key),sce.Client_Lead__r.DOB__c);
              
         }else if( key=='Client_Lead__r.Name'){
             output.put(fields.get(key),sce.Client_Lead__r.Name);
              
         }else if( key=='Client_Lead__r.Firstname'){
             output.put(fields.get(key),sce.Client_Lead__r.Firstname);
               
         }
         else if( key=='Client_Lead__r.Lastname'){
             output.put(fields.get(key),sce.Client_Lead__r.Lastname);
               
         }else if( key=='Client_Lead__r.City'){
             output.put(fields.get(key),sce.Client_Lead__r.City);
               
         }else if( key=='Client_Lead__r.Email'){
             output.put(fields.get(key),sce.Client_Lead__r.Email);
              
         }else if( key=='Client_Lead__r.Phone'){
             output.put(fields.get(key),sce.Client_Lead__r.Phone);
              
         }else if( key=='Client_Lead__r.Street'){
             output.put(fields.get(key),sce.Client_Lead__r.Street);
               
         }else if( key=='Client_Lead__r.State'){
             output.put(fields.get(key),getStateCode(sce.Client_Lead__r.State));
              
         }else if( key=='Client_Lead__r.Postalcode'){
             output.put(fields.get(key),sce.Client_Lead__r.Postalcode);
       
         }
        }
        return output;
    }

    // wrapper class for loan export data
    global class scenarioWithRelatedObjects {
        public Map<String, Object> BayDocs{get; set;}//Added by Ravi
        public Map<String, Object> loanlead {get; set;}
     //   public List<Map<String, Object>> clients {get; set;}
         

        scenarioWithRelatedObjects() {
      //      Scenario = new List<Map<String, Object>>();
            BayDocs = new map<string, object>(); 
        }
    }

     private static final Map<String, String> SCENARIO_FIELDS = new Map<String, String>{
                'BayDocsOrderNumber__c'                 => 'BayDocsOrderNumber',
                'Average_Growth_Rate__c'                => 'Average_Growth_Rate',
                'Cash_Flow_12_months_Amount__c'         => 'Cash_Flow_12_months_Amount',
                'Cash_Flow_2_Month_Number__c'           => 'Cash_Flow_2_Month_Number',
                'Cash_Flow_60_months_Amount__c'         => 'Cash_Flow_60_months_Amount',
                'Cash_Flow_Remaining_Month__c'          => 'Cash_Flow_Remaining_Month',
                'Cash_Flow_Remaining_months_Amount__c'  => 'Cash_Flow_Remaining_months_Amount',
                'ClientId__c'                           => 'ClientId',
                'Current_Mortgage_Balance__c'           => 'Current_Mortgage_Balance',
                'Current_Mortgage_Interest_Rate__c'     => 'Current_Mortgage_Interest_Rate',
                'Date_of_birth__c'                      => 'Date_of_birth',
                'Estimated_home_value__c'               => 'Estimated_home_value',
                'Home_Value_10_years__c'                => 'Home_Value_10_years',
                'Index__c'                              => 'Index',
                'Initial_Growth_Rate__c'                => 'Initial_Growth_Rate',
                'MIP__c'                                => 'MIP',
                'Margin__c'                             => 'Margin',
                'Monthly_Mortgage_Payment__c'           => 'Monthly_Mortgage_Payment',
                'PartnerId__c'                          => 'PartnerId',
                'Priority__c'                           => 'Priority',
                'Request_Scenario_Package_Count__c'     => 'Request_Scenario_Package_Count',
                'Principal_Limit__c'                    => 'Principal_Limit',
                'Loan__c'                               => 'Loan',
                'is_Converted__c'                       => 'is_Converted',
                'ORMS_Number_of_Scenarios_Run__c'       => 'ORMS_Number_of_Scenarios_Run',
                'Line_of_Credit__c'                     => 'Line_of_Credit',
                'ORM_AE__c'                             => 'ORM_AE',
                'Scenario_Type__c'                      => 'Mortgage_Type',
                'RateType__c'                           => 'Rate_Type',
                'EOF__c'                                => 'Adjustable_Desired_Origination_Origination_to_ORM',
                'Client_Lead__r.Id'                     => 'id',
                'Client_Lead__r.DOB__c'                 => 'DOB',
                'Client_Lead__r.Name'                   => 'Name',
                'Client_Lead__r.Firstname'              =>'First Name',
                'Client_Lead__r.Lastname'               =>'Last Name',
                'Client_Lead__r.City'                   => 'City',
                'Client_Lead__r.Email'                  => 'Email',
                'Client_Lead__r.Phone'                  => 'Phone Number',
                'Client_Lead__r.Street'                 => 'Street Address', 
                'Client_Lead__r.State'                  => 'State',
                'Client_Lead__r.Postalcode'             => 'ZipCode'
         };



       //Added by Ravi
       private static final Map<String, String> BAYDOC_FIELDS = new Map<String, String>{
        
                    'UserID'                    => '4738',
                    'XMLPassword'               => 'lR7i61T74c3h0746Q8S7zC2Nt1DF1m16',
                    'SubmitOrderForProcessing'  => 'true',
                    'WaitForPDF'                => 'true',
                    'LenderID'                  => '2364',
                 //   'LoanType'                  => '103',
                    'PackageType'               => '430'

                    
        
     };
public static string getStateCode(String stateName){
     
  //   return stateName;
     
         map<String,String> StateAndCode =new map<String,String>();
            for(States_And_Shortcodes__mdt eachState : [SELECT Id,developerName, MasterLabel, Language, NamespacePrefix, Label FROM States_And_Shortcodes__mdt]){
    
                StateAndCode.put(eachState.MasterLabel.toLowercase(),eachState.developerName);
             }
             if(stateName!='' && stateName !=null)
            return  StateAndCode.get(stateName.toLowercase());
            
            
            
            return '';
     
     }

}