({
	clickGetKeyword : function(component, event, helper) {
        var productType = component.get("v.productType");
        var mortgageAppliedFor = component.get("v.mortgageAppliedFor");
        var rateType = component.get("v.rateType");
		helper.getKeyword(component, productType, mortgageAppliedFor, rateType);
	}
})