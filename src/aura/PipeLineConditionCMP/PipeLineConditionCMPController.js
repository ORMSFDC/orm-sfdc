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
    
    // Code added for Story No:- 1088 by Developer 3 
    openPDF : function(component, event, helper) {
        var host = window.location.hostname;
        //var frameSrc = 'https://ormmortgageservices--devsandbox--c.cs19.visual.force.com/apex/ConditionPDF?id=a0Q29000002d4seEAA';
        var frameSrc = 'https://' + host + '/apex/ConditionPDF?id=' + component.get('v.LoanId');
        window.open(frameSrc, '_blank');
    }
    // End of Code change
})