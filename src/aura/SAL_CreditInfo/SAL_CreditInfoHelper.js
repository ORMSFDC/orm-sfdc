({
    ValidationForPills: function (component, event, helper) {
        var LoanId = component.get('v.LoanId');
        var action1 = component.get("c.CreditInfo_TabsValidatedData");
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
    GetSubmitButtonEnabledStatus: function (component, event, helper) {
        var action = component.get("c.GetButtonEnableFlag");
        action.setParams({
            "LoanID": component.get("v.LoanId")
        });
        action.setCallback(this, function (data) {
            debugger;
            var result = data.getReturnValue();
            //True means Loan created MAnually
            var ISLoanCreatedManually = result.IsLoancreatedMAnually;
            //True means Tabs Validated
            var IsTabsValidated = result.CompleteStatus;
            if (ISLoanCreatedManually == true) {
                component.set("v.TabErrorMsg", false);
                component.set("v.showError_Decla", false);
                component.set("v.SubmitbtnDisabled", false);
                /* if(IsTabsValidated==true)
                {
                    component.set("v.showError_Decla",false);
                    component.set("v.SubmitbtnDisabled",false);
                }
                else{
                    component.set("v.showError_Decla",true);
                    component.set("v.SubmitbtnDisabled",True);
                }*/
            }
            else {
                if (IsTabsValidated == true) {
                    component.set("v.TabErrorMsg", false);
                    component.set("v.SubmitbtnDisabled", false);
                }
                else {
                    component.set("v.TabErrorMsg", true);
                    component.set("v.SubmitbtnDisabled", True);
                }
            }
        });
        $A.enqueueAction(action);
    },
    GetCreditInfoById: function (component, event, helper) {
        //alert(component.get("v.LoanId"));
        var action = component.get("c.GetcreditInfoById");
        action.setParams({

            "LoanID": component.get("v.LoanId")
        });

        action.setCallback(this, function (data) {
            var result = data.getReturnValue();
            component.set("v.NewCredit", result);
            var LDTS = component.find("SelectNewCredit").get("v.value");
            if (LDTS == "Pull New Credit") {
                component.set("v.PullNewCredit", true);
                var a = component.get("v.PullNewCredit");
            }
            else {
                component.set("v.PullNewCredit", false);
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

        });
        $A.enqueueAction(action);
    },

    prev: function (component) {
        // <!--Code Started for Story No:- ORMSFDC-1275 by Dev4-->
        document.getElementById('CapacityLbl').innerHTML = 'NoNeedToMove';
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        $('li#l11').removeClass('active');
        //  $('li ul li#l10 a').click();
        if (!component.get('v.fromPopup')) {
            $A.getCallback(function (result) {
                $('li ul li#l10 a').click();
            });
        } else {
            $('li#l9').removeClass('active');

            $('li#l10').addClass('active');
            $('li#l11').removeClass('active');

        }

        //<!--Code Ended for Story No:- ORMSFDC-1275 by Dev4-->
        window.scrollTo(0, 0);
    },
    /*GetClientNamebyLoanId : function(component, event, helper) {  
        
        var action = component.get("c.GetClientByLoanId"); 
        action.setParams({
            
            "LoanID":component.get("v.LoanId")
        });
        //alert(component.get("v.LoanId"));
        action.setCallback(this, function(data) {          
            component.set("v.ClientName",data.getReturnValue()); 
            //component.set("v.NewCredit",data.getReturnValue()); 
            var LDTS = component.find("SelectNewCredit").get("v.value");
            if(LDTS == "Pull New Credit")
            {
                component.set("v.PullNewCredit",true);
                var a = component.get("v.PullNewCredit");
            }
            else{component.set("v.PullNewCredit",false);
                 var a = component.get("v.PullNewCredit");}
            
            if(LDTS == "Reissue Credit")
            {
                component.set("v.ReIssueCredit",true);
                var a = component.get("v.ReIssueCredit");
            }
            else{component.set("v.ReIssueCredit",false);
                 var a = component.get("v.ReIssueCredit");}
            
        });
        $A.enqueueAction(action);
    }*/
    CreditInfoSave: function (component, event, helper) {
        var action = component.get("c.SaveCreditInfo");
        action.setParams({
            "ObjCreditInfo": component.get("v.NewCredit"),
            "loanID": component.get("v.LoanId")
        });
        action.setCallback(this, function (data) {
            this.LoanExitHelper(component, event, helper);
        });

        $A.enqueueAction(action);

        //create task for AE- Bala - 4/20
        var action2 = component.get("c.createAETask");
        action2.setParams({
            'LoanID': component.get("v.LoanId")
        });
        action2.setCallback(this, function () {
            alert(getReturnValue());
        });
        $A.enqueueAction(action2);
    },

    /*CreditInfoFinal: function(component,event,helper)
    {
        debugger;
        var action = component.get("c.SaveLoanCompleteFlag");  
        //alert(component.get("v.LoanId")); 
        action.setParams({           
            "loanID":component.get("v.LoanId")
            
        });
        action.setCallback(this, function(data) {  
            
            this.LoanExitHelper(component, event, helper);
        });
        
        $A.enqueueAction(action); 
        //component.set("v.newLoan", false);
        //helper.PopulateClients(component, event, helper);
    },*/

    formatErrorMethod: function (component, regex, msg, aura_id) {
        //debugger;
        //Code if button is clicked
        var flag = false;
        for (var i = 0; i < aura_id.length; i++) {
            var inputCmp = component.find(aura_id[i]);
            var isValid = false;
            if (typeof inputCmp === 'undefined' || typeof inputCmp === null || typeof inputCmp === '') {
                //isValid = false;
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

    CheckCreditNumber: function (component, event, helper) {
        var CreditId = component.find('CreditRefNumber');
        var ConCreditId = component.find('ConCreditRefNumber');
        var IsValid = false;
        if (typeof CreditId === 'undefined' || typeof ConCreditId === 'undefined') {
            IsValid = false;
        }
        else {
            var CreditRefNumber = component.find('CreditRefNumber').get('v.value');
            var ConCreditRefNumber = component.find('ConCreditRefNumber').get('v.value');

            if (!$A.util.isEmpty(CreditRefNumber) || !$A.util.isEmpty(ConCreditRefNumber)) {
                if (CreditRefNumber != ConCreditRefNumber) {
                    var ConCreditRefNumberInp = component.find("ConCreditRefNumber");
                    var CreditRefNumberInp = component.find("CreditRefNumber");
                    CreditRefNumberInp.set("v.errors", [{ message: 'Credit Reference Number do not match.' }]);
                    ConCreditRefNumberInp.set("v.errors", [{ message: 'Credit Reference Number do not match.' }]);
                    component.set("v.showError", true);
                    IsValid = true;

                }
                else {
                    var ConCreditRefNumberInp = component.find("ConCreditRefNumber");
                    var CreditRefNumberInp = component.find("CreditRefNumber");
                    ConCreditRefNumberInp.set("v.errors", null);
                    CreditRefNumberInp.set("v.errors", null);
                    component.set("v.showError", false);
                    IsValid = false;
                }
            }
            else {
                IsValid = false;
            }
        }
        return IsValid;
    },

    FormatRefNumberhelper: function (component, event, helper) {
        var rxp = new RegExp("^(\\d)\\1{9}$");
        var CreditRefNumber = component.find("CreditRefNumber").get("v.value");
        var ConCreditRefNumber = component.find("ConCreditRefNumber").get("v.value");
        var isRegValid1 = rxp.test(CreditRefNumber);
        var isRegValid2 = rxp.test(ConCreditRefNumber);
        if (isRegValid1) {
            component.set("v.NewCredit.Credit_Reference_Number__c", '');

        } else {

            var result = ("" + CreditRefNumber).replace(/\D/g, '');
            //var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
            //var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];            
            component.set("v.NewCredit.Credit_Reference_Number__c", result);
        }
        if (isRegValid2) {
            component.set("v.NewCredit.Confirm_Credit_Reference_Number__c", '');
        } else {
            var result = ("" + ConCreditRefNumber).replace(/\D/g, '');
            //var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
            //var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
            component.set("v.NewCredit.Confirm_Credit_Reference_Number__c", result);
        }
    },
    LoanExitHelper: function (component, event, helper) {
        document.getElementById('startnewloan').style.display = 'none';
        document.getElementById('thnksdiv').style.display = 'block';
    },

    CreditInfoValidationMethod: function (component, regex, msg, aura_id) {
        var inputCmp = component.find(aura_id);
        var value = inputCmp.get("v.value");
        var isValid = regex.test(value);
        if (isValid) {
            component.set("v.LoanErr", false);
            inputCmp.set("v.errors", null);
        } else {
            inputCmp.set("v.errors", [{ message: msg + ":" + value }]);
            component.set("v.LoanErr", true);
        }
    },

    GetClientSize: function (component, event, helper) {
        var action = component.get("c.GetAllClientByLoanId");
        action.setParams({
            "LoanID": component.get("v.LoanId")
        });
        action.setCallback(this, function (data) {
            var ClientSize = data.getReturnValue();
            if (ClientSize == 1) {
                component.set("v.PullNewCredit", false);
                component.set("v.PullNewCreditNoJoint", true);
            }
            else {
                component.set("v.PullNewCreditNoJoint", false);
                component.set("v.PullNewCredit", true);
            }

        });
        $A.enqueueAction(action);
    },
})