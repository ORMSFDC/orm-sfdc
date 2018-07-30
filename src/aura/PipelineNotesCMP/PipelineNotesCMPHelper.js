({
	LoadNotes : function(component) {
        var id = component.get("v.Loan");
       //alert(id);
		var action = component.get("c.fetchNotes");
        action.setParams({
        
                "Loan_Id": id
    });
    
        action.setCallback(this, function(data) {
            var state = data.getState();
            //alert(state);
            var result=data.getReturnValue();
           //alert(result.Body__c);
            console.log(result);
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.Content",result);
                //alert("data present");
             
            }
            else
            {console.log("Failed with state: " + state);
             //alert("No data Present");
            }
       
        }); 
        $A.enqueueAction(action);
        component.set("v.text",'');
        
       component.set("v.textarea",'');
        window.scrollTo(0,0);

	}
})