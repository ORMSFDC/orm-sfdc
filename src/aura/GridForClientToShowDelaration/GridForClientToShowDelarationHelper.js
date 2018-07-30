({
	 PopulateClientsbyDeclaration: function(component, event, helper) {
        var _Loanid = component.get("v.LoanId");
       
        var action1 = component.get("c.GetAllClientsName");
        action1.setParams({
            "loanID": _Loanid
        });
        action1.setCallback(this, function(data) {
            component.set("v.clientRecords", data.getReturnValue());
            if(data.getState()==='SUCCESS')
            {
                var ReturnData = data.getReturnValue();
                alert(ReturnData.Name);
            }
            
        });
        $A.enqueueAction(action1);
    },
})