({
	 	    doInit : function(component, event, helper) {        
        			var action = component.get("c.getContacts");
                  
        			action.setCallback(this, function(a) {
            		component.set("v.Contact", a.getReturnValue());
        				});
       			 $A.enqueueAction(action);
    			 }
	 	    }
})