({
	clickGetKeyword : function(component, event, helper) {
        /*
        var productType = component.get("v.cmdPurposeOfRefinance.Product_Type__c");
        var mortgageAppliedFor = component.get("v.cmdPurposeOfRefinance.Mortgage_Applied_for__c");
        var rateType = component.get("v.cmdPurposeOfRefinance.Rate_Type__c");
        */
        var productType = component.get("v.loan.Product_Type__c");
        var mortgageAppliedFor = component.get("v.loan.Mortgage_Applied_for__c");
        var rateType = component.get("v.loan.Rate_Type__c");
		helper.getKeyword(component, productType, mortgageAppliedFor, rateType);
	}
})