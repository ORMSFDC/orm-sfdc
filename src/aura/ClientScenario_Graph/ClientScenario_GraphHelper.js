({
    //Pie Graph Populate
    hlperscriptsLoaded: function (component, event, helper) {
        //    component.set("v.IsSpinner",true);

        var lienAmount = 0;//prsn
        var evh = 0;
        var financingFees = 0;
        var insuranceFees = 0;
        var equityReserves = 0;
        var cashAtClose = 0;
        var lineOfCredit = 0;

        var i, j = "",
            x = "",
            y = "",
            z = "";
        var myObj = '';
        var myObjCF = '';
        var finalHome = '';
        var ynewStr = '';
        var cashflowdata = '';
        var currdate = new Date();
        // debugger;
        var ScenarioIDis = component.get("v.ScenarioID");
        //   alert('getScenarioData ---> ' + getScenarioData);
        var action = component.get("c.getScenarioData");
        //  alert('ScenarioID '+ScenarioID);
        action.setParams({
            "ScenarioID": ScenarioIDis
        });
        action.setCallback(this, function (a) {
            var result = a.getReturnValue();
            var jdata = result.PieChartResponse__c;
            console.log('jdata ', jdata);
            if (jdata == '' || jdata == undefined) {
                //alert(result.Scenario_Type__c);
                //hecm
                if (result.Scenario_Type__c == 'FHA Traditional HECM') {
                    component.set('v.isTraditional', true);

                } else {
                    component.set('v.isTraditional', false);

                }
            }
            if (jdata == '' || jdata == undefined) {
                component.set('v.isOldScenario', false);
                component.set('v.ScenarioType', result.Scenario_Type__c);
                //hecm
                if (result.Scenario_Type__c == 'FHA Traditional HECM') {

                    component.set('v.LMortgageAppliedFor', 'FHA Traditional HECM');
                } else {
                    component.set('v.LMortgageAppliedFor', 'HECM for Purchase');
                }
                //alert(result.RateType__c);
                if (result.RateType__c == 'Adjust') {
                    component.set('v.LRateType', 'ARM');
                    component.set('v.MarginIs', 'Margin');
                } else if (result.RateType__c == 'Fixed') { //Helo Fix
                    component.set('v.MarginIs', 'Rate');
                    component.set('v.LRateType', 'Fixed');
                }
                else if(result.RateType__c == 'Helo'){ //Helo Fix
                    component.set('v.MarginIs', 'Rate');
                    component.set('v.LRateType', 'Helo');
                }
                else{
                    component.set('v.MarginIs', 'Rate');
                    component.set('v.LRateType', 'HeloArm');                    
                }

                //alert(component.get('v.ScenarioType'));
                component.set('v.CF1MA', result.CashFlow1__c);

                component.set('v.CF5MA', result.CashFlow5__c);

                component.set('v.CF10MA', result.CashFlow10__c);

                component.set("v.FirstAmount", result.Cash_at_close__c);
                component.set('v.cashToClose', result.Cash_at_close__c);
                component.set('v.Cash_to_close', result.Cash_to_close__c);
            } else {
                component.set('v.isOldScenario', true);
                component.set('v.CF1MA', result.CashFlow1__c);

            }
            // alert('1234');
            lineOfCredit = result.Line_of_Credit__c;//prsn
            component.set("v.isConveted", result.is_Converted__c);
            //  alert();
            //       console.log('jdata is ',jdata);
            if (jdata != '' && jdata != undefined) {

                component.set("{!v.apr_is}", JSON.parse(jdata).apr);
                component.set("{!v.libor}", JSON.parse(jdata).annualLiborChangeDate);
                cashAtClose = JSON.parse(jdata).maxCash;
            } else {
                cashAtClose = parseInt(result.Cash_at_close__c);

            }

            var mydate = new Date(result.Date_of_birth__c);
            //  alert(mydate);            
            var timeDiff = Math.abs(currdate.getTime() - mydate.getTime());
            var diffYr = Math.ceil(timeDiff / (1000 * 3600 * 24 * 365));
            var EhvVal = result.Estimated_home_value__c;
            //Helo Fix
            var lrateType = component.get('v.LRateType');
            var otherEcc = result.Other_Estimated_Closing_Costs__c;
            console.log('Ecc helo', otherEcc);
            var origOrm = result.Origination_to_orm__c;
            console.log('origorm', origOrm);
            //end Helo Fix
            var finalEOF;
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
            if (result.EOF__c != '' && result.EOF__c != null && result.EOF__c != undefined) {
                finalEOF = result.EOF__c;
            }
            console.log('finalEOF is ', finalEOF);

            component.set("v.EOF", finalEOF);
            if (lrateType == 'Helo' || lrateType == 'HeloArm') { //Helo, Financing Fee for Pie
                component.set("v.EOF",origOrm); //Helo Origination to ORM 8/2
                financingFees = origOrm + otherEcc;
                console.log('helo finfee', financingFees);
            }
            else {
                financingFees = (Math.round(finalEOF * 100) / 100) + 2500;
                console.log('other finfee', financingFees);
            }
            component.set("v.Ageminus1", result.Age__c); //SFDC - 380
            component.set("v.EHV", result.Estimated_home_value__c);
            component.set("v.OECC", otherEcc); //Helo fix

            component.set("v.CMB", result.Current_Mortgage_Balance__c);
            component.set("v.CMIR", result.Current_Mortgage_Interest_Rate__c);
            component.set("v.MMP", result.Monthly_Mortgage_Payment__c);
            cashflowdata = result.BarChartResponse__c;
            if (jdata == '' || jdata == undefined) {

                myObj = {};//JSON.parse(jdata);
            } else {
                myObj = JSON.parse(jdata);

            }
            //  alert('c');
            //Pie Graph
            document.getElementById("GRAs").style.display = "BLOCK";
            //document.getElementById("clientdiv").style.display = "BLOCK";
            document.getElementById("CashFlows").style.display = "BLOCK";
            document.getElementById("LOCandCashFlows").style.display = "BLOCK";
            component.set("v.Index", result.Index__c);//myObj.annualLibor);
            component.set("v.Margin", result.Margin__c);// myObj.lendersMargin);
            component.set("v.MIP", result.MIP__c);
            insuranceFees = result.MIP__c; //prsn
            insuranceFees = (Math.round(insuranceFees * 100) / 100);
            component.set("v.TotalAmountAvailable", result.Principal_Limit__c);
            // component.set("v.IGR", myObj.growthRateInitial);
            // component.set("v.AGR", myObj.growthRateAverage10yr);
            component.set("v.RESTError", '');
            if (jdata != '' && jdata != undefined) {

                component.set("v.cashToClose", myObj.cashToClose);
            } else {
                //   alert('cac '+result.Cash_at_close__c);//

                component.set("v.cashToClose", result.Cash_at_close__c);
            }
            var eh = parseInt(component.get("v.EHV"));
            //   alert('eh ',eh);
            var mmb = parseInt(component.get("v.CMB"));
            // alert('mmb ',mmb);
            var result = (2 / 100) * eh;
            // var evh =result.Estimated_home_value__c;
            var evh = eh;
            equityReserves = eh;
            equityReserves = (Math.round(eh * 100) / 100);
            component.set("v.EstimatedClosingCosts", result);
            for (i in myObj.terms) {
                //   alert(i);
                if (i == 0) {
                    var FirstAmount = parseInt(myObj.terms[i].loc);
                    lienAmount = FirstAmount;
                    lienAmount = (Math.round(lienAmount * 100) / 100);
                    var eh = parseInt(component.get("v.CMB"));
                    //  component.set("v.FirstAmount", myObj.terms[i].loc)
                    //component.set("v.FirstAmount", lineOfCredit)                    

                    var TotalAmountAvailable = FirstAmount + eh;

                }
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
            for (i = 0; i < strArr.length; i++)
                intArr.push(parseInt(strArr[i]));
            finalHome = '{"Home Value($)":[' + jnewStr + '],"Line of Credit($)":[' + znewStr + '],"Mortgage Balance($)":[' + xnewStr + ']}';
            //alert('finalHome--->'+finalHome);
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

            var ctx = component.find("chart").getElement();
            console.log('ctx ', ctx);
            //   alert('cashAtClose ',cashAtClose);
            console.log(' mmb, insuranceFees, financingFees,equityReserves, cashAtClose,  lineOfCredit ', mmb, insuranceFees, financingFees, equityReserves, cashAtClose, lineOfCredit);
            var scenType = component.get('v.ScenarioType');
            console.log('scenar type', scenType);
            var p = $("#LOCandCashFlows");
            var offset = p.offset();
            var yaxis = offset.top - 200;
            window.scroll(0, yaxis);
            //Helo Fix start
            var labelchange = [];
            if (component.get('v.ScenarioType') == 'FHA Traditional HECM') { //refinance

                if (lrateType == 'Helo' ) { //Equity Reserve for Piegraph
                    equityReserves = EhvVal - (origOrm + otherEcc) - component.get('v.FirstAmount');
                }
                else if(lrateType == 'HeloArm'){
                    equityReserves = EhvVal - mmb - origOrm - otherEcc - cashAtClose;
                } 
                else {

                    if ((equityReserves - (insuranceFees + lineOfCredit + financingFees + cashAtClose + mmb)) < 0) {
                        equityReserves = 0;
                    } else {
                        equityReserves = (equityReserves - (insuranceFees + lineOfCredit + financingFees + cashAtClose + mmb));
                    }
                }

                labelchange = [
                    'Current Mortgage Balance',
                    'Insurance Fees',
                    'Financing Fees',
                    'Equity Reserves',
                    'Cash At Close',
                    'Line of Credit'
                ];
            } else { //purchase
                equityReserves = 0;
                cashAtClose = component.get('v.TotalAmountAvailable'); //Loan Amount for Purchase pie graph

                labelchange = [
                    'Current Mortgage Balance',
                    'Insurance Fees',
                    'Financing Fees',
                    'Equity Reserves',
                    'Loan Amount',
                    'Down Payment'
                ];
            }
            //Helo Fix End

            var chart = new Chart(ctx, {
                type: 'pie',

                data: {
                    datasets: [{
                        data: [mmb, insuranceFees, financingFees, equityReserves, cashAtClose, lineOfCredit],
                        backgroundColor: ['#FF9B00', '#B5121B', '#0C4569', '#2081BF', '#ffce56', '#6C9F2E']
                    }],
                    // These labels appear in the legend and in the tooltips when hovering different arcs
                    labels: labelchange
                },

                showDatapoints: true,
                options: {
                    tooltips: {
                        enabled: true
                    },
                    pieceLabel: {
                        render: function (args) { return '$' + args.value.toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); },
                        position: 'outside',
                        fontColor: '#000',
                    },
                    responsive: true,
                    maintainAspectRatio: false,
                    legend: {
                        position: 'top',
                    },
                    animation: {
                        animateScale: true,
                        animateRotate: true
                    }
                }

            });
            console.log('chart ', chart);
            //end Pie Graph
            //Error MEssage
            if (Object.values(myObj.errorMessages) != "") {
            }

            var mipIs = component.get("v.MIP") ? component.get("v.MIP") : 0;
            var firstAmt = component.get("v.TotalAmountAvailable") - component.get("v.CMB") - mipIs - component.get("v.EOF") - 2500;
            if (firstAmt < 0) {
                firstAmt = 0;
            }
            component.set("v.FirstAmount", firstAmt);
            this.cshflow(component, event, helper, cashflowdata);
        });
        $A.enqueueAction(action);
    },
    
    //SFDC - 360
    helperMethod : function(component,loanid,senarioid) {        
	var action = component.get("c.updateSenario");
        action.setParams({
    		senarioid:senarioid,
		loanId:loanid
        });        
        action.setCallback(this,function(data){       
        });
        $A.enqueueAction(action);       
    }, 
    
    //Cash Flow Graph
    cshflow: function (component, event, helper, cashflowdata) {
        var jdata = cashflowdata;
        debugger;
        var myObjCF = JSON.parse(jdata);
        if (myObjCF) {

            if (Object.values(myObjCF.errorMessages) != "") {
                document.getElementById("CashFlowTable").style.display = "None";
                /*    document.getElementById("GRAs").style.display = "None";
            document.getElementById("CashFlows").style.display = "None";   */
            }
            var i1, k, j1 = "",
                v1 = "",
                x1 = "",
                y1 = "",
                z1 = "";
            var monthlyPyment = myObjCF.monthlyPayment;
            var months = ['1 Year']
            var bar = [monthlyPyment * 12];
            component.set("v.CF12MA", monthlyPyment * 12);
            var MonthTerm = myObjCF.terms;
            if (MonthTerm < 60) {
                var m = (MonthTerm / 12).toFixed(1);
                component.set("v.secMN", m);
                months.push(m + ' Years');
                for (k in myObjCF.termCashFlowList) {
                    if (MonthTerm == myObjCF.termCashFlowList[k].month) {
                        bar.push(myObjCF.termCashFlowList[k].accumulatedSavings);
                        //       alert('1 '+ myObjCF.termCashFlowList[k].accumulatedSavings);
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
                        //  alert('2 '+ myObjCF.termCashFlowList[k].accumulatedSavings);
                        component.set("v.CF60MA", myObjCF.termCashFlowList[k].accumulatedSavings);
                    }
                    if (MonthTerm == myObjCF.termCashFlowList[k].month) {
                        bar.push(myObjCF.termCashFlowList[k].accumulatedSavings);
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
            var ctx1 = component.find("chart1").getElement();
            var chart1 = new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: months,
                    datasets: [{
                        label: 'Cashflow($)',
                        data: bar,
                        backgroundColor: [
                            '#ff6384', '#36a2eb', "#000080"
                        ]
                    }]
                },
                options: {
                    animation: {
                        duration: 1,
                        onComplete: function () {
                            var chartInstance = this.chart,
                                ctx1 = chartInstance.ctx;
                            ctx1.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize,
                                Chart.defaults.global.defaultFontStyle,
                                Chart.defaults.global.defaultFontFamily);
                            ctx1.textAlign = 'center';
                            ctx1.textBaseline = 'bottom';
                            this.data.datasets.forEach(function (dataset, i) {
                                var meta = chartInstance.controller.getDatasetMeta(i);
                                meta.data.forEach(function (bar, index) {
                                    var data = dataset.data[index];
                                    ctx1.fillText("$" + data, bar._model.x, bar._model.y - 5);
                                });
                            });
                        }
                    },
                    legend: {
                        display: false
                    },
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                userCallback: function (value, index, values) {
                                    // Convert the number to a string and splite the string every 3 charaters from the end
                                    value = value.toString();
                                    //value = value.split(/(?=(?:..)*$)/);

                                    // Convert the array to a string and format the output
                                    //value = value.join('.');
                                    return '$' + value;
                                }
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Cashflow',

                            }
                        }]
                    }
                }
            });

            var p = $("#LOCandCashFlows");
            var offset = p.offset();
            var yaxis = offset.top - 200;
            window.scroll(0, yaxis);

            component.set("v.IsSpinner", false);
        }

    },
    //end cashflow

})