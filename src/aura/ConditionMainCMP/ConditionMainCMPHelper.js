({
    
    PopulateCount : function(component, event, helper) {
        var LoanId=component.get("v.recordId");
        var action2 = component.get("c.getConditionCount");        
        action2.setParams({         
            LoanId:LoanId
        });
        action2.setCallback(this, function(data) {           
            var result= data.getReturnValue();          
            if(result>1)
            {
                
                component.set("v.DisplayViewall",true);
            }
            component.set("v.ConditionCount",result);
        });
        $A.enqueueAction(action2);  
        
    },
    PopulateCondition: function(component, event, helper) {
        var LoanId=component.get("v.recordId");
        var action2 = component.get("c.getLoanCondition"); 
        
        action2.setParams({         
            LoanID:LoanId
        });
        action2.setCallback(this, function(data) {  
            debugger;
            var result= data.getReturnValue();          
            result=result.slice(0, 6);
            component.set("v.ConditionD",result);
        });
        $A.enqueueAction(action2); 
    },
})