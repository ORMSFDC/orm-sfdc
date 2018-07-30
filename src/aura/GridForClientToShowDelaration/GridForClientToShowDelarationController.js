({
	 doInit: function(component, event, helper) {
        
        //helper.PopulateClientsbyDeclaration(component, event, helper);
        var _Loanid = component.get("v.LoanId");
        //alert('hello' + _Loanid);
        var action1 = component.get("c.AllClientsName");
        action1.setParams({
            "loanID": _Loanid
        });
        action1.setCallback(this, function(data) {
            
            var ReturnData = data.getReturnValue();
                alert(ReturnData);
            component.set("v.clientRecords", data.getReturnValue());
             
            
        });
        $A.enqueueAction(action1);
    },
})