({
    save : function(component, event, helper) {
        var fileInput = component.find("file").getElement();        
        var file = fileInput.files[0];
        var id=component.get("v.recordId");       
        var fr = new FileReader();
        var self = this;
        fr.onload = function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            self.upload(component, file, fileContents);
        };
        fr.readAsDataURL(file);       
    },
    upload: function(component, file, fileContents) {
        var action = component.get("c.saveTheFile"); 
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
        action.setCallback(this, function(a) {
            var action1 = component.get("c.GetAttLoanPartner");
            action1.setParams({
                LoanId:component.get("v.recordId")          
            });
            action1.setCallback(this, function(data) {
                var result=data.getReturnValue(); 
                component.set("v.LOAttachment",result); 
                window.scrollTo(0,0); 
            });
            $A.enqueueAction(action1); 
        });
        $A.enqueueAction(action); 
        $A.get('e.force:refreshView').fire();
    },
     ProfileDetail : function(component, event, helper) {
         var action = component.get("c.GetProfileDetail");
        
        action.setCallback(this, function(data) {
            var result=data.getReturnValue();
            component.set("v.IsDeletedisplay",result); 
        });
        $A.enqueueAction(action); 
    },
    
    getattach : function(component, event, helper) {
        var lid=component.get("v.recordId") ;
        var action = component.get("c.GetAttLoanOfficer");
        action.setParams({
            LoanId: component.get("v.recordId")          
        });
        action.setCallback(this, function(data) {
            var result=data.getReturnValue();
            component.set("v.Attachment",result); 
        });
        $A.enqueueAction(action); 
    },
    getattachLoanOfficer : function(component, event, helper) {
        var lid=component.get("v.recordId") ;
        var action = component.get("c.GetAttLoanPartnerForAE");
        action.setParams({
            LoanId: component.get("v.recordId")          
        });
        action.setCallback(this, function(data) {
            var result=data.getReturnValue();
            component.set("v.LOAttachment",result); 
        });
        
        $A.enqueueAction(action); 
    },
    sendMessage: function(component, helper, message){
        //Send message to VF
        message.origin = window.location.hostname;
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, component.get("v.vfHost"));
        //window.location.Reload();
        // window.open("https://dev-partnerportal22.cs64.force.com/s/pipeline");
        
    },
    showSpinner:function(component){
        component.set("v.IsSpinner",true);
    },
    
    hideSpinner:function(component){
        component.set("v.IsSpinner",false);
    }, 
})