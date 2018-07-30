({
	doInit : function(component, event, helper) {
        
        var LoanId=component.get("v.LoanId");
        var ConId=component.get("v.ConditionId");
        //alert(ConId);
         var action = component.get("c.getConditionById");
        action.setParams({
            
            "ConditionId":ConId
            
        });
        action.setCallback(this, function(data) {            
            debugger;
            
            var result=data.getReturnValue();
            
           
            component.set("v.ConditionData",result);
        });
        $A.enqueueAction(action);
		
	},
    SaveEditCondition:function(component, event, helper) {
       debugger;
        var retvalidate=helper.validateCondition(component, event, helper);
        if(retvalidate==true)
        {
            
        }
        else
        {
            
        helper.EditCondition(component, event, helper);
            
            }
    },
})