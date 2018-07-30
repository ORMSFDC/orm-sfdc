({
	CreateMeetingandSenMail : function(component, event, helper) {
		
       var TopicName = component.find("txtMeetingId");
       
        var TopicNAmeValue = TopicName.get("v.value");
         //alert(TopicNAmeValue);
        if(!$A.util.isEmpty(TopicNAmeValue))
        {
            // alert("Zoom MeetingURL");
            window.open("https://zoom.us/j/"+ TopicNAmeValue);
             $A.get('e.force:refreshView').fire();
        }
        else
        {	
            TopicName.set("v.errors", [{message: "Please Enter Meeting ID"}]);
        }  
	}
})