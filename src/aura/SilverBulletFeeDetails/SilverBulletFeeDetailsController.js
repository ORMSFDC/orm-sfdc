({
    doInit : function(component, event, helper) {
        var action = component.get("c.getServiceData");
        var loanId = component.get("v.loanId");
        action.setParams({"loanId" : loanId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
                var obj = JSON.parse(JSON.stringify(response.getReturnValue()));
                component.set("v.ServiceDataList",obj.feeDetails);
                component.set("v.totalAmount",obj.totalAmount);
            }
            else if (state === "INCOMPLETE") {
                alert('--incomplete--');
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            alert('--'+errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                        alert('Unknown error');
                    }
                }
        });
        $A.enqueueAction(action);
        
    }
})