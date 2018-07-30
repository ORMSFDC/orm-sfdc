({
	 doinit:function(component,event,helper){
        
        var del  = component.get("v.senario_delete");
      alert('deleteid asdf 123 ASDF '+del);
        var action= component.get('c.delete_senario');
        
        console.log('action ',action);
         action.setParams({
            'senaioid': del
        });
        
         action.setCallback(this, function(response) {

            //component.set("v.senario_delete_popup",false); 
            alert('deleted');
            //helper.getCaseList(component);
            
        });
        
        $A.enqueueAction(action);
    }
})