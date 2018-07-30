/*
 getLiabilityById,getLiabilityRealEstateDetails is modified by "Condominium_FHA_Approved__c" 
added for Story No:- ORMSFDC-1264 by Developer2 on 12/21/2016
 */
public with sharing class Sal_LiabilitiesController {
    @AuraEnabled
    public static List <Client__c> getclientValue(string LoanId) {
        return GenericController.getAllClientList(LoanId);
    }
     @AuraEnabled
    public static Loan_New__c  Liability_TabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);
            
        }
        catch(Exception ex)
        {
            system.debug(' Liability_TabsValidatedData----Exception---'+ex);
        }
        return objLoan;
    } 
    @AuraEnabled
    public static List <Liability__c> getLiabilityRealEstateDetails(string LoanId) {
        List <Liability__c> listOfLiability =new List <Liability__c>();
        List <Liability__c> listOfLiability_onlySP =new List <Liability__c>();
        List <Liability__c> listOfLiability_WithoutSP =new List <Liability__c>();
        try
        {
            listOfLiability_WithoutSP = [SELECT Id,Is_Liability_Validated__c,Real_Estate_Liability__c,Mortgage_Liens__c,Liability_Category__c,
                                         Address__c,Property_Address__c, Liability_Type__c,Liability_Monthly_Payment__c,Liability_Unpaid_Balance__c, 
                                         RelatedClient__r.Name, IsJoint__c, Mortgage_Payments__c,Present_Mortgage_Value__c ,Legal_Description_of_Property__c,
                                         Real_Estate_Taxes_Monthly__c, Year_Built__c, Square_Footage__c,Property_Held_as__c
                       					,Property_Title_is_Held_in_These_Names__c,Check_If_Title_is_also_Held_As__c
                                         FROM Liability__c where RelatedLoan__c =:LoanId and isActive__c = true 
                               			 and Liability_Category__c = 'Real Estate Schedule' and Property_Status__c!='Subject Property' ];
            
      		listOfLiability_onlySP = [SELECT Id,Is_Liability_Validated__c,Real_Estate_Liability__c,Mortgage_Liens__c,Liability_Category__c,Address__c,
                                      Property_Address__c, Liability_Type__c,Liability_Monthly_Payment__c,Liability_Unpaid_Balance__c,  
                                      RelatedClient__r.Name,IsJoint__c, Mortgage_Payments__c,Present_Mortgage_Value__c ,Legal_Description_of_Property__c,
                                      Real_Estate_Taxes_Monthly__c, Year_Built__c, Square_Footage__c,Property_Held_as__c ,
                                      Property_Title_is_Held_in_These_Names__c,Check_If_Title_is_also_Held_As__c
                                
                                FROM Liability__c where RelatedLoan__c =:LoanId and isActive__c = true 
                               and Liability_Category__c = 'Real Estate Schedule' and Property_Status__c='Subject Property' order by createddate ];
            
     
        }
        catch(Exception ex)
        {
            system.debug(' getLiabilityRealEstateDetails----Exception---'+ex);
        }
        
        listOfLiability.addall(listOfLiability_onlySP);
        listOfLiability.addall(listOfLiability_WithoutSP);
        return listOfLiability;
    }
    
    @AuraEnabled
    public static List <Liability__c> getLiabilityDetails(string LoanId) {
        List <Liability__c> listOfLiability=new List <Liability__c>();
        try
        {
            listOfLiability = [SELECT Id,Is_Liability_Validated__c,Liability_Category__c,
                               Payments_Owed_to__c, Amount__c,Job_Related_Expenses__c,
                               Liability_willBeClosed_by_paying__c,Alimony_Type__c, RelatedClient__r.Name, IsJoint__c,
                               Liability_Type__c,Liability_Monthly_Payment__c,Liability_Unpaid_Balance__c 
                               FROM Liability__c where RelatedLoan__c =: LoanId and isActive__c = true 
                               and Liability_Category__c in ('Alimony', 'Liability','Job Expense')];
            
        }
        catch(Exception ex)
        {
            system.debug(' getLiabilityDetails----Exception---'+ex);
        }
        return listOfLiability;
    }
    
    @AuraEnabled
    public static Liability__c getLiabilityById(string RecordId) {
        Liability__c objLiab = new Liability__c(); 
        try
        {
            objLiab = [SELECT Id,Account_Number__c,Address__c,Amount__c, Alimony_Type__c,
                       City__c,County__c,Gross_Rental_Income__c,Job_Expense_Type__c,Job_Related_Expenses__c ,
                       Liability_willBeClosed_by_paying__c, Liability_will_be_closed_by_paying__c,Liability_will_be_closed_by_Paying_RES__c,
                       Liability_will_be_closed_by_payingThis__c,
                       Liability_Type__c, Liability_Monthly_Payment__c, Liability_Unpaid_Balance__c, Liability_Category__c, 
                       Net_Rental_Income_RealEstate__c,Name, Name_of_Company__c, Other_Expense__c,OwnerId, Mortgage_Liens__c,
                       Mortgage_Payments__c,IsJoint__c, Payments_Owed_to__c, Present_Mortgage_Value__c, Property_Address2__c,
                       Property_City__c, Property_States__c, Property_Type__c, Property_ZIP__c, Property_Address__c,
                       Real_Estate_Liability__c,RelatedClient__c, RelatedLoan__c, State__c, Type__c, Zip__c, 
                       Property_Status__c, Additional_Remarks__c,Property_County__c
                       //fields added by dev5 for the story 1440
                       /**/,Annual_Hazard_Insurance__c,HOA_Monthly_Dues__c,Monthly_Flood_Insurance_Premium__c,
                       Monthly_Ground_Rents_Amount__c,Monthly_PUD_Fees_Amount__c
                       //fields added by dev2 for the story 1565
                       ,Legal_Description_of_Property__c,Real_Estate_Taxes_Monthly__c,
                       Year_Built__c,Square_Footage__c,Property_Held_as__c
                       ,Property_Title_is_Held_in_These_Names__c,Check_If_Title_is_also_Held_As__c
                       FROM Liability__c  where Id=: RecordId and isActive__c = true];
            
        }
        catch(Exception ex)
        {
            system.debug(' getLiabilityById----Exception---'+ex);
        }
        return objLiab;
    }
    @AuraEnabled
    public static List<Client__c> getPrimaryClient(string LoanId)
    {
     	List<Client__c> objClient = new List<Client__c>();   
        objClient = [SELECT Name FROM Client__c 
            WHERE LoanId__c =: LoanId  AND Primary_Client_for_the_Loan__c = true and is_Active__c=:true];
        return objClient;
    }
    @AuraEnabled
    public static List <Liability__c> getCategoryDetails() {
        List<Liability__c> listOfcategory=new List<Liability__c>();
        try
        {
            listOfcategory = [SELECT Liability_Monthly_Payment__c,Liability_Unpaid_Balance__c,Liability_Category__c,
                              Liability_Type__c FROM Liability__c];
        }
        catch(Exception ex)
        {
            system.debug(' getCategoryDetails----Exception---'+ex);
        }
        return listOfcategory;
    }
    
    @AuraEnabled
    public static void liabilitysave(Liability__c Objliability, string ClientId,string LoanId) {
        system.debug('Objliability'+Objliability);
        string userid=userinfo.getUserId();
        Loan_New__c ObjL=[SELECT Id,Related_Individual__c,Related_Partner__c from Loan_New__c where Id=: LoanId ];
        
        try
        {
              Objliability.isActive__c = true;
            if(ClientId=='Joint')
            {
                
                system.debug('Joint Call'+ClientId);
                string PrimaryClientId=[Select Id from Client__c where LoanId__c=:LoanId and  Primary_Client_for_the_Loan__c=true].Id;
                Objliability.RelatedClient__c =PrimaryClientId;
                Objliability.IsJoint__c = true;
            }
            else
            {
                Objliability.RelatedClient__c = ClientId;
                 Objliability.IsJoint__c = false;
            }
            
            Objliability.RelatedLoan__c = LoanId;
            Objliability.Is_Liability_Validated__c=true;
            upsert Objliability;
            GenericController.UpdateLiabilityFlag(LoanId);
        }
        catch(Exception ex)
        {
            system.debug(' liabilitysave----Exception---'+ex);
        }
    } 
    
    @AuraEnabled
    public static  void DeleteLiability(String RecordId)
    {
        Liability__c objLiability = new Liability__c();
        String Liability_Id='';
        try{
            objLiability = [Select Id,Name from Liability__c where Id =: RecordId];
            Liability_Id = objLiability.Id;
            
            if (Liability_Id == RecordId)
            {
                objLiability.isActive__c  = false;
                update objLiability;
                String loanID=[select RelatedLoan__c from Liability__c where id=:RecordId limit 1].RelatedLoan__c;
                GenericController.UpdateLiabilityFlagAfterDelete(loanID);
            }
        }
        catch(Exception ex)
        {
            system.debug(' DeleteLiability----Exception---'+ex);
        }
    }
    
    //Fetch Subject Proprty based on Loan Id  
    @AuraEnabled
    public static Loan_New__c  getSubjectPropertyAddressByLoanId(string RecordId) 
    {        
        Loan_New__c objLoan = new Loan_New__c(); 
        try
        {
            objLoan = [SELECT Id, Subject_Property_Address__c, Subject_Property_City__c, Subject_Property_State__c, 
                       Subject_Property_Zip_Code__c FROM Loan_New__c  where Id=: RecordId];
        }
        catch(Exception ex)
        {
            system.debug('getSubjectPropertyAddressByLoanId----Exception---'+ex);
        }
        return objLoan;
    }
    @AuraEnabled
    public static integer getSubjectPropertyCount(string LoanId) {
        return  [select count() from  Liability__c where Liability_Category__c = 'Real Estate Schedule' and Property_Status__c='Subject Property' and RelatedLoan__c=:LoanId and isActive__c = true];
    }
}