@isTest
public class TriggerNonBorrowingResidentTest {

    @isTest
    public static void TriggerNonBorrowingResidentMethodTest() {
     Loan_New__c loanManager = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                  LoanNumber__c = '12459',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                  Preferred_Contact_Type__c = 'Loan Officer');
        
        insert loanManager; 
         Client__c ClientInsertNew = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =loanManager.Id,Non_Borrowing_Date_of_Birth__c = date.parse('10/11/1925'),
                                                   Non_Borrowing_Relation__c = 'Married', Non_Borrowing_Spouse_Addres__c = 'Delhi', 
                                                   Non_Borrowing_Spouse_City__c = 'New delhi', Is_Non_Borrowing_Resident__c = true,
                                                   Non_Borrowing_Spouse_Name__c = 'Test Spouse', Non_Borrowing_Spouse_Phone_Number__c = '9654160090', 
                                                   Non_Borrowing_Spouse_State__c = 'California', Non_Borrowing_Spouse_Zip__c = '90001', 
                                                   Is_Non_Borrowing_Spouse_Filled__c = true, is_Active__c = true, Primary_Client_for_the_Loan__c=true);
           
            Insert ClientInsertNew;
            string ClientNewId = ClientInsertNew.Id;
            //List<Non_Borrowing_Resident__c> ObjNBRNotListForUpdate=new  List<Non_Borrowing_Resident__c>();
            Non_Borrowing_Resident__c ClientNBR=new Non_Borrowing_Resident__c(Loan_Id__c=loanManager.Id, Non_Borrowing_Resident_Name__c = 'Drush', 
                                                                              Relationship_to_Client__c = 'Father', Date_of_Birth__c = Date.parse('10/11/1920'),
                                                                              Monthly_Income__c = 15000.00, Client_Id__c = ClientInsertNew.Id,
                                                                              IsActiveNBR__c = true);
            
        insert ClientNBR;
       
        
    }
    
}