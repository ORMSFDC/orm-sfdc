({
    onchange_action: function (component, event, helper) {
        var loanPaymentValue = component.find('LoanPayment').get('v.value');
        if (loanPaymentValue == 'Term' || loanPaymentValue == 'Modified Term') {

        }
        else {
            component.set("v.NewLoan.Loan_Payment_Plan_Term__c", "");
        }
    },

    doInit: function (component, event, helper) {
        var rtype = component.get("v.NewLoan.Rate_Type__c");
        helper.PopulateRate(component, event, helper);
        window.scrollTo(0, 0);
        helper.DropdownPopulate(component, event, helper);
        var ApplicationDate = component.get("v.ApplicationDate");
        if (typeof ApplicationDate === 'undefined') {
            ApplicationDate = '';
        }
        else {
            component.find("ApplicationDate").set("v.value", ApplicationDate);
        }
        console.log('rate type: ',rtype);

        var checkId = component.get("v.LoanId");
        if (typeof checkId === "undefined" || checkId == null) {
            component.set('v.NewLoan.Children_Under_the_age_of_6_living_in_th__c', 'No');
        }
        else {
            component.set("v.NewStartLoan", false);
            helper.PopulateLoanBasedonId(component, event, helper);
            console.log('rate type2: ',rtype);
        }
        helper.showHideMortgage(component, event, helper);
    },

    onChangeLoanType: function (component, event, helper) {
        debugger;
        var loanType = component.find("LoanType").get("v.value");
        var mortgageType = component.find("LoanMortgageAppliedFor").get("v.value");
        var ehVal = component.find("LoanEstimateAppVal").get("v.value");
     //   helper.PopulateRate(component, event, helper); //SFDC-237

        if ('HELO' == loanType) {
            component.set('v.NewLoan.Rate_Type__c', 'ARM'); //set default
            component.set('v.NewLoan.Loan_Origination_Fee_Calculation__c','Calculate Maximum Fee');
            var rateType = component.find("RateType").get("v.value");
            if(rateType == 'ARM'){
                component.set('v.NewLoan.Selected_Loan_Payment_Plan__c', 'Line of Credit'); 
                component.set('v.NewLoan.Margin__c', ''); 
            }
            if(ehVal != ''){
                helper.feecaluculationHelper(component, event, helper, 'init');
            }
            if (mortgageType.includes('HECM')) {    //set default
                component.set('v.NewLoan.Mortgage_Applied_for__c', 'HELO Refinance');
            }
            
        } else if ('HECM' == loanType) {
            if (mortgageType.includes('HELO')) {    //set default
                component.set('v.NewLoan.Mortgage_Applied_for__c', 'FHA Traditional HECM');
                component.set('v.NewLoan.Loan_Origination_Fee_Calculation__c','Calculate Maximum Fee');
                component.set('v.NewLoan.Loan_Origination_Fee__c','');
                if(ehVal != ''){
                    helper.feecaluculationHelper(component, event, helper, 'init');
                }
                var rateType = component.find("RateType").get("v.value")
                if(rateType == 'ARM'){
                    component.set('v.NewLoan.Margin__c', ''); 
                }
            }
        }        

        helper.PopulateRate(component, event, helper); //SFDC-237
    },

    onRateTypeChange: function (component, event, helper) {
        debugger;
        console.log('margin iption2',component.find("marginoptions").get("v.value"));
        var rateType = component.find("RateType").get("v.value");        
        var loanType = component.find("LoanType").get("v.value");
        var ehVal = component.find("LoanEstimateAppVal").get("v.value");
        if('Fixed' == rateType){
            component.set('v.NewLoan.Selected_Loan_Payment_Plan__c', 'Single Lump Sum');
            if(loanType == 'HELO'){
                component.set('v.NewLoan.Loan_Origination_Fee__c','');
                component.set('v.NewLoan.Rate__c','');
            }
        }
        if('ARM' == rateType){            
            if(loanType == 'HELO'){
                component.set('v.NewLoan.Selected_Loan_Payment_Plan__c', 'Line of Credit');                
                component.set('v.NewLoan.Margin__c', '');
                component.set('v.NewLoan.Mortgage_Applied_for__c', 'HELO Refinance');
            }else{
                component.set('v.NewLoan.Selected_Loan_Payment_Plan__c', '');            
            }
                if(ehVal != ''){
                    helper.feecaluculationHelper(component, event, helper, 'init');
                }
            }
        helper.PopulateRate(component, event, helper);
    },

    changeSource: function (component, event, helper) {

        var fundSource = component.find("SourceOfFunds").get("v.value");
        var fSource = fundSource.split(';');
        if (fundSource.includes("Sale Of Other Property")) {
            document.getElementById("SalDate").style.display = 'block';
        }
        else {
            document.getElementById("SalDate").style.display = 'none';
        }

        if (fundSource.includes("Assets")) {
            document.getElementById("Assets").style.display = 'block';
        }
        else {
            document.getElementById("Assets").style.display = 'none';
        }
        if (fundSource.includes("Gift")) {
            document.getElementById("Gift").style.display = 'block';
        }
        else {
            document.getElementById("Gift").style.display = 'none';
        }
        if (fundSource.includes("Others")) {
            document.getElementById("Others").style.display = 'block';
        }
        else {
            document.getElementById("Others").style.display = 'none';
        }

    },

    displayAlert: function (component, event, helper) {

    },


    ZipFormatCheck: function (component, event, helper) {
        helper.ZipFormat(component, event);
    },
    PurofLoan: function (component, event, helper) {
        var selectedval = component.find("LoanPurposeLoan").get("v.value");
        alert(selectedval);
    },

    LoanSave: function (component, event, helper) {
        helper.SaveLoans(component, event, helper);
    },
    next: function (component, event, helper) {
        helper.Loan_Next(component, event, helper);
    },
    ChkFutureDate: function (component, event, helper) {
        helper.FutureDate(component, event, helper);
    },
    validateandgo: function (component, event, helper) {
        debugger;
        var rtype = component.get("v.NewLoan.Rate_Type__c");
        var mortgageAppliedFor = component.find("LoanMortgageAppliedFor").get("v.value");
        var loanType = component.find("LoanType").get("v.value");

        document.getElementById('SubjectPropertyLbl').innerHTML = 'NoNeedtomove';
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();

        var regr = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
        var arr_regr = new Array();
        var arr_funcr = new Array();

        function validateRequiredField(value) {

            if ($A.util.isEmpty(value)) {
                return false;
            }
            else {
                return true;
            }
        }
        function FutureDate(value) {

            var myDate = new Date(value);
            var today = new Date();
            if (myDate > today) {

                return false;

            } else {
                return true;
            }
        }

        var valArray = [
            { ar_id: "LoanMortgageAppliedFor", mes: "Please select a value for this field", reg: validateRequiredField },
            { ar_id: "Hmember", mes: "Please select a value for this field", reg: validateRequiredField },
            { ar_id: "Apptakenby", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "AltConName", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "AltConFullAdd", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "AltConphoneName", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "relationshipContact", mes: "This is a required field", reg: validateRequiredField }
        ];

        if ('Fixed' === rtype) {
            valArray.push(
                { ar_id: "Ratedata", mes: "Please select a value for this field", reg: validateRequiredField },
                { ar_id: "CredittoBorrower", mes: "This is a required field", reg: validateRequiredField }
            );
            if (component.get("v.show_originate_fee")) {
                valArray.push({ ar_id: "LoanOriginationFee", mes: "This is a required field", reg: validateRequiredField });
            }
        } else if ('ARM' === rtype) {
            valArray.push(                
                { ar_id: "marginoptions", mes: "Please select a value for this field", reg: validateRequiredField },
                { ar_id: "newSelectlist", mes: "This is a required field", reg: validateRequiredField }
            );
            if (!component.get("v.show_originate_fee_disable")) {
                valArray.push({ ar_id: "LoanOriginationFee", mes: "This is a required field", reg: validateRequiredField });
            }
        }

        if (mortgageAppliedFor.includes('Purchase')) {
            valArray.push(
                { ar_id: "PurchasePrice", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "EarnestMoneyDeposit", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "ContractDate", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "CurrentAddressStatus", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SourceOfFunds", mes: "This is a required field", reg: validateRequiredField }
            );

            if (document.getElementById("SalDate").style.display == 'block') {
                valArray.push(
                    { ar_id: "SaleDate", mes: "This is a required field", reg: validateRequiredField },
                    { ar_id: "SaleProceeds", mes: "This is a required field", reg: validateRequiredField }
                );
            }
            if (document.getElementById("Assets").style.display == 'block') {
                valArray.push(
                    { ar_id: "AssetAmount", mes: "This is a required field", reg: validateRequiredField }
                );
            }
            if (document.getElementById("Gift").style.display == 'block') {
                valArray.push(
                    { ar_id: "GiftAmount", mes: "This is a required field", reg: validateRequiredField }
                );
            }
            if (document.getElementById("Others").style.display == 'block') {
                valArray.push(
                    { ar_id: "OtherFundSource", mes: "This is a required field", reg: validateRequiredField },
                    { ar_id: "AmtOtherFund", mes: "This is a required field", reg: validateRequiredField }
                );
            }

        }
        else {
            valArray.push(
                { ar_id: "LoanPurposeLoan", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "LoanPayment", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "LoanEstimateAppVal", mes: "This is a required field", reg: validateRequiredField }
            );
            if ('ARM' === rtype) {
                valArray.push(
                    { ar_id: "LoanEstimateAppVal", mes: "This is a required field", reg: validateRequiredField },
                    { ar_id: "LoanOriginationFee", mes: "This is a required field", reg: validateRequiredField }
                );
            }
        }
        var valarrayregex = [];
        if (!mortgageAppliedFor.includes('Purchase')) {
            valarrayregex.push(
                { ar_idr: "LoanEstimateAppVal", mesr: "Please enter a valid number(non negative)  ", regr: "^[0-9]\\d*(\\.\\d+)?$" }
            );

            if (loanType != 'HELO') {
                valarrayregex.push({ ar_idr: "LoanOriginationFee", mesr: "Please enter a valid number (non negative) ", regr: "^[0-9]\\d*(\\.\\d+)?$" });
            }
        }

        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);

        array_idr = valarrayregex.map(item => item.ar_idr);
        array_mesr = valarrayregex.map(item => item.mesr);
        array_regr = valarrayregex.map(item => item.regr);

        var Isrequired = helper.formatErrorMethod(component, array_reg, array_mes, array_id);
        var IsRegex = helper.formatErrorMethodr(component, array_regr, array_mesr, array_idr);
        var checkingDate = false;
        var ValidateContractDate = false;
        var ValidateContractClosingDate = false;
        var ValidateSourceOfFundsDate = false;
        if (mortgageAppliedFor.includes('Purchase')) {
            checkingDate = helper.DateCheck(component, event, helper);
            ValidateContractDate = helper.ValidateDateFormat(component, event, helper, 'ContractDate');
            ValidateContractClosingDate = helper.ValidateDateFormat(component, event, helper, 'ContractClosingDate');
            var SourceOfFunds = component.find("SourceOfFunds").get("v.value");
            if (SourceOfFunds.includes("Sale Of Other Property")) {
                ValidateSourceOfFundsDate = helper.ValidateDateFormat(component, event, helper, 'SaleDate');

            }

        }

        var IsRelationshipRequired = false;
        var IsRelationshipDDValue = component.find("relationshipContact").get("v.value");

        if (IsRelationshipDDValue == 'Other') {
            IsRelationshipRequired = helper.Relationship_to_Alternative_Contact__Check(component, event, helper);
        }

        var isLoFeeInvalid = false;

        //If ele vis, appraised val is < 350k
        if (loanType == 'HELO' && $A.util.hasClass(component.find("invalidAppraisedValue"), "slds-show")) {
            Isrequired = true;
        }

        if ('ARM' === rtype) {
            var LoanOriginationFeeCalculationMethod = component.find("newSelectlist").get("v.value");

            if(loanType == 'HECM'){
                if (LoanOriginationFeeCalculationMethod == 'Enter Fee Value ($0 - $6,000)') {
                    isLoFeeInvalid = helper.calculate_fee_Value(component, event, helper);
                }
            }else{
                if (LoanOriginationFeeCalculationMethod == 'Enter Fee Value ($0 - $10,000)') {
                    isLoFeeInvalid = helper.calculate_fee_Value2(component, event, helper);
                }                
            }
        }

        if (isLoFeeInvalid || Isrequired || IsRegex || IsRelationshipRequired || checkingDate
            || ValidateContractDate || ValidateContractClosingDate || ValidateSourceOfFundsDate) {

            component.set("v.showError", true);
        }

        else {
            component.set("v.showError", false);
            helper.changeSource(component, event, helper);
            helper.SaveLoans(component, event, helper);
        }
    },

    LoanFormatValidations: function (component, event, helper) {
        debugger;
        var rtype = component.get("v.NewLoan.Rate_Type__c");
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();

        var regr = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
        var arr_regr = new Array();
        var arr_funcr = new Array();

        function validateRequiredField(value) {

            if ($A.util.isEmpty(value)) {
                return false;
            }
            else {
                return true;
            }
        }
        function FutureDate(value) {

            var myDate = new Date(value);
            var today = new Date();
            if (myDate > today) {

                return false;

            } else {
                return true;
            }


        }
        var valArray = [
            { ar_id: "LoanMortgageAppliedFor", mes: "Please select a value for this field", reg: validateRequiredField },
            { ar_id: "Hmember", mes: "Please select a value for this field", reg: validateRequiredField },

            { ar_id: "Apptakenby", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "AltConName", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "AltConFullAdd", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "AltConphoneName", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "relationshipContact", mes: "This is a required field", reg: validateRequiredField }
        ];

        if ('Fixed' === rtype) {
            valArray.push(
                { ar_id: "Ratedata", mes: "Please select a value for this field", reg: validateRequiredField },
                { ar_id: "CredittoBorrower", mes: "This is a required field", reg: validateRequiredField }
            );
            if (component.get("v.show_originate_fee")) {
                valArray.push({ ar_id: "LoanOriginationFee", mes: "This is a required field", reg: validateRequiredField });
            }
        } else if ('ARM' === rtype) {           
            valArray.push(
                { ar_id: "marginoptions", mes: "Please select a value for this field", reg: validateRequiredField },
                { ar_id: "newSelectlist", mes: "This is a required field", reg: validateRequiredField }
            );
            if (!component.get("v.show_originate_fee_disable")) {
                valArray.push({ ar_id: "LoanOriginationFee", mes: "This is a required field", reg: validateRequiredField });
            }
        }

        var mortgageAppliedFor = component.find("LoanMortgageAppliedFor").get("v.value");
        if (mortgageAppliedFor.includes('Purchase')) {
            valArray.push(
                { ar_id: "PurchasePrice", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "EarnestMoneyDeposit", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "ContractDate", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "CurrentAddressStatus", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SourceOfFunds", mes: "This is a required field", reg: validateRequiredField }
            );
            if (document.getElementById("SalDate").style.display == 'block') {
                valArray.push(
                    { ar_id: "SaleDate", mes: "This is a required field", reg: validateRequiredField },
                    { ar_id: "SaleProceeds", mes: "This is a required field", reg: validateRequiredField }
                );
            }
            if (document.getElementById("Assets").style.display == 'block') {
                valArray.push(
                    { ar_id: "AssetAmount", mes: "This is a required field", reg: validateRequiredField }
                );
            }
            if (document.getElementById("Gift").style.display == 'block') {
                valArray.push(
                    { ar_id: "GiftAmount", mes: "This is a required field", reg: validateRequiredField }
                );
            }
            if (document.getElementById("Others").style.display == 'block') {
                valArray.push(
                    { ar_id: "OtherFundSource", mes: "This is a required field", reg: validateRequiredField },
                    { ar_id: "AmtOtherFund", mes: "This is a required field", reg: validateRequiredField }
                );
            }

        }
        else {
            valArray.push(
                { ar_id: "LoanPurposeLoan", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "LoanPayment", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "LoanEstimateAppVal", mes: "This is a required field", reg: validateRequiredField }
            );
            if ('ARM' === rtype) {
                valArray.push(
                    { ar_id: "LoanEstimateAppVal", mes: "This is a required field", reg: validateRequiredField },
                    { ar_id: "LoanOriginationFee", mes: "This is a required field", reg: validateRequiredField }
                );
            }
        }
        var valarrayregex = [];
        if (!mortgageAppliedFor.includes('Purchase')) {
            valarrayregex.push(

                { ar_idr: "LoanOriginationFee", mesr: "Please enter a valid number (non negative) ", regr: "^[0-9]\\d*(\\.\\d+)?$" },
                { ar_idr: "LoanEstimateAppVal", mesr: "Please enter a valid number(non negative)  ", regr: "^[0-9]\\d*(\\.\\d+)?$" }

            );
        }

        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);

        array_idr = valarrayregex.map(item => item.ar_idr);
        array_mesr = valarrayregex.map(item => item.mesr);
        array_regr = valarrayregex.map(item => item.regr);

        var Isrequired = helper.formatErrorMethod(component, array_reg, array_mes, array_id);
        var IsRegex = helper.formatErrorMethodr(component, array_regr, array_mesr, array_idr);
        var checkingDate = false;
        var ValidateContractDate = false;
        var ValidateContractClosingDate = false;
        var ValidateSourceOfFundsDate = false;
        if (mortgageAppliedFor.includes('Purchase')) {
            checkingDate = helper.DateCheck(component, event, helper);
            ValidateContractDate = helper.ValidateDateFormat(component, event, helper, 'ContractDate');
            ValidateContractClosingDate = helper.ValidateDateFormat(component, event, helper, 'ContractClosingDate');
            var SourceOfFunds = component.find("SourceOfFunds").get("v.value");
            if (SourceOfFunds.includes("Sale Of Other Property")) {
                ValidateSourceOfFundsDate = helper.ValidateDateFormat(component, event, helper, 'SaleDate');

            }

        }

        var IsRelationshipRequired = false;
        var IsRelationshipDDValue = component.find("relationshipContact").get("v.value");

        if (IsRelationshipDDValue == 'Other') {
            IsRelationshipRequired = helper.Relationship_to_Alternative_Contact__Check(component, event, helper);
        }

        var isLoFeeInvalid = false;
        var loanType = component.find("LoanType").get("v.value");
        if ('ARM' === rtype) {
            var LoanOriginationFeeCalculationMethod = component.find("newSelectlist").get("v.value");           
            if(loanType == 'HECM'){
                if (LoanOriginationFeeCalculationMethod == 'Enter Fee Value ($0 - $6,000)') {
                    isLoFeeInvalid = helper.calculate_fee_Value(component, event, helper);
                }
            }else{
                if (LoanOriginationFeeCalculationMethod == 'Enter Fee Value ($0 - $10,000)') {
                    isLoFeeInvalid = helper.calculate_fee_Value2(component, event, helper);
                }                
            }
        }

        if (isLoFeeInvalid || Isrequired || IsRegex || IsRelationshipRequired || checkingDate
            || ValidateContractDate || ValidateContractClosingDate || ValidateSourceOfFundsDate) {
            document.getElementById('SubjectPropertyLbl').innerHTML = 'NoNeedtomove';
            component.set("v.showError", true);
        }
        else {
            component.set("v.showError", false);
            helper.SaveLoans(component, event, helper);
        }
    },

    validatePhone: function (component, event, helper) {
        var phone = component.find("AltConphoneName").get("v.value");
        helper.FormatPhone(component, event, helper);
    },

    FormatPhone: function (component, event, helper) {
        helper.FormatPhonehelper(component, event, helper);

    }
    ,

    RestrictZeroInAlternatePhoneFirstTime: function (component, event, helper) {
        var inz = 'v.NewLoan.Alternate_Contact_Phone_number__c';
        helper.RestrictZeroInPhoneFirstTime(component, event, helper, inz);
    },
    feeCalculation: function (component, event, helper) {
        helper.feecaluculationHelper(component, event, helper, 'notinit');

    },

    validateAppraisedValue: function (component, event, helper) {

    },

    populateFee: function (component, event, helper) {
        if(!component.find('newSelectlist')){
            return; //Not an ARM, so no Loan Origination Fee - Calculation Method
        }
        var rtype = component.get("v.NewLoan.Rate_Type__c");
        var productType = component.get("v.NewLoan.Product_Type__c");
        var selVal = component.find('newSelectlist').get('v.value');
        var amountIs = component.find("LoanEstimateAppVal").get("v.value");
        var amount = parseInt(amountIs);
        if (!isNaN(amount) && amount != 0) {
            component.set("v.newSelectlistdisable", false);
        } else {
            //Code Ended by Dev4 for ORMSFDC-1401
            component.set("v.newSelectlistdisable", true);
        }
        if (selVal == 'Calculate Maximum Fee') {
            component.set("v.show_originate_fee", true);
            component.set("v.show_originate_fee_disable", true);
            if (rtype == 'ARM' && productType == 'HECM') {
                helper.calculate_fee(component, event, helper);
            }else if (rtype == 'ARM' && productType == 'HELO') {
                helper.calculate_fee2(component, event, helper);
            }                
        }
    },
    populateFromPurchasePrice: function (component, event, helper) {
        debugger;
        var selVal = component.find('newSelectlist').get('v.value');
        var amountIs = component.find("PurchasePrice").get("v.value");
        var amount = parseInt(amountIs);
        if (!isNaN(amount) && amount != 0) {
            component.set("v.newSelectlistdisable", false);
            //Code Ended by Dev4 for ORMSFDC-1401
            component.set("v.newSelectlistdisable", true);
        }
        if (selVal == 'Calculate Maximum Fee') {
            component.set("v.show_originate_fee_disable", true);
            helper.calculateFromPurchasePrice(component, event, helper);
        }
    },
    checkpopulateFee: function (component, event, helper) {
        var amountIs = component.find("LoanOriginationFee").get("v.value");
        var amount = parseInt(amountIs);
        if (amount > 6000) {
            component.set('v.NewLoan.Loan_Origination_Fee__c', 6000);
        }
    },
    fee_change: function (component, event, helper) {
        var rtype = component.get("v.NewLoan.Rate_Type__c");
        var productType = component.get("v.NewLoan.Product_Type__c");
        if (rtype == 'ARM' && productType == 'HECM') {
            helper.fee_changeHelper(component, event, helper, 'LoanOriginationFee');
        }else if (rtype == 'ARM' && productType == 'HELO') {
            helper.fee_changeHelperHelo(component, event, helper, 'LoanOriginationFee');
        }
    },
    marginoption: function (component, event, helper) {
        var selVal = event.getSource().get('v.value');

        if (selVal != '') {
            if (selVal == 'Other') {

            }

        }
    },
    relationshipOption: function (component, event, helper) {
        var selVal = event.getSource().get('v.value');
        if (selVal != '') {
            if (selVal == 'Other') {
                component.set("v.Relationship_to_Alternative_Contact", true);
            }
            else {
                component.set("v.Relationship_to_Alternative_Contact", false);
            }

        } else {
            component.set("v.Relationship_to_Alternative_Contact", false);
        }
    },
    RateChange: function (component, event, helper) {
        var Rate = component.find("Ratedata").get("v.value");

        var productType = component.get("v.NewLoan.Product_Type__c");

        if ('HELO' == productType) { //SFDC-237
            component.set("v.NewLoan.Credit_to_Borrower__c", 0); 
            helper.getHeloOrigination(component, event, helper, Rate);
            helper.getHeloMargin(component, event, helper, Rate); //send Helo Margin
        } else {
            helper.getORMOrigination(component, event, helper, Rate);
            helper.getORMBorrower(component, event, helper, Rate);
        }
    },

})