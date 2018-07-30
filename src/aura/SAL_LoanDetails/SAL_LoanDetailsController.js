({
    doInit: function(component, event, helper) {
        
        window.scrollTo(0, 0);
        var checkId = component.get("v.LoanId");
        if (checkId != "undefined") {
            if (checkId != null) {
                helper.GetLoanDetailsById(component, event, helper);
                helper.ValidationForPills(component, event, helper);
                document.getElementById('targetID').innerHTML ='l9';
                //Code Started for Story No:- ORMSFDC-1275 by Dev4
                helper.getLoanOfficerhelper(component, event, helper);
                //Code Ended for Story No:- ORMSFDC-1275 by Dev4
                helper.getLoanProcessor(component, event, helper);
            }            
        }       
        
        // document.getElementById('targetID').innerHTML ='l11';
    },
    LoanDetails: function(component, event, helper) {
        
        var LDTS = helper.getRadioGroupValue(component, event, helper,"LoanDetailsTitleSource","v.NewLoan.Using_Title_Source_as_the_Closing_Agent__c");
        // var LDTS = component.find("LoanDetailsTitleSource").get("v.value");
        if (LDTS == "No") {
            component.set("v.Loan_Details", true);
            var a = component.get("v.Loan_Details");            
        } else {
            component.set("v.Loan_Details", false);
            var a = component.get("v.Loan_Details");
            component.set("v.showError", false);
        }
    },
    nexttab: function(component, event, helper){
        
        var el = document.getElementById('loanD');
        if(el.innerText=='Move')
        {
            if(component.get("v.nextDataExist"))
            {
                $('li#l10').removeClass('disabled');
                $('li#l10 a').attr("data-toggle","tab");                
                $('li#l10 a').click();
                component.set("v.nextOpt", "true");
                component.set("v.currentOpt", "false");
                window.scrollTo(0, 0);
            }
        }
    },
    LoanFormatValidations: function(component, event, helper) {  
        debugger;
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        
         var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
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
        
        var valArray = [
            { ar_id: "TitleCompany", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "Contact", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "ContactPhoneNumber", mes: "This is a required field", reg: validateRequiredField },
            //{ ar_id: "ContactEmail", mes: "This is a required field", reg: validateRequiredField },
            //{ ar_id: "SelectLoanProcessor", mes: "This is a required field", reg: validateRequiredField },
            //{ ar_id: "SelectpreferredContact", mes: "This is a required field", reg: validateRequiredField },
            
        ];
       var valarrayregex=[ 
            
           
            { ar_idr: "ContactEmail", mesr: "Please enter a valid Email", regr:'[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}'},
            
        ];
            array_id = valArray.map(item => item.ar_id);
            array_mes = valArray.map(item => item.mes);
            array_reg = valArray.map(item => item.reg); 
        
           array_idr = valarrayregex.map(item => item.ar_idr);
           array_mesr = valarrayregex.map(item => item.mesr);
           array_regr = valarrayregex.map(item => item.regr);
        
            var Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
           
            //Code Started for Story No:- ORMSFDC-1275 by Dev4
            var IsrequiredLoanContact=helper.LoanContactFormatValidations(component, event, helper);
         var IsRegex=helper.formatErrorMethodr(component, array_regr, array_mesr, array_idr);
            //Code Ended for Story No:- ORMSFDC-1275 by Dev4
            if (Isrequired || IsrequiredLoanContact || IsRegex) {
            component.set("v.showError", true); 
            
            } else {
            
            component.set("v.showError", false);
            // var LDTS = component.find("LoanDetailsTitleSource").get("v.value");
            var LDTS = helper.getRadioGroupValue(component, event, helper,"LoanDetailsTitleSource","v.NewLoan.Using_Title_Source_as_the_Closing_Agent__c");
            if (LDTS == "No") {
            component.set("v.Loan_Details", true);
            var a = component.get("v.Loan_Details");
            helper.LoanDetailsSave(component, event, helper);
            //helper.LoanContactsSave(component, event, helper);
            } else {
            component.set("v.Loan_Details", false);
            var a = component.get("v.Loan_Details");
            component.set("v.showError", false);
            component.set("v.NewLoan.Title_Company__c","");
            component.set("v.NewLoan.Contact_Name__c","");
            component.set("v.NewLoan.Contact_Phone_Number_LoanDetails__c","");
            helper.LoanDetailsSave(component, event, helper);
            //helper.LoanContactsSave(component, event, helper);
            }
            }
            
            },
            FormatPhone: function(component, event, helper) {
            helper.FormatPhonehelper(component, event, helper);
            },            
            previous: function(cmp, event, helper) {
            helper.prev(cmp, event, helper);
            },            
            RestrictZeroInCreditInfoPhoneFirstTime:function(component, event, helper) {
            var inz = 'v.NewLoan.Contact_Phone_Number_LoanDetails__c';        
            helper.RestrictZeroInPhoneFirstTime(component, event, helper,inz);     
            },  
            //Code Started for Story No:- ORMSFDC-1275 by Dev4
            PreContactChange: function(component, event, helper) {
            var Selectedvalue=  component.get("v.LoanContactDetailsResponse.PreferredContact");       
            if(Selectedvalue == "Loan Processor"){
            component.set("v.IsLPrequired", true);
            }else{component.set("v.IsLPrequired", false);}
            },
            //Code Ended for Story No:- ORMSFDC-1275 by Dev4
            })