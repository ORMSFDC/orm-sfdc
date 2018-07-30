({
	doIn : function(component, event, helper) {
        // var id = component.get("v.Loan");
      // alert(id);
      helper.LoadNotes(component);  
    },
    
    
    
    
    
    myAction : function(component, event, helper) {
		var note = component.find("note").get("v.value");       
        var title= component.find("title").get("v.value");
         component.set("v.title_error",false);	
         component.set("v.note_error",false);	
      //  document.getElementById("titleerr").innerHTML = "";
       // document.getElementById("noteerr").innerHTML = ""; 
        if ($A.util.isEmpty(title.trim()))
        {
           
            component.set("v.title_error",true);	
           // document.getElementById("titleerr").innerHTML = "Please enter some values into Title field";
           // document.getElementById('titleerr').classList.add("errorclr");
        }
        else
        {
             component.set("v.title_error",false);	
            if ($A.util.isEmpty(note.trim()) )
            {
                 component.set("v.note_error",true);	
             // document.getElementById("noteerr").innerHTML = "Please enter some values into Note field"; 
              //  document.getElementById('noteerr').classList.add("errorclr");
            }
            else
            {
                
            
        var id = component.get("v.Loan");
       // alert(note+","+title);
        var action = component.get("c.insNotes");
        //var T = 'This is the body content of the Note, be careful with HTML characters here, and use escapeXML to help format your content body strings!';
        
            action.setParams({
        
        "note": note,
                "title":title,
                "Loan_Id": id
    });
    
        action.setCallback(this, function(data) {
            var state = data.getState();
            if (component.isValid() && state === "SUCCESS"){
             
                
                //document.getElementById("LoanMortgageAppliedFor").focus();
                
                
            }
            else
            {console.log("Failed with state: " + state);
            }
            
        });
        
        $A.enqueueAction(action);
  helper.LoadNotes(component);
        
    }
        }   
        
    },
	}
})