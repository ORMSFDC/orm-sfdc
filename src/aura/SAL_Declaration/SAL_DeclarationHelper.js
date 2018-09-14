({
    PopulateDeclarationBasedonClient: function (component, event, helper, ClientId) {
        var ClientId = ClientId;
        var action1 = component.get("c.getDeclr");
        action1.setParams({
            "ClientId": ClientId
        });
        action1.setCallback(this, function (data) {
            var res = data.getReturnValue();
            if (res != null) {
                var result = data.getReturnValue();
                component.set("v.NewDeclaration", data.getReturnValue());
                this.validateAndOpenForm(component, event, helper);
            }
        });
        $A.enqueueAction(action1);
    },

    clientstatusDetails: function (component, event, helper) {
        var _Loanid = component.get("v.DecLoanId");
        var action1 = component.get("c.AllClientsName");
        action1.setParams({
            "loanID": _Loanid
        });
        action1.setCallback(this, function (data) {
            var ReturnData = data.getReturnValue();
            component.set("v.clientRecords", data.getReturnValue());
        });
        $A.enqueueAction(action1);
    },

    validateAndOpenForm: function (component, event, helper) {

        var bringback = component.find('groupd').get('v.value');
        if (bringback == 'Yes') {
            document.getElementById('reasond').style.display = 'block';
        }
        else { document.getElementById('reasond').style.display = 'None'; }

        var delinquent = component.find('groupc').get('v.value');
        if (delinquent == 'Yes') {
            document.getElementById('reasonc').style.display = 'block';

        }
        else { document.getElementById('reasonc').style.display = 'None'; }
        //intend to use the Reverse Mortgage
        var intend = component.find('groupi').get('v.value');

        if (intend == 'Yes') {
            document.getElementById('reasoni').style.display = 'block';

        }
        else { document.getElementById('reasoni').style.display = 'None'; }
        //FHA Insured Loan
        var FHA = component.find('groupj').get('v.value');

        if (FHA == 'Yes') {
            document.getElementById('FHADetails').style.display = 'block';

        }
        else { document.getElementById('FHADetails').style.display = 'None'; }

        var SelectedValue = component.find('groupl').get('v.value');

        var American = SelectedValue.indexOf("American Indian or Alaska Native");
        var Asian = SelectedValue.indexOf("Asian");

        if (American != -1) {
            //component.set('v.showRaceNative', true);
            document.getElementById('DivshowRaceNative').style.display = 'block';

        }
        else { //component.set('v.showRaceNative', false);
            document.getElementById('DivshowRaceNative').style.display = 'none';
        }

        if (Asian != -1) {
            //component.set('v.showAsian', true);
            document.getElementById('DivshowAsian').style.display = 'block';
        }
        else { //component.set('v.showAsian', false);
            document.getElementById('DivshowAsian').style.display = 'None';
        }

        var SelectedEthenicity = component.find('groupk').get('v.value');
        if (SelectedEthenicity == 'Hispanic or Latino') {
            //component.set('v.showEthnicity', true);
            document.getElementById('DivshowEthnicity').style.display = 'block';


        }
        else { //component.set('v.showEthnicity', false);
            document.getElementById('DivshowEthnicity').style.display = 'None';
        }
        var a = component.find('groupa').get('v.value');
        var b = component.find('grouph').get('v.value');
        var c = component.find('groupb').get('v.value');
        var d = component.find('groupc').get('v.value');
        var e = component.find('groupg').get('v.value');
        var f = component.find('groupe').get('v.value');
        var g = component.find('groupf').get('v.value');
        var h = component.find('groupalien').get('v.value');
        var i = component.find('groupd').get('v.value');

        if (a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || f == 'Yes' || g == 'Yes' || h == 'Yes' || i == 'Yes') {
            document.getElementById('DivshowRemarks').style.display = 'block';

        }
        else {
            document.getElementById('DivshowRemarks').style.display = 'None';
        }

        if (American != -1) {
            var EnrolledTribecc = component.find('EnrolledTribeText').get('v.value');
            if ($A.util.isEmpty(EnrolledTribecc)) {
                document.getElementById("EnrolledTribeError").innerHTML = '';
                var EnrolledTribecc = component.find("EnrolledTribecc");
                $A.util.addClass(EnrolledTribecc, 'errorComponent');
            } else {
                document.getElementById("EnrolledTribeError").innerHTML = '';
                var EnrolledTribecc = component.find("EnrolledTribecc");
                $A.util.removeClass(EnrolledTribecc, 'errorComponent');
            }
        }
        if (Asian != -1) {
            var groupAsiancc = component.find('groupAsian').get('v.value');
            if ($A.util.isEmpty(groupAsiancc)) {
                document.getElementById("groupAsianError").innerHTML = '';
                var groupAsiancc = component.find("groupAsiancc");
                $A.util.addClass(groupAsiancc, 'errorComponent');
            } else {
                document.getElementById("groupAsianError").innerHTML = '';
                var groupAsiancc = component.find("groupAsiancc");
                $A.util.removeClass(groupAsiancc, 'errorComponent');
            }
        }
        if (a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || f == 'Yes' || g == 'Yes' || h == 'Yes' || i == 'Yes') {
            var RemarksVal = component.find('DeclComments').get('v.value');
            if ($A.util.isEmpty(RemarksVal)) {
                document.getElementById("RemarksError").innerHTML = '';
                var RemarksVal = component.find("RemarksVal");
                $A.util.addClass(RemarksVal, 'errorComponent');
            } else {
                document.getElementById("RemarksError").innerHTML = '';
                var RemarksVal = component.find("RemarksVal");
                $A.util.removeClass(RemarksVal, 'errorComponent');

            }
        }
        if (SelectedEthenicity == 'Hispanic or Latino') {
            var ethenicitycc = component.find('groupEthnicity').get('v.value');
            if ($A.util.isEmpty(ethenicitycc)) {
                document.getElementById("ethnicityError").innerHTML = '';
                var ethenicitycc = component.find("ethenicitycc");
                $A.util.addClass(ethenicitycc, 'errorComponent');
            } else {
                document.getElementById("ethnicityError").innerHTML = '';
                var ethenicitycc = component.find("ethenicitycc");
                $A.util.removeClass(ethenicitycc, 'errorComponent');

            }

        }


    },

    prev: function (component) {
        $A.getCallback(function (result) {
            $('li#l7 a').click();
        });
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    }
    ,
    Loan_Next: function (component, event, helper) {
        $('li#step2Lock').removeClass('disabled');
        $('li#step2Lock a').attr("data-toggle", "collapse");
        $('li#l8').removeClass('active');
        $A.getCallback(function (result) {
            $('a#step2').click();
        });
        $('li#l9').removeClass('disabled');
        $('li#l9 a').attr("data-toggle", "tab");
        $A.getCallback(function (result) {
            $('#l9 a').click();
        });
        $('li#l10').attr('class', 'disabled');
        $('li#l10 a').attr("data-toggle", "cat");
        $('li#l11').attr('class', 'disabled');
        $('li#l11 a').attr("data-toggle", "cat");
        $('li#l12').attr('class', 'disabled');
        $('li#l12 a').attr("data-toggle", "cat");
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },

})