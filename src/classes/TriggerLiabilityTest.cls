@isTest
public class TriggerLiabilityTest {

    @isTest
    public static void TriggerLiabilityMethodTest() {
     Loan_New__c loanManager = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                  LoanNumber__c = '12459',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                  Preferred_Contact_Type__c = 'Loan Officer');
        
        insert loanManager; 
        Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='California', Zip__c = '90001',
                                                LoanId__c =loanManager.Id);
        Insert ClientInsert;
       Liability__c liability = new Liability__c(isActive__c = true, RelatedClient__c = ClientInsert.Id, RelatedLoan__c = loanManager.Id, Liability_Category__c = 'Alimony', Liability_Type__c  = 'Divorce');
        Insert liability;
        
    }
    
}