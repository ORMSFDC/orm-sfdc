({
	clickGetKeyword : function(component, event, helper) {
        var state = component.get("v.loan.Subject_Property_State__c");
		helper.getKeyword(component, state);
	}
})