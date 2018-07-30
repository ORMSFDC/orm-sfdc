({
    doInit : function(component, event, helper) {  
        window.scrollTo(0, 0);
        var action = component.get("c.getProcessContents");
        
        action.setCallback(this, function(a) {
            component.set("v.ReverseContent", a.getReturnValue());
        });
        $A.enqueueAction(action);
    }
    
})