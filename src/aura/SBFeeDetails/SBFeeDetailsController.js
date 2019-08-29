({
	NavigatetoC1 : function(component, event, helper) {
		var evt = $A.get("e.force:navigateToComponent");
        var recId = component.get("v.recordId");
		evt.setParams({
			componentDef : "c:SilverBulletFeeDetails",
            componentAttributes: {
            "loanId" : recId
        }
		});
		evt.fire();
	}
})