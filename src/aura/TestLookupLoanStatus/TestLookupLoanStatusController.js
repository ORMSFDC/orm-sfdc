({
	clickGetKeyword : function(component, event, helper) {
        /*
        var loanStatus = component.get("v.cmdLoanStatus.Loan_Status__c");
        */
        var loanStatus = component.get("v.loan.LoanStatus__c");
		helper.getKeyword(component, loanStatus);
	}
})