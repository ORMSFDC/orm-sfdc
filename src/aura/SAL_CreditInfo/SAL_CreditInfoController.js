({
    doInit: function (component, event, helper) {

        helper.ValidationForPills(component, event, helper);
        var adrcc = component.find("BtnApplicationSubmit");
        $A.util.addClass(adrcc, 'defaultCls Enableddisabledcls');
        helper.GetSubmitButtonEnabledStatus(component, event, helper);
        helper.GetCreditInfoById(component, event, helper);
        // <!--Code Started for Story No:- ORMSFDC-1275 by Dev4-->
        window.scrollTo(0, 0);
        document.getElementById('targetID').innerHTML = 'l11';
        // <!--Code Ended for Story No:- ORMSFDC-1275 by Dev4-->
    },
    previous: function (cmp, event, helper) {
        cmp.set('v.manual', true);
        helper.prev(cmp, event, helper);
    },
    CreditindicatorFunc: function (component, event, helper) {
        var LDTS = component.find("SelectNewCredit").get("v.value");
        var LDTS1 = component.find("SelectNewCredit");
        component.set("v.showError", false);
        component.set("v.showSuccess", false);
        LDTS1.set("v.errors", null);
        if (LDTS == "Pull New Credit") {
            helper.GetClientSize(component, event, helper);
        }
        else {
            component.set("v.PullNewCredit", false);
            component.set("v.PullNewCreditNoJoint", false);
            var a = component.get("v.PullNewCredit");
        }
        if (LDTS == "Reissue Credit") {
            component.set("v.ReIssueCredit", true);
            var a = component.get("v.ReIssueCredit");
        }
        else {
            component.set("v.ReIssueCredit", false);
            var a = component.get("v.ReIssueCredit");
        }
    },
    CreditReportFunc: function (component, event, helper) {
        component.set("v.showError", false);
        component.set("v.showSuccess", false);
    },
    FormatRefNumber: function (component, event, helper) {
        helper.FormatRefNumberhelper(component, event, helper);
    },
    CIFormatValidations: function (component, event, helper) {
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
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
        function FutureDate(value) {
            //boolean result;
            var myDate = new Date(value);
            var today = new Date();
            if (myDate > today) {
                return false;

            } else {
                return true;
            }
        }
        var valArray = [
            { ar_id: "CreditRefNumber", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "ConCreditRefNumber", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "CreditReissueVendor", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "SelectNewCredit", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "CreditReportType", mes: "This is a required field", reg: validateRequiredField },

        ];
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);
        var Isrequired = helper.formatErrorMethod(component, array_reg, array_mes, array_id);
        var CheckCreditNumbers = helper.CheckCreditNumber(component, event, helper);
        if (Isrequired || CheckCreditNumbers) {
            component.set("v.showError", true);
        }
        else {
            component.set("v.showError", false);
            //Save CreditInfo           
            component.set("v.showPopup_2", true);
        }
    },
    CreditInfoValidations: function (component, event, helper) {
        var a_id = event.getSource().getLocalId();
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        switch (a_id) {
            case "CreditScore":
                msg = "Invalid credit Score";
                reg = /^([3-8][0-9][0-9])$/;
                break;
            default:
                ;
        }

        helper.CreditInfoValidationMethod(component, reg, msg, a_id);
    },
    doAction: function (component, event, helper) {
        debugger;
        component.set("v.showPopup_2", false);
        helper.CreditInfoSave(component, event, helper);
    },
    closeModel: function (component, event, helper) {
        component.set("v.showPopup_2", false);
    },
})