({
	clickGetKeyword : function(component, event, helper) {
        /*
        var productType = component.get("v.cmdProduct.Product_Type__c");
        var mortgageAppliedFor = component.get("v.cmdProduct.Mortgage_Applied_for__c");
        var rateType = component.get("v.cmdProduct.Rate_Type__c");
        */
        var productType = component.get("v.loan.Product_Type__c");
        var mortgageAppliedFor = component.get("v.loan.Mortgage_Applied_for__c");
        var rateType = component.get("v.loan.Rate_Type__c");
		helper.getKeyword(component, productType, mortgageAppliedFor, rateType);
	}
})