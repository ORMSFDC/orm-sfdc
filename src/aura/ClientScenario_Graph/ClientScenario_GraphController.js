({   
    //Display Graph
    scriptsLoaded: function(component, event, helper) {
       // alert();
     
        helper.hlperscriptsLoaded(component, event, helper);        
    },
    Start_newloan:function(component, event, helper) {
        component.set("v.render_popup",true);
    },
    							 //For Request Package
    sendmailrequest: function(component, event, helper) {
           var ScenarioID = component.get("v.ScenarioID");
    
        var action = component.get("c.SendMailTMP");
        action.setParams({
            "ScenarioID": ScenarioID
        });        
        action.setCallback(this, function(data) {
          //  console.log(data.getReturnvalue());
         //   component.set("v.Messages", "Request Sent Successfully");
           var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "message": "Request Sent Successfully"
    });
    toastEvent.fire();           
           // document.getElementById("requestbtn").style.display = "None";
        });
        $A.enqueueAction(action);
    },
})