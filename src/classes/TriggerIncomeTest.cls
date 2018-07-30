@isTest
public class TriggerIncomeTest {

    @isTest
    public static void TriggerIncomeMethodTest() {
     Loan_New__c loanManager = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                  LoanNumber__c = '12459',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                  Preferred_Contact_Type__c = 'Loan Officer');
        
        insert loanManager; 
        Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='California', Zip__c = '90001',
                                                LoanId__c =loanManager.Id);
        Insert ClientInsert;
       Income_New__c IncomeInsert = new Income_New__c(Income_Source__c='',Income_Types__c='',Income_Value__c=0.00,
                                                RelatedClient__c = ClientInsert.Id, isActive__c = true, Related_Loan__c = loanManager.Id);
        insert IncomeInsert;
        
    }
    
}