/**
* @description  sal_decalarationcontroller - Used to fetch data for Start New Loan Declaration tab

* @author GalaxE (original)
* changelog:
* 09/19/2018: Sahitya: Added Borrower fields to display in declaration tab for SaNL, SFDC - 282
* 12/06/2018: Sahitya: SFDC-578
*/
public class sal_decalarationcontroller {
    
    @AuraEnabled
    public static List <Client__c> getclientValue(string LoanId) {
        return GenericController.getAllClientList(LoanId); 
    }
    @AuraEnabled
    public static Loan_New__c  Declarartion_TabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);            
        }
        catch(Exception ex)
        {
            system.debug(' Declarartion_TabsValidatedData----Exception---'+ex);
        }
        return objLoan;
    } 
    @AuraEnabled
    public static Declaration__c getDeclr(string ClientId) {
        Declaration__c objDeclr =new Declaration__c(); 
        try
        {
            //Code Added/Changed by Dev4 for ORMSFDC-1432
            objDeclr = [SELECT Id, Bankruptcy__c,CashtoClose__c,CashtoClose_Borrowed_Money__c, Declaration_Reason__c,
                        Delinquent__c,Delinquent_Address__c,Delinquent_Date_of_the_Debt__c,Delinquent_FHA_VA_Case__c,  
                        Delinquent_Name__c,Delinquent_Reason__c,Endorser__c,Ethnicity_New__c,FHA_Insured_Loan__c, 
                        FHA_Property_Address__c, FHA_Acc_No__c, FHA_Creditor__c, FHA_Amount__c, FHA_Unpaid_Loan__c, 
                        Lawsuit__c, Outstanding_Judgments__c, Permanent_Resident__c, Primary_Residence__c, Race__c, 
                        DeclarationClient__c, DeclarationLoan__c, ReverseMortgage__c, ReverseMortgage_Cost__c,
                        Enrolled_tribe__c,Declaration_Remarks__c,Ethnicity__c, Borrower_Ethnicity__c,Borrower_Race__c, Borrower_Sex__c,
                        ReverseMortgage_finproduct__c, Sex_New__c, US_Citizen__c FROM Declaration__c where DeclarationClient__c = :ClientId limit 1];
//Code Ended by Dev4 for ORMSFDC-1432
        }
        catch(Exception ex)
        {
            system.debug(' getDeclr----Exception---'+ex);
        }
        return objDeclr;
    }
    
    @AuraEnabled
    public static List<String> saveDeclr(Declaration__c declr,string ClientId,string LoanId){
        try
        {
            declr.DeclarationClient__c=ClientId;
            declr.DeclarationLoan__c=LoanId;
            declr.IsDeclaration_Filled_From_Tab__c=true;
            
            update declr;
            GenericController.UpdateDeclarationFlag(LoanId);
            UpdateCashflowTab(LoanId);
        }
        catch(Exception ex)
        {
            system.debug(' saveDeclr----Exception---'+ex);
        }
        return clientNameWhoMadeDeclaration(LoanId);
    }
   private static void UpdateCashflowTab(String LoanId)
   {
       loan_new__c loanObj=new loan_new__c();
       loanObj=[select Is_Loan_Created_Manually__c from loan_new__c where id=:LoanId];
       if(loanObj.Is_Loan_Created_Manually__c==false){
          loanObj.Is_CashFlow_Viewed__c=true;
           loanObj.Id=LoanId;
           update loanObj;
       }
           }
    @AuraEnabled
    public static List<ClientDeclarationDetails> AllClientsName(string loanID)
    {
        List<ClientDeclarationDetails> declarationList= new  List<ClientDeclarationDetails>();
        List <Declaration__c> ClientDeclarations =new List <Declaration__c>();
        List<Client__c> objAllclient=new List<Client__c>();
        try
        {
             objAllclient= [Select Id, Name, First_Name__c ,Last_Name__c from Client__c where LoanId__c= :loanID order by createddate];
            ClientDeclarations = [SELECT DeclarationClient__c,IsDeclaration_Filled_From_Tab__c FROM Declaration__c where IsActive__c=:true and DeclarationLoan__c = :loanID];
            for(Declaration__c obj:ClientDeclarations)
            {
                  for(Client__c c:objAllclient)
                {
                    if(c.id==obj.DeclarationClient__c)
                    {
                        ClientDeclarationDetails Objdeclaration= new  ClientDeclarationDetails();
                        Objdeclaration.ClientId= c.Id;
                        Objdeclaration.ClientFirstName= c.First_Name__c;
                        Objdeclaration.ClientLastName=c.Last_Name__c ;
                        Objdeclaration.ClientFullName=c.Name ;
                        Objdeclaration.ClientDeclarationStatus=obj.IsDeclaration_Filled_From_Tab__c;
                        declarationList.Add(Objdeclaration);
                    }
                }
             }
        }
        catch(Exception ex)
        {
            system.debug(' AllClientsName----Exception---'+ex);
        }
        return declarationList;
    }
    
    @AuraEnabled
    public static List<string> clientNameWhoMadeDeclaration(string LoanId)
    {
        List<String>ClientName=new List<String>() ;      
        List <Declaration__c> ClientDeclarations =new List <Declaration__c>();
        try
        {
            ClientDeclarations = [SELECT DeclarationClient__c FROM Declaration__c where DeclarationLoan__c = :LoanId and IsDeclaration_Filled_From_Tab__c=:true];
            for(Declaration__c obj:ClientDeclarations)
            {
                Client__c objClient=[Select Name from Client__c where id=: obj.DeclarationClient__c Limit 1 ];
                
                if(ClientName.equals(objClient.Name))
                {
                    
                }
                else
                {
                    ClientName.add(objClient.Name);
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(' clientNameWhoMadeDeclaration----Exception---'+ex);
        }
        return ClientName;
    }
    
    @AuraEnabled
    public static boolean CheckDeclaration(string LoanId)
    {
        integer clientcountDeclaration=0;
        integer clientcount=0;
        try
        {
            clientcountDeclaration = [SELECT count() FROM Declaration__c where DeclarationLoan__c = :LoanId and IsDeclaration_Filled_From_Tab__c=true and IsActive__c=:true];
            clientcount = [SELECT count() FROM Client__c where  LoanId__c= :LoanId and is_Active__c=:true];
        }
        catch(Exception ex)
        {
            system.debug(' CheckDeclaration----Exception---'+ex);
        }
        if (clientcountDeclaration==clientcount)
        {
            return true;
        }
        else{
            return false;
        }
    }
    
    //SFDC - 578
    @AuraEnabled
    public static string getApptaken(String loanID){
        Loan_New__c apptaken=new Loan_New__c();
        apptaken = [SELECT This_application_was_taken_by__c FROM Loan_New__c WHERE id=:Loanid];
        String apptakenval = apptaken.This_application_was_taken_by__c;
        if(apptaken.This_application_was_taken_by__c != 'Face to Face'){                      
            List<Declaration__c> ethnicitydec = new List<Declaration__c>();
            ethnicitydec = [SELECT id,Borrower_Ethnicity__c,Borrower_Race__c,Borrower_Sex__c FROM Declaration__c where DeclarationLoan__c = :LoanId];
            for(Declaration__c obj:ethnicitydec)
            {
                obj.Borrower_Ethnicity__c = 'N';
                obj.Borrower_Race__c = 'N';
                obj.Borrower_Sex__c = 'N';
            }
            update ethnicitydec;
        }
        return apptakenval;        
    } 
    
}
