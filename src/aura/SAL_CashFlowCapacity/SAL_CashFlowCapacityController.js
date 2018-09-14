({
    doInit: function (component, event, helper) {
        helper.ValidationForPills(component, event, helper);
        window.scrollTo(0, 0);
        var loanID = component.get('v.LoanId');
        var action = component.get("c.getCashFlowData");
        action.setParams({
            "LoanID": loanID
        });
        action.setCallback(this, function (data) {
            debugger;
            var result = data.getReturnValue();
            component.set("v.CashFlowdata", result);
            var CashFlow = result.CashFlow;
            var TotalCapacity = result.TotalCapacity;
            var CapacityStorage = result.CapacityStorage;

            if (result.HouseholdMembers == '' || typeof result.HouseholdMembers === 'undefined') {
                component.set("v.showError", true);

            }
            else {
                component.set("v.showError", false)
                // alert('Not blank');
            }
            if (CashFlow.toString().indexOf("(") != -1) {
                helper.applyCSS(component, event, helper, 'CashFlowVal');
            }
            if (TotalCapacity.toString().indexOf("(") != -1) {
                helper.applyCSS(component, event, helper, 'TotalCapacityVal');
            }
            if (CapacityStorage.toString().indexOf("(") != -1) {
                helper.applyCSS(component, event, helper, 'CapacityShortageVal');
            }
            helper.GetCashFlowViewedStatus(component, event, helper);
            document.getElementById('targetID').innerHTML = 'l10';
        });
        $A.enqueueAction(action);

    },
    Continue: function (component, event, helper) {
        var _Loanid = component.get("v.LoanId");
        var action = component.get("c.UpdateCashFlowStatus");
        action.setParams({
            "loanID": _Loanid
        });
        action.setCallback(this, function (data) {
            helper.Loan_Next(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    nexttab: function (component, event, helper) {
        var el = document.getElementById('CapacityLbl');
        if (el.innerText == 'Move') {
            if (component.get("v.Incomplete")) {
                $('li#l11').removeClass('disabled');
                $('li#l11 a').attr("data-toggle", "tab");
                $A.getCallback(function (result) {
                    $('li#l11 a').click();
                });
                component.set("v.nextOpt", "true");
                component.set("v.currentOpt", "false");
                window.scrollTo(0, 0);
            }
        }
    },
    previous: function (component, event, helper) {
        helper.prev(component, event, helper);
    },
})