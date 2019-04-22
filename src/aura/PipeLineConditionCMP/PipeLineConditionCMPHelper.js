({
	 PopulateCondition: function(component, event, helper) {
         debugger;
         var LoanId=component.get("v.LoanId");
        var action2 = component.get("c.getLoanConditionPipeline"); 
         
        action2.setParams({         
            LoanID:LoanId
           //LoanID:'a0Q29000002m5NqEAI'
        });
        action2.setCallback(this, function(data) {  
            debugger;
            var result= data.getReturnValue();          
             if( typeof result==='undefined'|| result==null || result=='')
             {
                 component.set("v.showNoCondition",true);
                 component.set("v.showPrintCondition",false);
             }
            else
            {
                component.set("v.showNoCondition",false);
                 component.set("v.showPrintCondition",true);
            }
                component.set("v.ConditionD",result);
            });
         
        $A.enqueueAction(action2); 
    },
    PopulateHistoryStatus: function(component, event, helper) {
         var LoanId=component.get("v.LoanId");
         var ConId=event.currentTarget.id;
        var action2 = component.get("c.getConditionHistoryStatus"); 
         
        action2.setParams({         
            LoanId:LoanId,
            conditionNumber:ConId
        });
        action2.setCallback(this, function(data) {  
            debugger;
            var result= data.getReturnValue();         
            
       		 component.set("v.ConditionStatus",result);
            });
        $A.enqueueAction(action2); 
    },
    
    PopulatCurrentStatusandCondition: function(component, event, helper) {
        debugger
         var ConId=event.currentTarget.id;
        //alert(ConId);
        var action2 = component.get("c.getConditionCurrentStatusandCondition"); 
         
        action2.setParams({ 
            CinditionId:ConId
        });
        action2.setCallback(this, function(data) {  
            debugger;
            var result= data.getReturnValue();         
            
       		 component.set("v.CurrentStatusCondition",result);
            });
        $A.enqueueAction(action2); 
    },
})