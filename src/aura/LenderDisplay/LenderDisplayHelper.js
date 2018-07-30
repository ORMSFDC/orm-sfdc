({
    GetMessagforDisplay : function(component, event, helper) {
       
        var action = component.get("c.getMessage");
        action.setCallback(this,function(response){
             debugger;
            
            var count = response.getReturnValue();
            var Message = 'You have '+ count +' Day Left for Evaluation.';
            var type = "";
             
            if(count!=0)
            {
                var toastEvent = $A.get("e.force:showToast");
                
                if(count >=4 && count <=7)
                {
                    type = "success"
                }
                else if(count >=2 && count <4)
                {
                    type = "warning";
                }
                else if(count == 1)
                {
                    type = "error";
                }
                
                toastEvent.setParams({                    
                        "title": "Information!",  
                        "type": type,
                        "message":  Message                  
                    });  
                toastEvent.fire();   
            }
        });
        $A.enqueueAction(action);   
    },
})