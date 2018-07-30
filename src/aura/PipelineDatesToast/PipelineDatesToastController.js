({
	doInit : function(component, event, helper) {
        var id=component.get("v.recordId");
      //alert(id);
        var action = component.get("c.getLoanDate");
        action.setParams({            
            LoanID:id            
        });
        action.setCallback(this, function(data) {            
            debugger;
            var result=data.getReturnValue();
            //code done by dev5 for story 1545
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth()+1; //January is 0!            
            var yyyy = today.getFullYear();
            if(dd<10)
            {
                dd='0'+dd;
            } 
            if(mm<10)
            {
                mm='0'+mm;
            } 
            var today = mm+'/'+dd+'/'+yyyy;
            var coolingDate=result.CoolingOffNoticeSignedDate;
            var date1 = new Date(today);
            var date2 = new Date(coolingDate);
            var timeDiff = Math.abs(date2.getTime() - date1.getTime());
            var diffDays = parseInt(Math.ceil(timeDiff / (1000 * 3600 * 24))); 
            
            if(result.LoanOriginationState=="Minnesota" && diffDays<7)
            {
                //toaster....
                var toastEvent = $A.get("e.force:showToast");                
                toastEvent.setParams({                    
                    "title": "Information!",                    
                    "message": "You cannot contact the client within 7 days after the client signing the Cooling off Notice." ,
                    "type":"error"
                });                
                toastEvent.fire();
            }
            /////////////////////////////////////////////////////////////dev5 1545
        });
        $A.enqueueAction(action);
		
	}
})