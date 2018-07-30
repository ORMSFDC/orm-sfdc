({
	doInit : function(component, event, helper) {
        
        
        var ConId=component.get("v.ConditionId");
        //alert(ConId);
         var action = component.get("c.getConditionHistory");
        action.setParams({            
            "ConditionId":ConId            
        });
        action.setCallback(this, function(data) {           
            debugger;            
            var result=data.getReturnValue(); 
            
            var createBy=result[0].CreatedBy;
            
            var CdDate=result[0].CreatedDate;
            
            var ModiBy=result[0].LastModifyBy;
            
            var MDate=result[0].LastModifyDate;
            
            component.set("v.CreateBy",createBy);
            
            component.set("v.CreateDate",CdDate);
            
            component.set("v.ModifyBy",ModiBy);
            
            component.set("v.ModifyDate",MDate);
            
           component.set("v.ConditionData",result);
        });
        $A.enqueueAction(action);  
		
	}
})