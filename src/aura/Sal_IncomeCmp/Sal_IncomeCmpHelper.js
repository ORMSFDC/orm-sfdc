({
    
    PopulateIncomeBasedonClient : function(component, event, helper,ClientId) {
        var ClientId = ClientId;
        var action1 = component.get("c.getIncomeData");
        action1.setParams({
            "ClientId" : ClientId
        });
        action1.setCallback(this, function(data) {
            var result=data.getReturnValue();
            var total = 0;
            if (result != undefined) {
                
                var e = result;
                if (e.Alimony_ChildSupport_Income__c != undefined) {
                    total += e.Alimony_ChildSupport_Income__c;
                }  if (e.Automobile_Expense_Income__c != undefined) {
                    total += e.Automobile_Expense_Income__c;
                }  if (e.Boarder_Income__c != undefined) {
                    total += e.Boarder_Income__c;
                } if (e.Capital_Gains__c != undefined) {
                    total += e.Capital_Gains__c;
                }if (e.Disability_Income__c != undefined) {
                    total += e.Disability_Income__c;
                } if (e.Foster_Care_Income__c != undefined) {
                    total += e.Foster_Care_Income__c;
                } if (e.Military_Base_Pay__c != undefined) {
                    total += e.Military_Base_Pay__c;
                } if (e.Military_Clothes_Allowance__c != undefined) {
                    total += e.Military_Clothes_Allowance__c;
                } if (e.Military_Combat_Pay__c != undefined) {
                    total += e.Military_Combat_Pay__c;
                } if (e.Military_Flight_Pay__c != undefined) {
                    total += e.Military_Flight_Pay__c;
                } if (e.Military_Hazard_Pay__c != undefined) {
                    total += e.Military_Hazard_Pay__c;
                } if (e.Military_Overseas_Pay__c != undefined) {
                    total += e.Military_Overseas_Pay__c;
                } if (e.Military_Prop_Pay__c != undefined) {
                    total += e.Military_Prop_Pay__c;
                } if (e.Military_Quarters_Allowance__c != undefined) {
                    total += e.Military_Quarters_Allowance__c;
                } if (e.Military_Rations_Allowance__c != undefined) {
                    total += e.Military_Rations_Allowance__c;
                } if (e.Military_Variable_Housing_allowance__c != undefined) {
                    total += e.Military_Variable_Housing_allowance__c;
                } if (e.Mortgage_Credit_Certificate__c != undefined) {
                    total += e.Mortgage_Credit_Certificate__c;
                } if (e.Mortgage_Differential_Certificate__c != undefined) {
                    total += e.Mortgage_Differential_Certificate__c;
                } if (e.Notes_Receivable_Installment__c != undefined) {
                    total += e.Notes_Receivable_Installment__c;
                } if (e.Other_Income__c != undefined) {
                    total += e.Other_Income__c;
                } if (e.Pension_Retirement_Income__c != undefined) {
                    total += e.Pension_Retirement_Income__c;
                } if (e.Social_Security_Disability_Income__c != undefined) {
                    total += e.Social_Security_Disability_Income__c;
                } if (e.SubjectProperty_Income__c != undefined) {
                    total += e.SubjectProperty_Income__c;
                } if (e.Temporary_Leave_income__c != undefined) {
                    total += e.Temporary_Leave_income__c;
                } if (e.Trust_Income__c != undefined) {
                    total += e.Trust_Income__c;
                } if (e.Unemployment_Welfare_Income__c != undefined) {
                    total += e.Unemployment_Welfare_Income__c;
                } if (e.VA_Benefits_non_education__c != undefined) {
                    total += e.VA_Benefits_non_education__c;
                }/* if (e.Bonus_Income__c != undefined) {
                    total += e.Bonus_Income__c;
                } if (e.OverTime_Income__c != undefined) {
                    total += e.OverTime_Income__c;
                }*/ if (e.Dividents_Interest_Income__c != undefined) {
                    total += e.Dividents_Interest_Income__c;
                } if (e.Base_Employment_Income__c != undefined) {
                    total += e.Base_Employment_Income__c;
                } if (e.Net_Rental_Income__c != undefined) {
                    total += e.Net_Rental_Income__c;
                }
            }
            component.set("v.total", total);
            component.set("v.IncomeList", result);
            var cid = component.find("pickClient").get("v.value");
            var ReturnData = data.getReturnValue();
            
            if(ReturnData.Alimony_ChildSupport_Income__c != '' && ReturnData.Alimony_ChildSupport_Income__c != null) 
            {
                component.set('v.divAlimony', true);
            }
            else                 
            {
                component.set('v.divAlimony', false);
            }
            if(ReturnData.Automobile_Expense_Income__c != '' && ReturnData.Automobile_Expense_Income__c != null) 
            {
                component.set('v.divAutomobile', true);
            }
            else                 
            {
                component.set('v.divAutomobile', false);
            }
            if(ReturnData.Boarder_Income__c != '' && ReturnData.Boarder_Income__c != null) 
            {
                component.set('v.divBoarder', true);
            }
            else                 
            {
                component.set('v.divBoarder', false);
            }
            if(ReturnData.Capital_Gains__c != '' && ReturnData.Capital_Gains__c != null) 
            {
                component.set('v.divCapitalGains', true);
            }
            else                 
            {
                component.set('v.divCapitalGains', false);
            }
            if(ReturnData.Disability_Income__c != '' && ReturnData.Disability_Income__c != null) 
            {
                component.set('v.divDisability', true);
            }
            else                 
            {
                component.set('v.divDisability', false);
            }
            if(ReturnData.Foster_Care_Income__c != '' && ReturnData.Foster_Care_Income__c != null) 
            {
                component.set('v.divFaosterCare', true);
            }
            else                 
            {
                component.set('v.divFaosterCare', false);
            }
            if(ReturnData.Military_Base_Pay__c != '' && ReturnData.Military_Base_Pay__c != null) 
            {
                component.set('v.divMilitaryBasePay', true);
            }
            else                 
            {
                component.set('v.divMilitaryBasePay', false);
            }
            if(ReturnData.Military_Clothes_Allowance__c != '' && ReturnData.Military_Clothes_Allowance__c != null) 
            {
                component.set('v.divMilitaryClothAllowance', true);
            }
            else                 
            {
                component.set('v.divMilitaryClothAllowance', false);
            }
            if(ReturnData.Military_Combat_Pay__c != '' && ReturnData.Military_Combat_Pay__c != null) 
            {
                component.set('v.divMilitaryCombatPay', true);
            }
            else                 
            {
                component.set('v.divMilitaryCombatPay', false);
            }
            if(ReturnData.Military_Flight_Pay__c != '' && ReturnData.Military_Flight_Pay__c != null) 
            {
                component.set('v.divMilitaryFlightPay', true);
            }
            else                 
            {
                component.set('v.divMilitaryFlightPay', false);
            }
            if(ReturnData.Military_Hazard_Pay__c != '' && ReturnData.Military_Hazard_Pay__c != null) 
            {
                component.set('v.divMilitaryHazardPay', true);
            }
            else                 
            {
                component.set('v.divMilitaryHazardPay', false);
            }
            if(ReturnData.Military_Overseas_Pay__c != '' && ReturnData.Military_Overseas_Pay__c != null) 
            {
                component.set('v.divMilitaryOverseasPay', true);
            }
            else                 
            {
                component.set('v.divMilitaryOverseasPay', false);
            }
            if(ReturnData.Military_Prop_Pay__c != '' && ReturnData.Military_Prop_Pay__c != null) 
            {
                component.set('v.divMilitaryPropPay', true);
            }
            else                 
            {
                component.set('v.divMilitaryPropPay', false);
            }
            if(ReturnData.Military_Quarters_Allowance__c != '' && ReturnData.Military_Quarters_Allowance__c != null) 
            {
                component.set('v.divMilitaryQuartersAllowance', true);
            }
            else                 
            {
                component.set('v.divMilitaryQuartersAllowance', false);
            }
            if(ReturnData.Military_Rations_Allowance__c != '' && ReturnData.Military_Rations_Allowance__c != null) 
            {
                component.set('v.divMilitaryRationsAllowance', true);
            }
            else                 
            {
                component.set('v.divMilitaryRationsAllowance', false);
            }
            if(ReturnData.Military_Variable_Housing_allowance__c != '' && ReturnData.Military_Variable_Housing_allowance__c != null) 
            {
                component.set('v.divMilitaryVariableHousigAllowance', true);
            }
            else                 
            {
                component.set('v.divMilitaryVariableHousigAllowance', false);
            }
            if(ReturnData.Mortgage_Credit_Certificate__c != '' && ReturnData.Mortgage_Credit_Certificate__c != null) 
            {
                component.set('v.divMortgageCreditCertificate', true);
            }
            else                 
            {
                component.set('v.divMortgageCreditCertificate', false);
            }
            if(ReturnData.Mortgage_Differential_Certificate__c != '' && ReturnData.Mortgage_Differential_Certificate__c != null) 
            {
                component.set('v.divMortgageDifferentialCertificate', true);
            }
            else                 
            {
                component.set('v.divMortgageDifferentialCertificate', false);
            }
            if(ReturnData.Notes_Receivable_Installment__c != '' && ReturnData.Notes_Receivable_Installment__c != null) 
            {
                component.set('v.divNotesRecievableInstallment', true);
            }
            else                 
            {
                component.set('v.divNotesRecievableInstallment', false);
            }
            if(ReturnData.Other_Income__c != '' && ReturnData.Other_Income__c != null) 
            {
                component.set('v.divOtherTypeOfIncome', true);
            }
            else                 
            {
                component.set('v.divOtherTypeOfIncome', false);
            }
            if(ReturnData.OverTime_Income__c != '' && ReturnData.OverTime_Income__c != null) 
            {
                component.set('v.divOverTime', true);
            }
            else                 
            {
                component.set('v.divOverTime', false);
            }
            if(ReturnData.Bonus_Income__c != '' && ReturnData.Bonus_Income__c != null) 
            {
                component.set('v.divBonus', true);
            }
            else                 
            {
                component.set('v.divBonus', false);
            }
            if(ReturnData.Pension_Retirement_Income__c != '' && ReturnData.Pension_Retirement_Income__c != null) 
            {
                component.set('v.divPensionRetirement', true);
            }
            else                 
            {
                component.set('v.divPensionRetirement', false);
            }
            if(ReturnData.Social_Security_Disability_Income__c != '' && ReturnData.Social_Security_Disability_Income__c != null) 
            {
                component.set('v.divSocialSecurity', true);
            }
            else                 
            {
                component.set('v.divSocialSecurity', false);
            }
            if(ReturnData.SubjectProperty_Income__c != '' && ReturnData.SubjectProperty_Income__c != null) 
            {
                component.set('v.divSubjectProperty', true);
            }
            else                 
            {
                component.set('v.divSubjectProperty', false);
            }
            if(ReturnData.Temporary_Leave_income__c != '' && ReturnData.Temporary_Leave_income__c != null) 
            {
                component.set('v.divTemporaryLeave', true);
            }
            else                 
            {
                component.set('v.divTemporaryLeave', false);
            }
            if(ReturnData.Trust_Income__c != '' && ReturnData.Trust_Income__c != null) 
            {
                component.set('v.divTrust', true);
            }
            else                 
            {
                component.set('v.divTrust', false);
            }
            if(ReturnData.Unemployment_Welfare_Income__c != '' && ReturnData.Unemployment_Welfare_Income__c != null) 
            {
                component.set('v.divUnemployment', true);
            }
            else                 
            {
                component.set('v.divUnemployment', false);
            }
            if(ReturnData.VA_Benefits_non_education__c != '' && ReturnData.VA_Benefits_non_education__c != null) 
            {
                component.set('v.divVABenefits', true);
            }
            else                 
            {
                component.set('v.divVABenefits', false);
            }
        });
        $A.enqueueAction(action1);
        
        
    },
    VisiilityForOptionalValues:function(component, event, helper) {
        var newselectedRecord = {
            'sobjectType': 'Income__c',
            'Bonus_Income__c': '',
            'OverTime_Income__c': '',
            'Dividents_Interest_Income__c': '',
            'Net_Rental_Income__c': ''
        };
        component.set("v.IncomeList", newselectedRecord);
    },
    
    Saveincome:function(component, event, helper) {
        component.set("v.showError", false);        
        var ClientId = component.get("v.ClientID");
        var incomeVal = component.get("v.IncomeList");        
        var LoanId = component.get("v.IncomeLoanId");        
        var action = component.get("c.incomesave");
        var nextFlag = new String();
        action.setParams({
            ObjIncome: incomeVal,
            ClientId: ClientId,
            LoanId: LoanId
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            component.set("v.recordSaved", true);
            component.set("v.showSuccess", true);
            this.PopulateIncomeBasedonClient(component, event, helper,ClientId);
        });        
        $A.enqueueAction(action);        
    },
    
    getAllIncome:function(component, event, helper)
    {
        var LoanId = component.get("v.IncomeLoanId");        
        var action1 = component.get("c.getAllIncome");
         action1.setParams({
            "LoanId": LoanId
        });
        
        action1.setCallback(this, function(data) {
            var state = data.getState();            
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.ClientIncome", data.getReturnValue());                
            }
        });
        $A.enqueueAction(action1);
    },
    
    CurrencyRegexCheck: function(component) {
        var flagR = false;
        var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
        var arr_regr = new Array();
        var arr_funcr = new Array();
        var valArray = [
            
            { ar_id: "AlimonyChildSupport", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "socialIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "pensionIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "dividendIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "baseIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "netRentalIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "AutomobileExpance", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "BorderIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "CapitalGain", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "DisabilityIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },            
            { ar_id: "FosterCare", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MBasePay", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MClothAllow", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MCombatPay", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MFlightPay", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MHazardPay", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MoverseaPay", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MpropPay", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MQuaterAllow", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MrationAllow", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MDiffCertificate", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MortgageCreditCertificate", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "MVHousingAllow", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "NotesRecevIns", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "OTI", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "OvertimeIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "BonusIncome", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "VABenifit", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "Unempasst", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "Trust", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "TempLeave", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            { ar_id: "SubpronetCash", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },
            
        ];
            array_idr = valArray.map(item => item.ar_id);
            array_mesr = valArray.map(item => item.mes);
            array_regr = valArray.map(item => item.reg);            
            for (var i = 0; i < array_idr.length; i++) {
            var inputCmp = component.find(array_idr[i]);
        if(typeof inputCmp==='undefined' || inputCmp==null || inputCmp=='')
        {}else{
            var value = inputCmp.get("v.value");            
            var isRegValid = false;
            if(typeof value==='undefined' || value==null || value=='')
            {}
            else
            {
                if (value.length !=0 ) {
                    
                    var rxp = new RegExp(array_regr[i]);
                    
                    isRegValid = rxp.test(value);
                    if (isRegValid) {
                        
                        inputCmp.set("v.errors", null);                        
                        
                    } 
                    else {
                        inputCmp.set("v.errors", [{ message: array_mesr[i] + "."  }]);
                        
                        flagR = true;                        
                    }                     
                } 
            }
        }}
    return flagR;
},
 
 formatErrorMethod: function(component, regex, msg, aura_id) {
    //Code if button is clicked
    var flag = false;
    for (var i = 0; i < aura_id.length; i++) {
        
        var inputCmp = component.find(aura_id[i]);
        if(typeof inputCmp==='undefined' || inputCmp==null || inputCmp=='')
        {}else{
            var value = inputCmp.get("v.value");
            var isValid = false;
            
            if (typeof regex[i] != "string") {
                //Checks to see if this is a function and not a regex string
                isValid = regex[i](value); // Please return true if there is an error or else false
            } else {
                var rxp = new RegExp(regex[i]);
                isValid = rxp.test(value);
            }
            if (isValid) {
                //Please leave out this line while replicating. LoanErr may not exist on other compnents
                inputCmp.set("v.errors", null);
                
            } else {
                inputCmp.set("v.errors", [{ message: msg[i] + "."  }]);
                //Please leave out this line while replicating. LoanErr may not exist on other compnents
                flag = true;
            }}
    }
    return flag;
},
    
    Loan_Next : function(component, event, helper) {
        $('li#l6').removeClass('disabled');
        $('li#l6 a').attr("data-toggle","tab");
        $('li#l6 a').click();
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);        
    },
        
        prev : function(component) {
            $('li#l4 a').click();
            component.set("v.prevOpt", "true");
            component.set("v.currentOpt", "false");
            window.scrollTo(0, 0);
        },
            
            IncomeFormatValidations : function(component, regex, msg, aura_id) {
                var inputCmp = component.find(aura_id);
                var value = inputCmp.get("v.value");
                var isValid = regex.test(value);
                if (isValid) {
                    component.set("v.LoanErr", false);
                    inputCmp.set("v.errors", null);
                } else {
                    inputCmp.set("v.errors", [ {
                        message : msg + ":" + value
                    } ]);
                    component.set("v.LoanErr", true);
                }
            },
                
                HideIncome: function(component, event, helper) {
                    // set additional income attribute to "False" 
                    component.set('v.divAlimony', false);
                    component.set('v.divAutomobile', false);
                    component.set('v.divBoarder', false);
                    component.set('v.divCapitalGains', false);
                    component.set('v.divDisability', false);
                    component.set('v.divFaosterCare', false);
                    component.set('v.divMilitaryBasePay', false);
                    component.set('v.divMilitaryClothAllowance', false);
                    component.set('v.divMilitaryCombatPay', false);
                    component.set('v.divMilitaryFlightPay', false);
                    component.set('v.divMilitaryHazardPay', false);
                    component.set('v.divMilitaryOverseasPay', false);
                    component.set('v.divMilitaryPropPay', false);
                    component.set('v.divMilitaryQuartersAllowance', false);
                    component.set('v.divMilitaryRationsAllowance', false);
                    component.set('v.divMilitaryVariableHousigAllowance', false);
                    component.set('v.divMortgageCreditCertificate', false);
                    component.set('v.divMortgageDifferentialCertificate', false);
                    component.set('v.divNotesRecievableInstallment', false);
                    component.set('v.divOtherTypeOfIncome', false);
                    component.set('v.divOverTime', false);
                    component.set('v.divBonus', false);
                    component.set('v.divPensionRetirement', false);
                    component.set('v.divSocialSecurity', false);
                    component.set('v.divSubjectProperty', false);
                    component.set('v.divTemporaryDisability', false);
                    component.set('v.divTemporaryLeave', false);
                    component.set('v.divTrust', false);
                    component.set('v.divUnemployment', false);
                    component.set('v.divVABenefits', false);
                    component.set('v.divDividend', false);
                    component.set('v.divBase', false);
                    component.set('v.divNetRental', false);
                },
                SetId: function(component, event, helper)
				{
                    var value=component.find('incomePicklist').get('v.value');
                    if(value=='Alimony/Child Support Income')
                    {
                        component.set("v.CntrlId",'AlimonyChildSupport');
                    }
                    else if(value=='Automobile Expense Amount')
                    {
                        component.set("v.CntrlId",'AutomobileExpance');
                    }
                    else if(value=='Boarder Income')
                    {
                        component.set("v.CntrlId",'BorderIncome');
                    }
                    else if(value=='Capital Gains')
                    {
                        component.set("v.CntrlId",'CapitalGain');
                    }
                    else if(value=='Disability Income')
                    {
                        component.set("v.CntrlId",'DisabilityIncome');
                    }
                    else if(value=='Foster Care')
                    {
                        component.set("v.CntrlId",'FosterCare');
                    }
                    else if(value=='Millitary Base Pay')
                    {
                        component.set("v.CntrlId",'MBasePay');
                    }
                    else if(value=='Millitary Clothes Allowance')
                    {
                        component.set("v.CntrlId",'MClothAllow');
                    }
                    else if(value=='Millitary Combat Pay')
                    {
                        component.set("v.CntrlId",'MCombatPay');
                    }
                    else if(value=='Millitary Flight Pay')
                    {
                        component.set("v.CntrlId",'MFlightPay');
                    }
                    else if(value=='Millitary Hazard Pay')
                    {
                        component.set("v.CntrlId",'MHazardPay');
                    }
                    else if(value=='Millitary Overseas Pay')
                    {
                        component.set("v.CntrlId",'MoverseaPay');
                    }
                    else if(value=='Millitary Prop Pay')
                    {
                        component.set("v.CntrlId",'MpropPay');
                    }
                    else if(value=='Millitary Quarters Allowance')
                    {
                        component.set("v.CntrlId",'MQuaterAllow');
                    }
                    else if(value=='Millitary Rations Allowance')
                    {
                        component.set("v.CntrlId",'MrationAllow');
                    }
                    else if(value=='Millitary Variable Housing Allowance')
                    {
                        component.set("v.CntrlId",'MVHousingAllow');
                    }
                    else if(value=='Mortgage Credit Certificate')
                    {
                        component.set("v.CntrlId",'MortgageCreditCertificate');
                    }
                    else if(value=='Mortgage Differential')
                    {
                        component.set("v.CntrlId",'MDiffCertificate');
                    }
                    else if(value=='Notes Recievable/Installment')
                    {
                        component.set("v.CntrlId",'NotesRecevIns');
                    }
                    else if(value=='Other Type Of Income')
                    {
                        component.set("v.CntrlId",'OTI');
                    }
                    else if(value=='Subject Property Net Cash Flow')
                    {
                        component.set("v.CntrlId",'SubpronetCash');
                    }
                    else if(value=='Temporary Leave Income')
                    {
                        component.set("v.CntrlId",'TempLeave');
                    }
                    else if(value=='Trust')
                    {
                        component.set("v.CntrlId",'Trust');
                    }
                    else if(value=='Unemployment/Public Assistance Income')
                    {
                        component.set("v.CntrlId",'Unempasst');
                    }
                    else if(value=='VA Benefits (Non Educational)')
                    {
                        component.set("v.CntrlId",'VABenifit');
                    }
                }

})