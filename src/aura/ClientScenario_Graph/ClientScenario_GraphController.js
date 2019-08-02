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

    downloadDocument: function(component, event, helper){
               
        var sc = component.get("v.ScenarioID");        
        var action = component.get("c.getAttachment");
        action.setParams({
            scenarioID : sc
        });        
        action.setCallback(this,function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var  contentType = contentType || '';
  				var sliceSize = sliceSize || 512;

                const byteCharacters = atob(storeResponse.attBlob);
                const byteArrays = [];
                
                for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                    const slice = byteCharacters.slice(offset, offset + sliceSize);
                    const byteNumbers = new Array(slice.length);
                    for (let i = 0; i < slice.length; i++) {
                        byteNumbers[i] = slice.charCodeAt(i);
                    }
                    const byteArray = new Uint8Array(byteNumbers);
                    byteArrays.push(byteArray);
                }
                const blob = new Blob(byteArrays, {type: contentType});
                var newBlob = new Blob([blob], {type: "application/pdf"});
                if (window.navigator && window.navigator.msSaveOrOpenBlob) {
                    window.navigator.msSaveOrOpenBlob(newBlob);
                    return;
                } 
                const data = window.URL.createObjectURL(newBlob);
                var link = document.createElement('a');
                link.href = data;
                link.download= storeResponse.attName + ".pdf";
                link.click();
                setTimeout(function(){
                    window.URL.revokeObjectURL(data);
                }, 100);
            }
        }); 
        $A.enqueueAction(action);
    },
})