({
    ValidationForPills: function (component, event, helper) {
        var LoanId = component.get('v.LoanId');
        var action1 = component.get("c.LoanDetailsTabsValidatedData");
        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function (data) {
            var result = data.getReturnValue();
            if (result.Is_Loan_Created_Manually__c == false) {
                var evt = $A.get("e.c:NavPillsEvent");
                evt.setParams({ "IsPillsValidationRequired": true });
                evt.fire();
            }
        });
        $A.enqueueAction(action1);
    },

    GetLoanDetailsById: function (component, event, helper) {

        var _Loanid = component.get("v.LoanId");
        var action = component.get("c.GetLoanDetailsById");
        action.setParams({
            "LoanID": _Loanid
        });
        action.setCallback(this, function (data) {

            var datais = data.getReturnValue();
            if (datais.Using_Title_Source_as_the_Closing_Agent__c != undefined) {
                component.set('v.nextDataExist', true);
            }
            else {
                datais.Using_Title_Source_as_the_Closing_Agent__c = 'Yes';
                document.getElementById('targetID').innerHTML = 'l9';
            }
            component.set("v.NewLoan", data.getReturnValue());
            this.validateAndOpenForm(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    validateAndOpenForm: function (component, event, helper) {

        var LDTS = helper.getRadioGroupValue(component, event, helper, "LoanDetailsTitleSource", "v.NewLoan.Using_Title_Source_as_the_Closing_Agent__c");
        //var LDTS = component.find("LoanDetailsTitleSource").get("v.value");
        if (LDTS == "No") {
            component.set("v.Loan_Details", true);
            var a = component.get("v.Loan_Details");
        } else {
            component.set("v.Loan_Details", false);
            var a = component.get("v.Loan_Details");
        }
        component.set("v.clientIncomplete", false);
    },
    formatErrorMethod: function (component, regex, msg, aura_id) {
        //Code if button is clicked
        var flag = false;
        for (var i = 0; i < aura_id.length; i++) {
            var inputCmp = component.find(aura_id[i]);
            var isValid = false;

            if (typeof inputCmp === 'undefined' || typeof inputCmp === null || typeof inputCmp === '') {
            }
            else {
                var value = inputCmp.get("v.value");

                if (typeof regex[i] != "string") {
                    //Checks to see if this is a function and not a regex string
                    isValid = regex[i](value); // Please return true if there is an error or else false
                }
                if (isValid) {
                    //component.set("v.LoanErr", false);//Please leave out this line while replicating. LoanErr may not exist on other compnents
                    inputCmp.set("v.errors", null);
                } else {
                    inputCmp.set("v.errors", [{ message: msg[i] + "." }]);
                    flag = true;
                }
            }
        }
        return flag;
    },
    formatErrorMethodr: function (component, regexr, msgr, aura_idr) {

        //Code if button is clicked
        var flagR = false;
        console.log('aura_idr', aura_idr);
        for (var i = 0; i < aura_idr.length; i++) {
            var inputCmp = component.find(aura_idr[i]);
            if (typeof inputCmp === 'undefined') { } else {
                var value = inputCmp.get("v.value");
                var isRegValid = false;
                if (typeof value === 'undefined' || value == null || value == '') { }
                else {

                    if (value.length != 0) {
                        var rxp = new RegExp(regexr[i]);
                        isRegValid = rxp.test(value);
                        if (isRegValid) {
                            inputCmp.set("v.errors", null);
                        }
                        else {
                            inputCmp.set("v.errors", [{ message: msgr[i] + ":" + value }]);
                            flagR = true;

                        }

                    }
                }
            }
        }
        return flagR;
    },
    FormatPhonehelper: function (component, event, helper) {
        var rxp = new RegExp("^(\\d)\\1{9}$");
        var phone = component.find("ContactPhoneNumber").get("v.value");
        var isRegValid = rxp.test(phone);
        if (isRegValid) {
            component.set("v.NewLoan.Contact_Phone_Number_LoanDetails__c", '');
        }
        else {
            var s2 = ("" + phone).replace(/\D/g, '');
            var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);
            var result = (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
            component.set("v.NewLoan.Contact_Phone_Number_LoanDetails__c", result);
        }
    },
    /*LoanDetailsSave: function(component, event, helper) {
        var newLoan = component.get("v.NewLoan");
        var LoanId = component.get("v.LoanId");
        var action = component.get("c.SaveLoan");
        action.setParams({
            "objNewLoan": newLoan,
            "loanID": LoanId
        });
        action.setCallback(this, function(data) {
            
            var state = data.getState();
            console.log("state is" + state);
            //Goes to the next Step
            this.Loan_Next(component, event, helper);
        });
        $A.enqueueAction(action);
    },*/
    LoanDetailsSave: function (component, event, helper) {
        //Code Started for Story No:- ORMSFDC-1275 by Dev4
        var newLoan = component.get("v.NewLoan");
        var LoanId = component.get("v.LoanId");
        var data = component.get("v.LoanContactDetailsResponse");
        var action = component.get("c.SaveLoanWithPreferredContact");

        action.setParams({
            "objNewLoan": newLoan,
            "loanID": LoanId,
            "LO": data.LoanOfficer,
            "LP": data.LoanProcessor,
            "PC": data.PreferredContact,
        });
        //Code Ended for Story No:- ORMSFDC-1275 by Dev4
        action.setCallback(this, function (data) {

            var state = data.getState();
            console.log("state is" + state);
            //Goes to the next Step
            this.Loan_Next(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    prev: function (component) {
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        $('li#l9').removeClass('active');
        if (!component.get('v.fromPopup')) {
            $A.getCallback(function (result) {
                $('li ul li#l8 a').click();
            });

        } else {
            $('li#9').removeClass('active');
            $('li#l8').addClass('active');
            $('li#l10').removeClass('active');
        }
        window.scrollTo(0, 0);
    },
    Loan_Next: function (component, event, helper) {
        if (event.getSource().getLocalId() == "NextbtnLoanDetails")//Goes to the next step if it is an actual click

        {
            document.getElementById('CapacityLbl').innerHTML = 'NoNeedToMove';

        }
        $('#p2').addClass('autoMoved');
        $('li#l10').removeClass('disabled');
        $('li#l10 a').attr("data-toggle", "tab");
        if (!component.get('v.fromPopup')) {
            $A.getCallback(function (result) {
                $('li#l0 a').click();
            });

        } else {
            $('li#9').removeClass('active');
            $('li#l10').addClass('active');
            $('li#l11').removeClass('active');
        }
        component.set('v.itemsClicked', 'opt10');
        $('li#l9').removeClass('active');
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },

    RestrictZeroInPhoneFirstTime: function (component, event, helper, compId) {
        var inz = component.get(compId);
        var digit = parseInt(inz[0]);
        if (digit == 0) {
            component.set(compId, inz.substring(0, inz.length - 1));
        }
    },
    getRadioGroupValue: function (component, event, helper, id, controlId) {

        var R_ID = id;
        var getValue = component.find(R_ID).get('v.value');
        if ($A.util.isUndefinedOrNull(getValue) || getValue == "") {

        }
        else {
            if (getValue[0].length < 2) {
                component.set(controlId, getValue);
                return getValue;
            }
            else {
                component.set(controlId, getValue[0]);
                return getValue[0];
            }
        }
    },

    //Code Started for Story No:- ORMSFDC-1275 by Dev4
    getLoanOfficerhelper: function (component, event, helper) {

        var id = component.get("v.LoanId");
        var action = component.get("c.getLoanOfficerList");
        action.setCallback(this, function (data) {

            var result = data.getReturnValue();

            console.log('result ', result);
            component.set("v.LoanOfficerList", result);
            this.getLoanProcessorhelper(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    getLoanProcessorhelper: function (component, event, helper) {

        var Res = 0;
        var staticItem = [{
            Id: "Loan Officer",
            Name: "Loan Officer"
        },
        {
            Id: "Loan Processor",
            Name: "Loan Processor"
        }];
        var staticItem1 = [{
            Id: "Loan Officer",
            Name: "Loan Officer"
        }];
        var id = component.get("v.LoanId");
        var action = component.get("c.getLoanProcessorList");
        action.setCallback(this, function (data) {

            var result = data.getReturnValue();
            if (result != null || result != '') {
                Res = result.length;
            }
            else {
                Res = 0;
            }
            if (Res == 0) {
                component.set("v.Preferredlist", staticItem1);
                document.getElementById('LoanProcessor').style.display = 'None';
            }
            else {
                component.set("v.Preferredlist", staticItem);
                document.getElementById('LoanProcessor').style.display = 'block';
                var LoanProcessorList = {
                    Id: "",
                    LoanProcessorName: "---Select One---"
                };
                result.splice(0, 0, LoanProcessorList);
                component.set("v.LoanProcessorList", result);

            }
            // alert("loan contact");
            var checkId = component.get("v.LoanId");
            if (checkId != "undefined") {
                if (checkId != null) {
                    helper.GetLoanContactsById(component, event, helper);

                }

            }
            //component.set("v.LoanProcessorList",result);            
        });
        $A.enqueueAction(action);
    },
    getCurrentUserhelper: function (component, event, helper) {

        var _Loanid = component.get("v.LoanId");
        var action = component.get("c.getUserId");
        action.setParams({
            "LoanID": _Loanid
        });
        action.setCallback(this, function (data) {

            var result = data.getReturnValue();
            if (result != null || result != '') {
                var Res = result.length;
            }
            else {
                var Res = 0;
            }

            component.set("v.LoanContactDetailsResponse.LoanOfficer", result);
            component.set("v.LoanContactDetailsResponse.LoanProcessor", result);
        });
        $A.enqueueAction(action);
    },
    getLoanProcessor: function (component, event, helper) {
        var action = component.get("c.getLoanProcessor");
        var _Loanid = component.get("v.LoanId");

        action.setParams({
            "LoanID": _Loanid
        });
        action.setCallback(this, function (data) {

            var result = data.getReturnValue();
            debugger;
            if (result != null || result != '') {
                component.set("v.isLoanProccessor", result.LoanProcessor);
                component.set("v.isLoanOfficer", result.LoanOfficer);

            }
        });
        $A.enqueueAction(action);
    },
    GetLoanContactsById: function (component, event, helper) {

        var _Loanid = component.get("v.LoanId");
        var action = component.get("c.GetLoanContactsById");
        action.setParams({
            "LoanID": _Loanid
        });
        //var opts = [];
        action.setCallback(this, function (data) {

            var result = data.getReturnValue();

            console.log('>>>>>>>>  result ', result);
            if (result.Preferred_Contact_Type__c != undefined) {
                component.set('v.nextDataExist', true);

            }
            if (typeof result.LoanOfficer__c === 'undefined') {
                helper.getCurrentUserhelper(component, event, helper);
                if (typeof result.Preferred_Contact_Type__c === 'undefined' && typeof result.Loan_Processor__c === 'undefined') {
                    component.set("v.LoanContactDetailsResponse.PreferredContact", "")
                } else if (typeof result.Preferred_Contact_Type__c === 'undefined') {
                    component.set("v.LoanContactDetailsResponse.PreferredContact", "Loan Officer");
                } else {
                    component.set("v.LoanContactDetailsResponse.PreferredContact", result.Preferred_Contact_Type__c);
                    component.set("v.LoanContactDetailsResponse.LoanProcessor", result.Loan_Processor__c);
                }
            }
            else {
                if (typeof result.Loan_Processor__c === 'undefined') {
                    helper.getCurrentUserhelper(component, event, helper);
                    component.set("v.LoanContactDetailsResponse.LoanProcessor", "");
                }
                else {
                    component.set("v.LoanContactDetailsResponse.LoanProcessor", result.Loan_Processor__c);
                }
                component.set("v.LoanContactDetailsResponse.LoanOfficer", result.LoanOfficer__c);
                component.set("v.LoanContactDetailsResponse.PreferredContact", result.Preferred_Contact_Type__c);
            }
            component.set("v.clientIncomplete", false);

        });
        $A.enqueueAction(action);
    },

    LoanContactFormatValidations: function (component, event, helper) {
        debugger;
        var value = component.get("v.LoanContactDetailsResponse.LoanOfficer");
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

            if ($A.util.isEmpty(value)) {
                return false;

            }
            else {
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

        var Isrequired = false;
        var LDCPComp = component.find("SelectpreferredContact");

        if (!$A.util.isUndefinedOrNull(LDCPComp)) {
            var LDCP = LDCPComp.get("v.value");

            if (!$A.util.isUndefinedOrNull(LDCP) || LDCP != "") {

                if (LDCP != undefined) {
                    if (LDCP != "Loan Officer") {
                        Isrequired = this.formatErrorMethod(component, array_reg, array_mes, array_id);
                    }
                    else {
                        var inputCmp = component.find("SelectLoanProcessor");
                        inputCmp.set("v.errors", null);
                        Isrequired = false;
                    }

                }
            } else {

                Isrequired = this.formatErrorMethod(component, array_reg, array_mes, array_id);

            }
        }
        else {
            Isrequired = true;
        }
        return Isrequired;



    },
    //Code Ended for Story No:- ORMSFDC-1275 by Dev4
})