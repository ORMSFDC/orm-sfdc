({
	 	    doInit : function(component, event, helper) {        
        			var action = component.get("c.getFAQContents");
                  
        			action.setCallback(this, function(a) {
            		component.set("v.FAQ", a.getReturnValue());
        				});
       			 $A.enqueueAction(action);
    			 }
	 	    }
})