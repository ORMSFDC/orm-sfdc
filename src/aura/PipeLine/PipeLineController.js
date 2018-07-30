({
	myAction : function(component, event, helper) {
		
	},
     doIn : function (component, event, helper){
     helper.Isdataavailableforpipeline(component, event, helper);
		
       
       
        },
    PipeLineMenu : function(component, event, helper) {
        var x = event.target.id;
        //alert(x);
        var evt = $A.get("e.c:NavigatetoPipeLineMenu");
        //alert('pipeline controller evt --> '+evt);
        //alert('pipeline controller --> ' + evt.setParams({ LoanNumberE: x }));
        evt.setParams({LoanNumberE:x})
        evt.fire();
        
    },
})