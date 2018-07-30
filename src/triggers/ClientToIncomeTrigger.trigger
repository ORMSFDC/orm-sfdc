trigger ClientToIncomeTrigger on Client__c (after insert) {
    
    for(Client__c  c:trigger.new) {
     string clientID = c.Id;
     string LoanId = c.LoanId__c;
        
        //Loan_New__c obbjLoan = new Loan_New__c();
        //obbjLoan=[select Related_Individual__c,Related_Partner__c from Loan_New__c where id=:LoanId];
        
        Income__c Income = new Income__c();
        Income.Bonus_Income__c = 0.00;
        Income.OverTime_Income__c = 0.00;
        Income.Commissions_Income__c = 0.00;
        Income.Dividents_Interest_Income__c = 0.00;
        Income.Base_Employment_Income__c = 0.00;
        Income.Net_Rental_Income__c = 0.00;
        Income.RelatedClient__c = clientID;
        Income.isActive__c = true;
        Income.Related_Loan__c = c.LoanId__c;
        //Income. = obbjLoan.Related_Individual__c
        //Income.Related_Partner__c = obbjLoan.Related_Partner__c
        
        insert Income;
        system.debug('income data'+ Income);
}

}