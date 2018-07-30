({
	myAction : function(component, event, helper) {
		var action = component.get("c.create_task");
        action.setCallback(this,function(){          
          alert(getReturnValue());            
        });       
        $A.enqueueAction(action);        
	}
})