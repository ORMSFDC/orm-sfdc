public class SAL_AssetController {
    
    //get Client List 
    @AuraEnabled
    public static List<Client__c> getClientList(string LoanId) {
        return GenericController.getAllClientList(LoanId);  
    }
     @AuraEnabled
    public static Loan_New__c  Asset_TabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);
            
        }
        catch(Exception ex)
        {
            system.debug(' Asset_TabsValidatedData----Exception---'+ex);
        }
        return objLoan;
    } 
    //Save Asset(Insert/Update)
    @AuraEnabled
    public static void SaveAsset(Asset ObjAsset,string ClientId,string LoanId, string assetCategory) {
        try{
            Loan_New__c ObjL=[SELECT Id,Related_Individual__c,Related_Partner__c from Loan_New__c where Id=: LoanId ];
            if(ClientId=='Joint')
            {
                system.debug('Joint Call'+ClientId);
                string PrimaryClientId=[Select Id from Client__c where LoanId__c=:LoanId and  Primary_Client_for_the_Loan__c=true].Id;
                ObjAsset.RelatedClient__c =PrimaryClientId;
                ObjAsset.isJoint__c = true;
            }
            else
            {
                ObjAsset.RelatedClient__c = ClientId;
                ObjAsset.isJoint__c = false;
            }
            
            ObjAsset.RelatedLoan__c = LoanId;
            ObjAsset.Category__c =assetCategory;
            ObjAsset.Name='Ast_'+assetCategory;
            ObjAsset.ContactId=ObjL.Related_Individual__c;//objusercontaid.ContactId;
            ObjAsset.AccountId=ObjL.Related_Partner__c;//objusercontaid.AccountId;
            ObjAsset.Is_Asset_Validated__c=true;
            upsert ObjAsset;
            GenericController.UpdateAssetFlag(LoanId);
        }
        catch(Exception ex)
        {
            system.debug(' SaveAsset----Exception---'+ex);
        }
    }
    
    //Get Asset Based On Client and Loan
    @AuraEnabled
    public static List <Asset> getAsset(string LoanId) {
        List <Asset> objAsset =new List <Asset>(); 
        try{ 
            objAsset = [SELECT Id, Is_Asset_Validated__c,Category__c,Type__c,Cash_or_Market_Value__c,Type_of_Account__c,Other_Assets_Type__c,Life_Insurance_Policy_Face_Value__c,Net_Worth_of_Business_es_Owned__c,Other_Asset_Amount__c,Vested_Interest_in_Retirement_Fund__c, 
                        Schedule_of_REO_Property_Address__c,Schedule_of_REO_Address_Line_2__c,Schedule_of_REO_City__c,Schedule_of_REO_State__c,Schedule_of_REO_Zip_Code__c,Present_Market_Value__c,Source_Name__c,RelatedClient__r.Name,isJoint__c  FROM Asset 
                        where isActive__c= true and RelatedLoan__c=: LoanId];
            
        }
        catch(Exception ex)
        {
            system.debug(' getAsset----Exception---'+ex);
        }
        return objAsset;
    }
    @AuraEnabled
    public static decimal getAllAssets(string LoanId) {
        List<AggregateResult> results = new List<AggregateResult>();
        decimal AssetTotal=0.00;
        decimal cash = 0.00,lic = 0.00,vInterest = 0.00, NetWorth = 0.00, PreMarVAlue = 0.00, OtherAsset = 0.00;
        try{ 
            results = [SELECT sum(Cash_or_Market_Value__c),                        
                       sum(Life_Insurance_Policy_Face_Value__c),
                       sum(Vested_Interest_in_Retirement_Fund__c),
                       sum(Net_Worth_of_Business_es_Owned__c),
                       sum(Present_Market_Value__c),
                       sum(Other_Asset_Amount__c)
                       FROM Asset where isActive__c= true and RelatedLoan__c =: LoanId];
            
            cash = ((decimal)results[0].get('expr0')==null?0:(decimal)results[0].get('expr0'));
            lic = ((decimal)results[0].get('expr1')==null?0:(decimal)results[0].get('expr1'));
            vInterest = ((decimal)results[0].get('expr2')==null?0:(decimal)results[0].get('expr2'));
            NetWorth = ((decimal)results[0].get('expr3')==null?0:(decimal)results[0].get('expr3'));
            PreMarVAlue = ((decimal)results[0].get('expr4')==null?0:(decimal)results[0].get('expr4'));
            OtherAsset = ((decimal)results[0].get('expr5')==null?0:(decimal)results[0].get('expr5'));
            AssetTotal = cash + lic + vInterest + NetWorth + PreMarVAlue + OtherAsset;
        }
        catch(Exception ex)
        {
            system.debug(' getAllAssets----Exception---'+ex);
        }
        return AssetTotal;
    }
    
    //Get Asset Based On Asset ID
    @AuraEnabled
    public static Asset  getAssetById(string RecordId) {
        Asset objEmp = new Asset();  
        try
        {
            objEmp = [SELECT Id, Category__c,Type__c,Type_of_Account__c,Cash_or_Market_Value__c,Other_Assets_Type__c ,Life_Insurance_Policy_Face_Value__c,Net_Worth_of_Business_es_Owned__c,Other_Asset_Amount__c,Vested_Interest_in_Retirement_Fund__c,Retirement_Funds__c,Account_Number__c ,
                      Schedule_of_REO_Property_Address__c,Schedule_of_REO_Address_Line_2__c,Schedule_of_REO_City__c,Schedule_of_REO_State__c,Schedule_of_REO_Zip_Code__c,Present_Market_Value__c,Source_Name__c,RelatedClient__c,isJoint__c 
                      FROM Asset  where isActive__c= true and Id=: RecordId];
        }
        catch(Exception ex)
        {
            system.debug(' getAssetById----Exception---'+ex);
        }
        return objEmp;
    }
    
    //Delete(Make Inactive) Asset
    @AuraEnabled
    public static  void DeleteAsset(String RecordId) {
        Asset objAsset = new Asset();
        try
        {
            objAsset= [Select Id,Category__c from Asset where Id = :RecordId];
            ObjAsset.isActive__c=false;
            upsert ObjAsset;
             String loanID=[select RelatedLoan__c from Asset where id=:RecordId limit 1].RelatedLoan__c;
             GenericController.UpdateAssetFlagAfterDelete(loanID);
        }
        catch(Exception ex)
        {
            system.debug(' DeleteAsset----Exception---'+ex);
        }
    }
    
}