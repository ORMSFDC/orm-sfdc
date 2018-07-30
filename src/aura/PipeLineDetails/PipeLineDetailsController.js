({
    doInit : function(component, event, helper) {
        debugger;
        var id=component.get("v.LoanNumber");
        console.log(id);
        
        var action = component.get("c.getLoanDetails");
        action.setParams({
            
            "LoanID":id
            
        });
        action.setCallback(this, function(data) {            
            debugger;
            
            var result=data.getReturnValue();
            
            
            /*  var lstatus=result.LoanStatus;
            if(result==null)
            {
                document.getElementById("email").style.display = "None";
            }
            if(lstatus == 'Proposal')
            {
                //alert('proposal');
                document.getElementById("email").style.display = "None";
                
            }
            else
            {  
              //   alert('not proposal');
                document.getElementById("email").style.display = "Block";
                
            }*/
            component.set("v.loanD",result);
         //   alert('pipelinedetails' + component.get("v.loanD"));
           
           
        });
        $A.enqueueAction(action);
    },
    display: function(component, event, helper) {
         component.set("v.showPopup",true);
        var id=component.get("v.LoanNumber");
         var action = component.get("c.GetLoanStatusHistory");
        action.setParams({
            
            "LoanID":id
            
        });
          action.setCallback(this, function(data) {            
            debugger;
            
            var result=data.getReturnValue();
              if(result.length==0){
              var CurrentStatus=  component.get("v.loanD.LoanStatus");
                  component.set("v.CurrentStatus",CurrentStatus);
          }
              
             //var arraylenght=result.length;
            var status=result[0].LoanCurrentStatus;
              component.set("v.CurrentStatus",status)
             
           
            component.set("v.loanStatus",result);
        });
        $A.enqueueAction(action);
    },
     closeDeleteModel : function(component, event, helper) {
        component.set("v.showPopup",false);
    }
    /*,
    showImpDates : function(component, event, helper)
    {
        component.set('v.showDates',true);
    }*/
    
})