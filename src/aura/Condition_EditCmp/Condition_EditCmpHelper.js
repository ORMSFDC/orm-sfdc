({
	 validateCondition:function(component, event, helper) {
        var finalResult=false; 
        	var Desc=component.find('DDl_Description');
         var DescriptionVal=component.find('DDl_Description').get('v.value');
        var Comment=component.find('inputCondition');
        var commentval=component.find('inputCondition').get('v.value');
        if ($A.util.isEmpty(DescriptionVal)) {
            finalResult = true;
            
            Desc.set("v.errors", [{ message: "Please select Description" }]);
        } else{            
            Desc.set("v.errors", null);
        }
 if ($A.util.isEmpty(commentval)) {
            finalResult = true;
            
            Comment.set("v.errors", [{ message: "Please Add Description Comment" }]);
        } else{            
            Comment.set("v.errors", null);
        }  
        return finalResult;
    },
     EditCondition:function(component, event, helper) {
         
         var Checkboxvalue=component.find("CheckEditCondition").get("v.value");
         var LoanId=component.get("v.LoanId");
        var ConId=component.get("v.ConditionId");
        var responsedata=component.get("v.ConditionData");
        var action = component.get("c.SaveEditConditions");
        action.setParams({
            
            "LoanId":LoanId,
            "ConditionId":ConId,
            "responseString":JSON.stringify(responsedata),
            "MailSendneeded":Checkboxvalue
            
        });
         action.setCallback(this, function(data) {
           debugger;
            var result= data.getReturnValue(); 
             var evt=$A.get("e.c:Event_Condition_ForCloseUpdateModal");
            evt.setParams({"ModalValue":false});          
             
            evt.fire();
             //alert(result);
           
            });
        $A.enqueueAction(action);
          
    },
})