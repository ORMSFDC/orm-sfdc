({
	getKeyword : function(component, productType, mortgageAppliedFor, rateType) {
		var action = component.get("c.getProductKeywordWrapper");
        action.setParams({
            "productType" : productType,
            "mortgageAppliedFor" : mortgageAppliedFor,
            "rateType" : rateType
        });
        action.setCallback(this, function(response) {
            var responseState = response.getState();
            if (responseState === "SUCCESS") {
                var keyword = component.get("v.keyword");
                keyword = response.getReturnValue();
                component.set("v.keyword", keyword);
            }
        });
        $A.enqueueAction(action);
	}
})