({
	 selectContact : function(component, event, helper){      
    // get the selected Account from list  
        var commentsControl = component.find("secret");    
   		var commentsControlvalue  = commentsControl.get("v.value") ;
        //alert(commentsControlvalue);
      var getSelectContact = component.get("v.oContact");
    // call the event   
      var compEvent = component.getEvent("oSelectedContactEvent");
    // set the Selected Account to the event attribute.  
   // console.log('getSelectAccount ',getSelectContact);
         compEvent.setParams({"contactByEvent" : getSelectContact });  
    // fire the event  
         compEvent.fire();
        
    },
})