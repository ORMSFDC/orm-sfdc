public class SAL_LoanContactController {
    
         @AuraEnabled
    public static Loan_New__c  LoanContact_TabsValidatedData(string RecordId) 
    {    
        Loan_New__c objLoan = new Loan_New__c();  
        try
        { 
            objLoan  = GenericController.TabsData(RecordId);
            
        }
        catch(Exception ex)
        {
            system.debug(' LoanContact_TabsValidatedData----Exception---'+ex);
        }
        return objLoan;
    } 
    @AuraEnabled
    public static Loan_New__c GetLoanContactsById(id LoanID)
    {
        Loan_New__c LoanContacts=new  Loan_New__c();
        try
        {
            LoanContacts =  [SELECT  Name,LoanOfficer__c, Loan_Processor__c, Preferred_Contact_Type__c FROM Loan_New__c where id = : LoanId];
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
        List<Contact> Objcon = new List<Contact>();
        List<Contact> ObjConId = new List<Contact>();
        User MatchedUsers = new User();
        List<LoanOfficerResponse> ListLoanOfficer = New List<LoanOfficerResponse>();
        try
        {
            //id CUId = '00539000005aJctAAE'; //UserInfo.getUserId();
            //userId='00539000005aJctAAE';
            //Profile p = [SELECT Id FROM Profile WHERE Name='ORM Partners'];
            MatchedUsers = [select id, Name, contactId,AccountId,ProfileID from User where id = : userinfo.getUserId()];
            //Objcon = [Select Id,AccountId,Title__c,Name from Contact where AccountId=:u.AccountId and Title__c='Loan officer'];
            //ObjConId=[Select Id from Contact where AccountId=:u.AccountId and Title__c='Loan officer'];
            //MatchedUsers = [select Id, Name,contactId from User where contactId IN: ObjConId and IsActive = true];
            List<user> usrList=new List<user>();
            usrList= [select Id, Name from User where AccountId =: MatchedUsers.AccountId and ProfileID =:MatchedUsers.ProfileID and IsActive = true];
            //for(Contact Contactusr: Objcon){
            
            for(user usr : usrList){
                LoanOfficerResponse ObjLoanOfficer = New LoanOfficerResponse();
                //if(Contactusr.Id == usr.ContactId){ 
                ObjLoanOfficer.Id = usr.Id;
                ObjLoanOfficer.LoanofficerName=usr.Name;
                ListLoanOfficer.add(ObjLoanOfficer);
            }
            //}
        }
        
        catch(Exception ex)
        {
            system.debug(' ListLoanOfficer----Exception---' + ex);
        }
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
            id CUId = '00539000005aJctAAE'; //UserInfo.getUserId();
            //userId='00539000005aJctAAE'; 0013900001YLlLmAAL
            MatchedUsers = [select id, Name, contactId,AccountId from User where id = : userinfo.getUserId()];
            Profile p = [SELECT Id FROM Profile WHERE Name='Portal Loan Processors'];
            Profile p1 = [SELECT Id FROM Profile WHERE Name='Portal Loan Processor'];
         
            //MatchedUsers = [select id, Name, contactId,AccountId from User where id = : userinfo.getUserId() and 
            // IsActive = true];
            //Objcon = [Select Id,AccountId,Title__c,Name from Contact where AccountId=:u.AccountId and Title__c='Processor'];
            //ObjConId=[Select Id from Contact where AccountId=:u.AccountId and Title__c='Processor'];
            UserList = [select Id, Name from User where AccountId =: MatchedUsers.AccountId and (ProfileID =:p.Id or ProfileID =:p1.Id) and IsActive = true];
            //for(Contact Contactusr: Objcon){
            
            for(user usr : UserList){
                LoanProcessorResponse ObjLoanProcessor = New LoanProcessorResponse();
                //if(Contactusr.Id == usr.ContactId){                         
                ObjLoanProcessor.Id = usr.Id;
                ObjLoanProcessor.LoanProcessorName=usr.Name;
                ListLoanProcessor.add(ObjLoanProcessor);                         
                //}
                
                
                //}
                
            }
        }
        catch(Exception ex)
        {
            system.debug(' ListLoanProcessor----Exception---' + ex);
        }
        return ListLoanProcessor;
    }
    
    //Save Asset(Insert/Update)
    @AuraEnabled
    public static integer SavePreferredContact(string LO,string LP,string PC,string LoanID) {
        integer i =0;
        try{
            Loan_new__c objloan=new loan_new__c();
            objloan.Id=LoanID;
            objloan.LoanOfficer__c =LO;
            objloan.Loan_Processor__c =   LP; 
            objloan.Preferred_Contact_Type__c = PC;
            objloan.IsLoanContactFilled_Flag__c=true;
            upsert objloan;
            i=1;
        }
        catch(Exception ex)
        {
            system.debug(' SavePreferredContact-'+ex);
            i=0;
        }
        return i;
    }
   
}