({
    save : function(component, event, helper) {
        var Checkboxvalue=component.find("CheckAddCondition").get("v.value");
        //alert(Checkboxvalue);
        var LoanId=component.get("v.LoanId");
        var text=component.find("inputCondition").get("v.value");
        var Index=component.find("ConditionIndex").get("v.value");
        var DropDownValue=component.find("DDl_Description").get("v.value");
        var staticItem = { Index:Index,
                          DescText: text,DropDownValue:DropDownValue,Status:"Outstanding" };
        var result=component.get("v.ConditionData");
        result.push(staticItem);
        component.set("v.ConditionData",result);
        var conditionList=component.get("v.ConditionData");
        var action2 = component.get("c.SaveConditions"); 
        
        action2.setParams({
            
            ConditionList: JSON.stringify(conditionList) ,
            LoanId:LoanId,
            MailSendneeded:Checkboxvalue
        });
        action2.setCallback(this, function(data) {
            var result= data.getReturnValue(); 
            var evt=$A.get("e.c:Event_Condition_ForCloseAddModal");
            evt.setParams({"ModalValue":false});          
            
            evt.fire();
            
            //$A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action2);
        
    },
    saveWithoutvalidation : function(component, event, helper) {
        var Checkboxvalue=component.find("CheckAddCondition").get("v.value");
        //alert(Checkboxvalue);
        var LoanId=component.get("v.LoanId");
        
        var conditionList=component.get("v.ConditionData");
        var action2 = component.get("c.SaveConditions"); 
        
        action2.setParams({
            
            ConditionList: JSON.stringify(conditionList) ,
            LoanId:LoanId,
            MailSendneeded:Checkboxvalue
        });
        action2.setCallback(this, function(data) {
            var result= data.getReturnValue(); 
            var evt=$A.get("e.c:Event_Condition_ForCloseAddModal");
            evt.setParams({"ModalValue":false});          
            
            evt.fire();
            
            //$A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action2);
        
    },
    validateCondition:function(component, event, helper) {
        var finalResult=false; 
        var Desc=component.find('DDl_Description');
        var DescriptionVal=component.find('DDl_Description').get('v.value');        
        if ($A.util.isEmpty(DescriptionVal)) {
            finalResult = true;            
            Desc.set("v.errors", [{ message: "Please select Description" }]);
        } else{            
            Desc.set("v.errors", null);
        }  
        return finalResult;
    },
    validateTextBoxCondition:function(component, event, helper) {
        var finalResult=false; 
        
        var Comment=component.find('inputCondition');
        var commentval=component.find('inputCondition').get('v.value');
        
        if ($A.util.isEmpty(commentval)) {
            finalResult = true;
            
            Comment.set("v.errors", [{ message: "Please Add Description Comment" }]);
        } else{            
            Comment.set("v.errors", null);
        }  
        return finalResult;
    },
})