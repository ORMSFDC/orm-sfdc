@isTest()
private class loanAttachment_test{

    static testMethod void getloanAttachment(){
    
        Loan_New__c l = new Loan_New__c();
        l.loanstatus__c = 'Proposal';
        
        insert l;
        
        loanAttachment classObject = new loanAttachment();
        List<Loan_New__c> loanList = new List<Loan_New__c>();
        classObject.loanId = l.Id;
        loanList = classObject.getLoan();
        
        System.assertNotEquals(0,loanList.size());
        
    
    }

}