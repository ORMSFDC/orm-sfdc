({
    doinit: function (cmp) {
        cmp.set("v.loadingDone", true);
    },
    //New Scenario
    backButton: function (component, event, helper) {
        component.set("v.DOB", '');
        component.set("v.EHV", '');
        component.set("v.CMB", '');
        // component.set("v.CFY",'');
        component.set("v.CMIR", '');
        component.set("v.MMP", '');
        component.set("v.ClientDiv", false);
        component.set("v.showError", false);
        component.set("v.showPopup", false);
        component.set("v.VisibleDefaultDiv", true);
    },
    //Validate Estimate Home Value
    validateEHV: function (component, event, helper) {
        var inz = component.get('v.EHV');
        console.log('inz ', inz);

        if (isNaN(inz) && inz) {
            component.set('v.EHV', inz.substring(0, inz.length - inz.length));
        }
    },
    //Validate Current Mortgage Balance
    validateCMB: function (component, event, helper) {
        var inz = component.get('v.CMB');
        console.log('CMB ', inz);
        if (isNaN(inz) && inz) {
            component.set('v.CMB', inz.substring(0, inz.length - inz.length));
            component.set("v.ErrorMsg", "");
        }
    },
    //Validate Current Mortgage Balance
    /* validateCFY:function(component, event, helper) {
         var inz = component.get('v.CFY');
         if(isNaN(inz))
         {
             component.set('v.CFY', inz.substring(0, inz.length - inz.length));
             component.set("v.ErrorMsg","");
         }
     }, */
    //Validate Current Mortgage Interest Rate
    validateCMIR: function (component, event, helper) {
        debugger;
        var inz = component.get('v.CMIR');
        var digit = inz.toString()[0];
        if (typeof digit === 'undefined') {
        }
        if (digit == ' ') {
            component.set('v.CMIR', inz.substring(0, inz.length - inz.length));
        }
        else {
            if (isNaN(inz)) {
                component.set('v.CMIR', inz.substring(0, inz.length - inz.length));

            }
        }
    },
    //Validate Monthly Mortgage Payment
    validateMMP: function (component, event, helper) {
        var inz = component.get('v.MMP');
        if (isNaN(inz) && inz) {
            component.set('v.MMP', inz.substring(0, inz.length - inz.length));
            component.set("v.ErrorMsg", "");
        }
    },
    //Validate Required Field
    Validations: function (component, event, helper) {
        //   alert();
        var msg = "";
        var reg = '';
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();
        function validateRequiredField(value) {
            if ($A.util.isEmpty(value)) {
                return false;
            }
            else {
                return true;
            }
        }
        var valArray = [
            { ar_id: "inputDOB", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputEHV", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputCMB", mes: "This is a required field.", reg: validateRequiredField },
            // { ar_id: "inputCFY", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputCMIR", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputMMP", mes: "This is a required field.", reg: validateRequiredField }
        ];
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);
        var Isrequired = helper.formatErrorMethod(component, array_reg, array_mes, array_id);
        var isdateworng = helper.validateDate(component, event, helper);
        var IsCurrenyWorng = helper.CurrencyRegexCheck(component);
        var IsInterestrateWorng = helper.validateCMIRValue(component, event, helper);
        if (Isrequired || IsCurrenyWorng || isdateworng || IsInterestrateWorng) {
            component.set("v.showError", true);
        }
        else {
            component.set("v.showError", false);
            helper.checkFor62(component, event, helper);
        }
    },
    //ValidateClose Modal
    closeModel: function (component, event, helper) {
        component.set("v.showPopup", false);
    },

    save_pdf: function (component, event, helper) {
        //   alert();
        //location.hash = "";
        //alert('>>>> '+location.hash);
        //var spinner = component.find("print_Spinner");
        $A.util.addClass(spinner, "slds-show");
        if (location.hash != '#savePdf')
            location.hash = "savePdf";
        else
            location.hash = "Pdfsave";

    },
    print_pdf: function (component, event, helper) {
        if (location.hash != '#printPdf')
            location.hash = "printPdf";
        else
            location.hash = "Pdfprint";

    },

    calculate_loan: function (component, event, helper) {



    },

    optionChanged: function (component, event, helper) {
        //  alert('loancalculator cmp '+component.get("v.showLoan"));
        var lnId = component.get("v.showLoanId");
        //  alert("showLoanId "+component.get("v.ApplicationDate"));
        $A.createComponent(
            "c:StartNewLoanProductContainer",

            {
                "ApplicationDate": component.get("v.ApplicationDate"),
                "LoanId": component.get("v.showLoanId"),
                "fromPopup": true
            },
            function (newCmp) {
                if (component.isValid()) {
                    //           alert();
                    component.set("v.displayTab", false);
                    component.set("v.body", newCmp);
                }
            }
        );
    }

})