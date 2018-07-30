({
	doInit : function(component, event, helper) {
		helper.onLoad(component, event, 'Created_DateTime__c');
        var action = component.get("c.getPriorityTaskStatus");
		action.setCallback(this,function(response){
            var state = response.getState();        
            if (state === "SUCCESS") {
                component.set("v.PrioritytaskStatusList", response.getReturnValue());
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
        var action = component.get("c.savePriorityTaskStatus");
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
        
        // Added New 
        var action2 = component.get("c.savePriorityTaskStatus2");
        action2.setParams(
            {
                "taskId": taskId,
                "status": statusVal
            }
        );
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var c = response.getReturnValue();
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(action2); 
	},
    
	sortDueDate: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.
       component.set("v.selectedTabsoft", 'DueDate');
       // call the helper function with pass sortField Name
       helper.sortHelper(component, event, 'Created_DateTime__c');      
    },
    
    sortDueDate2: function(component, event, helper) { //Added New
       component.set("v.selectedTabsoft", 'DueDate');
       helper.sortHelper(component, event, 'ActivityDate'); 
    },
})