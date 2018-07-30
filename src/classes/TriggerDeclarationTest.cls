@isTest
public class TriggerDeclarationTest {

    @isTest
    public static void TriggerDeclarationMethodTest() {
     Loan_New__c loanManager = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                  LoanNumber__c = '12459',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                  Preferred_Contact_Type__c = 'Loan Officer');
        
        insert loanManager; 
        Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='California', Zip__c = '90001',
                                                LoanId__c =loanManager.Id);
        Insert ClientInsert;
       Declaration__c ojDeclaration = new Declaration__c(Name = 'DRUSH', IsActive__c=true, IsDeclaration_Filled_From_Tab__c = true, DeclarationLoan__c = loanManager.Id, DeclarationClient__c = ClientInsert.Id);
        Insert ojDeclaration;
        
    }
    
}