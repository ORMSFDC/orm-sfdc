({
    validateAsset: function(component) {
        var validAsset = true;
        document.getElementById("assetserr").innerHTML = '';
        component.set("v.post", null);
        var msg = '';

        var TA = document.getElementById("AssetsTotalAssets").value;
        var AIN = document.getElementById("AssetsInstitutionName").value;
        var AIA = document.getElementById("AssetsInstitutionAddress").value;
        var AAN = document.getElementById("AssetsAccountNumber").value;
        var AMV = document.getElementById("AssetsMarketValue").value;

        var APA = document.getElementById("AssetsPropertyAddress").value;
        var APMV = document.getElementById("AssetsPresentMarketValue").value;

        if ($A.util.isEmpty(TA)) {
            msg = ' Please fill in all mandatory fields.\n';
            document.getElementById("assetserr").innerHTML = msg;
            validAsset = false;
        }

        if ($A.util.isEmpty(msg)) {
            component.set("v.error", null);



            component.set("v.newloan.AssetsTotalAssets__c", TA);

            component.set("v.newloan.AssetsInstitutionName__c", AIN);

            component.set("v.newloan.AssetsInstitutionAddress__c", AIA);

            component.set("v.newloan.AssetsAccountNumber__c", AAN);

            component.set("v.newloan.AssetsMarketValue__c", AMV);

            component.set("v.newloan.AssetsPropertyAddress__c", APA);

            component.set("v.newloan.AssetsPresentMarketValue__c", APMV);

        }
        return (validAsset);
    },

    validateLoan: function(component) {
        var validLoan = true;
        component.set("v.error", null);
        component.set("v.post", null);
        var msg = '';

        var LMA = document.getElementById("LoanMortgageAppliedFor").value;

        var LPL = $('#LoanPurpose').val();
        var LP = LPL.toString();
        //alert("values are: " + LP);

        var LAT = document.getElementById("LoanApplicationTakenBy").value;

        var LORF = document.getElementById("LoanOriginationFee").value;

        var LID = document.getElementById("LoanInterviewDate").value;

        var LORP = document.getElementById("LoanOriginatorPhone").value;
        var LORCN = document.getElementById("LoanOriginatorCompanyName").value;
        var LORCA = document.getElementById("LoanOriginatorCompanyAddress").value;
        var LORI = document.getElementById("LoanOriginatorIdentifier").value;
        var LORCI = document.getElementById("LoanOriginatorCompanyIdentifier").value;
        var LH = document.getElementById("LoanHouseHoldMembers").value;
        var LC = document.getElementById("LoanChildrenbelow6").value;
        var LPOA = document.getElementById("LoanPOA").value;
        var LSF = document.getElementById("LoanSquareFoot").value;
        var LACN = document.getElementById("LoanAlternateContactName").value;
        var LACA = document.getElementById("LoanAlternateContactAddress").value;
        var LACP = document.getElementById("LoanAlternateContactPhone").value;
        var LEAV = document.getElementById("LoanEstimateAppraisedValue").value;
        var LORN = document.getElementById("LoanOriginatorName").value;

        //alert("value assigned");

        if ($A.util.isEmpty(LP) || $A.util.isEmpty(LAT) || $A.util.isEmpty(LORF) || $A.util.isEmpty(LID) || $A.util.isEmpty(LORP) || $A.util.isEmpty(LORCN) || $A.util.isEmpty(LORCA) || $A.util.isEmpty(LORI) || $A.util.isEmpty(LORCI) || $A.util.isEmpty(LH) || $A.util.isEmpty(LC) || $A.util.isEmpty(LSF) || $A.util.isEmpty(LACN) || $A.util.isEmpty(LACA) || $A.util.isEmpty(LACP) || $A.util.isEmpty(LEAV) || $A.util.isEmpty(LORN)) {
            msg = ' Please fill all mandatory fields.';
            document.getElementById("loanerr").innerHTML = msg;
            document.getElementById("loanerr").classList.add("errorclr");

            validLoan = false;
        } else {

            component.set("v.newloan.LoanMortgageAppliedFor__c", LMA);
            component.set("v.newloan.LoanPurpose__c", LP);
            component.set("v.newloan.LoanApplicationTakenBy__c", LAT);
            component.set("v.newloan.LoanOriginationFee__c", LORF);
            component.set("v.newloan.testnum__c", LORF);
            component.set("v.newloan.LoanInterviewDate__c", LID);
            component.set("v.newloan.LoanOriginatorPhone__c", LORP);
            component.set("v.newloan.LoanOriginatorCompanyName__c", LORCN);
            component.set("v.newloan.LoanOriginatorCompanyAddress__c", LORCA);
            component.set("v.newloan.LoanOriginatorIdentifier__c", LORI);
            component.set("v.newloan.LoanOriginatorCompanyIdentifier__c", LORCI);
            component.set("v.newloan.LoanHouseHoldMembers__c", LH);
            component.set("v.newloan.LoanChildrenbelow6__c", LC);
            component.set("v.newloan.LoanPOA__c", LPOA);
            component.set("v.newloan.LoanSquareFoot__c", LSF);
            component.set("v.newloan.LoanAlternateContactName__c", LACN);
            component.set("v.newloan.LoanAlternateContactAddress__c", LACA);
            component.set("v.newloan.LoanAlternateContactPhone__c", LACP);
            component.set("v.newloan.LoanEstimateAppraisedValue__c", LEAV);
            component.set("v.newloan.LoanOriginatorName__c", LORN);
        }


        return (validLoan);
    },

    validateDec: function(component) {
        var validDec = true;
        component.set("v.error", null);
        component.set("v.post", null);
        var msg = '';

        var DOJ = document.getElementById('DecOutstandingJudgement').value;

        var DPFC = document.getElementById('DecPropertyForClose').value;

        var DLS = document.getElementById('DecLawsuit').value;

        var DFD = document.getElementById('DecDefaultFederalDebt').value;

        var DOL = document.getElementById('DecObligatedLoan').value;

        var DOA = document.getElementById('DecObligatedPayAlimony').value;

        var DDPB = document.getElementById('DecDownPaymentBorrowed').value;
        var DUC = document.getElementById('DecUSCitizen').value;
        var DCM = document.getElementById('DecCoMaker').value;
        var DIO = document.getElementById('DecIntendToOccupy').value;
        var DB = document.getElementById('DecBankrupt').value;
        var DRM = document.getElementById('DecReverseMortgage').value;
        var DFIL = document.getElementById('DecFHAInsuranceLoan').value;
        var DE = document.getElementById('DecEthenicity').value;
        var DR = $("#DecRace").val();
        var DRS = DR.toString();
        var DS = document.getElementById('DecSex').value;


        if ($A.util.isEmpty(DOJ) || $A.util.isEmpty(DPFC) || $A.util.isEmpty(DLS) || $A.util.isEmpty(DFD) || $A.util.isEmpty(DOL) || $A.util.isEmpty(DOA) || $A.util.isEmpty(DDPB) || $A.util.isEmpty(DUC) || $A.util.isEmpty(DCM) || $A.util.isEmpty(DIO) || $A.util.isEmpty(DB) || $A.util.isEmpty(DRM) || $A.util.isEmpty(DFIL) || $A.util.isEmpty(DE) || $A.util.isEmpty(DRS) || $A.util.isEmpty(DS)) {
            msg = ' Please fill in all mandatory fields.\n';
            document.getElementById("decerr").innerHTML = msg;
            validDec = false;
        } else {
            component.set('v.newloan.DecOutstandingJudgement__c', DOJ);
            component.set('v.newloan.DecPropertyForClose__c', DPFC);
            component.set('v.newloan.DecLawsuit__c', DLS);
            component.set('v.newloan.DecDefaultFederalDebt__c', DFD);
            component.set('v.newloan.DecObligatedLoan__c', DOL);
            component.set('v.newloan.DecObligatedPayAlimony__c', DOA);
            component.set('v.newloan.DecDownPaymentBorrowed__c', DDPB);
            component.set('v.newloan.DecUSCitizen__c', DUC);
            component.set('v.newloan.DecCoMaker__c', DCM);
            component.set('v.newloan.DecIntendToOccupy__c', DIO);
            component.set('v.newloan.DecBankrupt__c', DB);
            component.set('v.newloan.DecReverseMortgage__c', DRM);
            component.set('v.newloan.DecFHAInsuranceLoan__c', DFIL);
            component.set('v.newloan.DecEthenicity__c', DE);
            component.set('v.newloan.DecRace__c', DRS);
            component.set('v.newloan.DecSex__c', DS);
        }


        return (validDec);
    },

    validateInc: function(component) {
        var validIncome = true;
        component.set("v.error", null);
        component.set("v.post", null);
        var msg = '';
        var IGM = document.getElementById('IncomeGrossMonthly').value;
        var IDO = document.getElementById('IncomeDescribeOther').value;
        var IM = document.getElementById('IncomeMonthly').value;
        var IGR = document.getElementById('IncomeGrossRental').value;
        var INR = document.getElementById('IncomeNetRental').value;

        if ($A.util.isEmpty(IGM))

        {
            msg = ' Please fill in all mandatory fields.\n';
            document.getElementById("incomeerr").innerHTML = msg;
            validIncome = false;
        } else {

            component.set('v.newloan.IncomeGrossMonthly__c ', IGM);
            component.set('v.newloan.IncomeDescribeOther__c ', IDO);
            component.set('v.newloan.IncomeMonthly__c ', IM);
            component.set('v.newloan.IncomeGrossRental__c ', IGR);
            component.set('v.newloan.IncomeNetRental__c', INR);
        }


        return (validIncome);
    },


    validateEmp: function(component) {
        var validEmp = true;
        component.set("v.error", null);
        component.set("v.post", null);
        var msg = '';

        var EA2 = document.getElementById('EmploymentAddress2').value;

        var EC = document.getElementById('EmploymentCity').value;

        var ES = document.getElementById('EmploymentState').value;

        var EZ = document.getElementById('EmploymentZip').value;

        var EN = document.getElementById('EmploymentName').value;

        var EA1 = document.getElementById('EmploymentAddress1').value;
        var ESE = document.getElementById('EmploymentSelfEmployed').value;
        var EBP = document.getElementById('EmploymentBusinessPhone').value;
        var ESD = document.getElementById('EmploymentStartDate').value;
        var EED = document.getElementById('EmploymentEndDate').value;
        /*if ($A.util.isEmpty(EA2) || $A.util.isEmpty(EC) ||  $A.util.isEmpty(ES) || $A.util.isEmpty(EZ) || $A.util.isEmpty(EN) || $A.util.isEmpty(EA1) || $A.util.isEmpty(ESE) || $A.util.isEmpty(EBP) || $A.util.isEmpty(ESD) || $A.util.isEmpty(EED))
                {
                    msg = msg + ' Please fill in all mandatory fields.\n';
                    component.set("v.error",msg);
                    validIncome = false;
                }
                else {*/

        component.set('v.newloan.EmploymentAddress2__c ', EA2);
        component.set('v.newloan.EmploymentCity__c ', EC);
        component.set('v.newloan.EmploymentState__c ', ES);
        component.set('v.newloan.EmploymentZip__c ', EZ);
        component.set('v.newloan.EmploymentName__c ', EN);
        component.set('v.newloan.EmploymentAddress1__c ', EA1);
        component.set('v.newloan.EmploymentSelfEmployed__c ', ESE);
        component.set('v.newloan.EmploymentBusinessPhone__c ', EBP);
        component.set('v.newloan.EmploymentStartDate__c ', ESD);
        component.set('v.newloan.EmploymentEndDate__c', EED);
        // }


        return (validEmp);
    },

    validateLiab: function(component) {
        var validLiab = true;
        component.set("v.error", null);
        component.set("v.post", null);
        var msg = '';
        var LA = document.getElementById('LiabilitiesAlimony').value;
        var LJR = document.getElementById('LiabilitiesJobRelated').value;
        var LM = document.getElementById('LiabilitiesMortgage').value;
        var LMP = document.getElementById('LiabilitiesMortgagePayment').value;
        var LT = document.getElementById('LiabilitiesTaxes').value;
        var LCD = document.getElementById('LiabilitiesCombinedMonthlyDebts').value;




        if ($A.util.isEmpty(LM)) {
            msg = ' Please fill in all mandatory fields.\n';
            document.getElementById("liaberr").innerHTML = msg;
            validLiab = false;
        } else {

            component.set('v.newloan.LiabilitiesAlimony__c', LA);
            component.set('v.newloan.LiabilitiesJobRelated__c', LJR);
            component.set('v.newloan.LiabilitiesMortgage__c', LM);
            component.set('v.newloan.LiabilitiesMortgagePayment__c', LMP);
            component.set('v.newloan.LiabilitiesTaxes__c', LT);
            component.set('v.newloan.LiabilitiesCombinedMonthlyDebts__c', LCD);
        }


        return (validLiab);
    },


    validateSub: function(component) {
        var validSub = true;
        component.set("v.error", null);
        component.set("v.post", null);
        var msg = '';

        var SPA = document.getElementById('SubjectPropertyAddress').value;

        var SPD = document.getElementById('SubjectPropertyDescription').value;

        var SPRT = document.getElementById('SubjectPropertyResidenceType').value;

        var SPYB = document.getElementById('SubjectPropertyYearBuilt').value

        var SPNP = document.getElementById('SubjectPropertyNoOfProperty').value;

        var SPHA = document.getElementById('SubjectPropertyHeldAs').value;

        var SPHN = document.getElementById('SubjectPropertyHeldNames').value;


        var SPRET = document.getElementById('SubjectPropertyRealEstateTax').value;

        var SPHI = document.getElementById('SubjectPropertyHazardInsurance').value;

        var SPHOF = document.getElementById('SubjectPropertyHomeOwnerFee').value;

        var SCHA = document.getElementById('SubjectCheckHeldAs').value



        if ($A.util.isEmpty(SPA) || $A.util.isEmpty(SPRT) || $A.util.isEmpty(SPYB) || $A.util.isEmpty(SPNP) || $A.util.isEmpty(SPHA) || $A.util.isEmpty(SPHN) || $A.util.isEmpty(SPRET) || $A.util.isEmpty(SPHI) || $A.util.isEmpty(SPHOF)) {
            msg = ' Please fill in all mandatory fields.\n';
            document.getElementById("subjecterr").innerHTML = msg;
            validSub = false;
        } else {

            component.set('v.newloan.SubjectPropertyAddress__c', SPA);
            component.set('v.newloan.SubjectPropertyDescription__c', SPD);
            component.set('v.newloan.SubjectPropertyResidenceType__c', SPRT);
            component.set('v.newloan.SubjectPropertyYearBuilt__c', SPYB);
            component.set('v.newloan.SubjectPropertyNoOfProperty__c', SPNP);
            component.set('v.newloan.SubjectPropertyHeldAs__c', SPHA);
            component.set('v.newloan.SubjectPropertyHeldNames__c', SPHN);

            component.set('v.newloan.SubjectPropertyRealEstateTax__c', SPRET);
            component.set('v.newloan.SubjectPropertyHazardInsurance__c', SPHI);
            component.set('v.newloan.SubjectPropertyHomeOwnerFee__c', SPHOF);
            component.set('v.newloan.SubjectCheckHeldAs__c', SCHA);
        }


        return (validSub);
    },



    validateClient: function(component) {
        var validClient = true;
        component.set("v.error", null);
        component.set("v.post", null);


        var msg = '';

        var sec = component.find("secret").get("v.value");

        var NBS = document.getElementById('NBS').value;



        var NBR = document.getElementById('NBR').value;


        //var CBN = document.getElementById('ClientBorrowerName').value;
        var SSN = document.getElementById('ClientSSN').value;
        var CDOB = document.getElementById('ClientDOB').value
        var CMS = document.getElementById('ClientMaritalStatus').value
        //var CMA1 = document.getElementById('ClientMailingAddress1').value;
        var CPAY = document.getElementById('ClientPresentAddressYears').value;
        if (NBR == "true") {
            var CNBRN = document.getElementById('ClientNBRName').value;

            var CNBRP = document.getElementById('ClientNBRPhone').value;

            var CNBRDOB = document.getElementById('ClientNBRDOB').value;

            var CNBRR = document.getElementById('ClientNBRRelationship').value;
        }

        if (NBS == "true") {
            var CNBSN = document.getElementById('ClientNBSName').value;

            var CNBSP = document.getElementById('ClientNBSPhone').value;

            var CNBSDOB = document.getElementById('ClientNBSDOB').value;

            var CNBSR = document.getElementById('ClientNBSRelationship').value
        }
        //var CMA2 = document.getElementById('ClientMailingAddress2').value;

        //var CC = document.getElementById('ClientCity').value;
        //var CS = document.getElementById('ClientState').value;
        //var CZ = document.getElementById('ClientZip').value;

        var FNAME = component.find("inputFName").get("v.value");
        var LNAME = component.find("inputLName").get("v.value");
        var INADR = component.find("inputAddress").get("v.value");
        var SSTATE = component.find("SelectState").get("v.value");
        var IZ = component.find("inputZip").get("v.value");
        var EMAIL = component.find("inputEmail").get("v.value");
        var PHONE = component.find("inputPhone").get("v.value");



        if ($A.util.isEmpty(EMAIL) || $A.util.isEmpty(CDOB) || $A.util.isEmpty(FNAME) || $A.util.isEmpty(LNAME) || $A.util.isEmpty(INADR) || $A.util.isEmpty(SSTATE) || $A.util.isEmpty(IZ) || $A.util.isEmpty(PHONE) || $A.util.isEmpty(SSN) || $A.util.isEmpty(CMS) || $A.util.isEmpty(CPAY)) {
            msg = ' Please fill in all mandatory fields.\n';
            document.getElementById("clienterr").innerHTML = msg;
            validClient = false;
        } else {

            //component.set('v.newloan.ClientBorrowerName__c',CBN);
            component.set('v.newloan.ClientSSN__c', SSN);
            //component.set('v.newloan.ClientDOB__c',CDOB);
            component.set('v.newloan.ClientMaritalStatus__c', CMS);
            //component.set('v.newloan.ClientMailingAddress1__c',CMA1);
            component.set('v.newloan.ClientPresentAddressYears__c', CPAY);
            component.set('v.newloan.ClientNBRName__c', CNBRN);
            component.set('v.newloan.ClientNBRPhone__c', CNBRP);
            component.set('v.newloan.ClientNBRDOB__c', CNBRDOB);
            component.set('v.newloan.ClientNBRRelationship__c', CNBRR);
            component.set('v.newloan.ClientNBSName__c', CNBSN);
            component.set('v.newloan.ClientNBSPhone__c', CNBSP);
            component.set('v.newloan.ClientNBSDOB__c', CNBSDOB);
            component.set('v.newloan.ClientNBSRelationship__c', CNBSR);
            //component.set('v.newloan.ClientMailingAddress2__c',CMA2);
            //component.set('v.newloan.ClientCity__c',CC);
            //component.set('v.newloan.ClientState__c',CS);
            //component.set('v.newloan.ClientZip__c',CZ);
            component.set('v.newloan.ClientNBR__c', NBR);
            component.set('v.newloan.ClientNBS__c', NBS);
            //  if ($A.util.isEmpty(sec))
            //{
            //component.set('v.newloan.ClientIName__c',FNAME);  
            // }

            component.set('v.newclient.Name', FNAME);
            component.set('v.newclient.Last_Name__c', LNAME);
            component.set('v.newclient.Street_Address__c', INADR);
            component.set('v.newclient.State__c', SSTATE);
            component.set('v.newclient.Zip__c', IZ);
            component.set('v.newclient.Email_Optional__c', EMAIL);
            component.set('v.newclient.Phone_Number__c', PHONE);
            component.set('v.newclient.DOB__c', CDOB);

        }



        return (validClient);
    },
    createExpense: function(component, L1, id) {
        var action = component.get("c.saveLoan");
        // var L1 = component.get("v.loans");
        //console.dir(L1);
        var Loan = JSON.stringify(L1);

        //L.AssetsTotalAssets__c = document.getElementById("AssetsTotalAssets").value;
        // console.log("String is " + Loan);
        //alert("String is " + Loan);

        action.setParams({
            "Loan": L1,
            "id": id
        });

        //console.log("Value is : " + JSON.stringify(action));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //var expenses = component.get("v.loans");
                //expenses.push(response.getReturnValue());
                component.set("v.loans", response.getReturnValue());
                var ind = component.get("v.loans.LoanInterviewDate__c");
                var subind = ind.substring(0, 10);

                console.log("subind: " + subind);

                // console.log($A.localizationService.formatDate(in);

                document.getElementById("LoanInterviewDate").value = subind;
            } else if (component.isValid() && state === "ERROR") {
                //This console logs are meant for your understanding,
                ﻿ //avoid using them in your production code.
                console.log("Exception caught successfully");
                console.log("Error object", response);
                console.log("Error Message", response.getError()[0]);
                console.log("Error Message", response.getError()[0].message);
                console.log("Error Message", response.getState());
                console.log("Error object", JSON.stringify(response));
                //component.set("v.errMessage", response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    phoneFormat: function(component, phone, phn) {
        //alert(phn);
        //alert(phone);

        var phn_out = '+1(' + phone.substring(0, 3) + ') ' + phone.substring(3, 6) + '-' + phone.substring(6, 10);

        document.getElementById(phn).value = phn_out;

    },

    screenSet: function(component, id) {
        var action = component.get("c.setScreen");

        action.setParams({

            "id": id
        });

        action.setCallback(this, function(data) {

            var state = data.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.loanflag", data.getReturnValue());

                var retvalue = true;
                //alert("in screen helper");
                var flag_A = component.get("v.loanflag.AssetsCompleteFlag__c");
                var flag_L = component.get("v.loanflag.LoanCompleteFlag__c");
                var flag_C = component.get("v.loanflag.ClientCompleteFlag__c");
                var flag_E = component.get("v.loanflag.EmploymentCompleteFlag__c");
                var flag_Li = component.get("v.loanflag.LiabilitiesCompleteFlag__c");
                var flag_S = component.get("v.loanflag.SubjectCompleteFlag__c");
                var flag_I = component.get("v.loanflag.IncomeCompleteFlag__c");
                var flag_D = component.get("v.loanflag.DecCompleteFlag__c");

                // alert(flag_E);

                if (flag_D == 'N') {
                    document.getElementById("l1").classList.remove("active");
                    document.getElementById("l2").classList.remove("active");
                    document.getElementById("l3").classList.remove("active");
                    document.getElementById("l4").classList.remove("active");
                    document.getElementById("l5").classList.remove("active");
                    document.getElementById("l6").classList.remove("active");
                    document.getElementById("l7").classList.remove("active");
                    document.getElementById("l8").classList.add("active");
                    document.getElementById("Loan").classList.remove("active", "in");
                    document.getElementById("subject").classList.remove("active", "in");
                    document.getElementById("client").classList.remove("active", "in");
                    document.getElementById("income").classList.remove("active", "in");
                    document.getElementById("employment").classList.remove("active", "in");
                    document.getElementById("assets").classList.remove("active", "in");
                    document.getElementById("declarations").classList.add("active", "in");
                    document.getElementById("liabilities").classList.remove("active", "in");
                    window.scrollTo(0, 0);

                }

                if (flag_Li == 'N') {
                    document.getElementById("l1").classList.remove("active");
                    document.getElementById("l2").classList.remove("active");
                    document.getElementById("l3").classList.remove("active");
                    document.getElementById("l4").classList.remove("active");
                    document.getElementById("l5").classList.remove("active");
                    document.getElementById("l6").classList.remove("active");
                    document.getElementById("l7").classList.add("active");
                    document.getElementById("l8").classList.remove("active");
                    document.getElementById("Loan").classList.remove("active", "in");
                    document.getElementById("subject").classList.remove("active", "in");
                    document.getElementById("client").classList.remove("active", "in");
                    document.getElementById("income").classList.remove("active", "in");
                    document.getElementById("employment").classList.remove("active", "in");
                    document.getElementById("assets").classList.remove("active", "in");
                    document.getElementById("declarations").classList.remove("active", "in");
                    document.getElementById("liabilities").classList.add("active", "in");
                    window.scrollTo(0, 0);

                }
                if (flag_A == 'N') {
                    document.getElementById("l1").classList.remove("active");
                    document.getElementById("l2").classList.remove("active");
                    document.getElementById("l3").classList.remove("active");
                    document.getElementById("l4").classList.remove("active");
                    document.getElementById("l5").classList.remove("active");
                    document.getElementById("l6").classList.add("active");
                    document.getElementById("l7").classList.remove("active");
                    document.getElementById("l8").classList.remove("active");
                    document.getElementById("Loan").classList.remove("active", "in");
                    document.getElementById("subject").classList.remove("active", "in");
                    document.getElementById("client").classList.remove("active", "in");
                    document.getElementById("income").classList.remove("active", "in");
                    document.getElementById("employment").classList.remove("active", "in");
                    document.getElementById("assets").classList.add("active", "in");
                    document.getElementById("declarations").classList.remove("active", "in");
                    document.getElementById("liabilities").classList.remove("active", "in");
                    window.scrollTo(0, 0);

                }
                if (flag_I == 'N') {
                    document.getElementById("l1").classList.remove("active");
                    document.getElementById("l2").classList.remove("active");
                    document.getElementById("l3").classList.remove("active");
                    document.getElementById("l4").classList.remove("active");
                    document.getElementById("l5").classList.add("active");
                    document.getElementById("l6").classList.remove("active");
                    document.getElementById("l7").classList.remove("active");
                    document.getElementById("l8").classList.remove("active");
                    document.getElementById("Loan").classList.remove("active", "in");
                    document.getElementById("subject").classList.remove("active", "in");
                    document.getElementById("client").classList.remove("active", "in");
                    document.getElementById("income").classList.add("active", "in");
                    document.getElementById("employment").classList.remove("active", "in");
                    document.getElementById("assets").classList.remove("active", "in");
                    document.getElementById("declarations").classList.remove("active", "in");
                    document.getElementById("liabilities").classList.remove("active", "in");
                    window.scrollTo(0, 0);

                }
                if (flag_E == 'N') {
                    document.getElementById("l1").classList.remove("active");
                    document.getElementById("l2").classList.remove("active");
                    document.getElementById("l3").classList.remove("active");
                    document.getElementById("l4").classList.add("active");
                    document.getElementById("l5").classList.remove("active");
                    document.getElementById("l6").classList.remove("active");
                    document.getElementById("l7").classList.remove("active");
                    document.getElementById("l8").classList.remove("active");
                    document.getElementById("Loan").classList.remove("active", "in");
                    document.getElementById("subject").classList.remove("active", "in");
                    document.getElementById("client").classList.remove("active", "in");
                    document.getElementById("income").classList.remove("active", "in");
                    document.getElementById("employment").classList.add("active", "in");
                    document.getElementById("assets").classList.remove("active", "in");
                    document.getElementById("declarations").classList.remove("active", "in");
                    document.getElementById("liabilities").classList.remove("active", "in");
                    window.scrollTo(0, 0);

                }

                if (flag_C == 'N') {
                    document.getElementById("l1").classList.remove("active");
                    document.getElementById("l2").classList.remove("active");
                    document.getElementById("l3").classList.remove("active");
                    document.getElementById("l4").classList.add("active");
                    document.getElementById("l5").classList.remove("active");
                    document.getElementById("l6").classList.remove("active");
                    document.getElementById("l7").classList.remove("active");
                    document.getElementById("l8").classList.remove("active");
                    document.getElementById("Loan").classList.remove("active", "in");
                    document.getElementById("subject").classList.remove("active", "in");
                    document.getElementById("client").classList.add("active", "in");
                    document.getElementById("income").classList.remove("active", "in");
                    document.getElementById("employment").classList.remove("active", "in");
                    document.getElementById("assets").classList.remove("active", "in");
                    document.getElementById("declarations").classList.remove("active", "in");
                    document.getElementById("liabilities").classList.remove("active", "in");
                    window.scrollTo(0, 0);

                }
                if (flag_S == 'N') {
                    document.getElementById("l1").classList.remove("active");
                    document.getElementById("l2").classList.add("active");
                    document.getElementById("l3").classList.remove("active");
                    document.getElementById("l4").classList.remove("active");
                    document.getElementById("l5").classList.remove("active");
                    document.getElementById("l6").classList.remove("active");
                    document.getElementById("l7").classList.remove("active");
                    document.getElementById("l8").classList.remove("active");
                    document.getElementById("Loan").classList.remove("active", "in");
                    document.getElementById("subject").classList.add("active", "in");
                    document.getElementById("client").classList.remove("active", "in");
                    document.getElementById("income").classList.remove("active", "in");
                    document.getElementById("employment").classList.remove("active", "in");
                    document.getElementById("assets").classList.remove("active", "in");
                    document.getElementById("declarations").classList.remove("active", "in");
                    document.getElementById("liabilities").classList.remove("active", "in");
                    window.scrollTo(0, 0);
                }
                if (flag_L == 'N') {
                    document.getElementById("l1").classList.add("active");
                    document.getElementById("l2").classList.remove("active");
                    document.getElementById("l3").classList.remove("active");
                    document.getElementById("l4").classList.remove("active");
                    document.getElementById("l5").classList.remove("active");
                    document.getElementById("l6").classList.remove("active");
                    document.getElementById("l7").classList.remove("active");
                    document.getElementById("l8").classList.remove("active");
                    document.getElementById("Loan").classList.add("active", "in");
                    document.getElementById("subject").classList.remove("active", "in");
                    document.getElementById("client").classList.remove("active", "in");
                    document.getElementById("income").classList.remove("active", "in");
                    document.getElementById("employment").classList.remove("active", "in");
                    document.getElementById("assets").classList.remove("active", "in");
                    document.getElementById("declarations").classList.remove("active", "in");
                    document.getElementById("liabilities").classList.remove("active", "in");
                    window.scrollTo(0, 0);
                }
            } else {
                console.log("Failed with state: " + state);
            }

        });
        $A.enqueueAction(action);
    },

    check: function(component) {
        document.getElementById("l1").classList.remove("active");
        document.getElementById("l2").classList.remove("active");
        document.getElementById("l3").classList.remove("active");
        document.getElementById("l4").classList.add("active");
        document.getElementById("l5").classList.remove("active");
        document.getElementById("l6").classList.remove("active");
        document.getElementById("l7").classList.remove("active");
        document.getElementById("l8").classList.remove("active");
        document.getElementById("Loan").classList.remove("active", "in");
        document.getElementById("subject").classList.remove("active", "in");
        document.getElementById("client").classList.add("active", "in");
        document.getElementById("income").classList.remove("active", "in");
        document.getElementById("employment").classList.remove("active", "in");
        document.getElementById("assets").classList.remove("active", "in");
        document.getElementById("declarations").classList.remove("active", "in");
        document.getElementById("liabilities").classList.remove("active", "in");
        window.scrollTo(0, 0);

    },

    validateLoandetails: function(component) {
        var validLoan = true;
        component.set("v.error", null);
        component.set("v.post", null);
        var msg = '';

        var LDTS = document.getElementById("LoanDetailsTitleSource").value;
        if (LDTS == "true") {
            var LDTC = document.getElementById("LoanDetailsTitleCompany").value;

            var LDTCO = document.getElementById("LoanDetailsContact").value;
        }
        var LDPP = document.getElementById("LoanDetailsPayPartner").value;
        if ($A.util.isEmpty(LDTS) || $A.util.isEmpty(LDPP)) {
            msg = ' Please fill all feilds.';
            document.getElementById("loandetailerr").innerHTML = msg;
            document.getElementById("loandetailerr").classList.add("errorclr");

            validLoan = false;
        } else {

            component.set("v.newloan.LoanDetailsTitleCompany__c", LDTC);
            component.set("v.newloan.LoanDetailsTitleSource__c", LDTS);
            component.set("v.newloan.LoanDetailsContact__c", LDTCO);
            component.set("v.newloan.LoanDetailsPayPartner__c", LDPP);

        }


        return (validLoan);
    },

    validateCreditInfo: function(component) {
        var validCreditInfo = true;
        component.set("v.error", null);
        component.set("v.post", null);
        var msg = '';

        var CPN = document.getElementById("CreditPullNew").value;
        if (CPN == "true") {
            var CPNC = document.getElementById("CreditPullNewChild").value;
        }
        var CRI = document.getElementById("CreditReissue").value;
        if (CRI == "true") {
            var CRN = document.getElementById("CreditReferenceNumber").value;
            var CRNC = document.getElementById("CreditReferenceNumberConfirm").value;
        }

        if ($A.util.isEmpty(CPN) || $A.util.isEmpty(CRI)) {
            msg = ' Please fill all feilds.';
            document.getElementById("CreditInfoerr").innerHTML = msg;
            document.getElementById("loandetailerr").classList.add("errorclr");

            validCreditInfo = false;
        } else {
            component.set("v.newloan.CreditPullNew__c", CPN);
            component.set("v.newloan.CreditPullNewChild__c", CPNC);
            component.set("v.newloan.CreditReissue__c", CRI);
            component.set("v.newloan.CreditReferenceNumber__c", CRN);
            component.set("v.newloan.CreditReferenceNumberConfirm__c", CRNC);

        }


        return (validCreditInfo);
    },

    searchHelper: function(component, event, getInputkeyWord) {
        //alert("in helper");
        // call the apex class method 
        var action = component.get("c.fetchAccount");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }

                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }

        });
        // enqueue the Action  
        $A.enqueueAction(action);

    },

    createClient: function(component, Client, Loan) {
        var action = component.get("c.SaveClient");
        var client_id = component.find("secret").get("v.value");
        //alert(client_id);
        // var L1 = component.get("v.loans");
        //console.dir(L1);
        //var Loan = JSON.stringify(Client);
        var id = document.getElementById("id").value;

        //L.AssetsTotalAssets__c = document.getElementById("AssetsTotalAssets").value;
        // console.log("String is " + Loan);
        //alert("String is " + Loan);

        action.setParams({
            "Loan": Loan,
            "objClient": Client,
            "Loan_id": id,
            "client_id": client_id


        });

        //console.log("Value is : " + JSON.stringify(action));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //var expenses = component.get("v.loans");
                //expenses.push(response.getReturnValue());
                //component.set("v.loans", response.getReturnValue());

            } else if (component.isValid() && state === "ERROR") {
                //This console logs are meant for your understanding,
                ﻿ //avoid using them in your production code.
                console.log("Exception caught successfully");
                console.log("Error object", response);
                console.log("Error Message", response.getError()[0]);
                console.log("Error Message", response.getError()[0].message);
                console.log("Error Message", response.getState());
                console.log("Error object", JSON.stringify(response));
                //component.set("v.errMessage", response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    LoanCompletechk: function(component, id) {
        if ($A.util.isEmpty(id)) {
            alert("Please fill in  all the neccesary fields");
        } else {
            var action = component.get("c.setScreen");

            action.setParams({

                "id": id
            });

            action.setCallback(this, function(data) {

                var state = data.getState();
                if (component.isValid() && state === "SUCCESS") {
                    component.set("v.loanflag", data.getReturnValue());

                    var retvalue = true;
                    //alert("in screen helper");
                    var final_flag = component.get("v.loanflag.FinalCompleteFlag__c");

                    if (final_flag == 'N') {
                        alert("Please fill in  all the mandatory fields");
                    } else {
                        alert("Thank You. You request has been successfully submitted");
                    }


                } else {
                    console.log("Failed with state: " + state);
                }

            });
            $A.enqueueAction(action);
        }
    },

    setClient: function(component, id) {

        //alert("Set Client Helper" + id);

        var action = component.get("c.getclientValue");


        action.setParams({

            "id": id
        });

        action.setCallback(this, function(data) {
            var state = data.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.selectedRecord", data.getReturnValue());


            } else {
                console.log("Failed with state: " + state);
            }

        });
        $A.enqueueAction(action);

    },

})