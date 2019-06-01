({
	doInit : function(component, event, helper) {
		var action = component.get("c.getLoggedInUserInfo");
		
		action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
				component.set("v.Link", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},


	navigateToURL : function(component, event, helper){
		var URL = component.get("v.Link");
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": URL
        });
		urlEvent.fire();
	},

	navigateToURL2 : function(component, event, helper){
		var URL = component.get("v.Link2");
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": URL
        });
		urlEvent.fire();
	}

})