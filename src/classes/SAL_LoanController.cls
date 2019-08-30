/**
* @description  SAL_LoanController - Used to fetch metadata,data for Start New Loan, Loan tab and Save Loan subtab contents.   
* @author GalaxE 

* changelog:
* 09/06/2018: Sahitya: SFDC-237 - Fetch Helo rates, orig to orm from Metadata table
* 09/07/2018: Sahitya: Fetch Helo Margin from Metadata table
* 09/20/2018: Sahitya: SFDC-289 - Added 3rd Tier
* 09/26/2018: Sahitya: SFDC - 275 Divided Authorised states into two metadata tables based on product type
* 10/22/2018: Sahitya: SFDC - 377 Added Two new values for Tier1, 2, and 3 and made changes to fetch margin from Metadata Table
*/

public with sharing class SAL_LoanController {
    
    public static String formatphonenum (String s) {  
        string returnval='';
        if(s!=null && s!=''){
            returnval = '(' + s.substring(0, 3) + ') ' + s.substring(3, 6) + '-' + s.substring(6);            
        }
        return returnval;
    }
    
    @AuraEnabled
    public static string SaveLoan(Loan_New__c ObjLoan)
    {
        try
        {
            ObjLoan.IsActiveFlag__c=true;
            id userId = UserInfo.getUserId();
            User u = [select id, contactId,AccountId from User where id = : userId];
            List<Contact> ct = [Select AccountId,Contact_NMLS__c from Contact where id=:u.contactId];
            string Company_NMLS_ID = '';
            try{
                Company_NMLS_ID = [select Company_NMLS_ID__c from Account where Id=:ct[0].AccountId].Company_NMLS_ID__c;
            }catch(exception ex){}
            ObjLoan.Loan_Origination_Company_Identifier__c = Company_NMLS_ID;
            ObjLoan.Loan_Originator_Identifier__c = ct[0].Contact_NMLS__c;
            ObjLoan.Related_Individual__c = u.contactId;
            ObjLoan.Related_Partner__c = ct[0].AccountId;
            if(ObjLoan.Id==null)
            {
            ObjLoan.IsLoanCreatedByLoanProcessor__c=GenericController.IsLoanCreatedByLoanProcessor();  
            }
            ObjLoan.IsLoanFilled_Flag__c=true;       
            upsert ObjLoan;
            string LoanId=ObjLoan.Id;
            //SAL_ApexManagedSharingHelperController.DeleteSharedLoan(ObjLoan.Id,'Loan_New__share','Origination_Loan_Officer__c');
             //SAL_ApexManagedSharingController.ShareLoanRecord(ObjLoan.Id);
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'loan Exception','save Loan','if Else Part');
            system.debug(' SaveLoan----Exception---'+ex);
        }
        return ObjLoan.id;   
        
    }    
    
    @AuraEnabled
    public static string  getLoanOfficerLoanById(string RecordId) 
    {        string val=[select Originating_Loan_Officer__c from Loan_New__c where id=:RecordId].Originating_Loan_Officer__c;
     return val;        
    }
    
    @AuraEnabled
    public static Loan_New__c  getLoanById(string RecordId) 
    {        
        Loan_New__c objLoan = new Loan_New__c();  
        try
        {
            system.debug(' getLoanById----Exception---'+RecordId);
            //Code Added by Dev4 for ORMSFDC-1423
            objLoan   = [SELECT Subject_Property_Type__c,IsSubjectPropertyFilled_Flag__c,Is_Loan_Created_Manually__c,IsDeclarationFilled_Flag__c
                         ,IsClientFilled_Flag__c,Id,Margin__c, Loan_Origination_Fee_Calculation__c,Relationship_to_Alternative_Contact__c,Other_Relationship_Alternative_Contact__c,Mortgage_Applied_for__c,Subject_Property_Address__c, Subject_Property_City__c, Subject_Property_State__c, Subject_Property_County__c, Subject_Property_Zip_Code__c, Legal_Description_of_Property__c,Loan_Origination_Company_Identifier__c,Household_Members__c,
                         No_of_Units__c, Year_Built__c, Property_Held_as__c, Property_Title_is_Held_in_These_Names__c,Purpose_of_Loan__c,Loan_Origination_Fee__c,Estimate_of_Appraised_Value__c,This_application_was_taken_by__c,Children_Under_the_age_of_6_living_in_th__c,// Square_Footage__c,(moved to subject property)
                         Square_Footage__c,Check_If_Title_is_also_Held_As__c,Alternate_Contact_full_address__c,Alternate_Contact_Phone_number__c,Application_Date__c, Real_Estate_Taxes__c, Hazard_Insurance__c, IsActiveFlag__c,
                         Alternate_Contact_Name__c,HOA_Monthly_Dues__c,Rate_Type__c,Rate__c,Credit_to_Borrower__c,Selected_Loan_Payment_Plan__c,
                         Monthly_PUD_Fees_Amount__c,Monthly_Ground_Rents_Amount__c,Monthly_Flood_Insurance_Premium__c,Condominium_FHA_Approved__c,Condominium_Name__c,
                         Present_Market_Value__c,Mortgage_and_Liens__c,Name_of_Company__c,Account_Number__c,Gross_Rental_Income__c,Monthly_Mortgage_Payment__c,
                         Net_Rental_Income__c, Purchase_Price__c,Earnest_Money_Deposit__c,Contract_Date__c,Contract_Closing_Date__c,Status_Of_Current_Address__c,
                         Source_Of_Funds__c,Sale_Date__c,Sale_Proceeds__c,Assets_Amount__c,Gift_Amount__c,Other_Source_Of_Funds__c,Amount_Of_Other_Funds__c,
                         Originating_Loan_Officer__c, Product_Type__c, Loan_Payment_Plan_Term__c, Solar_Panels_Exist__c, Solar_Panels_Paid_Off__c
                         //End
                         FROM Loan_New__c where Id=: RecordId];
            //Code Ended by Dev4 for ORMSFDC-1423
        }
        catch(Exception ex)
        {
            system.debug(' getLoanById----Exception---'+ex);
        }
        return objLoan;
    }
    
    //Fetch Subject Proprty based on Loan Id  
    @AuraEnabled
    public static Loan_New__c  getSubjectPropertyByLoanId(string RecordId) 
    {        
        Loan_New__c objLoan = new Loan_New__c(); 
        try
        {
            //Code Added by Dev4 for ORMSFDC-1423
            objLoan = [SELECT Subject_Property_Type__c,IsSubjectPropertyFilled_Flag__c,Is_Loan_Created_Manually__c,IsDeclarationFilled_Flag__c
                       ,IsClientFilled_Flag__c,Id,Margin__c, Loan_Origination_Fee_Calculation__c,Subject_Property_Address__c, Subject_Property_City__c,
                       Subject_Property_State__c, Subject_Property_County__c, Subject_Property_Zip_Code__c, Legal_Description_of_Property__c,
                       No_of_Units__c, Year_Built__c,Square_Footage__c, Property_Held_as__c, Property_Title_is_Held_in_These_Names__c,
                       Check_If_Title_is_also_Held_As__c, Real_Estate_Taxes__c, Hazard_Insurance__c, IsActiveFlag__c,HOA_Monthly_Dues__c,
                       Monthly_PUD_Fees_Amount__c,Monthly_Ground_Rents_Amount__c,Monthly_Flood_Insurance_Premium__c,Condominium_FHA_Approved__c,Condominium_Name__c,
                       Present_Market_Value__c,Mortgage_and_Liens__c,Name_of_Company__c,Account_Number__c,Gross_Rental_Income__c,Monthly_Mortgage_Payment__c,Rate_Type__c
                       ,Net_Rental_Income__c,Originating_Loan_Officer__c, Product_Type__c,Mortgage_Applied_for__c //SFDC - 275
                       FROM Loan_New__c  where Id=: RecordId];
            //Code Ended by Dev4 for ORMSFDC-1423
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'Populate SubjectProperty','date:'+System.today(),'UpdateSubjectProperty');
            system.debug(' getSubjectPropertyByLoanId----Exception---'+ex);
        }
        return objLoan;
    }
    
    //Save(Insert/Update) Subject Property
    @AuraEnabled
    public static string UpdateSubjectProperty(Loan_New__c ObjLoan,string LoanId)
    {
        Loan_New__c obj=new Loan_New__c();
        
        try
        {
            obj.Id=LoanId;
            obj.Subject_Property_Address__c=ObjLoan.Subject_Property_Address__c;
            obj.Subject_Property_City__c=ObjLoan.Subject_Property_City__c;
            obj.Subject_Property_State__c=ObjLoan.Subject_Property_State__c;
            obj.Subject_Property_County__c=objLoan.Subject_Property_County__c;
            obj.IsSubjectPropertyFilled_Flag__c=true;
            obj.Subject_Property_Zip_Code__c=ObjLoan.Subject_Property_Zip_Code__c;
            obj.Legal_Description_of_Property__c=ObjLoan.Legal_Description_of_Property__c;
            obj.No_of_Units__c=ObjLoan.No_of_Units__c;  
            obj.Year_Built__c=String.valueOf(ObjLoan.Year_Built__c); 
            obj.Square_Footage__c = ObjLoan.Square_Footage__c;//moved from loan to subject property
            obj.Property_Held_as__c=ObjLoan.Property_Held_as__c;
            obj.Property_Title_is_Held_in_These_Names__c=ObjLoan.Property_Title_is_Held_in_These_Names__c;
            obj.Check_If_Title_is_also_Held_As__c=ObjLoan.Check_If_Title_is_also_Held_As__c;
            obj.Real_Estate_Taxes__c=ObjLoan.Real_Estate_Taxes__c;
            obj.Hazard_Insurance__c=ObjLoan.Hazard_Insurance__c;
            
            //Code Added by Dev4 for ORMSFDC-1423
            obj.HOA_Monthly_Dues__c=ObjLoan.HOA_Monthly_Dues__c;
            obj.Monthly_PUD_Fees_Amount__c=ObjLoan.Monthly_PUD_Fees_Amount__c;
            obj.Monthly_Ground_Rents_Amount__c=ObjLoan.Monthly_Ground_Rents_Amount__c;
            obj.Monthly_Flood_Insurance_Premium__c=ObjLoan.Monthly_Flood_Insurance_Premium__c;
            //Code Ended by Dev4 for ORMSFDC-1423
            obj.Present_Market_Value__c=ObjLoan.Present_Market_Value__c;
            obj.Mortgage_and_Liens__c=ObjLoan.Mortgage_and_Liens__c;
            obj.Name_of_Company__c=ObjLoan.Name_of_Company__c;
            obj.Account_Number__c=ObjLoan.Account_Number__c;
            obj.Gross_Rental_Income__c=ObjLoan.Gross_Rental_Income__c;
            obj.Monthly_Mortgage_Payment__c=ObjLoan.Monthly_Mortgage_Payment__c;
            obj.Net_Rental_Income__c=ObjLoan.Net_Rental_Income__c;
            obj.Subject_Property_Type__c=ObjLoan.Subject_Property_Type__c;
            obj.Solar_Panels_Exist__c=ObjLoan.Solar_Panels_Exist__c;            
            obj.Solar_Panels_Paid_Off__c=ObjLoan.Solar_Panels_Paid_Off__c;
            if(ObjLoan.Subject_Property_Type__c=='Condominium')
            {
                obj.Condominium_FHA_Approved__c=ObjLoan.Condominium_FHA_Approved__c;
                obj.Condominium_Name__c=objLoan.Condominium_Name__c;
            }
            else
            {
                obj.Condominium_FHA_Approved__c='';
                obj.Condominium_Name__c='';
            }
            
            // Inserting Originating  Loan Officer from Subject Property if profile is Loan Processor.
            // Code By DEV-2
            Boolean IsLoanCreatedByLoanPro=GenericController.IsLoanCreatedByLoanProcessor();
            if(IsLoanCreatedByLoanPro==true)
            {
                if(ObjLoan.Originating_Loan_Officer__c !=null)
                {
                   //obj.LoanOfficer__c=ObjLoan.Originating_Loan_Officer__c;                
                    obj.Originating_Loan_Officer__c=ObjLoan.Originating_Loan_Officer__c;
                }
            }
            //obj.OwnerId='005m0000002dh6OAAQ'        ;
            upsert obj;
            
            UpdateLiability(ObjLoan,LoanId);        // do not delete // story no 1398
            checkAndUpdateLiabilityClient(LoanId);
        }
        catch(Exception ex)
        {
            
            Exception_log.Create_Custom_Logs(ex.getMessage(),'UpdateSubjectProperty','date:'+System.today(),'Exception');
        }
        return obj.Id;
    }

    @AuraEnabled
    public static void UpdateLiability(Loan_New__c ObjLoan,string LoanId)
    {
        try
        {
            Liability__c objLiability=new Liability__c();
            List<Liability__c> objLiability1=new List<Liability__c>(); 
            objLiability.Liability_Category__c='Real Estate Schedule';
            objLiability.Liability_Type__c='Property';
            objLiability.Property_Address__c=ObjLoan.Subject_Property_Address__c;
            objLiability.Property_Address2__c='';
            objLiability.Property_City__c=ObjLoan.Subject_Property_City__c;
            objLiability.Property_States__c=ObjLoan.Subject_Property_State__c;
            objLiability.Property_County__c=ObjLoan.Subject_Property_County__c;
            objLiability.Property_ZIP__c=ObjLoan.Subject_Property_Zip_Code__c;
            objLiability.Legal_Description_of_Property__c=ObjLoan.Legal_Description_of_Property__c;
            objLiability.Present_Mortgage_Value__c=ObjLoan.Present_Market_Value__c;
            objLiability.Mortgage_Liens__c=ObjLoan.Mortgage_and_Liens__c;
            objLiability.Name_of_Company__c=ObjLoan.Name_of_Company__c;
            objLiability.Account_Number__c=ObjLoan.Account_Number__c;
            objLiability.Gross_Rental_Income__c=ObjLoan.Gross_Rental_Income__c;
            objLiability.Mortgage_Payments__c=ObjLoan.Monthly_Mortgage_Payment__c;
            objLiability.Real_Estate_Taxes_Monthly__c=ObjLoan.Real_Estate_Taxes__c;
            objLiability.Annual_Hazard_Insurance__c=ObjLoan.Hazard_Insurance__c;
            objLiability.HOA_Monthly_Dues__c=ObjLoan.HOA_Monthly_Dues__c;
            objLiability.Monthly_PUD_Fees_Amount__c=ObjLoan.Monthly_PUD_Fees_Amount__c;
            objLiability.Monthly_Ground_Rents_Amount__c=ObjLoan.Monthly_Ground_Rents_Amount__c;
            objLiability.Monthly_Flood_Insurance_Premium__c=ObjLoan.Monthly_Flood_Insurance_Premium__c;
            objLiability.Net_Rental_Income_RealEstate__c=ObjLoan.Net_Rental_Income__c;
            objLiability.Property_Type__c=ObjLoan.Subject_Property_Type__c;
            objLiability.Year_Built__c=  string.valueOf(ObjLoan.Year_Built__c);
            objLiability.Square_Footage__c=ObjLoan.Square_Footage__c;
            objLiability.Property_Held_as__c=ObjLoan.Property_Held_as__c;
            objLiability.Property_Title_is_Held_in_These_Names__c=ObjLoan.Property_Title_is_Held_in_These_Names__c;
            objLiability.Check_If_Title_is_also_Held_As__c=ObjLoan.Check_If_Title_is_also_Held_As__c;
            objLiability.Property_Status__c='Subject Property';
            objLiability.Liability_will_be_closed_by_Paying_RES__c=true;
            objLiability.RelatedLoan__c=LoanId;
            objLiability.Is_Liability_Validated__c=true;
            
            
            objLiability1=[SELECT Id FROM Liability__c  
                           
                           where RelatedLoan__c=:LoanId and Liability_Category__c='Real Estate Schedule'
                           and Property_Status__c='Subject Property'
                           and isActive__c = true limit 1];
            if(!objLiability1.isEmpty())
            {
                objLiability.Id=objLiability1[0].Id;
                update objLiability;
            }
            else
            {
                insert objLiability;
            }
        }
        catch(exception ex){
            Exception_log.Create_Custom_Logs(ex.getMessage(),'liability','date:'+System.today(),'UpdateLiability');
        }
    }

    public static void checkAndUpdateLiabilityClient(string LoanId)
    {
        Loan_New__c objLoan = new Loan_New__c();
        objLoan=[select Is_Loan_Created_Manually__c from Loan_New__c where Id=: LoanID and IsActiveFlag__c=true];
        if(objLoan.Is_Loan_Created_Manually__c==false)
        {
            Client__c objClient = new Client__c();   
            objClient = [SELECT Id FROM Client__c 
                         WHERE LoanId__c =: LoanId  AND Primary_Client_for_the_Loan__c = true and is_Active__c=:true];
            Liability__c objLiability=new Liability__c();
            objLiability=[SELECT Id FROM Liability__c where RelatedLoan__c=:LoanId and 
                          Liability_Category__c='Real Estate Schedule' and Property_Status__c='Subject Property'
                          and isActive__c = true limit 1]; 
            objLiability.RelatedClient__c=objClient.Id;
            update objLiability; 
            
        }
    }
    @AuraEnabled
    public static string getLoanName(string LoanID)
    {
        Loan_New__c objLoan = new Loan_New__c();  
        try
        {
            objLoan = [SELECT Name FROM Loan_New__c  where Id=: LoanID];
        }
        catch(Exception ex)
        {
            system.debug(' getLoanName----Exception---'+ex);
        }        
        return objLoan.Name;        
    }
    
    @AuraEnabled
    public static Loan_New__c  TabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);            
        }
        catch(Exception ex)
        {
            system.debug(' TabsValidatedData----Exception---'+ex);
        }
        return objLoan;
    }
    @AuraEnabled
    public static List<string>  getZipData(string ZIP) 
    {
        List<string> ob=new  List<string>();
        ob= zipCodeLookup.lookup(ZIP);
        system.debug(ob);
        return ob;
    }
    @AuraEnabled
    public static StateLisenceResponse getStateName(String StateName,String LoanOfficerId)
    {       
        StateLisenceResponse objFc=new StateLisenceResponse();        
        //Code by DEV2 for Story-1661       
        id Userid;        
        Userid=LoanOfficerId!=null?LoanOfficerId:UserInfo.getUserId();      
        try
        {
            Id Branch_RecortypeId = Schema.SObjectType.License__c.getRecordTypeInfosByName().get('Branch Licenses').getRecordTypeId();
            Id Individual_RecortypeId = Schema.SObjectType.License__c.getRecordTypeInfosByName().get('Individual Licenses').getRecordTypeId();
            Id Partner_RecortypeId = Schema.SObjectType.License__c.getRecordTypeInfosByName().get('Partner Licenses').getRecordTypeId();
            id ContactID = [select contactid from user where id=:Userid].contactid;
            ID AccoutnID=[select AccountId from user where id=:Userid].accountid;
            String InstitutionType = [SELECT Type_of_Institution__c  FROM Account  where 
                                      Id =:AccoutnID ].Type_of_Institution__c;
            objFc.IsLicenseValidated=false;
            objFc.ErrorMessage='You are not licensed to apply for a loan in this state. Please contact your Account Executive for more information.';
            if(InstitutionType=='Federal charter')
            {
                objFc.IsLicenseValidated=true;
                objFc.ErrorMessage='All Validated';                
            }
            //Not federal
            else 
            {
                //Check for branch 
                List<License__c>  BranchStateName=[select State__c from License__c where Related_Account__c=:AccoutnID 
                                                   and recordtypeid=:Branch_RecortypeId and State__c=:StateName];
                if(!BranchStateName.isEmpty())
                {
                    //chk for individual
                    List<License__c> IndividualStateName=[select State__c from License__c where Related_Account__c=:AccoutnID and 
                                                          recordtypeid=:Individual_RecortypeId and related_contact__c=:ContactID 
                                                          and State__c=:StateName];
                    if(!IndividualStateName.isEmpty() )
                    {
                        objFc.IsLicenseValidated=true;
                        objFc.ErrorMessage='All Validated'; 
                        
                    }
                }
                else
                {
                    List<License__c> PartnerStateName=[select State__c from License__c where Related_Account__c=:AccoutnID 
                                                       and recordtypeid=:Partner_RecortypeId   and State__c=:StateName]; 
                    if(!PartnerStateName.isEmpty())
                    {
                        //chk for individual
                        List<License__c> IndividualStateName=[select State__c from License__c where Related_Account__c=:AccoutnID and 
                                                              recordtypeid=:Individual_RecortypeId and related_contact__c=:ContactID 
                                                              and State__c=:StateName];
                        if(!IndividualStateName.isEmpty() )
                        {
                            objFc.IsLicenseValidated=true;
                            objFc.ErrorMessage='All Validated';                                    
                        }
                        
                    }
                    
                }
            }
            
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'SAL_LoanController','getStateName','TestData');
        }        
        return objFc;        
    }


    //SFDC - 275 start
    @AuraEnabled
    public static list<AuthorisedStates__mdt> getStates(){        
        return [Select MasterLabel from AuthorisedStates__mdt where isActive__c=:true and isRefinance__c=:true];        
    }    

    @AuraEnabled
    public static list<AuthorisedStates__mdt> getStatesPur(){        
        return [Select MasterLabel from AuthorisedStates__mdt where isActive__c=:true and isPurchase__c=:true];        
    }

    @AuraEnabled
    public static list<Hecm_FixedState__mdt> get_HecmFixedStates(){        
        return [Select MasterLabel from Hecm_FixedState__mdt where isActive__c=:true and isRefinance__c=:true];        
    }

    @AuraEnabled
    public static list<Hecm_FixedState__mdt> get_HecmFixedStates_Pur(){        
        return [Select MasterLabel from Hecm_FixedState__mdt where isActive__c=:true and isPurchase__c=:true];        
    }
    
    @AuraEnabled
    public static list<HeloState__mdt> get_heloStatesPur() {
        return [Select MasterLabel from HeloState__mdt where isActive__c=:true and isPurchase__c=:true];                
    }

    @AuraEnabled
    public static list<HeloState__mdt> get_heloStatesRefi() {
        return [Select MasterLabel from HeloState__mdt where isActive__c=:true and isRefinance__c=:true];                
    }

    @AuraEnabled
    public static list<HeloArmState__mdt> get_heloArmStatesRefi() {
        system.debug('@@@test');
        return [Select MasterLabel from HeloArmState__mdt where isActive__c=:true and isRefinance__c=:true];      

    }

    @AuraEnabled
    public static list<HeloArmState__mdt> get_heloArmStatesPur() {
        return [Select MasterLabel from HeloArmState__mdt where isActive__c=:true and isPurchase__c=:true];                
    }
    //SFDC - 275 end

    
    @AuraEnabled
    public static list<string>getRateFixProduct()
    {
        List<string>FinaRateList=new List<string>();        
        String partnerType;
        try{
            id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
            //SFDC-289
            partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c;                        
            if(partnerType == 'Premier'){
                FinaRateList= getRateFixedPriceTier2();
            }
            else if(partnerType == 'Non Premier'){
                FinaRateList= getRateFixedPriceTier1();
            }  
            else if(partnerType == 'Premier Plus'){
                FinaRateList= getRateFixedPriceTier3();
            }      
        } 
        catch(Exception ex)
        {
            system.debug('getRateFixProduct .....'+ ex.getMessage());
        }
        return FinaRateList;        
    }
    
    //SFDC-237
    @AuraEnabled
    public static list<string>getHeloRate()
    {
        List<string>HeloRateList=new List<string>();
        String partnerType;
        try{
            Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
            //SFDC-289
            partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
            if(partnerType == 'Premier'){
                HeloRateList= getHeloRateTier2();
            }
            else if(partnerType == 'Non Premier'){
                HeloRateList= getHeloRateTier1();
            }  
            else if(partnerType == 'Premier Plus'){
                HeloRateList= getHeloRateTier3();
            }    
        } 
        catch(Exception ex)
        {
            system.debug('getRateFixProduct .....'+ ex.getMessage());
        }
        return HeloRateList;        
    }


    @AuraEnabled
    public static list<string>getHeloArmRate()
    {
        List<string>HeloArmRateList=new List<string>();
        String partnerType;
        system.debug('getHeloArmRate-->');
            Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
            //SFDC-289
            partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
            if(partnerType == 'Premier'){
                HeloArmRateList= getHeloArmRateTier2(); 
            }
            else if(partnerType == 'Non Premier'){
                HeloArmRateList= getHeloArmRateTier1();
            }  
            else if(partnerType == 'Premier Plus'){
                HeloArmRateList= getHeloArmRateTier3();
            } 
            system.debug('HeloArmRateList-->'+HeloArmRateList);
        return HeloArmRateList;        
    }
    
    //SFDC-377
    @AuraEnabled
    public static list<string>getARMRate()
    {
        List<string>ArmRateList=new List<string>();
        String partnerType;
        try{
            Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
            //SFDC-289
            partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
            if(partnerType == 'Premier'){
                ArmRateList= getArmRateTier2();
            }
            else if(partnerType == 'Non Premier'){
                ArmRateList= getArmRateTier1();
            }  
            else if(partnerType == 'Premier Plus'){
                ArmRateList= getArmRateTier3();
            }    
        } 
        catch(Exception ex)
        {
            system.debug('getArmFixProduct .....'+ ex.getMessage());
        }
        return ArmRateList;        
    }

    @AuraEnabled
    public static string getOrigination(string rate)
    {
        decimal ratevalue=decimal.valueOf(rate);
        string FinaOrigination;
        String partnerType;
        try{
            Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
            //SFDC-289
            partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
            if(partnerType == 'Premier'){
                FinaOrigination= getORMOriginationT2(ratevalue);
            }
            else if(partnerType == 'Non Premier'){
                FinaOrigination= getORMOriginationT1(ratevalue);
            }  
            else if(partnerType == 'Premier Plus'){
                FinaOrigination= getORMOriginationT3(ratevalue);
            }                
        } 
        catch(Exception ex)
        {
            system.debug('getOrigination .....'+ ex.getMessage());
        }
        return FinaOrigination;
        
    }

    //SFDC-237
    @AuraEnabled
    public static string getHeloOrigination(string rate)
    {
        decimal ratevalue=decimal.valueOf(rate);
        string HeloOrigination;
        try{
           HeloOrigination= getHeloOrigination(ratevalue);            
        } 
        catch(Exception ex)
        {
            system.debug('getOrigination .....'+ ex.getMessage());
        }
        return HeloOrigination;        
    }

    @AuraEnabled
    public static string getHeloArmOrigination(string rate)
    {
        decimal ratevalue=decimal.valueOf(rate);
        string HeloArmOrigination;
        try{
           HeloArmOrigination= getHeloArmOrigination(ratevalue);            
        } 
        catch(Exception ex)
        {
            system.debug('getOrigination .....'+ ex.getMessage());
        }
        return HeloArmOrigination;        
    }
    
    //fetch helo margin
    @AuraEnabled
    public static string getHeloMargin(string rate)
    {
        decimal ratevalue=decimal.valueOf(rate);
        string HeloMargin;        
        HeloMargin= getHeloMargin(ratevalue);   
        return HeloMargin;        
    }

    //fetch helo Arm margin
    @AuraEnabled
    public static string getHeloArmMargin(string rate)
    {
        system.debug('HeloArmMargin----->'+rate);
        decimal ratevalue=decimal.valueOf(rate);
        string HeloArmMargin;
        HeloArmMargin= getHeloArmMargin(ratevalue);  
        system.debug('HeloArmMargin----->'+HeloArmMargin);
        return HeloArmMargin;        
    }


    @AuraEnabled
    public static string getBorrower(string rate)
    {
        decimal ratevalue=decimal.valueOf(rate);
        string FinaBorrower;
        String partnerType;
        try{
            Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
            //SFDC-289
            partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
            if(partnerType == 'Premier'){
                FinaBorrower= getORMBorrowerT2(ratevalue);
            }
            else if(partnerType == 'Non Premier'){
                FinaBorrower= getORMBorrowerT1(ratevalue);
            }  
            else if(partnerType == 'Premier Plus'){
                FinaBorrower= getORMBorrowerT3(ratevalue);
            }    
        } 
        catch(Exception ex)
        {
            system.debug('getBorrower .....'+ ex.getMessage());
        }
        return FinaBorrower;
    }
    
    public static list<string>getRateFixedPriceTier1()
    {
        List<string> allrate=new List<string>();
        list<Fixed_Price_Tier1__mdt> lstPriceT1=new list<Fixed_Price_Tier1__mdt>();
        lstPriceT1=[Select  Rate__c from Fixed_Price_Tier1__mdt order by Rate__c ];
        for(Fixed_Price_Tier1__mdt rt:lstPriceT1)
        {
            string value= string.valueOf( rt.Rate__c);
            allrate.add(value);
        }
        return allrate;
    }
    
    public static list<string>getRateFixedPriceTier2()
    {
        List<string>allrate=new List<string>();
        list<Fixed_Price_Tier2__mdt> lstPriceT2=new list<Fixed_Price_Tier2__mdt>();
        lstPriceT2=[Select  Rate__c from Fixed_Price_Tier2__mdt order by Rate__c ];
        for(Fixed_Price_Tier2__mdt rt:lstPriceT2)
        {
            
            string value= string.valueOf( rt.Rate__c);
            allrate.add(value);
        }
        return allrate;
    }

    //SFDC-289
    public static list<string>getRateFixedPriceTier3()
    {
        List<string>allrate=new List<string>();
        list<Fixed_Price_Tier3__mdt> lstPriceT3=new list<Fixed_Price_Tier3__mdt>();
        lstPriceT3=[Select  Rate__c from Fixed_Price_Tier3__mdt order by Rate__c ];
        for(Fixed_Price_Tier3__mdt rt:lstPriceT3)
        {            
            string value= string.valueOf( rt.Rate__c);
            allrate.add(value);
        }
        return allrate;
    }
    
    //SFDC-237
    public static list<string>getHeloRateTier1()
    {
        List<string> allrate=new List<string>();
        list<Proprietary_Tier_1__mdt> lstPriceT1=new list<Proprietary_Tier_1__mdt>();
        lstPriceT1=[Select  Rate__c from Proprietary_Tier_1__mdt order by Rate__c ];
        for(Proprietary_Tier_1__mdt rt:lstPriceT1)
        {
            string value= string.valueOf( rt.Rate__c);
            allrate.add(value);
        }
        return allrate;
    }
    
    //SFDC-237
    public static list<string>getHeloRateTier2()
    {
        List<string>allrate=new List<string>();
        list<Proprietary_Tier_2__mdt> lstPriceT2=new list<Proprietary_Tier_2__mdt>();
        lstPriceT2=[Select  Rate__c from Proprietary_Tier_2__mdt order by Rate__c ];
        for(Proprietary_Tier_2__mdt rt:lstPriceT2)
        {
            
            string value= string.valueOf( rt.Rate__c);
            allrate.add(value);
        }
        return allrate;
    }

    //SFDC-289
    public static list<string>getHeloRateTier3()
    {
        List<string>allrate=new List<string>();
        list<Proprietary_Tier_3__mdt> lstPriceT2=new list<Proprietary_Tier_3__mdt>();
        lstPriceT2=[Select  Rate__c from Proprietary_Tier_3__mdt order by Rate__c ];
        for(Proprietary_Tier_3__mdt rt:lstPriceT2)
        {
            
            string value= string.valueOf( rt.Rate__c);
            allrate.add(value);
        }
        return allrate; 
    }

    public static list<string>getHeloArmRateTier1()
    {
        List<string> allrate=new List<string>();
        list<HELO_ARM_1__mdt> lstPriceT1=new list<HELO_ARM_1__mdt>();
        lstPriceT1=[Select  HeloArmMargin__c from HELO_ARM_1__mdt order by HeloArmMargin__c ];
        for(HELO_ARM_1__mdt rt:lstPriceT1)
        {
            string value= string.valueOf( rt.HeloArmMargin__c);
            allrate.add(value);
        }
        return allrate;
    }
    
    //SFDC-237
    public static list<string>getHeloArmRateTier2()
    {
        List<string>allrate=new List<string>();
        list<HELO_ARM_2__mdt> lstPriceT2=new list<HELO_ARM_2__mdt>();
        lstPriceT2=[Select  HeloArmMargin__c from HELO_ARM_2__mdt order by HeloArmMargin__c ];
        for(HELO_ARM_2__mdt rt:lstPriceT2)
        {            
            string value= string.valueOf( rt.HeloArmMargin__c);
            allrate.add(value);
        }
        return allrate;
    }

    //SFDC-289
    public static list<string>getHeloArmRateTier3()
    {
        List<string>allrate=new List<string>();
        list<HELO_ARM_3__mdt> lstPriceT2=new list<HELO_ARM_3__mdt>();
        lstPriceT2=[Select  HeloArmMargin__c from HELO_ARM_3__mdt order by HeloArmMargin__c ];
        for(HELO_ARM_3__mdt rt:lstPriceT2)
        {            
            string value= string.valueOf( rt.HeloArmMargin__c);
            allrate.add(value);
        }
        return allrate;
    }

     //SFDC-377
    public static list<string>getArmRateTier1()
    {
        List<string> allrate=new List<string>();
        list<Tier1__mdt> lstPriceT1=new list<Tier1__mdt>();
        lstPriceT1=[Select  Margin__c from Tier1__mdt order by Margin__c ];
        for(Tier1__mdt rt:lstPriceT1)
        {
            string value= string.valueOf( rt.Margin__c);
            allrate.add(value);
        }
        return allrate;
    }
    
    public static list<string>getArmRateTier2()
    {
        List<string> allrate=new List<string>();
        list<Tier2__mdt> lstPriceT1=new list<Tier2__mdt>();
        lstPriceT1=[Select  Margin__c from Tier2__mdt order by Margin__c ];
        for(Tier2__mdt rt:lstPriceT1)
        {
            string value= string.valueOf( rt.Margin__c);
            allrate.add(value);
        }
        return allrate;
    }
    
    public static list<string>getArmRateTier3()
    {
        List<string> allrate=new List<string>();
        list<Tier3__mdt> lstPriceT1=new list<Tier3__mdt>();
        lstPriceT1=[Select  Margin__c from Tier3__mdt order by Margin__c ];
        for(Tier3__mdt rt:lstPriceT1)
        {
            string value= string.valueOf( rt.Margin__c);
            allrate.add(value);
        }
        return allrate;
    }
    //end SFDC-377
    
    public static string getORMOriginationT1(decimal Rate)
    {
        string origtoorm;
        decimal Orignation;
        Orignation=[Select Origination_to_ORM__c from Fixed_Price_Tier1__mdt where Rate__c=:Rate].Origination_to_ORM__c;
        origtoorm=string.valueOf( Orignation);
        return origtoorm;
    }    
    
    public static string  getORMOriginationT2(decimal Rate)
    {
        string origtoorm;
        decimal Orignation;
        Orignation=[Select Origination_to_ORM__c from Fixed_Price_Tier2__mdt where Rate__c=:Rate].Origination_to_ORM__c;
        origtoorm=string.valueOf( Orignation);
        return origtoorm;
    }

    //SFDC-289
    public static string  getORMOriginationT3(decimal Rate)
    {
        string origtoorm;
        decimal Orignation;
        Orignation=[Select Origination_to_ORM__c from Fixed_Price_Tier3__mdt where Rate__c=:Rate].Origination_to_ORM__c;
        origtoorm=string.valueOf( Orignation);
        return origtoorm;
    }
    
    //SFDC-237
    public static string getHeloOrigination(decimal Rate)
    {
        string origtoorm;
        decimal Orignation;
        String partnerType;       
        Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
        //SFDC-289
        partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
        if(partnerType == 'Premier'){
            Orignation=[Select Origination_to_Partner__c from Proprietary_Tier_2__mdt where Rate__c=:Rate].Origination_to_Partner__c;
        }
        else if(partnerType == 'Non Premier'){
            Orignation=[Select Origination_to_Partner__c from Proprietary_Tier_1__mdt where Rate__c=:Rate].Origination_to_Partner__c;
        }  
        else if(partnerType == 'Premier Plus'){
            Orignation=[Select Origination_to_Partner__c from Proprietary_Tier_3__mdt where Rate__c=:Rate].Origination_to_Partner__c;
        }   
        origtoorm=string.valueOf( Orignation);
        return origtoorm;
    }

    //HELO Arm origination
    public static string getHeloArmOrigination(decimal Rate)
    {
        string origtoorm;
        decimal Orignation;
        String partnerType;       
        Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
        //SFDC-289
        partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
        if(partnerType == 'Premier'){
            Orignation=[Select HELO_Origination_to_partner__c from HELO_ARM_2__mdt where HELO_Rate__c=:Rate].HELO_Origination_to_partner__c;
        }
        else if(partnerType == 'Non Premier'){
            Orignation=[Select HELO_Origination_to_partner__c from HELO_ARM_1__mdt where HELO_Rate__c=:Rate].HELO_Origination_to_partner__c;
        }  
        else if(partnerType == 'Premier Plus'){
            Orignation=[Select HELO_Origination_to_partner__c from HELO_ARM_3__mdt where HELO_Rate__c=:Rate].HELO_Origination_to_partner__c;
        }   
        origtoorm=string.valueOf( Orignation);
        return origtoorm; 
    }
    
    //Fetch Helo Margin
    public static string getHeloMargin(decimal Rate)
    {
        string heloMargin;
        decimal margin;
        String partnerType;       
        Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
        //SFDC-289
        partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
        if(partnerType == 'Premier'){
            margin=[Select Helomargin__c from Proprietary_Tier_2__mdt where Rate__c=:Rate].HeloMargin__c;
        }
        else if(partnerType == 'Non Premier'){
            margin=[Select Helomargin__c from Proprietary_Tier_1__mdt where Rate__c=:Rate].HeloMargin__c;
        }  
        else if(partnerType == 'Premier Plus'){
            margin=[Select Helomargin__c from Proprietary_Tier_3__mdt where Rate__c=:Rate].HeloMargin__c;
        }   
        heloMargin=string.valueOf(margin);
        return heloMargin;
    }

    //Fetch Helo Arm Margin
    public static string getHeloArmMargin(decimal Rate)
    {
        string heloArmMargin;
        decimal margin;
        String partnerType;       
        Id accountID=[select accountId from User where id=:UserInfo.getUserId()].accountId;
        //SFDC-289
        partnerType = [select Partner_Type__c from account where id=:accountID].Partner_Type__c; 
        if(partnerType == 'Premier'){
            margin=[Select HeloArmMargin__c from HELO_ARM_2__mdt where HELO_Rate__c=:Rate].HeloArmMargin__c;
        }
        else if(partnerType == 'Non Premier'){
            margin=[Select HeloArmMargin__c from HELO_ARM_1__mdt where HELO_Rate__c=:Rate].HeloArmMargin__c;
        }  
        else if(partnerType == 'Premier Plus'){
            margin=[Select HeloArmMargin__c from HELO_ARM_3__mdt where HELO_Rate__c=:Rate].HeloArmMargin__c;
        }   
        heloArmMargin=string.valueOf(margin);
        return heloArmMargin;
    }
    
    public static string getORMBorrowerT1(decimal Rate)
    {
        string origtoorm;
        decimal Orignation;
        Orignation=[Select Credit_to_Borrower__c from Fixed_Price_Tier1__mdt where Rate__c=:Rate].Credit_to_Borrower__c;
        origtoorm=string.valueOf( Orignation);
        return origtoorm;
    }
    
    
    public static string  getORMBorrowerT2(decimal Rate)
    {
        string origtoorm;
        decimal Orignation;
        Orignation=[Select Credit_to_Borrower__c from Fixed_Price_Tier2__mdt where Rate__c=:Rate].Credit_to_Borrower__c;
        origtoorm=string.valueOf( Orignation);
        return origtoorm;
    }

    //SFDC-289
    public static string  getORMBorrowerT3(decimal Rate)
    {
        string origtoorm;
        decimal Orignation;
        Orignation=[Select Credit_to_Borrower__c from Fixed_Price_Tier3__mdt where Rate__c=:Rate].Credit_to_Borrower__c;
        origtoorm=string.valueOf( Orignation);
        return origtoorm;
    }


    @AuraEnabled
    public static List<LoanOfficerResponse>  getLoanOfficerList() {
        List<LoanOfficerResponse> ListLoanOfficer = New List<LoanOfficerResponse>();
        ListLoanOfficer=GenericController.getLoanOfficer();
        return ListLoanOfficer;
    }
    
    @AuraEnabled
    public static boolean  IsLoanCreatedByLoanProcessor(id RecordId)
    {
        boolean Allvalidation=false;
        Boolean LoanCreatedByLoanProcessor=false;
        Boolean IscurrentUserIsLoanProcessor=false;
        try
        {
            LoanCreatedByLoanProcessor=[select IsLoanCreatedByLoanProcessor__c from Loan_new__c where id=:RecordId].IsLoanCreatedByLoanProcessor__c;       
            string profileId=[SELECT ProfileID from User where id = : userinfo.getUserId()].ProfileID;
            if(profileId !='' || profileId !=null)
            {
                string ProfileName=[SELECT Name FROM Profile where id= :profileId].Name;
                if(ProfileName=='Portal Loan Processor' || ProfileName=='Portal Loan Processors' )
                {
                    IscurrentUserIsLoanProcessor=true;
                }
            } 
            if(LoanCreatedByLoanProcessor && IscurrentUserIsLoanProcessor)
            {Allvalidation=true;}
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'SAL_Loancontroller','IsLoanCreatedByLoanProcessor','Exception');
            
        }
        return Allvalidation;
    }
    
}