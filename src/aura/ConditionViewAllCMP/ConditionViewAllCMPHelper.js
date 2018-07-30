({
    showSpinner:function(component){ 
        component.set("v.IsSpinner",true); 
    },
    
    hideSpinner:function(component){ 
        component.set("v.IsSpinner",false); 
    },
    LoanName : function(component, event, helper) {
        var LoanId=component.get("v.recordId");
        var action2 = component.get("c.getLoanName");        
        action2.setParams({         
            LoanId:LoanId
        });
        action2.setCallback(this, function(data) {           
            var result= data.getReturnValue();        
            component.set("v.LoanName",result);            
        });
        $A.enqueueAction(action2);         
    },
    PopulateCount : function(component, event, helper) {
        var LoanId=component.get("v.recordId");
        var action2 = component.get("c.getConditionCount");        
        action2.setParams({         
            LoanId:LoanId
        });
        action2.setCallback(this, function(data) {           
            var result= data.getReturnValue();      
            component.set("v.ConditionCount",result);
            helper.hideSpinner(component) ;
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
            component.set("v.ConditionD",result);
        });
        $A.enqueueAction(action2); 
    },
})