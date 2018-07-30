({
	 	    doInit : function(component, event, helper) {        
        			var action = component.get("c.getResourceForms");
                  
        			action.setCallback(this, function(a) {
            		component.set("v.ResourceForm", a.getReturnValue());
        				});
       			 $A.enqueueAction(action);
    			 }
	 	    }
})