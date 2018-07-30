({
    onLoad : function(component, event, helper) {
        //alert("working");
       document.getElementById("p1").classList.toggle("in"); 
        document.getElementById("l1").classList.toggle("active");
        
         var action = component.get("c.getValue");
    
        action.setCallback(this, function(data) {
            var state = data.getState();
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.loans",data.getReturnValue());
            }
            else
            {console.log("Failed with state: " + state);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    
     
  Loan_Next : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l1").classList.remove("active");
        document.getElementById("l2").classList.toggle("active");
        //alert(a);
    },
    
    Subject_Prev : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l2").classList.remove("active");
        document.getElementById("l1").classList.toggle("active");
        //alert(a);
    },
    
    
    Subject_Next : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l2").classList.remove("active");
        document.getElementById("l3").classList.toggle("active");
        //alert(a);
    },
    
    
    Client_Prev : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l3").classList.remove("active");
        document.getElementById("l2").classList.toggle("active");
        //alert(a);
    },
    
    
    Client_Next : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l3").classList.remove("active");
        document.getElementById("l4").classList.toggle("active");
        //alert(a);
    },
    
    
    Emp_Prev : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l4").classList.remove("active");
        document.getElementById("l3").classList.toggle("active");
        //alert(a);
    },
    
    
    Emp_Next : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l4").classList.remove("active");
        document.getElementById("l5").classList.toggle("active");
        //alert(a);
    },
    
    
    Income_Prev : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l5").classList.remove("active");
        document.getElementById("l4").classList.toggle("active");
        //alert(a);
    },
    
    
    Income_Next : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l5").classList.remove("active");
        document.getElementById("l6").classList.toggle("active");
        //alert(a);
    },
    
    
    Assets_Prev : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l6").classList.remove("active");
        document.getElementById("l5").classList.toggle("active");
        //alert(a);
    },
    
    
    Assets_Next : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l6").classList.remove("active");
        document.getElementById("l7").classList.toggle("active");
        //alert(a);
    },
    
    
    Liab_Prev : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l7").classList.remove("active");
        document.getElementById("l6").classList.toggle("active");
        //alert(a);
    },
    
    
    Liab_Next : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l7").classList.remove("active");
        document.getElementById("l8").classList.toggle("active");
        //alert(a);
    },
    
    
    Dec_Prev : function(component) {
        
        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l8").classList.remove("active");
        document.getElementById("l7").classList.toggle("active");
        //alert(a);
    },
    
    
    click_step1 : function(component) {
        
        document.getElementById("p2").classList.remove("in");
        document.getElementById("Loan").classList.toggle("active");
        //document.getElementById("p3").classList.remove("in");
        
    },
    
    click_step2 : function(component) {
        
        document.getElementById("p1").classList.remove("in");
        //document.getElementById("p3").classList.remove("in");
        
    },
    click_step3 : function(component) {
        
        document.getElementById("p2").classList.remove("in");
        document.getElementById("p1").classList.remove("in");
        
    },
    
    ssn_validate : function(component) {
        document.getElementById("SSN_id").classList.remove("errorclr");
        var s = document.getElementById("SSN_id").value;
        var m = s.length;
        //var regExpNum = /[0-9]/;
        
        
               
          /*if ( !s.match(regExpNum))  
          {
              alert("Wrong Input");
              document.getElementById("SSN_id").value = "";
          }
            else {*/
                            
        
        if ( m == 3 )
        {
            var t = s.substring(0,3);
            var ssn = t + '-';
            document.getElementById("SSN_id").value = ssn;
               
        }
        if ( m == 6) {
            var t1 = s.substring(0,6);
            var ssn1 = t1 + '-';
            document.getElementById("SSN_id").value = ssn1;
        }
        //}
        
        

    },
    
    ssn_validate_change : function(component) {
        
        var ssn = document.getElementById("SSN_id").value
        var regVal = /[0-9]{3}-[0-9]{2}-[0-9]{4}/
        
        if ( !ssn.match(regVal))
        {
            //component.set("v.val","Please enter a valid SSN number")
            document.getElementById("SSN_id").classList.add("errorclr");
            document.getElementById("SSN_id").value = 'Please enter a valid SSN number';
            
        }
        
    },
    
})