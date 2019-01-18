({
	clickGetKeyword : function(component, event, helper) {
        var state = component.get("v.state");
		helper.getKeyword(component, state);
	}
})