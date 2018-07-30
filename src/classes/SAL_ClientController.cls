public class SAL_ClientController {
    
    @AuraEnabled
    public static List <Client__c> getclientValue(string LoanId) {
        return GenericController.getAllClientList(LoanId);
    }
    @AuraEnabled
    public static Integer getClientCount(string LoanId) {
        integer Count=[select count() from Client__c where LoanId__c=:LoanId and is_Active__c = true ];
        return Count;        
    }
      @AuraEnabled
    public static String getMortgageApplied(string LoanId) {
        String MortgageApplied=[select Mortgage_Applied_for__c from Loan_New__c where Id=:LoanId ].Mortgage_Applied_for__c;
        return MortgageApplied;        
    }
    @AuraEnabled
    public static List <Client__c> fetchClients(string loanID) {
        List <Client__c> returnList=new List <Client__c>();
        try
        {
            returnList = [SELECT Id, Name, City__c, DOB__c, Last_Name__c, First_Name__c, Marital_Status__c, Non_Borrowing_Spouse__c, Number_of_years__c, Property_type__c, Residence__c, Social_Security_Number__c, Zip__c, LoanId__c FROM Client__c 
                          where LoanId__c =: loanID and is_Active__c = true order by Primary_Client_for_the_Loan__c desc];
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','fetchClients','ApexType');
            system.debug(' fetchClients----Exception---'+ex);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static  void  SaveClient(Client__c objClient,id loanID) 
    {
        
        list<Client__c> ClientExists = fetchClients(loanID);  
        try
        {
            if(objClient.Id != null)
            {
                if(objClient.Middle_Name__c != null)
                    objClient.Name= objClient.Last_Name__c+', '+ objClient.First_Name__c +' '+ objClient.Middle_Name__c;
                else
                    objClient.Name= objClient.Last_Name__c+', '+ objClient.First_Name__c;
                objClient.LoanId__c = loanID;
                ObjClient.is_Active__c = true;
                ObjClient.Is_Client_Validated__c=true;
                upsert objClient; 
                
            }
            else
            {          
                if(ClientExists.size() >0)
                {
                    
                    objClient.Primary_Client_for_the_Loan__c = false;
                    if(objClient.Middle_Name__c != null)
                        objClient.Name= objClient.Last_Name__c+', '+ objClient.First_Name__c +' '+ objClient.Middle_Name__c;
                    else
                        objClient.Name= objClient.Last_Name__c+', '+ objClient.First_Name__c;
                    objClient.LoanId__c = loanID;
                    ObjClient.is_Active__c = true;
                    ObjClient.Is_Client_Validated__c=true;
                    //ObjClient.Is_Non_Borrowing_Spouse_Filled__c=true;
                    //ObjClient.Is_Non_Borrowing_Resident__c
                    upsert objClient;                 
                    CreateDeclaration(objClient,loanID);
                    //CreateIncome(objClient,loanID);                   
                    
                }
                else{
                    system.debug(objClient);
                    objClient.Primary_Client_for_the_Loan__c = true;                 
                    objClient.LoanId__c = loanID;
                    if(objClient.Middle_Name__c != null)
                        objClient.Name= objClient.Last_Name__c+', '+ objClient.First_Name__c +' '+ objClient.Middle_Name__c;
                    else
                        objClient.Name= objClient.Last_Name__c+', '+ objClient.First_Name__c;
                    ObjClient.is_Active__c = true;
                    ObjClient.Is_Client_Validated__c=true;                 
                    upsert objClient; 
                    
                    updateLiabilityForClient(loanID,objClient.Id);
                    CreateDeclaration(objClient,loanID); 
                    
                }
            }
            GenericController.UpdateClientFlag(loanID);
            GenericController.UpdateDeclarationFlagAfterClientInsert(loanID);
            
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','SaveClient','ApexType');
        }
    }
    @AuraEnabled 
    public static void updateLiabilityForClient(string LoanId,string ClientID)
    {
        try
        {
            Liability__c objLiability = new Liability__c();
            objLiability=[SELECT Id FROM Liability__c  WHERE RelatedLoan__c =: LoanId  AND 
                          Property_Status__c = 'Subject Property' and isActive__c =:true];
            objLiability.RelatedClient__c=ClientID;
            upsert objLiability;
        }
        catch(exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','updateLiabilityForClient','ApexType');
            
        }
    }
    @AuraEnabled
    public static Declaration__c CreateDeclaration(Client__c c,id loanID) {
        Declaration__c  Declaration = new Declaration__c ();
        try
        {
            Declaration.Name=c.Name+'_Declaration'; 
            Declaration.Outstanding_Judgments__c = ''; 
            Declaration.Lawsuit__c = '';
            Declaration.Delinquent__c = '';            
            Declaration.Delinquent_FHA_VA_Case__c = '';
            Declaration.Delinquent_Reason__c = '';
            Declaration.CashtoClose__c = '';
            Declaration.CashtoClose_Borrowed_Money__c = '';
            Declaration.Endorser__c = '';
            //Declaration.US_Citizen__c = 'Yes'; 
            //Declaration.Primary_Residence__c = 'Yes'; 
            Declaration.US_Citizen__c = ''; 
            Declaration.Primary_Residence__c = ''; 
            Declaration.Bankruptcy__c = ''; 
            Declaration.Bankruptcy_Reason__c = '';
            Declaration.ReverseMortgage__c = '';
            Declaration.Delinquent_Date_of_the_Debt__c = date.today();
            Declaration.ReverseMortgage_finproduct__c = '';
            Declaration.FHA_Insured_Loan__c = ''; 
            //Declaration.Ethnicity__c = 'Hispanic or Latino' ;
            //Declaration.Race__c = 'American Indian or Alaska Native' ;
            //Declaration.Sex__c = 'Male'; 
            Declaration.Ethnicity_New__c = '' ;
            Declaration.Race__c = '' ;
            // Change made by Dhiresh
            Declaration.Sex_New__c = '';
            Declaration.DeclarationLoan__c = c.LoanId__c;
            Declaration.DeclarationClient__c = c.Id;
            insert Declaration;
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','CreateDeclaration','ApexType');
            system.debug(' CreateDeclaration----Exception---'+ex);
        }
        return Declaration;
    }
    @AuraEnabled
    public static List<Client__c> getClientDetails(string loanID) {
        List<Client__c> ClientRecord=new List<Client__c> ();
        try
        {
            ClientRecord = [SELECT Id, Name, Home_Phone__c, Street_Address__c,City__c, DOB__c, Last_Name__c, First_Name__c, Marital_Status__c, Non_Borrowing_Spouse__c, Number_of_years__c, Property_type__c, Residence__c, Social_Security_Number__c, Zip__c, 
                            LoanId__c,Is_Client_Validated__c
                            FROM Client__c where LoanId__c = :loanID and is_Active__c = true order by createddate];
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','getClientDetails','ApexType');
            
            system.debug(' getClientDetails----Exception---'+ex);
        }
        try{
            
            Opportunity_field_populator.update_opportunity(loanID);
        }catch(Exception ex){
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','getClientDetails','ApexType');
            
            system.debug(' getClientDetails----Exception---'+ex);
        }
        return ClientRecord;
    }
    
    @AuraEnabled
    public static string getPrimaryClientNBSYes(string loanID) {
        string ShowNBS;
        boolean PrimaryClientY=[Select Is_Non_Borrowing_Spouse_Filled__c from Client__c where 
                                LoanId__c = :loanID and is_Active__c = true and Primary_Client_for_the_Loan__c=true].Is_Non_Borrowing_Spouse_Filled__c;
        if(PrimaryClientY)
            ShowNBS='Yes';
        else
            ShowNBS='No';
        return ShowNBS;
    }
    @AuraEnabled
    public static string getPrimaryClientNBRYes(string loanID) {
        string ShowNBR;
        boolean PrimaryClientY=[Select Is_Non_Borrowing_Resident__c from Client__c where 
                                LoanId__c = :loanID and is_Active__c = true and Primary_Client_for_the_Loan__c=true].Is_Non_Borrowing_Resident__c;
        if(PrimaryClientY)
            ShowNBR='Yes';
        else
            ShowNBR='No';
        return ShowNBR;
    }   
    
    @AuraEnabled
    public static Client__c getClientDetailsbyId(String RecordId) {
        Client__c ClientRecord=new  Client__c();
        try
        {
            ClientRecord = [SELECT Id, Name, Email_Optional__c,Address_Same_As_SubjectProperty__c, Street_Address__c,City__c,Client_State__c,Zip__c,DOB__c,
                            First_Name__c,Home_Phone__c,is_Active__c,Last_Name__c,LoanId__c,Address_Mailing__c,Check_if_Mailing_Address_is_similar_to_P__c,
                            City_Mailing__c,State_Mailing__c,Zip_Mailing__c,Marital_Status__c,Middle_Name__c,Phone_Number__c,Non_Borrowing_Relation__c,
                            Non_Borrowing_Spouse__c,Non_Borrowing_Spouse_Addres__c,Non_Borrowing_Spouse_City__c,Non_Borrowing_Date_of_Birth__c,
                            Non_Borrowing_Spouse_Name__c,Non_Borrowing_Spouse_Phone_Number__c,Non_Borrowing_Spouse_State__c,Non_Borrowing_Spouse_Zip__c,
                            Number_of_years__c,Primary_Client_for_the_Loan__c,Property_type__c,Residence__c,Monthly_Income__c,
                            Social_Security_Number__c,Spouse_Mailing_Address_same_as_client__c,Place_of_Celebration__c,Client_Address_Same_As_Primary_Client__c,
                            Is_there_a_POA__c,If_yes_Name_of_POA__c FROM Client__c where Id = :RecordId and is_Active__c = true];
            
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','getClientDetailsbyId','ApexType');
            system.debug(' getClientDetailsbyId----Exception---'+ex);
        }
        return ClientRecord;
    }
    
    @AuraEnabled
    public static boolean getPrimaryClientCheck(string loanID) {
        list<Client__c> ClientExists = fetchClients(loanID);        
        boolean isPrimaryClient = false;              
        try
        {
            if(ClientExists.size() > 0)
            {
                isPrimaryClient = false;
            }
            else
            {
                isPrimaryClient = true;    
            }                 
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','getPrimaryClientCheck','ApexType');
            system.debug(' getPrimaryClientCheck----Exception---'+ex);
        }
        return isPrimaryClient;
    }
    
    @AuraEnabled
    public static Client__c getPrimaryClientAddressDetails(string loanID) {
        Client__c ClientRecord=new  Client__c();
        try
        {
            ClientRecord = [SELECT Id, Name, Client_Address_Same_As_Primary_Client__c,Street_Address__c,City__c,Client_State__c, State__c,Zip__c,
                            Primary_Client_for_the_Loan__c,Check_if_Mailing_Address_is_similar_to_P__c, Address_Mailing__c, City_Mailing__c,
                            State_Mailing__c, Zip_Mailing__c,Number_of_years__c FROM Client__c where LoanId__c = :loanID and Primary_Client_for_the_Loan__c = true and is_Active__c = true];            
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','getPrimaryClientAddressDetails','ApexType');
            system.debug(' getPrimaryClientAddressDetails----Exception---'+ex);
        }
        return ClientRecord;
    }
    @AuraEnabled
    public static Loan_New__c getSubjectPropertyAddressData(string loanID) {
        Loan_New__c loanData=new  Loan_New__c();
        try
        {
            loanData = [SELECT  Subject_Property_Address__c,Subject_Property_City__c,
                        Subject_Property_State__c, Subject_Property_Zip_Code__c
                        FROM Loan_New__c where id = :loanID ];            
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','getSubjectPropertyAddressData','ApexType');
            
            system.debug(' getSubjectPropertyAddressData----Exception---'+ex);
        }
        return loanData;
    }
    
    @AuraEnabled
    public static  void DeleteClient(String RecordId)
    {  
        try
        {
            List<Asset> lstAsset= [Select Id,
                                   Category__c,isActive__c from Asset where RelatedClient__c = :RecordId];
            List<Asset>lstAssforDel=new  List<Asset>();
            if(lstAsset.size() > 0)
            {
                for (Asset objAsset: lstAsset) {    objAsset.isActive__c = false; lstAssforDel.add(objAsset);
                                                
                                               }
                update lstAssforDel;
            }
            
            List<Income_New__c> lstIncome= [Select Id,
                                            isActive__c from Income_New__c where RelatedClient__c = :RecordId];
            List<Income_New__c>lstIncomeforDel=new  List<Income_New__c>();
            if(lstIncome.size() > 0)
            {
                for (Income_New__c objIncome: lstIncome) {
                    objIncome.isActive__c = false;  objIncome.Income_Value__c = 0.00;      lstIncomeforDel.add(objIncome);
                }
                update lstIncomeforDel;
                
            }
            
            List<Liability__c> lstliability = [Select Id,
                                               isActive__c from Liability__c where RelatedClient__c = :RecordId];
            List<Liability__c>lstLiabforDel=new  List<Liability__c>();
            if(lstliability.size() > 0)
            {
                for (Liability__c objLiab: lstliability) {
                    objLiab.isActive__c = false;    lstLiabforDel.add(objLiab);
                }
                update lstLiabforDel;
            }
            
            List<Employment__c> lstEmployment = [Select Id,
                                                 is_Active__c from Employment__c where Client_id__c = :RecordId];
            List<Employment__c>lstEmpforDel=new  List<Employment__c>();
            if(lstEmployment.size() > 0)
            {
                for (Employment__c objEmp: lstEmployment) {
                    objEmp.is_Active__c = false;    lstEmpforDel.add(objEmp);
                }
                update lstEmpforDel;
            }
            
            List<Declaration__c> lstDeclaration= [Select Id,
                                                  isActive__c from Declaration__c where DeclarationClient__c = :RecordId];
            List<Declaration__c>lstDeclforDel=new  List<Declaration__c>();
            if(lstDeclaration.size() > 0)
            {
                for (Declaration__c objdec: lstDeclaration) {
                    objdec.isActive__c = false;    lstDeclforDel.add(objdec);
                }
                update lstDeclforDel;
            }
            string LoanID=[Select LoanId__c from Client__c where Id = :RecordId].LoanId__c;
            Client__c objClient = [Select Id,Name,is_Active__c, 
                                   Primary_Client_for_the_Loan__c from Client__c where Id = :RecordId];
            //remove NBS 
            objClient.is_Active__c = false;
            objClient.Non_Borrowing_Spouse_Name__c='';
            objClient.Non_Borrowing_Spouse_Phone_Number__c='';
            objClient.Non_Borrowing_Date_of_Birth__c=null;
            objClient.Non_Borrowing_Relation__c='';
            objClient.Spouse_Mailing_Address_same_as_client__c=false;
            objClient.Non_Borrowing_Spouse_Addres__c='';
            objClient.Non_Borrowing_Spouse_City__c='';
            objClient.Non_Borrowing_Spouse_State__c='';
            objClient.Non_Borrowing_Spouse_Zip__c='';
            objClient.IsNBSAvaliable__c=false;
            objClient.Place_of_Celebration__c='';
            objClient.Monthly_Income__c=0;
            //remove NBS
            
            update objClient;
            
            GenericController.UpdateEmploymentFlagAfterDelete(LoanID);
            GenericController.UpdateIncomeFlagAfterDelete(LoanID);
            GenericController.UpdateAssetFlagAfterDelete(LoanID);
            GenericController.UpdateLiabilityFlagAfterDelete(LoanID);
            GenericController.UpdateDeclarationFlagAfterClientDelete(LoanID);
            GenericController.UpdateClientFlag(LoanID);
            integer count=[Select count() from Client__c where LoanId__c = :LoanID and IsNBSAvaliable__c=true];
            if(count==0)
            {
                String PrimaryClientid= [Select Id from Client__c where LoanId__c= :LoanID
                                         and Primary_Client_for_the_Loan__c=true].Id;
                Client__c objClient_pri = [Select Id,Non_Borrowing_Spouse__c from Client__c where Id = :PrimaryClientid];
                objClient_pri.Non_Borrowing_Spouse__c='No';
                update objClient_pri;
            }
            
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','DeleteClient','ApexType');
            
            system.debug(' DeleteClient----Exception---'+ex);
        }
        
    }
    
    //This method retrieves all the client names associated with a Loan Id and also 
    //checks their respective declaration completion status
    @AuraEnabled
    public static boolean AllClientsName(string loanID)
    {
        boolean allDeclarationsComplete =true;
        List<ClientDeclarationDetails> declarationList= new  List<ClientDeclarationDetails>();
        List <Declaration__c> ClientDeclarations =new List <Declaration__c>();
        List<Client__c> objAllclient=new List<Client__c>();
        try
        {
            objAllclient= [Select Id, First_Name__c ,
                           Last_Name__c from Client__c where LoanId__c= :loanID order by Primary_Client_for_the_Loan__c desc];
            ClientDeclarations = [SELECT DeclarationClient__c,
                                  IsDeclaration_Filled_From_Tab__c FROM Declaration__c where IsActive__c=:true and DeclarationLoan__c = :loanID];
            for(Declaration__c obj:ClientDeclarations)
            {
                for(Client__c c:objAllclient)
                {
                    if(c.id==obj.DeclarationClient__c)
                    {
                        ClientDeclarationDetails Objdeclaration= new  ClientDeclarationDetails();
                        Objdeclaration.ClientFirstName= c.First_Name__c;
                        Objdeclaration.ClientLastName=c.Last_Name__c ;
                        Objdeclaration.ClientDeclarationStatus=obj.IsDeclaration_Filled_From_Tab__c;
                        if(Objdeclaration.ClientDeclarationStatus==false)
                        {
                            allDeclarationsComplete = false;
                            break;
                        }
                        declarationList.Add(Objdeclaration);
                    }
                }
                
            }
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','AllClientsName','ApexType');
            
            system.debug(' AllClientsName----Exception---'+ex);
        }
        
        return allDeclarationsComplete;
    }
    
    @AuraEnabled
    public static  Loan_New__c  GetTabtatus(string LoanID) 
    {
        Loan_New__c LoanDetails=new  Loan_New__c();
        try
        {
            LoanDetails =  [SELECT  Using_Title_Source_as_the_Closing_Agent__c,Is_CashFlow_Viewed__c,Preferred_Contact_Type__c    FROM Loan_New__c where id = : LoanID];
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','GetTabtatus','ApexType');
            
            system.debug('GetTabtatus----Exception---'+ex);
        }
        return LoanDetails;
    }
    
    @AuraEnabled
    public static Loan_New__c  IsClientValidate(string RecordId) 
    {   
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);
            
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','IsClientValidate','ApexType');
            
            system.debug(' IsClientValidate----Exception---'+ex);
        }
        return objLoan;
    }
    //Code for Adding NBS for story -1274
    //
    @AuraEnabled
    public static  void  SaveClientNBS(string NBSList,String LoanId,string ISNBS) 
    {
        try
        {
            
            //Update primary client Yes
            String Clientid= [Select Id from Client__c where LoanId__c= :LoanId and Primary_Client_for_the_Loan__c=true].Id;
            Client__c ClientYesNo=new Client__c();
            if(ISNBS=='Yes')            
                ClientYesNo.Is_Non_Borrowing_Spouse_Filled__c=true;          
            else             
                ClientYesNo.Is_Non_Borrowing_Spouse_Filled__c=false;   
            ClientYesNo.Id=Clientid;
            Update ClientYesNo;
            //End
            if(ISNBS=='Yes')
            {
                UpsertNBS(NBSList,LoanId);
            }
            else
            {
                SaveClientNBSNO(LoanId);
            }
            
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','SaveClientNBSYes','ApexType');
            
            system.debug(' SaveClientNBSYes----Exception---'+ex);
        }
        
    }
    public static void UpsertNBS(string NBSList,String LoanId)
    {
        try
        {
            //Update each clientNBS Data with blank
            List<Client__c> objClientNBS=[SELECT Id, Spouse_Mailing_Address_same_as_client__c 
                                          FROM Client__c where LoanId__c= :LoanId and is_Active__c = true];
            List<Client__c>objClientUpdateBlank=new List<Client__c>();
            for(Client__c i:objClientNBS)
            {
                Client__c Client=new Client__c();
                Client.Id=i.Id;
                // Client.Non_Borrowing_Spouse__c=ISNBS;
                Client.Non_Borrowing_Spouse_Name__c='';
                Client.Non_Borrowing_Spouse_Phone_Number__c='';
                Client.Non_Borrowing_Date_of_Birth__c=null;
                Client.Non_Borrowing_Relation__c='';                
                Client.Spouse_Mailing_Address_same_as_client__c=false;
                Client.Non_Borrowing_Spouse_Addres__c='';
                Client.Non_Borrowing_Spouse_City__c='';
                Client.Non_Borrowing_Spouse_State__c='';
                Client.Non_Borrowing_Spouse_Zip__c='';
                Client.Monthly_Income__c=null;
                Client.IsNBSAvaliable__c=false;
                Client.Place_of_Celebration__c='';
                objClientUpdateBlank.add(Client);
                
            }
            update objClientUpdateBlank; 
            //Start updating other parameter
            List<Client__c>objClientNBSYES=new List<Client__c>();
            List<ClientSpouseResponse>RequestList = (List<ClientSpouseResponse>)JSON.deserialize(NBSList, List<ClientSpouseResponse>.class);
            for(ClientSpouseResponse i:RequestList)
            {
                Client__c Client=new Client__c();
                Client.Id=i.ClientId;
                // Client.Non_Borrowing_Spouse__c=ISNBS;
                Client.Non_Borrowing_Spouse_Name__c=i.NonborrowingSpouseName;
                Client.Non_Borrowing_Spouse_Phone_Number__c=i.NonborrowingSpousePhone;
                Client.Non_Borrowing_Date_of_Birth__c=i.NonborrowingSpouseDOB;
                Client.Non_Borrowing_Relation__c=i.NonborrowingSpouseRelation;
                Client.Monthly_Income__c=i.NonborrowingSpouseMonthlyIncome;
                Client.IsNBSAvaliable__c=true;
                Client.Place_of_Celebration__c=i.PlaceofCelebration;                
                if(i.NonborrowingSpouseAddressSameAs==true)
                {
                    Loan_New__c loanData=new  Loan_New__c();
                    loanData = [SELECT  Subject_Property_Address__c,Subject_Property_City__c,
                                Subject_Property_State__c, Subject_Property_Zip_Code__c
                                FROM Loan_New__c where id = :LoanId ];
                    Client.Spouse_Mailing_Address_same_as_client__c=true;
                    Client.Non_Borrowing_Spouse_Addres__c=loanData.Subject_Property_Address__c;
                    Client.Non_Borrowing_Spouse_City__c=loanData.Subject_Property_City__c;
                    Client.Non_Borrowing_Spouse_State__c=loanData.Subject_Property_State__c;
                    Client.Non_Borrowing_Spouse_Zip__c=loanData.Subject_Property_Zip_Code__c;
                }
                else
                {
                    Client.Spouse_Mailing_Address_same_as_client__c=false;
                    Client.Non_Borrowing_Spouse_Addres__c=i.NonborrowingSpouseAddress;
                    Client.Non_Borrowing_Spouse_City__c=i.NonborrowingSpouseCity;
                    Client.Non_Borrowing_Spouse_State__c=i.NonborrowingSpouseState;
                    Client.Non_Borrowing_Spouse_Zip__c=i.NonborrowingSpouseZip;
                }
                objClientNBSYES.add(Client);                
                
            }
            update objClientNBSYES;
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','UpsertNBS','ApexType');
            
            system.debug(' UpsertNBS----Exception---'+ex);
        }
    }
    
    @AuraEnabled
    public static List<ClientSpouseResponse>  ShowNBSData(String LoanId) 
    {
        List<ClientSpouseResponse> objRes=new List<ClientSpouseResponse> ();
        List<Client__c> objclientSpouse=new List<Client__c>();
        objclientSpouse=[Select Id,Non_Borrowing_Spouse_Name__c,Non_Borrowing_Spouse_Phone_Number__c,Non_Borrowing_Date_of_Birth__c,
                         Non_Borrowing_Relation__c,Spouse_Mailing_Address_same_as_client__c,Non_Borrowing_Spouse_Addres__c,
                         Non_Borrowing_Spouse_City__c,Place_of_Celebration__c,Non_Borrowing_Spouse_State__c,Non_Borrowing_Spouse_Zip__c,Monthly_Income__c 
                         from Client__c where LoanId__c= :LoanId
                         and  is_Active__c = true and IsNBSAvaliable__c=true];
        for(Client__c c:objclientSpouse)
        {
            ClientSpouseResponse Cres=new ClientSpouseResponse();
            Cres.ClientId=c.Id;
            Cres.NonborrowingSpouseName=c.Non_Borrowing_Spouse_Name__c;
            Cres.NonborrowingSpousePhone=c.Non_Borrowing_Spouse_Phone_Number__c;
            Cres.NonborrowingSpouseDOB=c.Non_Borrowing_Date_of_Birth__c;
            Cres.NonborrowingSpouseRelation=c.Non_Borrowing_Relation__c;
            Cres.NonborrowingSpouseAddressSameAs=c.Spouse_Mailing_Address_same_as_client__c;
            Cres.NonborrowingSpouseAddress=c.Non_Borrowing_Spouse_Addres__c;
            Cres.NonborrowingSpouseCity=c.Non_Borrowing_Spouse_City__c;
            Cres.NonborrowingSpouseState=c.Non_Borrowing_Spouse_State__c;
            Cres.NonborrowingSpouseZip=c.Non_Borrowing_Spouse_Zip__c;
            Cres.NonborrowingSpouseMonthlyIncome=c.Monthly_Income__c;
            Cres.PlaceofCelebration=c.Place_of_Celebration__c;
            objRes.add(Cres);
        }
        
        return objRes;
    }   
    public static  void  SaveClientNBSNO(String LoanId) 
    { 
        //Update if Field has already value
        List<Client__c> objClientNBS=[SELECT Id, Spouse_Mailing_Address_same_as_client__c 
                                      FROM Client__c where LoanId__c= :LoanId and is_Active__c = true];
        List<Client__c> objClientNoNBS=new  List<Client__c>();
        for(Client__c i:objClientNBS)
        {
            Client__c Client=new Client__c();
            Client.Id=i.Id;
            // Client.Non_Borrowing_Spouse__c=ISNBS;
            Client.Non_Borrowing_Spouse_Name__c='';
            Client.Non_Borrowing_Spouse_Phone_Number__c='';
            Client.Non_Borrowing_Date_of_Birth__c=null;
            Client.Non_Borrowing_Relation__c='';            
            Client.Spouse_Mailing_Address_same_as_client__c=false;
            Client.Non_Borrowing_Spouse_Addres__c='';
            Client.Non_Borrowing_Spouse_City__c='';
            Client.Non_Borrowing_Spouse_State__c='';
            Client.Non_Borrowing_Spouse_Zip__c='';
            Client.Monthly_Income__c=null;
            Client.Place_of_Celebration__c='';
            objClientNoNBS.add(Client);
            
        }
        update objClientNoNBS; 
    }
    
    //NBR for Story-1274
    @AuraEnabled
    public static  void  SaveClientNBR(string NBRList,String LoanId,string ISNBR) 
    {
        try
        {
            
            //Update primary client Yes
            String Clientid= [Select Id from Client__c where LoanId__c= :LoanId and Primary_Client_for_the_Loan__c=true].Id;
            Client__c ClientYesNO=new Client__c();
            if(ISNBR=='Yes')
                ClientYesNO.Is_Non_Borrowing_Resident__c=true;
            else
                ClientYesNO.Is_Non_Borrowing_Resident__c=false;
            // ClientYesNO.Non_Borrowing_Resident__c=ISNBR;
            ClientYesNO.Id=Clientid;
            Update ClientYesNO;
            if(ISNBR=='Yes'){
                UpsertNBR(NBRList,LoanId,Clientid);
            }
            else
            {
                SaveClientNBRNo(LoanId);
            }
            
        }
        catch(Exception ex)
        {
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','SaveClientNBRYes','ApexType');
            
            system.debug(' SaveClientNBRYes----Exception---'+ex);
        }
        
    }
    @AuraEnabled
    //NBR for Story-1274
    public static  string  ShowNBS(String LoanId) 
    {
        string ShowNBSYN;
        String PrimaryClientid= [Select Id from Client__c where LoanId__c= :LoanId and Primary_Client_for_the_Loan__c=true].Id;
        boolean ShowNBSYNValue=[Select Is_Non_Borrowing_Spouse_Filled__c from Client__c where Id=:PrimaryClientid ].Is_Non_Borrowing_Spouse_Filled__c;
        if(ShowNBSYNValue)
            ShowNBSYN='Yes';
        else
            ShowNBSYN='No';
        return ShowNBSYN;
    }
    
    @AuraEnabled
    //NBR for Story-1274
    public static  string  ShowNBR(String LoanId) 
    {
        
        string ShowNBRYN;
        String PrimaryClientid= [Select Id from Client__c where LoanId__c= :LoanId and Primary_Client_for_the_Loan__c=true].Id;
        boolean ShowNBRYNValue=[Select Is_Non_Borrowing_Resident__c from Client__c where Id=:PrimaryClientid ].Is_Non_Borrowing_Resident__c;
        if(ShowNBRYNValue)
            ShowNBRYN='Yes';
        else
            ShowNBRYN='No';
        return ShowNBRYN;
    }
    @AuraEnabled
    public static List<ClientResidentResponse>  ShowNBRData(String LoanId) 
    {
        List<ClientResidentResponse> objRes=new List<ClientResidentResponse> ();
        List<Non_Borrowing_Resident__c> objclientNBR=new List<Non_Borrowing_Resident__c>();
        objclientNBR=[Select Id,Date_of_Birth__c,Monthly_Income__c,Relationship_to_Client__c,
                      Non_Borrowing_Resident_Name__c
                      from Non_Borrowing_Resident__c where Loan_Id__c= :LoanId and IsActiveNBR__c=true ];
        
        for(Non_Borrowing_Resident__c c:objclientNBR)
        {
            ClientResidentResponse Cres=new ClientResidentResponse();  
            Cres.RecordId=c.Id;
            Cres.NonborrowingResidentDOB=c.Date_of_Birth__c;
            Cres.NonborrowingResidentMonthlyIncome=c.Monthly_Income__c;
            Cres.NonborrowingResidentRelation=c.Relationship_to_Client__c;
            Cres.NonborrowingResidentName=c.Non_Borrowing_Resident_Name__c;           
            objRes.add(Cres);
        }
        
        return objRes;
    }
    public static  void  SaveClientNBRNo(String LoanId)
    {
        
        List<Non_Borrowing_Resident__c> NBRNO=new  List<Non_Borrowing_Resident__c>();
        List<Non_Borrowing_Resident__c> objclientNBR=new List<Non_Borrowing_Resident__c>();
        objclientNBR=[Select Id,Date_of_Birth__c,Monthly_Income__c,Relationship_to_Client__c,
                      Non_Borrowing_Resident_Name__c
                      from Non_Borrowing_Resident__c where Loan_Id__c= :LoanId and IsActiveNBR__c=true ];
        if(objclientNBR.size()>0)
        {
            for(Non_Borrowing_Resident__c nbr:objclientNBR)
            {
                Non_Borrowing_Resident__c NBRC=new Non_Borrowing_Resident__c();
                NBRC.IsActiveNBR__c=false;
                NBRC.Id=nbr.Id;
                NBRNO.add(NBRC);
                
            }
            update NBRNO;
        }
        
    }
    
    public static void UpsertNBR(String NBRList,String LoanId,String Clientid)
    {
        try{
            List<string>IdINNBR=new  List<string>();
            List<ClientResidentResponse>RequestList = (List<ClientResidentResponse>)JSON.deserialize(NBRList, List<ClientResidentResponse>.class);
            for(ClientResidentResponse i:RequestList)
            {
                if(i.RecordId!=null || i.RecordId!='')
                {
                    IdINNBR.add(i.RecordId);
                }
                
            }
            if(IdINNBR.size()>0)
            {
                List<Non_Borrowing_Resident__c> ObjNBRNotListForUpdate=new  List<Non_Borrowing_Resident__c>();
                List<Non_Borrowing_Resident__c> ObjNBRNotList=new  List<Non_Borrowing_Resident__c>();
                ObjNBRNotList=[Select Id from Non_Borrowing_Resident__c where Id NOT IN:IdINNBR ];
                for(Non_Borrowing_Resident__c i:ObjNBRNotList)
                {
                    Non_Borrowing_Resident__c ClientNBR=new Non_Borrowing_Resident__c();
                    ClientNBR.Id=i.Id; 
                    ClientNBR.IsActiveNBR__c=false;
                    ObjNBRNotListForUpdate.add(ClientNBR);
                }
                update ObjNBRNotListForUpdate; 
            }
            List<Non_Borrowing_Resident__c>ListtoInsert=new List<Non_Borrowing_Resident__c>();
            List<Non_Borrowing_Resident__c>ListtoUpdate=new List<Non_Borrowing_Resident__c>();
            for(ClientResidentResponse i:RequestList)
            {
                Non_Borrowing_Resident__c ClientNBR=new Non_Borrowing_Resident__c();
                if(i.RecordId=='')
                {                
                    ClientNBR.Date_of_Birth__c=i.NonborrowingResidentDOB;
                    ClientNBR.Monthly_Income__c=i.NonborrowingResidentMonthlyIncome;
                    ClientNBR.Relationship_to_Client__c=i.NonborrowingResidentRelation;
                    ClientNBR.Non_Borrowing_Resident_Name__c=i.NonborrowingResidentName;
                    ClientNBR.Loan_Id__c=LoanId;
                    ClientNBR.Client_Id__c=Clientid;
                    ClientNBR.IsActiveNBR__c=true;
                    ListtoInsert.add(ClientNBR)  ;
                    //insert ClientNBR;    
                }
                else
                {                
                    ClientNBR.Date_of_Birth__c=i.NonborrowingResidentDOB;
                    ClientNBR.Monthly_Income__c=i.NonborrowingResidentMonthlyIncome;
                    ClientNBR.Relationship_to_Client__c=i.NonborrowingResidentRelation;
                    ClientNBR.Non_Borrowing_Resident_Name__c=i.NonborrowingResidentName;
                    ClientNBR.Loan_Id__c=LoanId;
                    ClientNBR.Client_Id__c=Clientid;
                    ClientNBR.Id= i.RecordId;    
                    ListtoUpdate.add(ClientNBR)  ;
                }           
                
            }
            insert ListtoInsert;
            update ListtoUpdate;
        }
        catch(exception ex){
            //Create_Custom_Logs(String  Message,String ClassName,String MethodName,String Type)
            Exception_log.Create_Custom_Logs('Date:'+system.today()+'Error:'+ex.getMessage(),'SAL_ClientController','UpsertNBR','ApexType');
            
        }
    }
}