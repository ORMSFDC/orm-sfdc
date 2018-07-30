({
	doInit : function(component, event, helper) {
      $A.createComponent(
         "c:PipeLine",
         
         {
 
         },
         function(newCmp){
            if (component.isValid()) {
               component.set("v.body", newCmp);
            }
         }
      );
   },
    NavigateComponent : function(component,event,helper) {
       var Lnumber = event.getParam("LoanNumberE");
      //  alert('pipelinemaincmp Lnumber --> '+Lnumber);
       console.log(Lnumber);
       //var x  = JSON.stringify(id);
       
      // alert(id);
       component.set("v.LoanNumber",Lnumber);
             
      $A.createComponent(
         "c:PipeLineDetails",
         {
             "LoanNumber":component.get("v.LoanNumber"), 
         },
         function(newCmp){
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
         }
      );
   }
})