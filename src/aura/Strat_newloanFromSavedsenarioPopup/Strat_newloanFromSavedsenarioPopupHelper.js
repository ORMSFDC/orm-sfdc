({
	helperMethod : function(component,loanid,senarioid) {
        alert(senarioid);
		 var action = component.get("c.updateSenario");
        action.setParams({
            senarioid:senarioid,
			loanId:loanid
        });
        
        action.setCallback(this,function(data){
         //   alert('loan updated');
       
        });
        $A.enqueueAction(action);
       
	}
})