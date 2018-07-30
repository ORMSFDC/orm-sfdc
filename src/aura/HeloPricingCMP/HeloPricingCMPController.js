({
    doInit : function(component, event, helper) {        
        var action = component.get("c.getHeloRateORM");
        action.setCallback(this, function(a) {
            debugger;
            var result=a.getReturnValue();
            component.set("v.HeloRate", result);
            component.set("v.IsSpinner",false);
            window.scroll(0, 0);
        });
        $A.enqueueAction(action);
    }
})