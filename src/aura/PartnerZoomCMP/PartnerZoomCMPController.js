({
    
    CreateMeetingandSenMail : function(component, event, helper) { 
        var TopicName = component.find("Topic");
        var TopicNAmeValue = TopicName.get("v.value");
        
        var contactname = component.find("UserName");
        var contactnameValue = contactname.get("v.value");
        if($A.util.isEmpty(TopicNAmeValue))
        {
            //$A.util.addClass(contactname, 'slds-has-error');
            TopicName.set("v.errors", [{message:"Please enter Topic"}]);
            
        }
        else{
            TopicName.set("v.errors", null);
            
            if($A.util.isEmpty(contactnameValue))
            {
                //$A.util.addClass(contactname, 'slds-has-error');
                contactname.set("v.errors", [{message:"Please enter UserName"}]);
                return false ;
            }
            else
            { //$A.util.removeClass(contactname, 'slds-has-error');
                contactname.set("v.errors", null);
                
                var isValidEmail = true; 
                var emailField = component.find("EmailID");
                var emailFieldValue = emailField.get("v.value");
                var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
                
                if($A.util.isEmpty(emailFieldValue)){ 
                    //$A.util.addClass(emailField, 'slds-has-error');
                    emailField.set("v.errors", [{message: "Please Enter Email Address"}]);
                    return false;         
                }
                else{
                    // $A.util.removeClass(emailField, 'slds-has-error');
                    emailField.set("v.errors", null);
                   // if(emailFieldValue.match(regExpEmailformat)){
                       // emailField.set("v.errors", [{message: null}]);
                        // $A.util.removeClass(emailField, 'slds-has-error');
                        var action = component.get("c.CreateMeeting"); 
                        action.setParams({
                            UserName: contactnameValue,
                            Email: emailFieldValue,
                            TopicNameDetails: TopicNAmeValue,
                        });
                        action.setCallback(this, function(a) {                     
                            var ZoomCreateMeetingResponse = a.getReturnValue();
                            component.set("v.lenderlink", ZoomCreateMeetingResponse);                    
                        //window.location.reload();

                        });
                        $A.enqueueAction(action);
                        return ;
                   // }else{
                        // $A.util.addClass(emailField, 'slds-has-error');
                      //  emailField.set("v.errors", [{message: "Please Enter a Valid Email Address"}]);
                        
                    }
                }
            }
        }
        
    }
}
 })