{
	 selectAccount : function(component, event, helper){      
    // get the selected Account from list  
        var commentsControl = component.find("secret");    
   		var commentsControlvalue  = commentsControl.get("v.value") ;
        //alert(commentsControlvalue);
      var getSelectAccount = component.get("v.oAccount");
    // call the event   
      var compEvent = component.getEvent("oSelectedAccountEvent");
    // set the Selected Account to the event attribute.  
         compEvent.setParams({"accountByEvent" : getSelectAccount });  
    // fire the event  
         compEvent.fire();
        
    },
})