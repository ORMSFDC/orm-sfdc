({

	getLoanData : function(component, event, helper) {
		debugger;

		var action = component.get("c.resendOnBase")
		action.setParams({
			"LoanId": component.get("v.recordId")

		});		
		
		action.setCallback(this, function (data) {
			var result = data.getReturnValue();
			var Keyword = result.OnBase_Keyword__c;
			console.log('Keyword',Keyword);
			component.set("v.KeywordVal",Keyword);
			if(Keyword != undefined){				
				component.set("v.success_message",'true');
				if(Keyword == 'OnBase_10'){
					component.set("v.Keyword10",'All Status 10 Keywords have been sent to Onbase.');
				}	
				else if(Keyword == 'OnBase_16'){
					component.set("v.Keyword16",'All Status 10, 16 Keywords have been sent to Onbase.');
				}
				else if(Keyword == 'OnBase_20'){
					component.set("v.Keyword20",'All Status 10, 16, 20 Keywords have been sent to Onbase.');
				}
				else if(Keyword == 'OnBase_57'){
					component.set("v.Keyword57",'All Status 10, 16, 20, 57 Keywords have been sent to Onbase.');
				}
			}else{
				component.set("v.success_message",'false');
			}
			
		});		
		$A.enqueueAction(action);
	},
})