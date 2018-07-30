({
	 	    doInit : function(component, event, helper) {        
        			var action = component.get("c.getReversityContents");
                  
        			action.setCallback(this, function(a) {
            		component.set("v.ReverseContent", a.getReturnValue());
        				});
       			 $A.enqueueAction(action);
    			 }
	 	    }
})