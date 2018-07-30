public class Loan_Xml_ctrl{

    public Loan_New__c LN {get;set;}
    public map<String,String>  mappings {get;set;}
    public String mappingString {get;set;}
    public String FileName {get;set;}
    public Loan_Xml_ctrl(){
        
        
        String LoanId= ApexPages.currentpage().getParameters().get('id');
        
        LN = new Loan_New__c();
        Liability__c lb = new Liability__c();
        Client__c primaryClient = new Client__c();
        mappings = new map<String,String>();
        
      
        
        LN = [select id,Name,LoanNumber__c,Subject_Property_Zip_Code__c,Subject_Property_City__c,Subject_Property_Address__c,Estimate_of_Appraised_Value__c from Loan_New__c where id =:LoanId];
   try{
    primaryClient = [ SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Address_Mailing__c, Check_if_Mailing_Address_is_similar_to_P__c, City_Mailing__c, City__c, Client_has_Email_Address__c, DOB__c, Email_Optional__c, First_Name__c, Home_Phone__c, Last_Name__c, LoanId__c, Marital_Status__c, Middle_Name__c, Non_Borrowing_Date_of_Birth__c, Non_Borrowing_Relation__c, Non_Borrowing_Spouse_Addres__c, Non_Borrowing_Spouse_City__c, Non_Borrowing_Spouse_Name__c, Non_Borrowing_Spouse_Phone_Number__c, Non_Borrowing_Spouse_State__c, Non_Borrowing_Spouse_Zip__c, Non_Borrowing_Spouse__c, Number_of_years__c, Phone_Number__c, Primary_Client_for_the_Loan__c, Property_type__c, Residence__c, Social_Security_Number__c, State_Mailing__c, State__c, Street_Address__c, Zip_Mailing__c, Zip__c, is_Active__c, FHA_Insured_Loan__c, Client_Address_Same_As_Primary_Client__c, Spouse_Mailing_Address_same_as_client__c,
                                Address_Same_As_SubjectProperty__c FROM Client__c 
                                where LoanId__c=:LN.id and Primary_Client_for_the_Loan__c=true limit 1];
       }catch(Exception ex){}                         
       Client__c SecondartClient =new Client__c();
       try{
       SecondartClient =  [ SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Address_Mailing__c, Check_if_Mailing_Address_is_similar_to_P__c, City_Mailing__c, City__c, Client_has_Email_Address__c, DOB__c, Email_Optional__c, First_Name__c, Home_Phone__c, Last_Name__c, LoanId__c, Marital_Status__c, Middle_Name__c, Non_Borrowing_Date_of_Birth__c, Non_Borrowing_Relation__c, Non_Borrowing_Spouse_Addres__c, Non_Borrowing_Spouse_City__c, Non_Borrowing_Spouse_Name__c, Non_Borrowing_Spouse_Phone_Number__c, Non_Borrowing_Spouse_State__c, Non_Borrowing_Spouse_Zip__c, Non_Borrowing_Spouse__c, Number_of_years__c, Phone_Number__c, Primary_Client_for_the_Loan__c, Property_type__c, Residence__c, Social_Security_Number__c, State_Mailing__c, State__c, Street_Address__c, Zip_Mailing__c, Zip__c, is_Active__c, FHA_Insured_Loan__c, Client_Address_Same_As_Primary_Client__c, Spouse_Mailing_Address_same_as_client__c,
                                Address_Same_As_SubjectProperty__c FROM Client__c 
                                where LoanId__c=:LN.id and Primary_Client_for_the_Loan__c =false  Order by Createddate desc limit 1]; 
                                
                                }catch(exception ex){}  
                                
        FileName = LN.Name + '_'+system.today();
        FileName = FileName.replace('00:00:00','');                        
     try{
         lb = [select id,Property_Status__c,Mortgage_Liens__c from Liability__c where RelatedLoan__c=:LN.id and Property_Status__c='Subject Property' limit 1];
     }catch(Exception ex){}                      
             mappings.put('BR_LoanId',Ln.Name);
             mappings.put('BR_CITY',Ln.Subject_Property_City__c);
             mappings.put('BR_Address1',Ln.Subject_Property_Address__c);
             mappings.put('BR_Address2','null');
             mappings.put('BR_LoanId',Ln.Name);
              mappings.put('BR_ZIP',Ln.Subject_Property_Zip_Code__c);
               mappings.put('BR_PropertyValue',''+Ln.Estimate_of_Appraised_Value__c);
               
               mappings.put('BR_Lines',''+lb.Mortgage_Liens__c);
             mappings.put('BR_uniqueKey',LN.LoanNumber__c);
             //primary Borrower mappings 
             
              mappings.put('First_name',primaryClient.First_Name__c);
              mappings.put('Middle_Name',primaryClient.Middle_Name__c);
              mappings.put('Last_Name',primaryClient.Last_Name__c);
              string brdob = ''+primaryClient.DOB__c;
              mappings.put('BR_DOB',''+brdob.replace('00:00:00',''));
              mappings.put('BR_Phone',primaryClient.Home_Phone__c);
              mappings.put('BR_Mobile',primaryClient.Phone_Number__c);
              mappings.put('BR_Email',primaryClient.Email_Optional__c);
              
              
              //Co Borrower mappings 
             
              mappings.put('CO_BR_FName',SecondartClient.First_Name__c);
              mappings.put('CO_BR_MName',SecondartClient.Middle_Name__c);
              mappings.put('CO_BR_LName',SecondartClient.Last_Name__c);
              string cobrdob = ''+SecondartClient.DOB__c;
              mappings.put('CO_BR_DOB',''+cobrdob.replace('00:00:00',''));
             /// mappings.put('BR_Phone',primaryClient.Home_Phone__c);
             // mappings.put('BR_Mobile',primaryClient.Phone_Number__c);
             // mappings.put('BR_Email',primaryClient.Email_Optional__c);
              
             mappingString  = JSON.serialize(mappings);
    }

}