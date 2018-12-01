({
    //Display Graph
    scriptsLoaded: function (component, event, helper) {
        // alert();

        helper.hlperscriptsLoaded(component, event, helper);
    },
    Start_newloan: function (component, event, helper) {
        component.set("v.render_popup", true); //SFDC-360
    },
    //For Request Package
    sendmailrequest: function (component, event, helper) {
        component.set("v.IsSpinner", true);
        var ScenarioID = component.get("v.ScenarioID");
        var action = component.get("c.SendMailTMP");
        action.setParams({
            "ScenarioID": ScenarioID
        });
        action.setCallback(this, function (data) {           
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "Request Sent Successfully"
            });
            toastEvent.fire();
            component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
        
        //SFDC_568
        var action3 = component.get("c.createAETask");
        action3.setParams({ 
            "ScenarioID": ScenarioID
        }); 
        action3.setCallback(this,function(data){
        });       
        $A.enqueueAction(action3);
    },
})
