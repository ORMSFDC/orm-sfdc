({
	doInit : function(component, event, helper) {
		helper.onLoad(component, event, 'Priority','Created_DateTime__c');
        var action = component.get("c.getpriTaskStatus");
		action.setCallback(this,function(response){
            var state = response.getState();        
            if (state === "SUCCESS") {
                component.set("v.DoctaskStatusList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
	
    navigateToRecord : function(component, event, helper) {
         var idx = event.target.getAttribute('data-index');
         var navEvt = $A.get("e.force:navigateToSObject");
         navEvt.setParams({
             "recordId": idx,
             "slideDevName": "detail",
			 "isredirect" :true
         });
         navEvt.fire();
    },	
    
    navigateToViewAll : function(component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Task"
        });
        homeEvent.fire();
    },
    
	saveTaskStatusFun : function(component, event, helper) {
        var statusVal = event.getSource().get("v.value");
        var taskId = event.getSource().get("v.name");        
        var action = component.get("c.saveDocTaskStatus");
        action.setParams(
            {
                "taskId": taskId,
                "status": statusVal
            }
        );
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var c = response.getReturnValue();
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(action);       
        
	},
    
	sortDueDate: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.
       component.set("v.selectedTabsoft", 'DueDate');
       // call the helper function with pass sortField Name
       helper.sortHelper(component, event, 'Created_DateTime__c');      
    },
    
    sortDueDate2: function(component, event, helper) {
       component.set("v.selectedTabsoft", 'DueDate');
       helper.sortHelper(component, event, 'ActivityDate'); 
    },

    sortDueDate3: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'DueDate');
        helper.sortHelper(component, event, 'Priority'); 
     },

    sortDueDate4: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'DueDate');
        helper.sortHelper(component, event, 'Status');  
    },
})