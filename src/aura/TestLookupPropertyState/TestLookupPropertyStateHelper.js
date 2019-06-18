({
	getKeyword : function(component, state) {
		var action = component.get("c.getPropertyStateKeywordWrapper");
        action.setParams({
            "state" : state
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