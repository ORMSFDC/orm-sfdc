({
    ValidationForPills: function (component, event, helper) {
        var LoanId = component.get('v.assetLoanId');
        var action1 = component.get("c.Asset_TabsValidatedData");
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
    //Populate Asset data into table based on selected Client
    //PopulateAssetBasedonClient: function(component, event, helper,ClientId) { 
    //Populate Asset data into table based on selected Loan       
    PopulateAssetBasedonClient: function (component, event, helper, LoanId) {
        debugger;
        var LoanId = LoanId;
        if (LoanId != "") {
            var action1 = component.get("c.getAsset");
            action1.setParams({
                LoanId: LoanId
            });
            action1.setCallback(this, function (data) {
                var total = 0;
                var finalresult = data.getReturnValue();
                if (finalresult != undefined) {
                    for (var i = 0; i < finalresult.length; i++) {
                        var e = finalresult[i];
                        if (e.Cash_or_Market_Value__c != undefined) {
                            total += e.Cash_or_Market_Value__c;
                        } else if (e.Life_Insurance_Policy_Face_Value__c != undefined) {
                            total += e.Life_Insurance_Policy_Face_Value__c;
                        } else if (e.Net_Worth_of_Business_es_Owned__c != undefined) {
                            total += e.Net_Worth_of_Business_es_Owned__c;
                        } else if (e.Vested_Interest_in_Retirement_Fund__c != undefined) {
                            total += e.Vested_Interest_in_Retirement_Fund__c;
                        } else if (e.Present_Market_Value__c != undefined) {
                            total += e.Present_Market_Value__c;
                        } else if (e.Other_Asset_Amount__c != undefined) {
                            total += e.Other_Asset_Amount__c;
                        }
                    }
                }
                component.set("v.total", total);
                component.set("v.AssetList", data.getReturnValue());
                var resultLength = finalresult.length;
                if (resultLength == 0) {
                    document.getElementById("AssetCount").style.display = "none";
                    document.getElementById("NoAssetCount").style.display = "block";
                    return false;
                }
                else {
                    document.getElementById("AssetCount").style.display = "block";
                    this.addDelay(component, event, helper, finalresult);
                    document.getElementById("NoAssetCount").style.display = "none";
                }
            });
            $A.enqueueAction(action1);
        }
        else {
            component.set("v.AssetList", null);
            component.set("v.total", 0);
        }
    },

    //Currency Regex Check for Validation
    CurrencyRegexCheck: function (component) {
        var flagR = false;
        var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
        var arr_regr = new Array();
        var arr_funcr = new Array();
        var valArray = [
            { ar_id: "cashMarketValueID", mes: "Please enter a valid number (Non Negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "otherAssetAmtID", mes: "Please enter a valid number (Non Negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "cashMarketStockID", mes: "Please enter a valid number (Non Negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "LifeIPFVID", mes: "Please enter a valid number (Non Negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "RetirementVestedID", mes: "Please enter a valid number (Non Negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "BusinessNetWorthID", mes: "Please enter a valid number (Non Negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "marketValueID", mes: "Please enter a valid number (Non Negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            //{ ar_id: "REO_ZipID", mes: "Please enter a valid zip format (eg: 23454/23456-1234)", reg: "(^\\d{5}$)|(^\\d{5}-\\d{4}$)" }, 
        ];
        array_idr = valArray.map(item => item.ar_id);
        array_mesr = valArray.map(item => item.mes);
        array_regr = valArray.map(item => item.reg);
        for (var i = 0; i < array_idr.length; i++) {
            var inputCmp = component.find(array_idr[i]);
            if (typeof inputCmp === 'undefined') { }
            else {
                var value = inputCmp.get("v.value");
                var isRegValid = false;
                if (typeof value === 'undefined' || value == null || value == '') { }
                else {
                    if (value.length != 0) {
                        var rxp = new RegExp(array_regr[i]);
                        isRegValid = rxp.test(value);
                        if (isRegValid) {
                            inputCmp.set("v.errors", null);
                        }
                        else {
                            inputCmp.set("v.errors", [{ message: array_mesr[i] + ":" + value }]);
                            flagR = true;
                        }
                    }
                }
            }
        }
        return flagR;
    },
    //Edit Asset ater clicking on Edit From table
    GetAssetforEdit: function (component, event, helper) {
        debugger;
        var id = event.target.id;
        var action2 = component.get("c.getAssetById");

        action2.setParams({
            RecordId: id
        });
        action2.setCallback(this, function (data) {
            var state = data.getState();
            var finalresult = data.getReturnValue();
            var getClientId;
            if (state === "SUCCESS") {

                getClientId = finalresult.RelatedClient__c;
                if (finalresult.Category__c == 'Bank/Credit Union') {
                    component.set("v.isBankAccountOpen", true);
                }
                if (finalresult.Category__c == 'Stock & Bonds') {
                    component.set("v.isStockOpen", true);
                }
                if (finalresult.Category__c == 'Life Insurance') {
                    component.set("v.BLRText", 'Face Amount *');
                    component.set("v.isLifeInsuaranceOpen", true);
                }
                if (finalresult.Category__c == 'Retirement Fund') {
                    component.set("v.BLRText", 'Vested Interest in Retirment Fund *');
                    component.set("v.isRetirementOpen", true);
                }
                if (finalresult.Category__c == 'Business') {
                    component.set("v.BLRText", 'Net Worth of Business(es) Owned *');
                    component.set("v.isBusinessOpen", true);
                }

                if (finalresult.Category__c == 'Others') {
                    component.set("v.isOthersOpen", true);
                }

            }
            component.set("v.objAsset", data.getReturnValue());

            if (finalresult.isJoint__c == true) {
                component.find("pickClient").set("v.value", 'Joint');
            }
            else {
                component.find("pickClient").set("v.value", getClientId);
            }
            var category = finalresult.Category__c;
            component.set("v.category", category);
        });
        $A.enqueueAction(action2);
    },
    getAllAssets: function (component, event, helper) {
        var loanId = component.get("v.assetLoanId");
        var action1 = component.get("c.getAllAssets");
        action1.setParams({
            "LoanId": loanId
        });

        action1.setCallback(this, function (data) {
            var state = data.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.AssetsTotal", data.getReturnValue());
            }
        });
        $A.enqueueAction(action1);
    },

    //Save Asset(New Asset or Update Asset) after Clicking the save from popup(first it will check the Validation)
    saveAsset: function (component, event, helper) {
        debugger;
        var ClientId = component.find('pickClient').get('v.value');
        //var ClientId = component.get('v.objAsset.RelatedClient__c');
        var assetCategory = component.get('v.category');
        var action = component.get("c.SaveAsset");
        var loanId = component.get("v.assetLoanId");
        var AssetVal = component.get("v.objAsset");
        action.setParams({
            ObjAsset: AssetVal,
            ClientId: ClientId,
            LoanId: loanId,
            assetCategory: assetCategory
        });
        action.setCallback(this, function (data) {
            debugger;
            component.set("v.isBankAccountOpen", false);
            component.set("v.isStockOpen", false);
            component.set("v.isLifeInsuaranceOpen", false);
            component.set("v.isRetirementOpen", false);
            component.set("v.isBusinessOpen", false);
            // component.set("v.isREOOpen", false);
            component.set("v.isOthersOpen", false);
            var Loan = component.get("v.assetLoanId");
            helper.PopulateAssetBasedonClient(component, event, helper, Loan);
            helper.ClearData(component, event, helper);
            component.set("v.objAsset.Category__c", "Select one");
            component.find('addAsset').set('v.disabled', true);
        });
        $A.enqueueAction(action);
    },
    //Will show the delete popup
    deleteAsset: function (component, event, helper) {
        var id = event.target.id;
        component.set("v.idIs", id);
        component.set("v.showPopup", true);
    },

    //will delete the Asset
    doAction: function (component, event, helper) {
        var id = component.get("v.idIs");
        var action = component.get("c.DeleteAsset");
        action.setParams({
            RecordId: id
        });

        action.setCallback(this, function (data) {
            component.set("v.showPopup", false);
            //var ClientId = component.get("v.ClientID");
            var Loanid = component.get("v.assetLoanId");
            helper.PopulateAssetBasedonClient(component, event, helper, Loanid);
            helper.getAllAssets(component, event, helper);

        });
        $A.enqueueAction(action);
    },

    //will close the delete popup
    closeModel_helper: function (component, event, helper) {
        component.set("v.showPopup", false);
    },
    //Clear data from Popup for adding new Asset
    ClearData: function (component, event, helper) {
        var editselectedRecord = {
            'sobjectType': 'Asset',
            'Cash_or_Market_Value__c': '',
            'Category__c': '',
            'Company_Name_for_Stocks_or_Bonds__c': '',
            'Company_Name_Number__c': '',
            'Name_of_Bank_S_L_Credit_Union__c': '',
            'Net_Worth_of_Business_es_Owned__c': '',
            'Other_Asset_Amount__c': '',
            'Other_Assets_Type__c': '',
            'Type_of_Account__c': '',
            'Type__c': '',
            'Vested_Interest_in_Retirement_Fund__c': '',
            'Cash_or_Market_Value_for_Stocks_or_Bonds__c': '',
            'Life_Insurance_Policy_Face_Value__c': '',
        };
        component.set("v.objAsset", editselectedRecord);
        component.find('addAsset').set('v.disabled', true);
    },
    //Will move to next Tab of Stat A new Loan
    Loan_Next: function (component, event, helper) {
        $('li#l7').removeClass('disabled');
        $('li#l7 a').attr("data-toggle", "tab");
        if (!component.get('v.fromPopup')) {
            $A.getCallback(function (result) {
                $('li#l7 a').click();
            });
        } else {
            $('li#l6').removeClass('active');
            $('li#l7').addClass('active');
            $('li#l8').removeClass('active');
        }
        component.set('v.itemsClicked', 'opt7');

        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },

    //Will move to previous Tab of Start A New Loan
    prev: function (component) {
        if (!component.get('v.fromPopup')) {
            $A.getCallback(function (result) {
                $('li#l5 a').click();
            });
        } else {
            $('li#l4').removeClass('active');
            $('li#l5').addClass('active');
            $('li#l6').removeClass('active');
        }
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },

    //Will Check Required Validation
    formatErrorMethod: function (component, regex, msg, aura_id) {
        var flag = false;
        for (var i = 0; i < aura_id.length; i++) {
            var inputCmp = component.find(aura_id[i]);
            var value = inputCmp.get("v.value");
            var isValid = false;
            if (typeof regex[i] != "string") {
                //Checks to see if this is a function and not a regex string
                isValid = regex[i](value); // Please return true if there is an error or else false
            }
            if (isValid) {
                inputCmp.set("v.errors", null);
                $A.util.removeClass(inputCmp, 'errorComponent');
            } else {
                inputCmp.set("v.errors", [{ message: msg[i] }]);
                inputCmp.focus();
                $A.util.addClass(inputCmp, 'errorComponent');
                flag = true;
            }
        }
        return flag;
    },
    addDelay: function (component, event, helper, finalresult) {
        var delay = 1000; //4 seconds                                
        setTimeout(function () {
            var ClientCount = component.get("v.clientCount");
            var table = document.getElementById("mytable");
            for (var i = 4; i < ClientCount + 4; i++) {
                var C1 = table.rows[0].cells[i].innerHTML;
                for (var j = 0; j < finalresult.length; j++) {
                    if (finalresult[j].isJoint__c == true) {
                        table.rows[j + 1].cells[i].innerHTML = '&#10004;';
                    }
                    else {
                        if (typeof finalresult[j].RelatedClient__r.Name === 'undefined') {

                        }
                        else {
                            if (C1 == finalresult[j].RelatedClient__r.Name) {
                                table.rows[j + 1].cells[i].innerHTML = '&#10004;';
                            }
                        }
                    }

                }
            }
        }, delay);
    },
    ClientSelected: function (component, event, helper, finalresult) {
        var Client = component.find('pickClient').get('v.value');
        if (Client == '') {
            component.set("v.isClentSelected", "true");
        }
        else {
            component.set("v.isClentSelected", "false");
        }


    }

})