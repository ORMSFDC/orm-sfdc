({
    //Client Search
    searchHelper: function (component, event, getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchAccount");
        // set param to method  
        console.log('getInputkeyWord ', getInputkeyWord);
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse ', storeResponse);
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
    //Pie Graph Populate
    hlperscriptsLoaded: function (component, event, helper, almis, lien) {
        //CashFlow Method called 
        //this.do_margins_call(component, event, helper);
        component.set("v.IsSpinner", true);
        // alert('lien--->'+lien);
        var selectedMargin = component.get("v.Margins")[parseInt(component.get("v.Scenarioindex"))];//prsn
        console.log('selectedMargin---helper--->', selectedMargin.initialPrincipalLimit);
        console.log('lienAmount---Helper-->' + lienAmount);
        var lienAmount = lien;//prsn
        // alert('lienAmount--->'+lienAmount);
        var eof = component.get("v.EOF");
        var financingFees = Math.round((2500 + eof));
        var insuranceFees = 0;
        var equityReserves = 0;
        var cashAtClose = Math.round(selectedMargin.maxCashFirstYear);//prsn
        var lineOfCredit = Math.round(selectedMargin.initialLOC);//prsn

        var i, j = "",
            x = "",
            y = "",
            z = "";
        var myObj = '';
        var myObjCF = '';
        var finalHome = '';
        var ynewStr = '';
        var DobVal = component.get("v.DOB");
        // alert(DobVal);
        var EhvVal = component.get("v.EHV");
        var CmbVal = component.get("v.CMB");
        var CFYVal = component.get("v.CFY");
        //alert('helper CFYVal---'+CFYval);
        var CmirVal = component.get("v.CMIR");
        var MmpVal = component.get("v.MMP");
        var currdate = new Date();
        var mydate = new Date(DobVal);
        var timeDiff = Math.abs(currdate.getTime() - mydate.getTime());
        var diffYr = Math.ceil(timeDiff / (1000 * 3600 * 24 * 365));
        component.set("v.Ageminus1", diffYr - 1);
        component.set("v.AgeAfter10", diffYr + 10);
        //alert('CFY value--->'+CFYVal);
        var action = component.get("c.getScenarioResponse");
        console.log('almis ', almis);
        action.setParams({
            "DOB": DobVal,
            "hv": EhvVal,
            "mb": CmbVal,
            "CFY": CFYVal,
            "mp": MmpVal,
            "ir": CmirVal,
            "alm": almis
        });
        //   alert('calling action');
        action.setCallback(this, function (a) {
            //    alert('in dynamic');rerender_section
            component.set("v.rerender_section", true);
            //   component.set("v.rerender_chart",true);
            var jdata = a.getReturnValue();
            //    alert('yes');
            console.log('jdata ', jdata);
            component.set("v.PieChartResponse", jdata);

            myObj = JSON.parse(jdata);
            console.log('myObj ', myObj);
            component.set("{!v.apr_is}", myObj.apr);
            component.set("{!v.libor}", myObj.annualLiborChangeDate);
            var PriorityGraph = myObj.priority;
            if (PriorityGraph == 'loc,cashflow') {
                component.set("v.Priority", "LOC And CashFlow");
            }
            else if (PriorityGraph == 'cashflow') {
                component.set("v.Priority", "CashFlow");
            } else {
                component.set("v.Priority", "LOC");
            }
            //Pie Graph
            component.set("v.Index", myObj.annualLibor);
            component.set("v.Margin", myObj.lendersMargin);
            component.set("v.MIP", myObj.upfrontMip);
            insuranceFees = Math.round((myObj.upfrontMip));//prsn
            component.set("v.IGR", myObj.growthRateInitial);
            component.set("v.AGR", myObj.growthRateAverage10yr);
            component.set("v.RESTError", '');
            component.set("v.cashToClose", myObj.cashToClose);
            var eh = parseInt(component.get("v.EHV"));
            equityReserves = Math.round(eh * 100) / 100;//prsn
            var result = (2 / 100) * eh;
            component.set("v.EstimatedClosingCosts", result);
            var EOFis = EhvVal * 0.02;
            var finalEOF;
            //  alert('clientinfocmpController CFYVal-->'+CFYVal);

            debugger;
            if (EOFis < 2500) {

                finalEOF = 2500;
            } else if (EOFis > 6000) {

                finalEOF = 6000;
            } else {

                finalEOF = EOFis;
            }

            /*   alert('CmbVal-->'+CmbVal);
                     alert('EhvVal--->'+finalEOF);
                   alert('selectedMargin.initialPrincipalLimi--->t'+selectedMargin.initialPrincipalLimit);
                   alert('selectedMargin.upfrontMip--->'+selectedMargin.upfrontMip);  */
            var initialP = (selectedMargin.initialPrincipalLimit.replace(',', ''));
            // alert('initialP--->t'+initialP);
            var frontmip = selectedMargin.upfrontMip;
            // alert('frontmip--->t'+frontmip);
            var aalp = (initialP - frontmip - CmbVal - 2500 - finalEOF);
            // alert('aalp-->'+aalp);
            if (aalp < 0) {
                aalp = 0;
            }
            for (i in myObj.terms) {
                if (i == 0) {
                    var FirstAmount = parseInt(myObj.terms[i].loc);
                    var eh = parseInt(component.get("v.CMB"));
                    console.log('myObj.terms[i] ', myObj.terms[i]);
                    // component.set("v.FirstAmount", myObj.terms[i].loc)                    
                    var TotalAmountAvailable = FirstAmount + eh;
                    console.log('TotalAmountAvailable--Helper--FirstAmount + eh -->', TotalAmountAvailable);
                    //    component.set("v.TotalAmountAvailable", TotalAmountAvailable);
                }
                lienAmount = Math.round(lien);//prsn
                component.set("v.FirstAmount", aalp);
                //alert('first amount aalp helper--->'+aalp);


                /* alert('lineOfCredit--->'+lineOfCredit);
                 alert('cashAtClose--->'+cashAtClose);
                 alert('financingFees-->'+financingFees);
                 alert('insuranceFees--->'+insuranceFees);
                 alert('EhvVal--->'+EhvVal);  */
                // alert('123--->'+lienAmount);
                if (i == 10) {
                    component.set("v.TenthAmount", myObj.terms[i].loc)
                }
                x += myObj.terms[i].reverseUPB + ',';
                j += myObj.terms[i].homeValue + ',';
                z += myObj.terms[i].loc + ',';
                y += myObj.terms[i].age + ',';
            }
            var xnewStr = x.substring(0, x.length - 1);
            var jnewStr = j.substring(0, j.length - 1);
            var znewStr = z.substring(0, z.length - 1);
            ynewStr = y.substring(0, y.length - 1);
            var strArr = ynewStr.split(',');
            var intArr = [];
            //  console.log('CmbVal-->',CmbVal);
            //  alert('CmbVal-->'+CmbVal);

            for (i = 0; i < strArr.length; i++) {
                intArr.push(parseInt(strArr[i]));
                //    console.log('strArr[i] ',strArr[i]);
            }
            finalHome = '{"Home Value($) ":[' + jnewStr + '],"Line of Credit($) ":[' + znewStr + '],"Mortgage Balance($) ":[' + xnewStr + ']}';
            var colors = [
                "#000080",
                "#00CED1",
                "#B22222"
            ];
            var labels = intArr;
            var datasets = [];
            var terms = {};
            var terms1 = JSON.parse(finalHome);
            var dt = datasets;
            var i = 0;
            for (var key in terms1) {
                //  console.log('key ',terms1[key]);
                datasets.push({
                    label: key,
                    data: terms1[key],
                    fill: false,
                    borderWidth: 1.5,
                    backgroundColor: colors[i],
                    borderColor: colors[i],
                    pointBackgroundColor: "#FFFFFF",
                    pointBorderWidth: 4,
                    pointHoverRadius: 2,
                    pointRadius: 1,
                    pointHitRadius: 10,
                });
                i++;
            }
            //  console.log('datasets >>>>>',datasets);
            //   component.set("v.data_is",datasets)
            //create graph logic
            $A.createComponent(
                "c:DynamicLineChartCMP",
                {
                    "labels": labels,
                    //"datasets":datasets
                    // "datasets": [CmbVal,insuranceFees, (EhvVal -(insuranceFees + lineOfCredit + financingFees+cashAtClose+CmbVal )), cashAtClose, financingFees, lineOfCredit]
                    "datasets": [CmbVal, insuranceFees, financingFees, (EhvVal - (insuranceFees + lineOfCredit + financingFees + cashAtClose + CmbVal)), cashAtClose, lineOfCredit]
                },
                function (newChartComp, status, errorMessage) {
                    if (status == "SUCCESS") {
                        var body = component.get("v.body");
                        body.pop();
                        body.push(newChartComp);
                        component.set("v.body", body);
                        console.log('test  body ', body);
                        component.set("v.IsSpinner", false);
                        document.getElementById("GRA").style.display = "BLOCK";
                        document.getElementById("clientdiv").style.display = "BLOCK";
                        document.getElementById("CashFlow").style.display = "BLOCK";
                        document.getElementById("LOCandCashFlow").style.display = "BLOCK";
                    }
                }
            );
            //end of create graph logic
            //end Pie Graph
            //Error MEssage
            if (Object.values(myObj.errorMessages) != "") {
                /*        var p = myObj.errorMessages;
                        var errormessage = '<html><body>';
                        for (var key in p) {
                            if (p.hasOwnProperty(key)) {
                                errormessage += '<span style="color:red !important">*' + p[key] + '</span><br></br>';
                                //console.log(key + " -> " + p[key]);
                            }
                        }
                        errormessage+='<span style="color:red !important">*Please call your account executive to review your scenario.</span><br></br>'
                        component.set("v.RESTError", errormessage);  */
                this.cshflow(component, event, helper);
            }
            //End Error MEssage
            this.cshflow(component, event, helper);
        });

        $A.enqueueAction(action);




    },
    //Cash Flow Graph
    cshflow: function (component, event, helper) {
        var CmbVal = component.get("v.CMB");
        var CmirVal = component.get("v.CMIR");
        var MmpVal = component.get("v.MMP");
        var action1 = component.get("c.getScenarioCashFlowResponse");
        action1.setParams({
            "mb": CmbVal,
            "mp": MmpVal,
            "ir": CmirVal
        });
        action1.setCallback(this, function (res) {
            //   alert('cash flow call back ');
            var jdata = res.getReturnValue();
            if (jdata) {
                component.set("v.BarChartResponse", jdata);
                var myObjCF = JSON.parse(jdata);
                console.log('myObjCF cashflow', myObjCF);
                if (Object.values(myObjCF.errorMessages) != "") {
                    /*  document.getElementById("LOCandCashFlow").style.display = "None";
                      document.getElementById("GRA").style.display = "None";*/
                    document.getElementById("CashFlowTable").style.display = "None";
                    /*   document.getElementById("clientdiv").style.display = "None";*/
                }
                var i1, k, j1 = "",
                    v1 = "",
                    x1 = "",
                    y1 = "",
                    z1 = "";
                var monthlyPyment = myObjCF.monthlyPayment;
                var months = ['1 Year']
                var bar = [monthlyPyment * 12];
                debugger;
                component.set("v.CF12MA", monthlyPyment * 12);
                var MonthTerm = myObjCF.terms;
                if (MonthTerm < 60) {
                    var m = (MonthTerm / 12).toFixed(1);
                    component.set("v.secMN", m);
                    months.push(m + ' Years');
                    for (k in myObjCF.termCashFlowList) {
                        if (MonthTerm == myObjCF.termCashFlowList[k].month) {
                            bar.push(myObjCF.termCashFlowList[k].accumulatedSavings);
                            component.set("v.CF60MA", myObjCF.termCashFlowList[k].accumulatedSavings);
                        }
                    }
                } else {
                    for (k in myObjCF.termCashFlowList) {
                        if (60 == myObjCF.termCashFlowList[k].month) {
                            var m = (60 / 12).toFixed(1);
                            component.set("v.secMN", m);
                            months.push(m + ' Years');
                            bar.push(myObjCF.termCashFlowList[k].accumulatedSavings);
                            component.set("v.CF60MA", myObjCF.termCashFlowList[k].accumulatedSavings);
                        }
                        if (MonthTerm == myObjCF.termCashFlowList[k].month) {
                            bar.push(myObjCF.termCashFlowList[k].accumulatedSavings);
                            debugger;
                            component.set("v.CFRMA", myObjCF.termCashFlowList[k].accumulatedSavings);
                            component.set("v.CFRMACF", myObjCF.termCashFlowList[k].accumulatedSavings);


                            var m = (MonthTerm / 12).toFixed(1);
                            months.push(m + ' Years');
                            component.set("v.CFRM", m);
                            component.set("v.CFRMCF", m + ' Years Cash Flow Savings');
                        }
                    }
                }
                var MMPamount = component.get("v.MMP");

                //loadd dynamic Component
                $A.createComponent(
                    "c:DynamicLineCashCMP",
                    {
                        "months": months,
                        "chart": this.chart,
                        "data": component.get("v.data_is"),
                        "bar": bar
                    },
                    function (newChartComp, status, errorMessage) {
                        if (status == "SUCCESS") {
                            var body = component.get("v.dynamic_cash");
                            body.pop();
                            body.push(newChartComp);
                            //  alert();
                            component.set("v.dynamic_cash", body);


                        }
                    }
                );
                // document.getElementById("Backtoloan").style.display = "Block";
                component.set("v.IsSpinner", false);
                this.getProfileName(component, event, helper);
            }
        });
        $A.enqueueAction(action1);
    },
    getProfileName: function (component, event, helper) {
        var action = component.get("c.getLoggedInProfile");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var profile = response.getReturnValue();
                var profileName = component.get("v.profileName");

                if (profile.Name == profileName) {
                    document.getElementById("clientdiv").style.display = "None";
                }
                else {
                    document.getElementById("clientdiv").style.display = "block";
                }
            }
        });
        $A.enqueueAction(action);
    },
    //end cashflow
    //Generic Validation Method
    formatErrorMethod: function (component, regex, msg, aura_id) {
        //Code if button is clicked
        var flag = false;
        for (var i = 0; i < aura_id.length; i++) {
            var inputCmp = component.find(aura_id[i]);
            var value = inputCmp.get("v.value");
            var isValid = false;
            if (typeof regex[i] != "string") {
                isValid = regex[i](value);
            }
            if (isValid) {
                inputCmp.set("v.errors", null);
            } else {
                inputCmp.set("v.errors", [{ message: msg[i] }]);
                flag = true;
            }
        }
        return flag;
    },
    //Validate Zip
    ValidZip: function (component, event, helper, id) {
        var msgZip = '';
        var inputCmp = component.find(id);
        var value = inputCmp.get("v.value");
        var regZip = /(^\d{5}$)|(^\d{5}-\d{4}$)/;
        var isRegZipValid = false;
        if (typeof value == "undefined" || value == null || value == '') {
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
    //Phone NUmber Should Not start with Zero(0).
    RestrictZeroInPhoneFirstTime: function (component, event, helper, compId) {
        var inz = component.get(compId);
        var digit = parseInt(inz[0]);
        if (digit == 0) {
            component.set(compId, inz.substring(0, inz.length - 1));
        }
    },
    //Validate Phone
    FormatPhonehelper: function (component, event, helper) {
        var a = component.find("inputPhone").get("v.value");
        var rxp = new RegExp("^(\\d)\\1{9}$");
        var isRegValid = rxp.test(a);
        if (isRegValid) {
            component.set("v.selectedRecord.Phone_Number__c", '');
        } else {
            var s2 = ("" + a).replace(/\D/g, '');
            var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);
            var result = (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
            component.set("v.selectedRecord.Phone_Number__c", result);
        }
    },
    //Validation- for either enter email or Phone
    EmailOrPhoneRequired: function (component, regex, msg, aura_id) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var flagR = false;
        var EmailInput = component.find("inputEmail");
        var EmailInputValue = EmailInput.get("v.value");
        var PhoneInput = component.find("inputPhone");
        var PhoneInputValue = PhoneInput.get("v.value");
        if ($A.util.isEmpty(EmailInputValue) && $A.util.isEmpty(PhoneInputValue)) {
            flagR = true;
        }
        else {
        }
        return flagR
    },
    //Email Format Validation
    EmailValidation: function (component, regex, msg, aura_id) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var flagR = false;
        var EmailInput = component.find("inputEmail");
        var EmailInputValue = EmailInput.get("v.value");
        if (!$A.util.isEmpty(EmailInputValue) && !EmailInputValue.match(regExpEmailformat)) {
            EmailInput.set("v.errors", [{ message: "Please enter valid email id." }]);
            flagR = true;
        }
        else {
            EmailInput.set("v.errors", null);
        }
        return flagR;
    },
    //Save Scenario
    SaveScenario: function (component, event, helper) {
        // alert('saa');
        var FName, LName, Address, Zip, Phone = '',
            errorlbl, EmailVal = '';
        EmailVal = component.find("inputEmail").get("v.value");
        errorlbl = component.find("ErrorLabel");
        FName = component.find("inputFName").get("v.value");
        LName = component.find("inputLName").get("v.value");
        Address = component.find("inputAddress").get("v.value");
        Zip = component.find("inputZip").get("v.value");
        Phone = component.find("inputPhone").get("v.value");
        var ClientInfoval = component.get("v.selectedRecord");
        var DobVal = component.get("v.DOB");
        var action = component.get("c.SaveScenario");
        var BarChartResponse = component.get("v.BarChartResponse");
        var PieChartResponse = component.get("v.PieChartResponse");
        var selectedMargin = component.get("v.Margins")[parseInt(component.get("v.Scenarioindex"))];//prsn
        var lineOfCredit = Math.round(selectedMargin.initialLOC);
        console.log('lineOfCrediting ---> ', lineOfCredit);
        //alert('PieChartResponse'+PieChartResponse);
        //alert('PieChartResponse'+BarChartResponse);
        console.log('ClientInfoval ', ClientInfoval);
        //alert(component.get("v.TotalAmountAvailable"));
        var ttl_amt = component.get("v.TotalAmountAvailable");//parseFloat( component.get("v.TotalAmountAvailable").replace(',',''));
        // alert(ttl_amt);
        action.setParams({
            "objClient": ClientInfoval,
            "hv": component.get("v.EHV") == '' ? 0.00 : component.get("v.EHV"),
            "Dob": DobVal,
            "HV10yr": component.get("v.TenthAmount") == '' ? 0.00 : component.get("v.TenthAmount"),
            "mb": component.get("v.CMB"),
            "mp": component.get("v.MMP"),
            "ir": component.get("v.CMIR"),
            "Index": component.get("v.Index"),
            "Margin": component.get("v.Margin"),
            "MIP": component.get("v.MIP"),
            "IGR": component.get("v.IGR"),
            "AGR": component.get("v.AGR"),
            "Priority": component.get("v.Priority"),
            "CF12MA": component.get("v.CF12MA") == '' ? 0.00 : component.get("v.CF12MA"),
            "CF60MA": component.get("v.CF60MA") == '' ? 0.00 : component.get("v.CF60MA"),
            "CFRMA": component.get("v.CFRMA") == '' ? 0.00 : component.get("v.CFRMA"),
            "CFRM": component.get("v.CFRM") == '' ? 0.00 : component.get("v.CFRM"),
            "secMN": component.get("v.secMN") == '' ? 0.00 : component.get("v.secMN"),
            "PieChartResponse": PieChartResponse,
            "BarChartResponse": BarChartResponse,
            "P_Limit": ttl_amt == '' ? 0.00 : ttl_amt,
            "lineOfCredit": lineOfCredit == '' ? 0.00 : lineOfCredit
        });
        action.setCallback(this, function (response) {
            var result = response.getReturnValue();
            component.set("v.ScenarioID", result);
            component.set("v.senario_id", result);
            component.set("v.showError", false);
            component.set("v.EmailPhoneMessages", "");
            component.set("v.Messages", "Scenario Saved Successfully");
            component.set("v.showAlert", true);
            document.getElementById("request").style.display = "block";
            document.getElementById("savebtn").style.display = "None";
            component.set("v.selected_record", result);
            console.log('result ', result);
        });
        $A.enqueueAction(action);
    },

    do_margins_call: function (component, event, helper) {
        //  alert();
        var metaDataTableVales = component.get("v.metadatavalues");
        component.set("v.IsSpinner", true);

        //alert('asdf');
        var i, j = "",
            x = "",
            y = "",
            z = "";
        var myObj = '';
        var myObjCF = '';
        var finalHome = '';
        var ynewStr = '';
        var DobVal = component.get("v.DOB");
        var EhvVal = component.get("v.EHV");

        var CmbVal = component.get("v.CMB");
        var CFYVal = component.get("v.CFY");
        //alert('CFY val helper-->'+CFYVal);
        var CmirVal = component.get("v.CMIR");
        var MmpVal = component.get("v.MMP");
        var currdate = new Date();
        var mydate = new Date(DobVal);
        var timeDiff = Math.abs(currdate.getTime() - mydate.getTime());
        var diffYr = Math.ceil(timeDiff / (1000 * 3600 * 24 * 365));
        var action = component.get("c.getScenarioMarginsResponse");
        action.setParams({
            "DOB": DobVal,
            "hv": EhvVal,
            "mb": CmbVal,
            "CFY": CFYVal,
            "mp": MmpVal,
            "ir": CmirVal
        });
        console.log('action ', action);
        action.setCallback(this, function (a) {
            var jdata = a.getReturnValue();
            //   alert(jdata); 
            myObj = JSON.parse(jdata);
            var marginsData = [];
            var pl = [];
            console.log('myObj myObj  ', myObj);

            var EOFis;// = EhvVal *0.02;
            var finalEOF;
            //alert(EhvVal);
            if (EhvVal <= 200000) {
                finalEOF = EhvVal * 0.02;
            } else {
                finalEOF = (200000 * 0.02) + ((EhvVal - 200000) * 0.01);

            }
            if (finalEOF < 2500) {
                finalEOF = 2500;
            } else if (finalEOF > 6000) {

                finalEOF = 6000;
            }

            debugger;

            for (var i = 0; i < myObj.pricingList.length; i++) {
                var eachIs = myObj.pricingList[i];
                var eachMargin = myObj.pricingList[i].lendersMargin;
                var eachpl = myObj.pricingList[i].initialPrincipalLimit;
                var eachloc = myObj.pricingList[i].initialLOC;
                console.log('initial Loc =' + eachloc);//prsn
                var maxCFyear = myObj.pricingList[i].maxCashFirstYear;
                console.log('eachloc ', eachloc, maxCFyear);
                var FinalLoc = eachloc - maxCFyear;
                var eachAmount = myObj.pricingList[i].pricing;
                eachIs.lendersMargin = eachMargin.toFixed(3);
                eachIs.initialPrincipalLimit = eachpl.toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                eachIs.initialLOC = FinalLoc;//.toFixed(2);.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                eachIs.pricing = eachAmount.toFixed(3);


                //UPB Calculation 
                // max cash first year(response) + Upfront MIP(response) + Estimated Origination Fee (we calculate) + Other Estimated Closing Costs(we hardcode at 2500) + Current Mortgage Balance(input)		
                eachIs.initialReverseUPB = (myObj.pricingList[i].maxCashFirstYear + myObj.pricingList[i].upfrontMip + finalEOF + 2500 + CmbVal);
                if (eachIs.initialReverseUPB > parseInt(eachIs.initialPrincipalLimit.replace(',', ''))) {
                    eachIs.initialReverseUPB = parseInt(eachIs.initialPrincipalLimit.replace(',', ''));
                }

                //UPB Calculation ends


                var addingVal = 0;
                try {
                    var loc_calculation_value = metaDataTableVales[myObj.pricingList[i].lendersMargin];
                    debugger;



                    //UTILIZATION logic
                    var utcal = (myObj.pricingList[i].initialReverseUPB / parseInt(eachIs.initialPrincipalLimit.replace(',', ''))) * 100
                    eachIs.utilizationPercent = utcal;
                    //UTILIZATION logic ends



                    var utilizationPercent_round = Math.ceil((utcal) / 10) * 10;
                    if (isNaN(utilizationPercent_round)) {
                        utilizationPercent_round = 0;
                    }
                    addingVal = parseFloat(loc_calculation_value[utilizationPercent_round]);
                    if (isNaN(addingVal)) {
                        addingVal = 0;
                    }
                } catch (err) {
                    console.log('**** in erro *****');
                    console.log(err);
                }

                //Compensation Logic
                eachIs.compensation = finalEOF + (myObj.pricingList[i].initialReverseUPB * ((addingVal - 100) * 0.01));//myObj.pricingList[i].pricing;
                //Compensation Logic Ends

                marginsData.push(eachIs);
            }
            component.set("v.Margins", myObj.pricingList);
            component.set("v.IsSpinner", false);


        });

        $A.enqueueAction(action);

    },
    applyCSS: function (component, event, helper, ControlId) {
        var cmpTotalCapacity = component.find(ControlId);
        $A.util.removeClass(cmpTotalCapacity, 'TextColor_green');
        $A.util.addClass(cmpTotalCapacity, 'TextColor_red');
    },
    optionChanged: function (component, event, helper) {
        var lnId = component.get("v.showLoanId");
        $A.createComponent(
            "c:StartNewLoanProductContainer",

            {
                "ApplicationDate": component.get("v.ApplicationDate"),
                "LoanId": component.get("v.showLoanId"),
                "fromPopup": true
            },
            function (newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
})