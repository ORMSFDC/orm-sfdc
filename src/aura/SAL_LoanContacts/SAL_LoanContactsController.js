({
    doInit : function(component, event, helper) {
        window.scrollTo(0, 0);
        helper.ValidationForPills(component, event, helper) ;
        helper.getLoanOfficerhelper(component, event, helper);
        document.getElementById('targetID').innerHTML ='l11';
    },
    previous: function(component, event, helper) {
        //component.set('v.manual',true);
        helper.prev(component, event, helper);
    },
    PreContactChange: function(component, event, helper) {
        var Selectedvalue=  component.get("v.LoanContactDetailsResponse.PreferredContact");       
        if(Selectedvalue == "Loan Processor"){
            component.set("v.IsLPrequired", true);
        }else{component.set("v.IsLPrequired", false);}
    },
    LoanFormatValidations: function(component, event, helper) {
        debugger;
        var value=   component.get("v.LoanContactDetailsResponse.LoanOfficer");
        //var value=   component.get("v.LoanContactDetailsResponse.LoanOfficer");
        //alert(value);
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();
        
        
        function validateRequiredField(value) {
            
            if ($A.util.isEmpty(value))
            {
                return false; 
                
            }
            else
            {
                return true;
                
            }
            //Return true if there is an error and false if there aren't any
            //if (!isNaN(value) && parseInt(value) <= new Date().getFullYear()) 
            //  return true;
            // else 
            // return false;
            
        }
        function FutureDate (value) {
            
            var myDate = new Date(value);
            var today = new Date();
            if (myDate > today) {
                
                return false;
                
            } else {
                return true;
            }
            
            
        }
        
        var valArray = [//{ ar_id: "SelectLoanofficer", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "SelectLoanProcessor", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "SelectpreferredContact", mes: "This is a required field", reg: validateRequiredField },
            
        ];
            
            
            array_id = valArray.map(item => item.ar_id);
            array_mes = valArray.map(item => item.mes);
            array_reg = valArray.map(item => item.reg);
            
            
            var LDCPComp = component.find("SelectpreferredContact");
            debugger;
            if (!$A.util.isUndefinedOrNull(LDCPComp))
            {
            var LDCP= LDCPComp.get("v.value");
            
            if (!$A.util.isUndefinedOrNull(LDCP) || LDCP != "")
            {
            var Isrequired = false;
            if (LDCP != "Loan Officer" ) {
            Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
            }
            else{
            Isrequired=false;
            }
            if (Isrequired) {
            component.set("v.showError", true);   
            
            } else {
            debugger;
            component.set("v.showError", false);  
            helper.LoanContactsSave(component, event, helper);
            //Goes to the next Step
            //helper.Loan_Next(component, event, helper);
            }
            }else{
            
            Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
            if (Isrequired) {
            component.set("v.showError", true);   
            
            } else {
            debugger;
            component.set("v.showError", false);  
            helper.LoanContactsSave(component, event, helper);
            //Goes to the next Step
            //helper.Loan_Next(component, event, helper);
            }
            }
            }
            else{component.set("v.showError", true); }
            
            
            
            },
            nexttab: function(component, event, helper) {
            debugger;
            var el = document.getElementById('LoanContactLbl');
            if(el.innerText=='Move')
            {
            
            if(component.get("v.nextDataExist")){
            
            $('li#l12').removeClass('disabled');
            $('li#l12 a').attr("data-toggle","tab");
            
            $('li#l12 a').click();
            component.set("v.nextOpt", "true");
            component.set("v.currentOpt", "false");
            window.scrollTo(0, 0);
            }
            }},
            
            })