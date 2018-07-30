({
    LoanLoad : function(component) {
        var action = component.get("c.getName");
        action.setCallback(this, function(data) {
            var state = data.getState();
            var result=data.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.loan",result);
            }
            else
            {
            }
            document.getElementById('spinner').style.display = 'none';
        }); 
        $A.enqueueAction(action);
        
    }
})