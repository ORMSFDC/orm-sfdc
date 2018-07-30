({
    
    save : function(component, event, helper) {
        // alert('helper');
         //var spinner = component.find("spinner");

        //$A.util.toggleClass(spinner, "slds-hide");
        var fileInput = component.find("file").getElement();
        
        var file = fileInput.files[0];
        //  alert(file.type);
        //var fileName = fileInput.Type;
        var id=component.get("v.LoanId");
        
        
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
            parentId: component.get("v.LoanId"),
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
        
        action.setCallback(this, function(a) {
            var attachId = a.getState();
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
                    //var spinner = component.find("spinner");

        //$A.util.toggleClass(spinner, "slds-hide");
                    document.getElementById("file").value = "";
                   window.scrollTo(0,0);
                }
            });
            
            $A.enqueueAction(action); 
        });
        
        
        $A.enqueueAction(action); 
        
    },
    
    getattach : function(component, event, helper) {
        
        var lid=component.get("v.LoanId") ;
        
        var action = component.get("c.GetAttLoanOfficer");
        
        action.setParams({
            LoanId: component.get("v.LoanId")          
        });
        action.setCallback(this, function(data) {
            
            var state = data.getState();
            debugger;
            var result=data.getReturnValue();
            
            
            
            if (state == 'SUCCESS'){
                component.set("v.Attachment",result); 
                var doc=component.get("v.Attachment.DocName");              
                
            }
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
        var a  =  component.get("v.IsSpinner");
            //alert("in SS: " + a);

},

 hideSpinner:function(component){

  component.set("v.IsSpinner",false);
             var a  =  component.get("v.IsSpinner");
           // alert("in HS: " + a);

},
})