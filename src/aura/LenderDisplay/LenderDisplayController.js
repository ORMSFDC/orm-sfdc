({
    doInit : function(component, event, helper) {        
        var action = component.get("c.getLender");
        
        action.setCallback(this, function(a) {
            component.set("v.lender", a.getReturnValue());
            debugger;
            //helper.GetMessagforDisplay(component, event, helper);
        });
        $A.enqueueAction(action);
    }
    
})