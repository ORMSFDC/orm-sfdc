({
    doInit : function(component, event, helper) {
        $A.createComponent(
            "c:LoanIncompleteRegistration",
            
            {
                
            },
            
            function(newCmp){
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
    /*  
   NavigateComponent : function(component,event,helper) {
       var id = event.getParam("LoanId");
       var appDate=event.getParam("ApplicationDate");
                var LoanMortgageAppliedFor= event.getParam("EMortgageAppliedFor");           
        var RateType=event.getParam("ERateType");           
      if(RateType=='Fixed')
      {
            $A.createComponent(
             "c:StartNewLoanCmp_FixedProduct",
            
          {
              "ApplicationDate":appDate,
             "LoanId":id, 
              "LoanMortgageAppliedFor":LoanMortgageAppliedFor,
              "RateType":RateType
         },
         function(newCmp){
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
         }
      );
      }
       else
       {
      $A.createComponent(
             "c:StartNewLoanCmp",
            
          {
              "ApplicationDate":appDate,
             "LoanId":id, 
              "LoanMortgageAppliedFor":LoanMortgageAppliedFor, 
         },
         function(newCmp){
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
         }
      );
       }
       
   },*/
    NavigateComponent : function(component,event,helper) {
        var db=component.find("newtag");
        var id = event.getParam("LoanId");
        var appDate=event.getParam("ApplicationDate");
        var LoanMortgageAppliedFor= event.getParam("EMortgageAppliedFor");   
        var RateType=event.getParam("ERateType");           
        if(RateType=='Fixed')
        {
            $A.createComponent(
                "c:StartNewLoanCmp_FixedProduct",
                
                {
                    "ApplicationDate":appDate,
                    "LoanId":id, 
                    "LoanMortgageAppliedFor":LoanMortgageAppliedFor,
                    "RateType":RateType
                },
                function(newCmp){
                    component.find("newtag").set("v.body",[]);
                    if (component.isValid()) {
                        var bdy=db.get("v.body");
                        bdy.push(newCmp);
                        db.set("v.body",bdy);
                    }
                }
            );
            component.set("v.SpinnerDisplay",false);
        }
        else
        {
            $A.createComponent(
                "c:StartNewLoanCmp",
                {
                    "ApplicationDate":appDate,
                    "LoanId":id, 
                    "LoanMortgageAppliedFor":LoanMortgageAppliedFor, 
                },
                function(newCmp){
                    component.find("newtag").set("v.body",[]);
                    if (component.isValid()) {
                        var bdy=db.get("v.body");
                        bdy.push(newCmp);
                        db.set("v.body",bdy);
                        //component.set("v.body", newCmp);
                    }
                }
            );
            component.set("v.SpinnerDisplay",false);
        }
        
    },
    
    
})