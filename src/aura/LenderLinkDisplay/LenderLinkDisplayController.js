({
	 	    doInit : function(component, event, helper) {
                
        			var action = component.get("c.getLenderLinks");
                  
        			action.setCallback(this, function(a) {
            		component.set("v.lenderlink", a.getReturnValue());
        				});
       			 $A.enqueueAction(action);
    			 }
	 	    
})