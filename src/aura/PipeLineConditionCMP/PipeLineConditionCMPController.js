({
	doInit: function(component, event, helper) {  
          
      helper.PopulateCondition(component, event, helper) ;  
     
    },  
    display: function(component, event, helper) { 
     
       
         component.set("v.showPopup",true); 
        
      helper.PopulateHistoryStatus(component, event, helper) ;  
        helper.PopulatCurrentStatusandCondition(component, event, helper) ;  
     
    }, 
     closeDeleteModel : function(component, event, helper) {
        component.set("v.showPopup",false);
    },
    
    openPDF : function(component, event, helper) {
        var action = component.get("c.getBaseURL");
        action.setCallback(this, function(data) {            
            var result=data.getReturnValue();
            var frameSrc= result + '/apex/ConditionPDF?id=' + component.get('v.LoanId');
            window.open(frameSrc, '_blank');
        });
        $A.enqueueAction(action);  
    }
    
})