public with sharing class SAL_LoanDetailsController {
    
    @AuraEnabled
    public static Loan_New__c GetLoanDetailsById(id LoanID)
    {
        Loan_New__c LoanDetails=new  Loan_New__c();
        try
        {
            LoanDetails =  [SELECT  Originating_Loan_Officer__c, LoanOfficer__c,Loan_Processor__c,Preferred_Contact_Type__c,Id, Title_Company__c,Tell_the_story__c, Contact_Name__c,Contact_Email__c, Using_Title_Source_as_the_Closing_Agent__c,
                            Advanced_Fee_disclosures__c, Contact_Phone_Number_LoanDetails__c FROM Loan_New__c where id = : LoanId];
             
         }
        catch(Exception ex)
        {
            system.debug(' GetLoanDetailsById----Exception---'+ex);
        }
        return LoanDetails;
    }
    
   
    //Code Ended for Story No:- ORMSFDC-1275 by Dev4-->
    @AuraEnabled
    public static Loan_New__c  LoanDetailsTabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);
            
        }
        catch(Exception ex)
        {
            system.debug(' LoanDetailsTabsValidatedData----Exception---'+ex);
        }
        return objLoan;
    }
    
    
    //<!--Code Started for Story No:- ORMSFDC-1275 by Dev4-->
    @AuraEnabled
    public static Loan_New__c GetLoanContactsById(id LoanID)
    {
        Loan_New__c LoanContacts=new  Loan_New__c();
        try
        {
            LoanContacts =  [SELECT  IsLoanCreatedByLoanProcessor__c,createdbyid,Originating_Loan_Officer__c,Name,LoanOfficer__c, Loan_Processor__c, Preferred_Contact_Type__c FROM Loan_New__c where id = : LoanId];
        if(LoanContacts.Originating_Loan_Officer__c!=null && LoanContacts.IsLoanCreatedByLoanProcessor__c){
                if(LoanContacts.LoanOfficer__c==null){
                    LoanContacts.LoanOfficer__c=LoanContacts.Originating_Loan_Officer__c;
                    LoanContacts.Loan_Processor__c=LoanContacts.createdbyid;
                }
            }
             If(!LoanContacts.IsLoanCreatedByLoanProcessor__c )
            {
                 if(LoanContacts.LoanOfficer__c==null){
                    LoanContacts.LoanOfficer__c=LoanContacts.createdbyid;
                }
               
            }
            if(LoanContacts.Preferred_Contact_Type__c==null)
        {
            LoanContacts.Preferred_Contact_Type__c='Loan Officer';
        }
        }
        catch(Exception ex)
        {
            system.debug(' GetLoanContactsById----Exception---'+ex);
        }
        return LoanContacts;
    }
    
    @AuraEnabled
    public static String getUserId(id LoanID) {
        
        return  UserInfo.getUserId(); 
        //return '005q0000003QP0GAAW';
    }
    
    @AuraEnabled
    public static List<LoanOfficerResponse>  getLoanOfficerList() {
        
     
        List<LoanOfficerResponse> ListLoanOfficer = New List<LoanOfficerResponse>();
    	 ListLoanOfficer=GenericController.getLoanOfficer();
        return ListLoanOfficer;
    }
    
    @AuraEnabled
    public static List<LoanProcessorResponse>  getLoanProcessorList() {
        List<Contact> Objcon = new List<Contact>();
        List<Contact> ObjConId = new List<Contact>();
        User MatchedUsers = new User();
        List<User> UserList = new List<User>();
        List<LoanProcessorResponse> ListLoanProcessor = New List<LoanProcessorResponse>();
        try
        {
             MatchedUsers = [select id, Name, contactId,AccountId from User where id = : userinfo.getUserId()];
            Profile p = [SELECT Id FROM Profile WHERE Name='Portal Loan Processors'];
            Profile p1 = [SELECT Id FROM Profile WHERE Name='Portal Loan Processor'];
            UserList = [select Id, Name from User where AccountId =: MatchedUsers.AccountId and (ProfileID =:p.Id or ProfileID =:p1.Id) and IsActive = true];
            //for(Contact Contactusr: Objcon){
            
            for(user usr : UserList){
                LoanProcessorResponse ObjLoanProcessor = New LoanProcessorResponse();
                //if(Contactusr.Id == usr.ContactId){                         
                ObjLoanProcessor.Id = usr.Id;
                ObjLoanProcessor.LoanProcessorName=usr.Name;
                ListLoanProcessor.add(ObjLoanProcessor);                         
               
            }
        }
        catch(Exception ex)
        {
            system.debug(' ListLoanProcessor----Exception---' + ex);
        }
        return ListLoanProcessor;
    }
     
    @AuraEnabled
    public static void SaveLoanWithPreferredContact(Loan_New__c objNewLoan,id loanID,string LO,string LP,string PC) {
        
        try{
            
            objNewLoan.Id = loanID;
            objNewLoan.LoanOfficer__c =LO;
            objNewLoan.Loan_Processor__c =   LP; 
            objNewLoan.Preferred_Contact_Type__c = PC;
            objNewLoan.IsLoanDetailsFilled_Flag__c = true;
            objNewLoan.IsLoanContactFilled_Flag__c=true;
            upsert objNewLoan;
            
        }
        catch(Exception ex)
        {
            system.debug(' SaveLoanWithPreferredContact-'+ex);
            
        }
        
    }
    //<!--Code Ended for Story No:- ORMSFDC-1275 by Dev4-->
    //
    //Get UserId of Logged in User
    //Code by Developer-2 for story-1661
   /* @AuraEnabled
    public static string  GetUserId()
    {
        String Userid='';
         Userid=UserInfo.getUserId();
        return Userid;
    }*/
   /* @AuraEnabled
    public static boolean  getLoanProcessor(id LoanID) {        
    	 boolean lp=[select IsLoanCreatedByLoanProcessor__c from Loan_new__c where id=:LoanID].IsLoanCreatedByLoanProcessor__c; 
        return lp;
    }*/
     @AuraEnabled
    public static LPLO_Response  getLoanProcessor(id LoanID) {     
        LPLO_Response res=new LPLO_Response();
        res.LoanProcessor=true;
        res.LoanOfficer=false;
        Loan_new__c LoanObj=[select IsLoanCreatedByLoanProcessor__c,Originating_Loan_Officer__c,Createdbyid,LoanOfficer__c
                      from Loan_new__c where id=:LoanID];
        //Loan created by LP
        if(LoanObj.IsLoanCreatedByLoanProcessor__c){
            ID LoggedInUser=Userinfo.getUserId();
            if(LoanObj.LoanOfficer__c!=null && LoanObj.Originating_Loan_Officer__c!=null
               &&(LoggedInUser!=LoanObj.Originating_Loan_Officer__c)&&(LoanObj.LoanOfficer__c==LoggedInUser))
            {
                   res.LoanOfficer=true;
                
            }
        }
        //Loan Created by LO
        else{
            if(LoanObj.CreatedById==Userinfo.getUserId())
            {
                res.LoanProcessor=false;               
            }             
            else
            {
                 res.LoanOfficer=true;              
            } 
        }
                
        
        return res;
    }
    public Class LPLO_Response
    {
      @AuraEnabled public   Boolean LoanProcessor { get;set; }
    @AuraEnabled public   Boolean LoanOfficer { get;set; }  
    }
}