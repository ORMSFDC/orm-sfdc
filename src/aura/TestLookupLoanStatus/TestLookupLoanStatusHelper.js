({
	getKeyword : function(component, loanStatus) {
		var action = component.get("c.getLoanStatusKeywordWrapper");
        action.setParams({
            "loanStatus" : loanStatus
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