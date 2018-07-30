({
    GetMessageforUser : function(component, event, helper) {
        var ContactId=component.get("v.recordId");
        var action = component.get("c.IsUserActive");
        action.setParams({         
            ContactID:ContactId
        });
        action.setCallback(this,function(response){
            var type = response.getReturnValue();
            if(type==false)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({                    
                    "type": "Warning",
                    "message":  'There are no licenses available to create the portal login for this Business Individual.'                  
                });  
                toastEvent.fire();  
            }
        });
        $A.enqueueAction(action);   
    },
})