({
    saveData : function(component, event, helper) {       
        helper.save(component, event, helper);       
    },
    
    doInit : function(component, event, helper) {
        
        //Send LC Host as parameter to VF page so VF page can send message to LC; make it all dynamic
        component.set('v.lcHost', window.location.hostname);
        
        var frameSrc = '/UploadFilePage?id=' + component.get('v.LoanId') + '&lcHost=' + component.get('v.lcHost');
        console.log('frameSrc:' , frameSrc);
        component.set('v.frameSrc', frameSrc);
        
        //Add message listener
        window.addEventListener("message", function(event) {
            
            
            console.log('event.data:', event.data);
            
            // Handle the message
            if(event.data.state == 'LOADED'){
                
                
                //Set vfHost which will be used later to send message
                component.set('v.vfHost', event.data.vfHost);
                
                
            }
            
            if(event.data.state == 'uploadFileSelected'){
                //var spinner = component.find("spinner");
                //$A.util.toggleClass(spinner, "slds-hide");
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
                                            var action = component.get("c.GetAttLoanOfficer");
                                            //action.setStorable(true);
                                            action.setParams({
                                                LoanId: component.get("v.LoanId")          
                                            });
                                            action.setCallback(this, function(data) {
                                                var state = data.getState();
                                                var result=data.getReturnValue();
                                                if (state == 'SUCCESS'){
                                                    component.set("v.Attachment",result); 
                                                    var doc=component.get("v.Attachment.DocName");
                                                    document.getElementById("file").value = "";
                                                    window.scrollTo(0,0);
                                                }
                                            });
                                            $A.enqueueAction(action);
                                            // set the body of the ui:message to be the ui:outputText
                                            
                                            component.find('uiMessage').set("v.body", message);
                                            
                                            helper.hideSpinner(component);
                                            
                                            //Integer start = System.Now().millisecond();
                                            //while(System.Now().millisecond()< start+1000){ 
                                            //component.find('uiMessage').set("v.body", '');
                                            //}
                                            
                                        }
                                        else if (status === "INCOMPLETE") {
                                            var message = "No response from server or client is offline.";
                                            console.log("No response from server or client is offline.")
                                            component.find('uiMessage').set("v.body", message);
                                            helper.hideSpinner(component);
                                            // Show offline error
                                        }
                                            else if (status === "ERROR") {
                                                console.log("Error: " + errorMessage);
                                                component.find('uiMessage').set("v.body", errorMessage);
                                                helper.hideSpinner(component);
                                                // Show error message
                                            }
                                        
                                    }
                                    
                                   );
            }
        }, false);
        
        
        helper.getattach(component, event, helper);
        
        
        //alert(component.get("v.LoanId") );
        var action1 = component.get("c.GetAttLoanPartner");
        action1.setParams({
            LoanId: component.get("v.LoanId")          
        });
        action1.setCallback(this, function(data) {
            
            var state = data.getState();
            var result=data.getReturnValue();
            console.log('Loan Office'+ result);
            console.log('Loan Office>>>>>', result);
            component.set("v.LOAttachment",result); 
            //var spinner = component.find("spinner");
            // $A.util.toggleClass(spinner, "slds-hide");               
        });    
        $A.enqueueAction(action1); 
        
    },
    sendMessage: function(component, event, helper) {
        helper.showSpinner(component);
        //Clear UI message before trying for file upload again
        component.find('uiMessage').set("v.body",[]);
        
        //Prepare message in the format required in VF page
        var message = {
            "uploadFile" : true
        } ;
        // alert(window.location)
        // alert('ff')
        //Send message to VF
        helper.sendMessage(component, helper, message);
    },
    Download : function(component, event, helper) {
        debugger;
        var x = event.target.id;
        // alert(x);
        window.open("/servlet/servlet.FileDownload?file="+x);
      /* var action1 = component.get("c.UpdateAttachmentStatus");
              action1.setParams({
               id: x          
            });
           action1.setCallback(this, function(data) {
                    debugger;       
               var state = data.getState();
                var result=data.getReturnValue();
               alert(result);
             
           	
            });    
             $A.enqueueAction(action1);*/
    },
    DownloadDoc : function(component, event, helper) {
        var x = event.target.id;
        alert("/sfc/servlet.shepherd/version/download/"+x);
        //window.open("/sObject/ContentDocument/0690q0000000CFvAAM/");
        window.href("/sfc/servlet.shepherd/version/download/"+x);
        //0680q0000000CAoAAM
    },
    
    DeleteDoc : function(component, event, helper) {  
        
        var id=event.target.id;
        component.set("v.idIs",id);
        component.set("v.showPopup",true);
        
    },
    doDelete :  function(component, event, helper) {  
        //alert(id);
        var id =  component.get("v.idIs");
        var action1 = component.get("c.DeleteAttachment");
        action1.setParams({
            id: id          
        });
        action1.setCallback(this, function(data) {
            // alert('alert call back1')
            var state = data.getState();
            var result=data.getReturnValue();
            // alert(result);
            var action = component.get("c.GetAttLoanOfficer");
            //action.setStorable(true);
            action.setParams({
                LoanId: component.get("v.LoanId")          
            });
            action.setCallback(this, function(data) {
                component.set("v.showPopup",false);
                var result=data.getReturnValue();
                
                component.set("v.Attachment",result); 
                var doc=component.get("v.Attachment.DocName");                     
                window.scrollTo(0,0);
                
            });
            $A.enqueueAction(action);            
        });    
        $A.enqueueAction(action1); 
        
    },
    
    closeModel :function(component, event, helper) { 
        
        component.set("v.showPopup",false);
    },
    
    
    
})