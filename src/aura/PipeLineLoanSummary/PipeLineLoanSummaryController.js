({
	doInit : function(component, event, helper) {
		 
        var id=component.get("v.LoanId");
      // alert(id);
		var action = component.get("c.getLoanSummary");
         action.setParams({
           
            "LoanID":id
            
        });
           action.setCallback(this, function(data) {            
          debugger;
            var result=data.getReturnValue();
            
              component.set("v.loan",result);
               //result.FinancialAsstResult='No LESA';
               if(result.FinancialAsstResult=='No LESA')
               {
                   document.getElementById('showLesa').style.display = 'none';
               }
               else
               {
                   document.getElementById('showLesa').style.display = 'block';
               }
               
               });
         $A.enqueueAction(action);
	}
})