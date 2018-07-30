({
    myAction: function(component, event, helper) {

        var id = component.get("v.LoanId");
        // alert("In Loan Menu" + id);

        var action = component.get("c.getValue");

        action.setParams({

            "id": id
        });

        action.setCallback(this, function(data) {
            var state = data.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.loans", data.getReturnValue());
                var loan_a = component.get("v.loans.LoanPurpose__c");
                var id = component.get("v.loans.ClientIName__c");
                var ind = component.get("v.loans.LoanInterviewDate__c");
                console.log("ind is : " + ind);
                //alert("Value is : " + id);

                if (!$A.util.isEmpty(loan_a)) {
                    var loan_b = loan_a.split(",");
                    $('#LoanPurpose').val(loan_b);
                }


                var Dec_a = component.get("v.loans.DecRace__c");
                if (!$A.util.isEmpty(Dec_a)) {
                    var Dec_b = Dec_a.split(",");
                    $('#DecRace').val(Dec_b);
                }
                // document.getElementById("LoanMortgageAppliedFor").focus();
                var NBR = component.get("v.loans.ClientNBR__c");
                var NBS = component.get("v.loans.ClientNBS__c");
                var LTS = component.get("v.loans.LoanDetailsTitleSource__c");
                var PNC = component.get("v.loans.CreditPullNew__c");
                var RIC = component.get("v.loans.CreditReissue__c");
                //alert(LTS);




                component.set("v.client_borrowering_spouse", NBS);
                component.set("v.client_borrowering_resident", NBR);
                component.set("v.Loan_Details", LTS);
                component.set("v.PullNewCredit", PNC);
                component.set("v.ReIssueCredit", RIC);

                //document.getElementById("LoanMortgageAppliedFor").focus();
                helper.setClient(component, id);

            } else {
                console.log("Failed with state: " + state);
            }

        });
        $A.enqueueAction(action);
        if (id != '') {
            helper.screenSet(component, id);
        }
        //helper.check(component);
        window.scrollTo(0, 0);

    },



    Loan_Next: function(component, event, helper) {

        if (helper.validateLoan(component)) {
            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;
            component.set("v.post", "#subject");
            helper.createExpense(component, Loan, id);
            var a = component.get("v.newloan.LoanInterviewDate__c");
            document.getElementById("hdate").value = a;
            document.getElementById("l1").classList.remove("active");
            document.getElementById("l2").classList.toggle("active");
            window.scrollTo(0, 0);
        }

    },

    Subject_Prev: function(component) {
        var hdate = document.getElementById("hdate").value;
        document.getElementById("LoanInterviewDate").value = hdate;
        document.getElementById("l2").classList.remove("active");
        document.getElementById("l1").classList.toggle("active");
        window.scrollTo(0, 0);
    },


    Subject_Next: function(component, event, helper) {

        if (helper.validateSub(component)) {
            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;
            component.set("v.post", "#client");
            helper.createExpense(component, Loan, id);


            document.getElementById("l2").classList.remove("active");
            document.getElementById("l3").classList.toggle("active");
            window.scrollTo(0, 0);
        }
        //alert(a);
    },


    Client_Prev: function(component) {

        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l3").classList.remove("active");
        document.getElementById("l2").classList.toggle("active");
        window.scrollTo(0, 0);
        //alert(a);
    },


    Client_Next: function(component, event, helper) {

        if (helper.validateClient(component)) {

            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;

            component.set("v.post", "#employment");
            //helper.createExpense(component, Loan, id);
            var client = component.get("v.newclient");
            helper.createClient(component, client, Loan);

            document.getElementById("l3").classList.remove("active");
            document.getElementById("l4").classList.toggle("active");
            window.scrollTo(0, 0);
        }

    },


    Emp_Prev: function(component) {

        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l4").classList.remove("active");
        document.getElementById("l3").classList.toggle("active");
        window.scrollTo(0, 0);
        //alert(a);
    },


    Emp_Next: function(component, event, helper) {

        if (helper.validateEmp(component)) {
            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;
            helper.createExpense(component, Loan, id);
            component.set("v.post", "#income");
            document.getElementById("l4").classList.remove("active");
            document.getElementById("l5").classList.toggle("active");
            window.scrollTo(0, 0);
        }
    },


    Income_Prev: function(component) {

        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l5").classList.remove("active");
        document.getElementById("l4").classList.toggle("active");
        window.scrollTo(0, 0);
        //alert(a);
    },


    Income_Next: function(component, event, helper) {
        if (helper.validateInc(component)) {
            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;
            helper.createExpense(component, Loan, id);
            component.set("v.post", "#assets");
            document.getElementById("l5").classList.remove("active");
            document.getElementById("l6").classList.toggle("active");
            window.scrollTo(0, 0);
        }
    },


    Assets_Prev: function(component) {

        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l6").classList.remove("active");
        document.getElementById("l5").classList.toggle("active");
        //alert(a);
        window.scrollTo(0, 0);
    },


    Assets_Next: function(component, event, helper) {



        if (helper.validateAsset(component)) {
            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;
            component.set("v.post", '#liabilities');
            helper.createExpense(component, Loan, id);

            document.getElementById("l6").classList.remove("active");
            document.getElementById("l7").classList.toggle("active");
            window.scrollTo(0, 0);
        }
    },


    Liab_Prev: function(component) {

        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l7").classList.remove("active");
        document.getElementById("l6").classList.toggle("active");
        window.scrollTo(0, 0);
        //alert(a);
    },


    Liab_Next: function(component, event, helper) {

        if (helper.validateLiab(component)) {
            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;
            component.set("v.post", "#declarations");
            helper.createExpense(component, Loan, id);
            document.getElementById("l7").classList.remove("active");
            document.getElementById("l8").classList.toggle("active");
            window.scrollTo(0, 0);
        }
        //alert(a);
    },


    Dec_Prev: function(component) {

        // var a  = document.getElementById("Loan_div").getAttribute("name");
        // var b = "l2";
        document.getElementById("l8").classList.remove("active");
        document.getElementById("l7").classList.toggle("active");
        window.scrollTo(0, 0);
        //alert(a);
    },


    click_step1: function(component) {

        document.getElementById("p2").classList.remove("in");
        //document.getElementById("Loan").classList.toggle("active");
        document.getElementById("l1").classList.add("active");
        document.getElementById("l2").classList.remove("active");
        document.getElementById("l3").classList.remove("active");
        document.getElementById("l4").classList.remove("active");
        document.getElementById("l5").classList.remove("active");
        document.getElementById("l6").classList.remove("active");
        document.getElementById("l7").classList.remove("active");
        document.getElementById("l8").classList.remove("active");
        document.getElementById("l9").classList.remove("active");
        document.getElementById("l10").classList.remove("active");
        document.getElementById("Loan").classList.add("active", "in");
        document.getElementById("subject").classList.remove("active", "in");
        document.getElementById("client").classList.remove("active", "in");
        document.getElementById("income").classList.remove("active", "in");
        document.getElementById("employment").classList.remove("active", "in");
        document.getElementById("assets").classList.remove("active", "in");
        document.getElementById("declarations").classList.remove("active", "in");
        document.getElementById("liabilities").classList.remove("active", "in");
        document.getElementById("LoanDetails").classList.remove("active", "in");
        document.getElementById("CreditInfo").classList.remove("active", "in");
        window.scrollTo(0, 0);

        //document.getElementById("p3").classList.remove("in");


    },

    click_step2: function(component) {

        document.getElementById("p1").classList.remove("in");
        //document.getElementById("p3").classList.remove("in");
        document.getElementById("l1").classList.remove("active");
        document.getElementById("l2").classList.remove("active");
        document.getElementById("l3").classList.remove("active");
        document.getElementById("l4").classList.remove("active");
        document.getElementById("l5").classList.remove("active");
        document.getElementById("l6").classList.remove("active");
        document.getElementById("l7").classList.remove("active");
        document.getElementById("l8").classList.remove("active");
        document.getElementById("l9").classList.add("active");
        document.getElementById("l10").classList.remove("active");
        document.getElementById("Loan").classList.remove("active", "in");
        document.getElementById("subject").classList.remove("active", "in");
        document.getElementById("client").classList.remove("active", "in");
        document.getElementById("income").classList.remove("active", "in");
        document.getElementById("employment").classList.remove("active", "in");
        document.getElementById("assets").classList.remove("active", "in");
        document.getElementById("declarations").classList.remove("active", "in");
        document.getElementById("liabilities").classList.remove("active", "in");
        document.getElementById("LoanDetails").classList.add("active", "in");
        document.getElementById("CreditInfo").classList.remove("active", "in");
        window.scrollTo(0, 0);

    },
    click_step3: function(component) {

        document.getElementById("p2").classList.remove("in");
        document.getElementById("p1").classList.remove("in");

    },

    ssn_validate: function(component) {
        document.getElementById("SSNError").innerHTML = '';
        var s = document.getElementById("ClientSSN").value;
        var m = s.length;

        if (m == 3) {
            var t = s.substring(0, 3);
            var ssn = t + '-';
            document.getElementById("ClientSSN").value = ssn;

        }
        if (m == 6) {
            var t1 = s.substring(0, 6);
            var ssn1 = t1 + '-';
            document.getElementById("ClientSSN").value = ssn1;
        }



    },

    ssn_validate_change: function(component) {

        var ssn = document.getElementById("ClientSSN").value
        var regVal = /[0-9]{3}-[0-9]{2}-[0-9]{4}/

        if (!ssn.match(regVal)) {
            //component.set("v.val","Please enter a valid SSN number")
            document.getElementById("SSNError").classList.add("errorclr");
            document.getElementById("SSNError").innerHTML = 'Please enter a valid SSN number';

        }

    },

    Submit: function(component, event, helper) {
        if (helper.validateDec(component)) {
            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;
            component.set("v.post", "#LoanDetails");
            // helper.createExpense(component, Loan, id);

            document.getElementById("p1").classList.remove("in");
            document.getElementById("p2").classList.add("in");
            document.getElementById("l8").classList.remove("active");
            document.getElementById("l9").classList.toggle("active");
            window.scrollTo(0, 0);
        }
    },

    NBS: function(component) {
        var NBS = document.getElementById('NBS').value;
        component.set("v.client_borrowering_spouse", NBS);

    },

    NBR: function(component) {
        var NBR = document.getElementById('NBR').value;
        component.set("v.client_borrowering_resident", NBR);
    },

    divLoad: function(component) {
        window.scrollTo(0, 0);


    },

    phoneValidations: function(component, event, helper) {

        var phn = event.target.id;
        //alert(phn);
        var phone = document.getElementById(phn).value;
        //alert(phone);
        var regVal = /[1-9]{1}[0-9]{9}/;
        var err = phn + 'err';
        //alert(err);
        // [1-9]{1}[0-9]{2}) [0-9]{3}-[0-9]{4}
        //document.getElementById(err).classList.remove("errorclr");
        document.getElementById(err).innerHTML = '';

        if (!phone.match(regVal)) {
            // alert("true");//component.set("v.val","Please enter a valid SSN number")
            document.getElementById(err).classList.add("errorclr");
            document.getElementById(err).innerHTML = 'Please enter a valid phone number';
        } else {
            //alert(phone);
            helper.phoneFormat(component, phone, phn);

        }

    },

    Loandetail_Next: function(component, event, helper) {

        if (helper.validateLoandetails(component)) {
            var Loan = component.get("v.newloan");
            var id = document.getElementById("id").value;
            component.set("v.post", "#CreditInfo");
            helper.createExpense(component, Loan, id);

            document.getElementById("l9").classList.remove("active");
            document.getElementById("l10").classList.toggle("active");
            window.scrollTo(0, 0);
        }

    },

    Loandetail_Prev: function(component, event, helper) {
        document.getElementById("p1").classList.add("in");
        document.getElementById("p2").classList.remove("in");
        document.getElementById("l9").classList.remove("active");
        document.getElementById("l8").classList.toggle("active");
        window.scrollTo(0, 0);


    },

    LoanDetails: function(component) {
        // alert("in loan details");
        var LDTS = document.getElementById('LoanDetailsTitleSource').value;
        //alert(LDTS);
        component.set("v.Loan_Details", LDTS);
        var a = component.get("v.Loan_Details");
        //alert(a);

    },

    NewCredit: function(component) {
        // alert("in loan details");
        var LDTS = document.getElementById('CreditPullNew').value;
        //alert(LDTS);
        component.set("v.PullNewCredit", LDTS);
        var a = component.get("v.Loan_Details");
        //alert(a);

    },

    ReIssueCredit: function(component) {
        // alert("in loan details");
        var LDTS = document.getElementById('CreditReissue').value;
        component.set("v.ReIssueCredit", LDTS);
        var a = component.get("v.Loan_Details");
    },

    ReferenceValidate: function(component) {
        var CRN = document.getElementById('CreditReferenceNumber').value;

        var regVal = /[0-9]{15}/;

        document.getElementById('CRNValerr').innerHTML = '';

        if (!CRN.match(regVal)) {
            // alert("true");//component.set("v.val","Please enter a valid SSN number")
            document.getElementById('CRNValerr').classList.add("errorclr");
            document.getElementById('CRNValerr').innerHTML = 'Please enter a valid Credit Reference Number';
        }

    },

    ReferenceCheck: function(component) {
        var CRN = document.getElementById('CreditReferenceNumber').value;
        var CRNC = document.getElementById('CreditReferenceNumberConfirm').value;

        //var regVal = /[0-9]{15}/;

        document.getElementById('CRNerr').innerHTML = '';

        if (CRN != CRNC) {
            // alert("true");//component.set("v.val","Please enter a valid SSN number")
            document.getElementById('CRNerr').classList.add("errorclr");
            document.getElementById('CRNerr').innerHTML = 'Credit Reference Number not matching.';
        }

    },

    CreditSubmit: function(component, event, helper) {

        var CR = component.get("v.ReIssueCredit");


        if (CR == "true") {

            var CRN = document.getElementById('CRNerr').innerHTML;

            var CRNC = document.getElementById('CRNValerr').innerHTML;

            if ($A.util.isEmpty(CRN) || $A.util.isEmpty(CRNC)) {
                if (helper.validateCreditInfo(component)) {
                    var Loan = component.get("v.newloan");
                    var id = document.getElementById("id").value;
                    //component.set("v.post","#CreditInfo");
                    helper.createExpense(component, Loan, id);
                    var id = component.get("v.LoanId");
                    helper.LoanCompletechk(component, id);

                    window.scrollTo(0, 0);
                }
            }
        }

    },

    CreditPrevious: function(component, event, helper) {

        document.getElementById("l10").classList.remove("active");
        document.getElementById("l9").classList.toggle("active");
        window.scrollTo(0, 0);


    },


    keyPressController: function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component, event, getInputkeyWord);
        } else {
            component.set("v.listOfSearchRecords", null);
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }

    },
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent: function(component, event, helper) {

        // get the selected Account record from the COMPONETN event      
        var selectedAccountGetFromEvent = event.getParam("accountByEvent");

        component.set("v.selectedRecord", selectedAccountGetFromEvent);

        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');


        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');

    },
    // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner: function(component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible: false });
        evt.fire();
    },
    // automatically call when the component is waiting for a response to a server request.
    showSpinner: function(component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible: true });
        evt.fire();
    },

    //Clearing the client data
    clear: function(component, event, heplper) {
        var txtidControl = component.find("secret");
        txtidControl.set("v.value", "");

        var commentsControl = component.find("secret");
        var commentsControlvalue = commentsControl.get("v.value");
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField");

        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');

        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');

        component.set("v.SearchKeyWord", null);
        component.set("v.listOfSearchRecords", null);
        if (commentsControlvalue == '') {

            var newselectedRecord = {
                'sobjectType': 'ClientInfo__c',
                'Name': '',
                'Last_Name__c': '',
                'Street_Address__c': '',
                'State__c': '',
                'Street_Address__c': '',
                'Zip__c': '',
                'Email_Optional__c': '',
                'Phone_Number__c': '',
                'DOB__c': ''
            };
            //resetting the Values in the form
            component.set("v.selectedRecord", newselectedRecord);
            console.log("aaa");


        }

    },

    validateZip: function(component, event, helper) {
        var inz = component.get('v.selectedRecord.Zip__c');
        if (isNaN(inz)) {
            component.set('v.selectedRecord.Zip__c', inz.substring(0, inz.length - inz.length));
            component.set("v.ErrorMsg", "");
        }
    },

    validatePhone: function(component, event, helper) {
        var inp = component.get('v.selectedRecord.Phone_Number__c');
        if (isNaN(inp)) {
            component.set('v.selectedRecord.Phone_Number__c', inp.substring(0, inp.length - inp.length));
            component.set("v.ErrorMsg", "");
        }
    },

    validateNumber: function(component, event, helper) {
        var num = event.target.id;
        var today = new Date();

        var yyyy = today.getFullYear();


        var err = num + 'err';
        var inz = document.getElementById(num).value;

        document.getElementById(err).innerHTML = '';

        if (isNaN(inz)) {
            document.getElementById(err).classList.add("errorclr");
            document.getElementById(err).innerHTML = 'Please enter a valid number';
        } else {
            if (parseInt(inz) <= 0) {
                document.getElementById(err).classList.add("errorclr");
                document.getElementById(err).innerHTML = 'Value should always be equal to or greater than 0';
                document.getElementById(num).value = '';
            }
            if (num == "SubjectPropertyYearBuilt") {
                if (parseInt(inz) <= 0) {
                    document.getElementById(err).classList.add("errorclr");
                    document.getElementById(err).innerHTML = 'Value should always be equal to or greater than 0';
                    document.getElementById(num).value = '';
                } else {
                    if (parseInt(inz) > yyyy) {
                        document.getElementById(err).classList.add("errorclr");
                        document.getElementById(err).innerHTML = 'Year Should not be more than current year';
                        document.getElementById(num).value = '';

                    }
                }
            }

        }



    },

    DateValidation: function(component, event, helper) {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();

        if (mm < 9) {
            mm = '0' + mm;
        }

        if (dd < 9) {
            dd = '0' + dd;
        }
        var today_date = yyyy + mm + dd;
        //alert("today year: " + yyyy);
        var dt = event.target.id;
        var err = dt + 'err';
        //alert(err);

        document.getElementById(err).innerHTML = '';




        var getdate = document.getElementById(dt).value;
        var d = getdate.indexOf("-");
        //alert(d);

        var year = getdate.substring(0, d);
        var month = getdate.substring(d + 1, d + 3);
        var day = getdate.substring(d + 4, d + 6);
        getdate = year + month + day;
        //alert(getdate);
        if (parseInt(getdate) > 99991231) {
            document.getElementById(err).innerHTML = "Date cannot be greater than 12/31/9999";
            document.getElementById(err).classList.add("errorclr");
            document.getElementById(dt).value = '';
        }


        if (dt == "ClientDOB") {
            //alert(today_date);
            if (parseInt(today_date) < parseInt(getdate)) {
                document.getElementById(err).innerHTML = "Date of Birth cannot be greater than today";
                document.getElementById(err).classList.add("errorclr");
                document.getElementById(dt).value = '';
            }
        }

    },

    validateEmail: function(component, event, helper) {
        document.getElementById('inputEmailerr').innerHTML = '';
        var reg = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var email = component.find("inputEmail").get("v.value");

        if (!email.match(reg)) {
            // alert("true");//component.set("v.val","Please enter a valid SSN number")
            document.getElementById('inputEmailerr').classList.add("errorclr");
            document.getElementById('inputEmailerr').innerHTML = 'Please enter a valid email address';
            component.find("inputEmail").set("v.value", '');
        }
    }

})