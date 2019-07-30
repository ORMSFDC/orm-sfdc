({
    //Save Loan(Subject Property)
    SaveLoan: function (component, event, helper) {

        var Condonium = '';
        Condonium = helper.getRadioGroupValue(component, event, helper, "Condominium", "v.subjectProperty.Condominium_FHA_Approved__c");
        component.set("v.subjectProperty.Condominium_FHA_Approved__c", Condonium);
        var action = component.get("c.UpdateSubjectProperty");
        var _Loanid = component.get("v.subjectPropertyLoanId");

        action.setParams({
            "ObjLoan": component.get("v.subjectProperty"),
            "LoanId": _Loanid
        });
        action.setCallback(this, function (data) {

            var propertyType = component.find("auraPropertyType").get("v.value");
            if (propertyType != 'Multifamily (more than 4 units)') {
                component.find("NoUnitId").set("v.value", "");
            }

        });
        $A.enqueueAction(action);
    },



    //Populate saved Subject Property after Page Load based on Loan Id
    PopulateSubjectPropertyByLoanId: function (component, event, helper) {

        document.getElementById("l3").classList.remove("active");
        $('#l3').removeClass('active');
        var LoanId = component.get('v.subjectPropertyLoanId');

        var ln = component.get('v.subjectProperty');
        if (ln.Is_Loan_Created_Manually__c == false) {
            if (ln.IsClientFilled_Flag__c == true) {
                if (ln.IsDeclarationFilled_Flag__c == true) {
                    document.getElementById('ClentLbl').innerHTML = 'Move';
                } else { document.getElementById('ClentLbl').innerHTML = 'NoNeedtomove'; }
            }
            else {
                document.getElementById('ClentLbl').innerHTML = 'NoNeedtomove';
            }
        }
        if ($A.util.isUndefinedOrNull(ln.Property_Title_is_Held_in_These_Names__c)) {
            component.find("PTHeldNameId").set("v.value", "Clients on Application");
        }

        this.addDelayPType(component, event, helper);

        if (ln['IsSubjectPropertyFilled_Flag__c'] == true) {

            var el = document.getElementById('SubjectPropertyLbl');
            var text = el.innerText;
            if (text == "Move") {
                helper.Loan_Next(component, event, helper);//Please note this function 
            } else { window.scrollTo(0, 0); }

        }
        else {
            var action1 = component.get("c.getSubjectPropertyByLoanId");
            action1.setParams({
                "RecordId": LoanId
            });
            action1.setCallback(this, function (data) {
                debugger
                component.set("v.subjectProperty", data.getReturnValue());
                var spData = data.getReturnValue();
                // component.set("v.LOID", spData.Originating_Loan_Officer__c);

                //alert(spdata.Subject_Property_Country__c);
                var titleHeld = spData.Property_Title_is_Held_in_These_Names__c;

                if (data.getState() === 'SUCCESS') {
                    if (spData.Is_Loan_Created_Manually__c == false) {

                        if (component.get('v.subIncomplete')) {

                            component.set('v.subIncomplete', false);

                        }

                        else {

                            component.set('v.subIncomplete', true);

                        }

                    }

                    else {

                        var el = document.getElementById('SubjectPropertyLbl');

                        var text = el.innerText;

                        if (text == "Move") {

                            component.set('v.subIncomplete', false);

                        }
                    }

                    this.addDelay(component, event, helper);
                }

            });
            $A.enqueueAction(action1);
        }
    },

    checkLoanCreatedByLoanOfficer: function (component, event, helper) {
        debugger;
        var action = component.get('c.IsLoanCreatedByLoanProcessor');
        var LoanId = component.get('v.subjectPropertyLoanId');
        action.setParams({
            "RecordId": LoanId
        });
        action.setCallback(this, function (data) {

            var result = data.getReturnValue();
            component.set("v.IsLoanCreatedByLoanOfficer", result);
            if (result == true) {
                document.getElementById("LoanOfficerDiv").style.display = 'block';
            }
            else {
                document.getElementById("LoanOfficerDiv").style.display = 'none';
            }

        });
        $A.enqueueAction(action);

    },
    addDelay: function (component, event, helper) {
        var delay = 2000; //4 seconds                                
        setTimeout(function () {
            document.getElementById("l2").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        }, delay);
    },

    addDelayPType: function (component, event, helper) {
        var delay = 500; //4 seconds                                
        setTimeout(function () {
            var ln = component.get('v.subjectProperty');
            if (ln.Subject_Property_Type__c == 'Condominium') {
                document.getElementById('Check_Condominium').style.display = 'block';
            }
            else {
                document.getElementById('Check_Condominium').style.display = 'none';
            }
            if (ln.Subject_Property_Type__c == 'Multifamily (more than 4 units)') {
                document.getElementById("UnitsNumberDiv").style.display = 'block';
            }
            else {
                document.getElementById("UnitsNumberDiv").style.display = 'none';
            }
        }, delay);
    },

    //Regex Validation
    formatErrorMethod: function (component, regexr, msgr, aura_idr) {
        //Code if button is clicked
        var flagR = false;
        for (var i = 0; i < aura_idr.length; i++) {
            var inputCmp = component.find(aura_idr[i]);
            var value = inputCmp.get("v.value");
            if (typeof value === 'undefined' || value == null || value == '') { }
            else {
                var isRegValid = false;
                if (value.length != 0) {
                    var rxp = new RegExp(regexr[i]);
                    isRegValid = rxp.test(value);
                    if (isRegValid) {
                        flagR = false;
                    }
                    else {
                        inputCmp.set("v.errors", [{ message: msgr[i] + ":" + value }]);
                        inputCmp.focus();
                        flagR = true;
                    }
                }
            }
        }

        return flagR;
    },

    //Validation for Required Fields
    formatErrorMethodReq: function (component, regex, msg, aura_id) {
        //Code if button is clicked
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

            } else {
                inputCmp.set("v.errors", [{ message: msg[i] }]);
                inputCmp.focus();
                flag = true;
            }
        }
        return flag;
    },

    //Will Move to next Tab of Start a New Loan after clicking on Save&Next button
    Loan_Next: function (component, event, helper) {
        if (component.get("v.manual") == true) {
            console.log('SAL_Subject Auto move');
            $('li#l3').removeClass('disabled');
            $('li#l3 a').attr("data-toggle", "tab");
            if (!component.get('v.fromPopup')) {
                $A.getCallback(function (result) {
                    $('li#l3 a').click();
                });

            } else {
                $('li#l2').removeClass('active');
                $('li#l3').addClass('active');
                $('li#l4').removeClass('active');

            }

            component.set('v.itemsClicked', 'opt3');
            component.set("v.nextOpt", "true");
            component.set("v.currentOpt", "false");
        }
    },

    //Will Move to previous Tab of Start a New Loan after clicking on previous button
    prev: function (component) {
        if (!component.get('v.fromPopup')) {
            $A.getCallback(function (result) {
                $('li#l1 a').click();
            });
        } else {
            $('li#l1').addClass('active');
            $('li#l2').removeClass('active');
        }
        document.getElementById('targetID').innerHTML = 'l1';
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },
    //will allow to enter only numeric Value
    validateEnteredValue: function (component, event, helper, compId) {

        var inz = component.get(compId);
        var digit = inz.toString()[0];

        if (digit == '0') {

            component.set(compId, inz.substring(0, inz.length - 1));
        }
        if (isNaN(inz)) {
            component.set(compId, inz.substring(0, inz.length - 1));

        }
        /* if(!isRegValid)
        {
            component.set(compId, inz.substring(0, inz.length - 1));
        }*/
    },

    //Validate required when Self employed is "yes" 
    ValidateResidenceType: function (component, event, helper) {
        //true means error
        var finalResult = false;
        var residenceType = component.find('ResidenceTypeId');
        var residenceTypeVal = residenceType.get('v.value');
        if (residenceTypeVal == 'Investment') {
            finalResult = true;
            residenceType.set("v.errors", [{ message: "Value must be primary for residence type. Please call your account executive to review your selection." }]);
        }
        else if (residenceTypeVal == '' || residenceTypeVal == null || typeof residenceTypeVal === 'undefined') {
            finalResult = true;
            residenceType.set("v.errors", [{ message: "Please select a value for this field." }]);
        }
        else {
            residenceType.set("v.errors", null);
        }

        return finalResult;
    },

    //Validate required when Self employed is "yes"
    validateGeneric: function (component, event, helper) {

        var negativeTaxes = false;
        var negativeHazard = false;
        //Code Added by Dev4 for ORMSFDC-1423
        //var negativeHOA=false;
        var negativeHOA = false;
        var negativePUD = false;
        var negativeGroundRents = false;
        var negativefloodIns = false;
        var negativePrsntMasrkt = false;
        var negativeMortLiens = false;
        //var negativeNameCompany=false;
        var negativeGrossRentalIncome = false;
        var negativeMonthlyMortPayment = false;
        var negativeInsTaxes = false;
        var negativeNetRentalIncm = false;
        //Code Ended by Dev4 for ORMSFDC-1423
        var RETaxes = component.get('v.subjectProperty.Real_Estate_Taxes__c');
        var HazardInsurance = component.get('v.subjectProperty.Hazard_Insurance__c');
        // var HOAPUDCondo=component.get('v.subjectProperty.HOA_PUD_Condo_Fees__c');
        var HOAMonthlyDuesVal = component.get('v.subjectProperty.HOA_Monthly_Dues__c');
        var PUDVal = component.get('v.subjectProperty.Monthly_PUD_Fees_Amount__c');
        var monthlyGroundRentsVal = component.get('v.subjectProperty.Monthly_Ground_Rents_Amount__c');
        var monthlyFloodInsuranceVal = component.get('v.subjectProperty.Monthly_Flood_Insurance_Premium__c');
        var PresentMarket = component.get('v.subjectProperty.Present_Market_Value__c');
        var MortLiens = component.get('v.subjectProperty.Mortgage_and_Liens__c');
        //var NameOFCompany=component.get('v.subjectProperty.Name_of_Company__c');
        var GrossRentalIncome = component.get('v.subjectProperty.Gross_Rental_Income__c');
        var MonthlyMortgagePayment = component.get('v.subjectProperty.Monthly_Mortgage_Payment__c');
        var InsTaxes = component.get('v.subjectProperty.Monthly_Insurance_Taxes_etc__c');
        var NetRentalIncome = component.get('v.subjectProperty.Net_Rental_Income__c');

        var checkYear = false;
        var yearBuilt = component.get('v.subjectProperty.Year_Built__c');
        if (RETaxes == null || RETaxes == '') {

        }
        else {

            if (RETaxes < 0) {
                negativeTaxes = true;
                document.getElementById("RETaxesError").innerHTML = 'Value can not be less than zero';

                var RETaxesID = component.find("RETaxes");

                $A.util.addClass(RETaxesID, 'errorComponent');

            }
            else {
                document.getElementById("RETaxesError").innerHTML = '';
                var RETaxesID = component.find("RETaxes");
                $A.util.removeClass(RETaxesID, 'errorComponent');
            }
        }
        if (HazardInsurance == null || HazardInsurance == '') {
        }
        else {
            if (HazardInsurance < 0) {
                negativeHazard = true;
                document.getElementById("HazardInsuranceError").innerHTML = 'Value can not be less than zero';


                var HazardInsuranceId = component.find("HazardInsuranceId");

                $A.util.addClass(HazardInsuranceId, 'errorComponent');

            }
            else {
                document.getElementById("HazardInsuranceError").innerHTML = '';
                var HazardInsuranceId = component.find("HazardInsuranceId");
                $A.util.removeClass(HazardInsuranceId, 'errorComponent');
            }
        }
        //Code Modified by Dev4 for ORMSFDC-1423
        if (HOAMonthlyDuesVal == null || HOAMonthlyDuesVal == '') {
        }
        else {
            if (HOAMonthlyDuesVal < 0) {
                negativeHOA = true;
                document.getElementById("HOAError").innerHTML = 'Value can not be less than zero';


                var HOACmp = component.find("HOAId");

                $A.util.addClass(HOACmp, 'errorComponent');

            }
            else {
                document.getElementById("HOAError").innerHTML = '';
                var HOACmp = component.find("HOAId");;
                $A.util.removeClass(HOACmp, 'errorComponent');
            }
        }
        if (PUDVal == null || PUDVal == '') {
        }
        else {
            if (PUDVal < 0) {
                negativePUD = true;
                document.getElementById("PUDError").innerHTML = 'Value can not be less than zero';


                var PUDId = component.find("PUDId");

                $A.util.addClass(PUDId, 'errorComponent');

            }
            else {
                document.getElementById("PUDError").innerHTML = '';
                var PUDId = component.find("PUDId");
                $A.util.removeClass(PUDId, 'errorComponent');
            }
        }
        if (monthlyGroundRentsVal == null || monthlyGroundRentsVal == '') {
        }
        else {
            if (monthlyGroundRentsVal < 0) {
                negativeGroundRents = true;
                document.getElementById("GroundRentsError").innerHTML = 'Value can not be less than zero';


                var GroundRentsId = component.find("GroundRentsId");

                $A.util.addClass(GroundRentsId, 'errorComponent');

            }
            else {
                document.getElementById("GroundRentsError").innerHTML = '';
                var GroundRentsId = component.find("GroundRentsId");
                $A.util.removeClass(GroundRentsId, 'errorComponent');
            }
        }
        if (monthlyFloodInsuranceVal == null || monthlyFloodInsuranceVal == '') {
        }
        else {
            if (monthlyFloodInsuranceVal < 0) {
                negativefloodIns = true;
                document.getElementById("FloodInsuranceError").innerHTML = 'Value can not be less than zero';


                var FloodInsuranceId = component.find("FloodInsuranceId");

                $A.util.addClass(FloodInsuranceId, 'errorComponent');

            }
            else {
                document.getElementById("FloodInsuranceError").innerHTML = '';
                var FloodInsuranceId = component.find("FloodInsuranceId");
                $A.util.removeClass(FloodInsuranceId, 'errorComponent');
            }
        }
        if (PresentMarket == null || PresentMarket == '') {

        }
        else {

            if (PresentMarket < 0) {
                negativePrsntMasrkt = true;
                document.getElementById("PresentMarketError").innerHTML = 'Value can not be less than zero';

                var PresentMarketID = component.find("PresentMarketId");

                $A.util.addClass(PresentMarketID, 'errorComponent');

            }
            else {
                document.getElementById("PresentMarketError").innerHTML = '';
                var PresentMarketID = component.find("PresentMarketId");
                $A.util.removeClass(PresentMarketID, 'errorComponent');
            }
        }
        if (MortLiens == null || MortLiens == '') {

        }
        else {

            if (MortLiens < 0) {
                negativeMortLiens = true;
                document.getElementById("MortLiensError").innerHTML = 'Value can not be less than zero';

                var MortLiensID = component.find("MortLiensId");

                $A.util.addClass(MortLiensID, 'errorComponent');

            }
            else {
                document.getElementById("MortLiensError").innerHTML = '';
                var MortLiensID = component.find("MortLiensId");
                $A.util.removeClass(MortLiensID, 'errorComponent');
            }
        }

        if (GrossRentalIncome == null || GrossRentalIncome == '') {

        }
        else {

            if (GrossRentalIncome < 0) {
                negativeGrossRentalIncome = true;
                document.getElementById("GrossRentalIncomeError").innerHTML = 'Value can not be less than zero';

                var GrossRentalIncomeID = component.find("GrossRentalIncomeId");

                $A.util.addClass(GrossRentalIncomeID, 'errorComponent');

            }
            else {
                document.getElementById("GrossRentalIncomeError").innerHTML = '';
                var GrossRentalIncomeID = component.find("GrossRentalIncomeId");
                $A.util.removeClass(GrossRentalIncomeID, 'errorComponent');
            }
        }
        if (MonthlyMortgagePayment == null || MonthlyMortgagePayment == '') {

        }
        else {

            if (MonthlyMortgagePayment < 0) {
                negativeMonthlyMortPayment = true;
                document.getElementById("MonthlyMortPaymentError").innerHTML = 'Value can not be less than zero';

                var MonthlyMortgagePaymentID = component.find("MonthlyMortPaymentId");

                $A.util.addClass(MonthlyMortgagePaymentID, 'errorComponent');

            }
            else {
                document.getElementById("MonthlyMortPaymentError").innerHTML = '';
                var MonthlyMortgagePaymentID = component.find("MonthlyMortPaymentId");
                $A.util.removeClass(MonthlyMortgagePaymentID, 'errorComponent');
            }
        }
        if (InsTaxes == null || InsTaxes == '') {

        }
        else {

            if (InsTaxes < 0) {

                negativeTaxes = true;
                document.getElementById("InsTaxesError").innerHTML = 'Value can not be less than zero';

                var InsTaxesID = component.find("InsTaxesId");

                $A.util.addClass(InsTaxesID, 'errorComponent');

            }
            else {
                document.getElementById("InsTaxesError").innerHTML = '';
                var InsTaxesID = component.find("InsTaxesId");
                $A.util.removeClass(InsTaxesID, 'errorComponent');
            }
        }
        if (NetRentalIncome == null || NetRentalIncome == '') {

        }
        else {

            if (NetRentalIncome < 0) {
                negativeNetRentalIncm = true;

                document.getElementById("NetRentalIncmError").innerHTML = 'Value can not be less than zero';

                var NetRentalIncomeID = component.find("NetRentalIncmId");

                $A.util.addClass(NetRentalIncomeID, 'errorComponent');

            }
            else {
                document.getElementById("NetRentalIncmError").innerHTML = '';
                var NetRentalIncomeID = component.find("NetRentalIncmId");
                $A.util.removeClass(NetRentalIncomeID, 'errorComponent');
            }
        }

        /* if(HOAPUDCondo==null || HOAPUDCondo==''  ){
        }
        else{
            if(HOAPUDCondo<0)
            {
                negativeHOA=true;
                document.getElementById("HOAPUDCondoError").innerHTML = 'Value can not be less than zero';
                var HOAPUDCondoId = component.find("HOAPUDCondoId");
                $A.util.addClass(HOAPUDCondoId, 'errorComponent');
                
            }
            else
            {
                document.getElementById("HOAPUDCondoError").innerHTML = '';
                var HOAPUDCondoId = component.find("HOAPUDCondoId");
                $A.util.removeClass(HOAPUDCondoId, 'errorComponent');            
            }
        }*/
        //Code Ended by Dev4 for ORMSFDC-1423
        if (yearBuilt == null || yearBuilt == '' || typeof yearBuilt === 'undefined') { }
        else {
            var strYearBuilt = yearBuilt.toString();
            if (strYearBuilt.length != 0 && strYearBuilt.length < 4) {

                checkYear = true;
                document.getElementById("YearBuiltError").innerHTML = 'This should be a valid year and should not be a future year(eg: 2017)';
                var YearBuiltId = component.find("YearBuiltId");
                $A.util.addClass(YearBuiltId, 'errorComponent');
            }

            else if (yearBuilt > new Date().getFullYear()) {
                checkYear = true;
                document.getElementById("YearBuiltError").innerHTML = 'This should be a valid year and should not be a future year(eg: 2017)';
                var YearBuiltId = component.find("YearBuiltId");
                $A.util.addClass(YearBuiltId, 'errorComponent');
            }
            else {
                document.getElementById("YearBuiltError").innerHTML = '';
                var YearBuiltId = component.find("YearBuiltId");
                $A.util.removeClass(YearBuiltId, 'errorComponent');
            }
        }
        //Code Modified by Dev4 for ORMSFDC-1423
        if (negativeTaxes || negativeHazard || checkYear || negativeHOA || negativePUD || negativeGroundRents || negativefloodIns || negativePrsntMasrkt
            || negativeMortLiens || negativeGrossRentalIncome || negativeMonthlyMortPayment || negativeInsTaxes || negativeNetRentalIncm) {
            return true;
            //Code Ended by Dev4 for ORMSFDC-1423
        }
        else
            return false;
    },

    //Validate Zip Format
    ValidZip: function (component, event, helper, id) {
        var msgZip = '';
        var inputCmp = component.find(id);
        var value = inputCmp.get("v.value");
        var regZip = /(^\d{5}$)|(^\d{5}-\d{4}$)/;
        var isRegZipValid = false;
        if (typeof value === "undefined" || value == null || value == '') {
            value = '';
        }
        if (value.length > 0) {
            var rxp = new RegExp(regZip);
            isRegZipValid = rxp.test(value);
            if (isRegZipValid) {
                inputCmp.set("v.errors", null);
                isRegZipValid = false;
            }
            else {

                inputCmp.set("v.errors", [{ message: "Please enter a valid zip format (eg: 23454/23456-1234)" }]);
                isRegZipValid = true;
            }
        }

        return isRegZipValid;
    },
    ValidationForPills: function (component, event, helper) {
        var LoanId = component.get('v.subjectPropertyLoanId');
        var action1 = component.get("c.TabsValidatedData");
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
    getStateCity: function (component, event, helper, ZIP) {
        //Fetch States based on Product and rate types SFDC - 275 
        var action2 = component.get("c.getSubjectPropertyByLoanId");
        var LoanId = component.get('v.subjectPropertyLoanId');
        action2.setParams({
            "RecordId": LoanId
        });
        action2.setCallback(this, function (data) {
            var rateData = data.getReturnValue();                   
            component.set("v.prodType",rateData.Product_Type__c);
            component.set("v.rateType",rateData.Mortgage_Applied_for__c);
            console.log('prodtype!',component.get("v.prodType"));

        });
        $A.enqueueAction(action2);
        //end 
        
        var action = component.get("c.getZipData");
        action.setParams({
            "ZIP": ZIP
        });
        action.setCallback(this, function (data) {

            var result = data.getReturnValue();
            var a = false;
            var n = result.length;
            if (n != 0) {
                //SFDC-275 start
                var prodType = component.get('v.prodType'); 
                var rateType = component.get('v.rateType');
                console.log('prodtypeinside',prodType); 
                //HECM Refinance
                if(prodType == 'HECM' && (rateType == 'FHA Traditional HECM' || rateType == 'HECM to HECM Refinance')){
                    var action1 = component.get("c.getStates");
                }
                //HECM Purchase
                else if(prodType == 'HECM' && rateType == 'HECM for Purchase'){
                    var action1 = component.get("c.getStatesPur");
                }
                //HELO Purchase
                else if(prodType == 'HELO' && rateType == 'HELO for Purchase'){                    
                    var action1 = component.get("c.get_heloStatesPur");
                }
                //HELO Refinance
                else if(prodType == 'HELO' && rateType == 'HELO Refinance'){                    
                    var action1 = component.get("c.get_heloStatesRefi");
                }
                //var action1 = component.get("c.getStates");
                //SFDC-275 end
                
                action1.setCallback(this, function (data) {
                    var result1 = data.getReturnValue();
                    var i;
                    for (i = 0; i < result1.length; i++) {
                        if (result[0] == result1[i].MasterLabel) {
                            a = true;
                            component.find("State").set("v.value", result[0]);
                            component.find("SP_City").set("v.value", result[1]);
                        }
                    }
                    if (a == true) {
                        component.set("v.requiredZip", false);
                        component.set("v.requiredZip1",false); //SFDC-365
                        component.set("v.requiredZip2",false); //SFDC-365
                        component.set("v.requiredZip3",false);
                        component.set("v.requiredZip4",false);
                    }
                    else {
                        component.set("v.requiredZip", true);
                        //SFDC-365
                        if((prodType == 'HECM' &&  (rateType == 'FHA Traditional HECM' || rateType == 'HECM to HECM Refinance'))  ){
                            component.set("v.requiredZip1", true);
                            component.set("v.requiredZip", false);
                        }    
                        if(prodType == 'HELO' && rateType == 'HELO Refinance'){
                            component.set("v.requiredZip2", true);
                            component.set("v.requiredZip", false);
                        }
                        if(prodType == 'HECM' &&  rateType == 'HECM for Purchase'){
                            component.set("v.requiredZip3", true);
                            component.set("v.requiredZip", false);
                        }
                        if(prodType == 'HELO' && rateType == 'HELO for Purchase'){
                            component.set("v.requiredZip4", true);
                            component.set("v.requiredZip", false);
                        }
                        //SFDC-365
                    }
                });
                $A.enqueueAction(action1);
            }
            else {
                component.set("v.isZipExist", true);
            }

        });
        $A.enqueueAction(action);
    },
    getRadioGroupValue: function (component, event, helper, id, controlId) {

        var R_ID = id;
        var getValue = component.find(R_ID).get('v.value');
        if ($A.util.isUndefinedOrNull(getValue)) {

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
    checkCondominiumFHAApproved: function (component, event, helper) {

        var checkFHAapproved = false;
        var getPropertyType = component.get('v.subjectProperty.Subject_Property_Type__c');
        if (getPropertyType == "Condominium") {
            var getFHAApproved = component.get('v.subjectProperty.Condominium_FHA_Approved__c');
            if (getFHAApproved == '' || getFHAApproved == undefined || getFHAApproved == null) {
                checkFHAapproved = true;
                document.getElementById("lbl_FHAapproved").innerText = 'Please check atleast one option.';
            }
            else {
                document.getElementById("lbl_FHAapproved").innerText = '';
            }
        }
        return checkFHAapproved;
    },

    //New
    checkSolarPanelHelp:  function (component, event, helper) {
        debugger;
        var checkSolarPanel = false;
        var getSolarPaidOff = component.get('v.subjectProperty.Solar_Panels_Paid_Off__c');
        var productType = component.get('v.subjectProperty.Product_Type__c');
        
        console.log('getSolarPaidOff',getSolarPaidOff);
        console.log('productType',productType);

        if(getSolarPaidOff == "No" && productType == "HECM"){
            checkSolarPanel = true;
            document.getElementById("lbl_SolarPanelPaidId").innerText = 'ORM does not allow for leased solar panels on the HECM program.';
        }
        else{
            document.getElementById("lbl_SolarPanelPaidId").innerText = '';
        }
        console.log('checkSolarPanel',checkSolarPanel);
    return checkSolarPanel;
    },

    checkCondominiumName: function (component, event, helper) {

        var checkCname = false;
        var inputCmp = component.find("CondominiumName");
        var getPropertyType = component.get('v.subjectProperty.Subject_Property_Type__c');
        if (getPropertyType == "Condominium") {
            var getcName = component.get('v.subjectProperty.Condominium_Name__c');
            if (getcName == '' || getcName == undefined || getcName == null) {
                checkCname = true;
                inputCmp.set("v.errors", [{ message: "This is a required field." }]);
                //document.getElementById("lbl_FHAapproved").innerText = 'Please check atleast one option.';
            }
            else {
                inputCmp.set("v.errors", null);
                //document.getElementById("lbl_FHAapproved").innerText = '';
            }
        }
        return checkCname;
    }
})