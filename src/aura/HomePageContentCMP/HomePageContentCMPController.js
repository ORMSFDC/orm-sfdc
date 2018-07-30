({
	 	    doInit : function(component, event, helper) {        
        			var action = component.get("c.getHomeContents");
                  
        			action.setCallback(this, function(a) {
            		component.set("v.HomePageContent", a.getReturnValue());
        				});
       			 $A.enqueueAction(action);
    			 }
	 	    
})