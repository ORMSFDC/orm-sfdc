({
	myAction : function(component, event, helper) {
		
	},

	navigateToURL : function(component, event, helper){
		var URL = component.get("v.Link");
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": URL
        });
		urlEvent.fire();
	}
})
