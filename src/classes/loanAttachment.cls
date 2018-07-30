public class loanAttachment{
    public Id loanId{get; set;}
    public List<Loan_New__c> getLoan(){
    
        List<Loan_New__c> loanList = new List<Loan_New__c>();
            loanList = [Select Name, Client_Name__c, LoanNumber__c, Purpose_of_Loan__c, LoanStatus__c, Subject_Property_Address__c
                        FROM Loan_New__c];
        return loanList;
   }
}