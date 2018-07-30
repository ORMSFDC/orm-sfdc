({
    saveData : function(component, event, helper) {       
        helper.save(component, event, helper);       
    },
    doInit : function(component, event, helper) {
        //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
        component.set('v.lcHost', window.location.hostname);
        var frameSrc = '/apex/UploadFilePage?id=' + component.get('v.recordId') + '&lcHost=' + component.get('v.lcHost');
        component.set('v.frameSrc', frameSrc);
        //Add message listener
        window.addEventListener("message", function(event) {
            // Handle the message
            if(event.data.state == 'LOADED'){
                //Set vfHost which will be used later to send message
                component.set('v.vfHost', event.data.vfHost);
            }
            if(event.data.state == 'uploadFileSelected'){
                component.find('uiMessage').set("v.body", '');
                component.find('uploadFileButton').set('v.disabled', false);
            }
            if(event.data.state == 'fileUploadprocessed'){
                var uiMessage = component.find('uiMessage');
                //Disable Upload button until file is selected again
                component.find('uploadFileButton').set('v.disabled', true);
                $A.createComponents([
                    ["markup://ui:message",{
                        "body" : event.data.message,
                        "severity" : event.data.messageType,
                    }]
                ],
                                    function(components, status, errorMessage){
                                        if (status === "SUCCESS") {
                                            var message = components[0];
                                            helper.getattach(component, event, helper);
                                            helper.getattachLoanOfficer(component, event, helper);
                                            // set the body of the ui:message to be the ui:outputText
                                            component.find('uiMessage').set("v.body", message);
                                            helper.hideSpinner(component);
                                        }
                                        else if (status === "INCOMPLETE") {
                                            var message = "No response from server or client is offline.";
                                            component.find('uiMessage').set("v.body", message);
                                            helper.hideSpinner(component);
                                            // Show offline error
                                        }
                                            else if (status === "ERROR") {
                                                component.find('uiMessage').set("v.body", errorMessage);
                                                helper.hideSpinner(component);
                                            }
                                        
                                    }
                                   );
            }
        }, false);
        
        helper.ProfileDetail(component, event, helper);
        helper.getattach(component, event, helper);
        helper.getattachLoanOfficer(component, event, helper);
    },
    sendMessage: function(component, event, helper) {
        helper.showSpinner(component);
        //Clear UI message before trying for file upload again
        component.find('uiMessage').set("v.body",[]);
        //Prepare message in the format required in VF page
        var message = {
            "uploadFile" : true
        } ;
        helper.sendMessage(component, helper, message);
    },
    Download : function(component, event, helper) {
        var x = event.target.id;
        window.open("/servlet/servlet.FileDownload?file="+x);
        var action1 = component.get("c.UpdateAttachmentStatus");
        action1.setParams({
            id: x          
        });
        action1.setCallback(this, function(data) {
            var state = data.getState();
            var result=data.getReturnValue();
        });    
        $A.enqueueAction(action1); 
    },
    DeleteDocConfirmation : function(component, event, helper) {
        var name=event.target.name;
        var id=event.target.id;
        component.set("v.targetid",id);
        component.set("v.TargetDocument",name);        
        component.set("v.DocDeletePopup",true);
    },
    DeleteDocConfirmationClose : function(component, event, helper) {
        component.set("v.targetid",'');
        component.set("v.DocDeletePopup",false);
        component.set("v.TargetDocument",'');
    },
    DeleteDoc : function(component, event, helper) { 
        var id= component.get("v.targetid");
        var action1 = component.get("c.DeleteAttachment");
        action1.setParams({
            id: id          
        });
        action1.setCallback(this, function(data) {
            var state = data.getState();
            var result=data.getReturnValue();
            helper.getattach(component, event, helper);
            helper.getattachLoanOfficer(component, event, helper);
            component.set("v.targetid",'');
            component.set("v.DocDeletePopup",false);
            component.set("v.TargetDocument",'');
        });    
        $A.enqueueAction(action1); 
    },
})