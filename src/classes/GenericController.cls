public class GenericController {
    @AuraEnabled
    public static List<Client__c> getAllClientList(string LoanId) {
        return [SELECT Id, Name, Last_Name__c,First_Name__c from Client__c 
                where LoanId__c = :LoanId and is_Active__c = true order by Primary_Client_for_the_Loan__c desc];   
    }
    
    @AuraEnabled
    //Get the Tabs Data
    public static Loan_New__c  TabsData(string LoanId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = [SELECT Is_Loan_Created_Manually__c,IsLoanFilled_Flag__c,IsSubjectPropertyFilled_Flag__c,IsClientFilled_Flag__c,
                        IsEmploymentFilled_Flag__c, IsAssetsFilled_Flag__c, IsIncomeFilled_Flag__c,
                        IsLaibilitiesFilled_Flag__c,IsDeclarationFilled_Flag__c,IsLoanDetailsFilled_Flag__c,
                        Is_CashFlow_Viewed__C,IsLoanContactFilled_Flag__c,IsCreditInfoFilled_Flag__c
                        FROM Loan_New__c  where Id=: LoanId];
            
        }
        catch(Exception ex)
        {
           Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','TabsData','Exception');
        }
        return objLoan;
    } 
    
    @AuraEnabled
    public static void UpdateClientFlag(id loanID) {
        //try{
            List<Client__c> clientsize=new List<Client__c>();
            clientsize=[select id from client__c where LoanId__c =: loanID and is_Active__c = true  ];
            List<Client__c> Vlidateclientsize=new List<Client__c>();
            Vlidateclientsize=[select id from client__c where LoanId__c =: loanID 
                               and is_Active__c = true and  Is_Client_Validated__c=true];
            if(clientsize.size()==Vlidateclientsize.size())
            {
                loan_new__c loan =new loan_new__c();
                if([select Is_Loan_Created_Manually__c from loan_new__c where id=:loanID].Is_Loan_Created_Manually__c ==true)
                {
                    loan.IsIncomeFilled_Flag__c=true;
                    loan.IsEmploymentFilled_Flag__c=true;
                    loan.IsAssetsFilled_Flag__c=true;
                    loan.IsLaibilitiesFilled_Flag__c=true;
                }
                
                loan.IsClientFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
        /*}
        catch(Exception ex)
        {
           Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateClientFlag','Exception');
        }*/
        
    }
    @AuraEnabled
    public static void UpdateEmploymentFlag(id loanID) {
        try
        {
            List<Employment__c> Empsize=new List<Employment__c>();
            Empsize=[select id from Employment__c where RelatedLoan__c =: loanID and is_Active__c = true  ];
            List<Employment__c> VlidateEmpsize=new List<Employment__c>();
            VlidateEmpsize=[select id from Employment__c where RelatedLoan__c =: loanID and is_Active__c = true and  Is_Employment_Validated__c=true];
            if(Empsize.size()==VlidateEmpsize.size())
            {
                loan_new__c loan =new loan_new__c();
                loan.IsEmploymentFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
        }
        catch(Exception ex)
        {
             Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateEmploymentFlag','Exception');
        }
    }
    @AuraEnabled
    public static void UpdateEmploymentFlagAfterDelete(id loanID) {
        
        //try{
            List<Employment__c> VlidateEmpsize=new List<Employment__c>();
            VlidateEmpsize=[select id from Employment__c where RelatedLoan__c =: loanID and is_Active__c = true ];
            if(VlidateEmpsize.size()==0)
            {
                loan_new__c loan =new loan_new__c();
                loan.IsEmploymentFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
            else{
         
                List<Employment__c> Empsize=new List<Employment__c>();
                Empsize=[select id from Employment__c where RelatedLoan__c =: loanID and is_Active__c = true  ];
                List<Employment__c> VlidateEmpsizeNew=new List<Employment__c>();
                VlidateEmpsizeNew=[select id from Employment__c where RelatedLoan__c =: loanID and is_Active__c = true and  Is_Employment_Validated__c=true];
                integer count= Empsize.size()-VlidateEmpsizeNew.size();
                if (count==0){
                    loan_new__c loan =new loan_new__c();
                    loan.IsEmploymentFilled_Flag__c=true;
                    loan.id=loanID;
                    update loan;  
                }
                else{
                    loan_new__c loan =new loan_new__c();
                    loan.IsEmploymentFilled_Flag__c=false;
                    loan.id=loanID;
                    update loan; 
                }
                
                 
            }
       /* }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateEmploymentFlagAfterDelete','Exception');
        }*/
    }
    @AuraEnabled
    public static void UpdateIncomeFlag(id loanID) {
        try
        {
            List<Income_New__c> Incmsize=new List<Income_New__c>();
            Incmsize=[select id from Income_New__c where Related_Loan__c =: loanID and IsActive__c = true  ];
            List<Income_New__c> VlidateIncmsize=new List<Income_New__c>();
            VlidateIncmsize=[select id from Income_New__c where Related_Loan__c =: loanID 
                             and IsActive__c = true and  Is_Income_Validated__c=true];
            if(Incmsize.size()==VlidateIncmsize.size())
            {
                loan_new__c loan =new loan_new__c();
                loan.IsIncomeFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateIncomeFlag','Exception');
        }
        
    }
    
    @AuraEnabled
    public static void UpdateIncomeFlagAfterDelete(id loanID) {         
        try
        {
            List<Income_New__c> Incmsize=new List<Income_New__c>();
            Incmsize=[select id from Income_New__c where Related_Loan__c =: loanID and IsActive__c = true  ];
            if(Incmsize.size()==0)
            {
                loan_new__c loan =new loan_new__c();
                loan.IsIncomeFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
            else{
                List<Income_New__c> IncmsizeNew=new List<Income_New__c>();
            IncmsizeNew=[select id from Income_New__c where Related_Loan__c =: loanID and IsActive__c = true  ];
            List<Income_New__c> VlidateIncmsize=new List<Income_New__c>();
            VlidateIncmsize=[select id from Income_New__c where Related_Loan__c =: loanID 
                             and IsActive__c = true and  Is_Income_Validated__c=true];
                integer count= IncmsizeNew.size()-VlidateIncmsize.size();
                if (count==0){
                    loan_new__c loan =new loan_new__c();
                    loan.IsIncomeFilled_Flag__c=true;
                    loan.id=loanID;
                    update loan;  
                }
                else{
                    loan_new__c loan =new loan_new__c();
                    loan.IsIncomeFilled_Flag__c=false;
                    loan.id=loanID;
                    update loan; 
                }
                
            }
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateIncomeFlagAfterDelete','Exception');
        }
    }
    @AuraEnabled
    public static void UpdateAssetFlag(id loanID) {
        try
        {
            List<Asset> Assetsize=new List<Asset>();
            Assetsize=[select id from Asset where RelatedLoan__c =: loanID and isActive__c = true  ];
            List<Asset> VlidateAssetsize=new List<Asset>();
            VlidateAssetsize=[select id from Asset where RelatedLoan__c =: loanID and isActive__c = true
                              and Is_Asset_Validated__c=true];
            if(Assetsize.size()==VlidateAssetsize.size())
            {
                loan_new__c loan =new loan_new__c();
                loan.IsAssetsFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateAssetFlag','Exception');
        }
        
    }
     @AuraEnabled
    public static void UpdateAssetFlagAfterDelete(string loanID) {
        
       // try{
          
            List<Asset> Assetsize=new List<Asset>();
            Assetsize=[select id from Asset where RelatedLoan__c =: loanID and isActive__c = true  ];
              
            if(Assetsize.size()==0)
            {
                
                loan_new__c loan =new loan_new__c();
                loan.IsAssetsFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
            else{
               
                List<Asset> AssetsizeNew=new List<Asset>();
            AssetsizeNew=[select id from Asset where RelatedLoan__c =: loanID and isActive__c = true  ];
            List<Asset> VlidateAssetsizeNew=new List<Asset>();
            VlidateAssetsizeNew=[select id from Asset where RelatedLoan__c =: loanID and isActive__c = true
                              and Is_Asset_Validated__c=true]; 
                integer count= AssetsizeNew.size()-VlidateAssetsizeNew.size();
                if (count==0){
                    loan_new__c loan =new loan_new__c();
                    loan.IsAssetsFilled_Flag__c=true;
                    loan.id=loanID;
                    update loan;  
                }
                else{
                    loan_new__c loan =new loan_new__c();
                    loan.IsAssetsFilled_Flag__c=false;
                    loan.id=loanID;
                    update loan; 
                }
                
            }
        /*}
        catch(Exception ex)
        {
             Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateAssetFlagAfterDelete','Exception');
        }*/
    }
    @AuraEnabled
    public static void UpdateLiabilityFlag(id loanID) {
      //  try{
            List<Liability__c> Liabilitysize=new List<Liability__c>();
            Liabilitysize=[select id from Liability__c where RelatedLoan__c =: loanID and isActive__c = true  ];
            List<Liability__c> VlidateLiabilitysize=new List<Liability__c>();
            VlidateLiabilitysize=[select id from Liability__c where RelatedLoan__c =: loanID and isActive__c = true
                                  and Is_Liability_Validated__c=true];
            if(Liabilitysize.size()==VlidateLiabilitysize.size())
            {
                loan_new__c loan =new loan_new__c();
                loan.IsLaibilitiesFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
        /*}
        catch(Exception ex)
        {
             Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateLiabilityFlag','Exception');
        }*/
        
    }
     @AuraEnabled
    public static void UpdateLiabilityFlagAfterDelete(string loanID) {
         
        //try{           
            List<Liability__c> Liabilitysize=new List<Liability__c>();
            Liabilitysize=[select id from Liability__c where RelatedLoan__c =: loanID and isActive__c = true  ];
             
            if(Liabilitysize.size()==0)
            {               
                loan_new__c loan =new loan_new__c();
                loan.IsLaibilitiesFilled_Flag__c=true;
                loan.id=loanID;
                update loan; 
            }
            else{
                 
              List<Liability__c> LiabilitysizeNew=new List<Liability__c>();
            LiabilitysizeNew=[select id from Liability__c where RelatedLoan__c =: loanID and isActive__c = true  ];
            List<Liability__c> VlidateLiabilitysize=new List<Liability__c>();
            VlidateLiabilitysize=[select id from Liability__c where RelatedLoan__c =: loanID and isActive__c = true
                                  and Is_Liability_Validated__c=true];
                integer count= LiabilitysizeNew.size()-VlidateLiabilitysize.size();
                if (count==0){
                    loan_new__c loan =new loan_new__c();
                    loan.IsLaibilitiesFilled_Flag__c=true;
                    loan.id=loanID;
                    update loan;  
                }
                else{
                    loan_new__c loan =new loan_new__c();
                    loan.IsLaibilitiesFilled_Flag__c=false;
                    loan.id=loanID;
                    update loan; 
                }
                
            }
       /* }
        catch(Exception ex)
        {
           Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateLiabilityFlagAfterDelete','Exception');
        }*/
    }
    @AuraEnabled
    public static void UpdateDeclarationFlag(string LoanId)
    {
        integer clientcountDeclaration=0;
        integer clientcount=0;
        //try{
            clientcountDeclaration = [SELECT count() FROM Declaration__c where DeclarationLoan__c = :LoanId and IsDeclaration_Filled_From_Tab__c=true and IsActive__c=:true];
            clientcount = [SELECT count() FROM Client__c where  LoanId__c= :LoanId and is_Active__c=:true];
            system.debug( 'decla client counts '+ clientcountDeclaration + 'client' + clientcount);
            if (clientcountDeclaration==clientcount)
            {
                Loan_New__c loanObj = new Loan_New__c();
                
                loanObj.Id=LoanId;
                loanObj.IsDeclarationFilled_Flag__c=true;
                update loanObj;
            }
       /* }
        catch(Exception ex)
        {
             Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateDeclarationFlag','Exception');
        }*/
    }
    @AuraEnabled
    public static void UpdateDeclarationFlagAfterClientInsert(string LoanId)
    {
        integer clientcountDeclaration=0;
        integer clientcount=0;
        //try{
            clientcountDeclaration = [SELECT count() FROM Declaration__c where DeclarationLoan__c = :LoanId and IsDeclaration_Filled_From_Tab__c=true and IsActive__c=:true];
            clientcount = [SELECT count() FROM Client__c where  LoanId__c= :LoanId and is_Active__c=:true];
            if (clientcountDeclaration!=clientcount)
            { 
                Loan_New__c loanObj = new Loan_New__c();
                loanObj.Id=LoanId;
                loanObj.IsDeclarationFilled_Flag__c=false;
                update loanObj;
            }
            
        /*}
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateDeclarationFlagAfterClientInsert','Exception');
        }*/
    }
         @AuraEnabled
    public static void UpdateDeclarationFlagAfterClientDelete(string LoanId)
    {
        integer clientcountDeclaration=0;
        integer clientcount=0;
        //try{
            clientcountDeclaration = [SELECT count() FROM Declaration__c where DeclarationLoan__c = :LoanId and IsDeclaration_Filled_From_Tab__c=true and IsActive__c=:true];
            clientcount = [SELECT count() FROM Client__c where  LoanId__c= :LoanId and is_Active__c=:true];
            if (clientcountDeclaration==clientcount)
            { 
                Loan_New__c loanObj = new Loan_New__c();
                loanObj.Id=LoanId;
                loanObj.IsDeclarationFilled_Flag__c=true;
                update loanObj;
            }
            
       /* }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','UpdateDeclarationFlagAfterClientDelete','Exception');
        }*/
    }    
  
     @AuraEnabled
    public static boolean  IsLoanCreatedByLoanProcessor()
    {
        Boolean LoanCreatedByLoanProcessor=false;
        //try{
          string profileId=UserInfo.getProfileId();
          if( profileId !=null)
        {
           string ProfileName=[SELECT Name FROM Profile where id= :profileId].Name;
            if(ProfileName=='Portal Loan Processor' || ProfileName=='Portal Loan Processors' )
            {
                LoanCreatedByLoanProcessor=true;
            }
        }
        
        /* }
           catch(Exception ex)
        {
              Exception_log.Create_Custom_Logs(ex.getMessage(),'GenericController','IsLoanCreatedByLoanProcessor','Exception');
           
        }*/
        return LoanCreatedByLoanProcessor;
    }
    //all Loan officer
    @AuraEnabled
    public static List<LoanOfficerResponse>  getLoanOfficer() {
        
        List<Contact> Objcon = new List<Contact>();
        List<Contact> ObjConId = new List<Contact>();
        User MatchedUsers = new User();
        List<LoanOfficerResponse> ListLoanOfficer = New List<LoanOfficerResponse>();
        try
        {
            
            list<Profile> OrmPartnerProfileId = [SELECT Id FROM Profile WHERE Name in ('ORM Partner' , 'ORM Partners')];
            list<string> Profilelst=new list<string>();
            for (Profile obj:OrmPartnerProfileId){
                string PID=obj.id;
                Profilelst.add(PID);
            }
                
            // Id OrmPartnersProfileId = [SELECT Id FROM Profile WHERE ].Id;
            MatchedUsers = [select AccountId from User where id = : userinfo.getUserId()];         
            List<user> usrList=new List<user>();
            usrList= [select Id, Name from User where AccountId =: MatchedUsers.AccountId and ProfileID in:Profilelst and IsActive = true];
      
            for(user usr : usrList){
                LoanOfficerResponse ObjLoanOfficer = New LoanOfficerResponse();            
                ObjLoanOfficer.Id = usr.Id;
                ObjLoanOfficer.LoanofficerName=usr.Name;
                ListLoanOfficer.add(ObjLoanOfficer);
            }
       }
        catch(Exception ex)
        {
            system.debug(' ListLoanOfficer----Exception---' + ex);
        }
        return ListLoanOfficer;
    }
}