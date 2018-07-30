@isTest
public class TriggerEmploymentTest {

    @isTest
    public static void TriggerEmploymentMethodTest() {
     Loan_New__c loanManager = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                                  LoanNumber__c = '12459',Appraisal_Received_Date__c=Date.parse('10/11/2017'),                                            
                                                  Preferred_Contact_Type__c = 'Loan Officer');
        
        insert loanManager; 
        
      Employment__c objEmployment = new Employment__c(City__c = 'Ghaziabad',EmployerAddress__c = 'Delhi',
            EmployerName__c = 'ORMS',EmployerPhone__c = '7894561230',Months__c = 2,
            PositionTitle__c = 'Manager',RelatedLoan__c = loanManager.Id,
            State__c = 'California',Years__c = 2,IncomeValue__c = 0.00, Income_Type__c = 'Employment Income');
        Insert objEmployment;   
    }
}