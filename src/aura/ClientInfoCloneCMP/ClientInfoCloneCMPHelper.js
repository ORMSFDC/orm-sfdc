({
    //Client Search
    searchHelper: function(component, event, getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchAccount");
        // set param to method  
        console.log('getInputkeyWord ',getInputkeyWord);
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse ',storeResponse);
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
    hlperscriptsLoaded: function(component, event, helper,almis,lien) {  
        //CashFlow Method called 
        component.set("v.IsSpinner",true);
        var selectedMargin = component.get("v.Margin");
        	console.log('selectedmargin',selectedMargin);
        var lienAmount = lien;//prsn
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
        component.set("v.Ageminus1", diffYr-1);
        component.set("v.AgeAfter10", diffYr + 10);
        //alert('CFY value--->'+CFYVal);
        var ADOVal = component.get('v.ADO'); // 300000
        console.log('ADOVal helper  --->', ADOVal); 
        var action = component.get("c.getScenarioResponse");
        console.log('almis ',almis);
        action.setParams({
            "DOB": DobVal,
            "hv": EhvVal,
            "mb": CmbVal,
            "CFY": CFYVal,
            "mp": MmpVal,
            "ir": CmirVal,
            "alm":almis
        });
        //   alert('calling action');
        action.setCallback(this, function(a) {
            //    alert('in dynamic');rerender_section
            component.set("v.rerender_section",true);
            //   component.set("v.rerender_chart",true);
            var jdata = a.getReturnValue();
            //    alert('yes');
            console.log('jdata ',jdata);
            component.set("v.PieChartResponse",jdata);
            
            myObj = JSON.parse(jdata);       
            console.log('myObj ',myObj);
            component.set("{!v.apr_is}",myObj.apr);
            component.set("{!v.libor}",myObj.annualLiborChangeDate);
            var PriorityGraph = myObj.priority;
            if (PriorityGraph == 'loc,cashflow') {                
                component.set("v.Priority", "LOC And CashFlow");
            }
            else if (PriorityGraph == 'cashflow') {
                component.set("v.Priority", "CashFlow");               
            } else {              
                component.set("v.Priority", "LOC");}
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
            equityReserves = Math.round(eh*100) / 100;//prsn
            var result = (2 / 100) * eh;
            component.set("v.EstimatedClosingCosts", result); 
            var EOFis = EhvVal *0.02;
            var finalEOF;
            //  alert('clientinfocmpController CFYVal-->'+CFYVal);
            
            debugger;
            if(EOFis<2500){
                
                finalEOF  = 2500;
            }else if(EOFis>6000) {
                
                finalEOF  = 6000;
            }else{
                
                finalEOF = EOFis;
            }
            
            /*   alert('CmbVal-->'+CmbVal);
                  alert('EhvVal--->'+finalEOF);
                alert('selectedMargin.initialPrincipalLimi--->t'+selectedMargin.initialPrincipalLimit);
                alert('selectedMargin.upfrontMip--->'+selectedMargin.upfrontMip);  */
            var initialP = (selectedMargin.initialPrincipalLimit.replace(',',''));
            // alert('initialP--->t'+initialP);
            var frontmip = selectedMargin.upfrontMip;
            // alert('frontmip--->t'+frontmip);
            var aalp =(initialP-frontmip-CmbVal-2500-finalEOF);
            // alert('aalp-->'+aalp);
            if(aalp<0){
                aalp = 0;
            }
            for (i in myObj.terms) {
                if (i == 0) {
                    var FirstAmount = parseInt(myObj.terms[i].loc);
                    var eh = parseInt(component.get("v.CMB"));   
                    var TotalAmountAvailable = FirstAmount + eh;
                }
                lienAmount = Math.round(lien);//prsn
                component.set("v.FirstAmount",aalp);
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
            
            for (i = 0; i < strArr.length; i++){
                intArr.push(parseInt(strArr[i]));
                //    console.log('strArr[i] ',strArr[i]);
            }
            finalHome = '{"Home Value($) ":[' + jnewStr + '],"Line of Credit($) ":[' + znewStr + '],"Mortgage Balance($) ":[' +  xnewStr + ']}';
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
            //create graph logic
            $A.createComponent(
                "c:DynamicLineChartCMP",
                {
                    "labels": [
                        'Current Mortgage Balance',
                        'Insurance Fees',
                        'Financing Fees',
                        'Equity Reserves',
                        'Cash At Close',
                        'Line of Credit'
                    ],
                    //  "labels": labels,
                    //"datasets":datasets
                    // "datasets": [CmbVal,insuranceFees, (EhvVal -(insuranceFees + lineOfCredit + financingFees+cashAtClose+CmbVal )), cashAtClose, financingFees, lineOfCredit]
                    "datasets": [CmbVal,insuranceFees,financingFees, (EhvVal -(insuranceFees + lineOfCredit + financingFees+cashAtClose+CmbVal )), cashAtClose,  lineOfCredit]
                },
                function(newChartComp, status, errorMessage){
                    if(status == "SUCCESS"){
                        var body = component.get("v.body");
                        body.pop();
                        body.push(newChartComp);
                        component.set("v.body", body);
                        console.log('test  body ',body);
                        component.set("v.IsSpinner",false);
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
                this.cshflow(component,event,helper);
            }
            //End Error MEssage
            this.cshflow(component,event,helper);
        });
        
        $A.enqueueAction(action);        
    },
    
    //Cash Flow Graph
    cshflow: function(component,event,helper)
    {       
        var CmbVal = component.get("v.CMB");
        var CmirVal = component.get("v.CMIR");
        var MmpVal = component.get("v.MMP");
        var action1 = component.get("c.getScenarioCashFlowResponse");
        action1.setParams({
            "mb": CmbVal,
            "mp": MmpVal,
            "ir": CmirVal
        });
        action1.setCallback(this, function(res) {
            //   alert('cash flow call back ');
            var jdata = res.getReturnValue();
            if(jdata){  
                component.set("v.BarChartResponse",jdata);
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
                        "chart":this.chart,
                        "data":component.get("v.data_is"),
                        "bar":bar
                    },
                    function(newChartComp, status, errorMessage){
                        if(status == "SUCCESS"){
                            var body = component.get("v.dynamic_cash");
                            body.pop();
                            body.push(newChartComp);
                            //  alert();
                            component.set("v.dynamic_cash", body);
                        } 
                    }
                );
                // document.getElementById("Backtoloan").style.display = "Block";
                component.set("v.IsSpinner",false);
                this.getProfileName(component, event, helper);
            }
        });
        $A.enqueueAction(action1);
    },
    getProfileName : function(component, event, helper) {
        var action = component.get("c.getLoggedInProfile");
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state == 'SUCCESS') {
                var profile=response.getReturnValue();
                var profileName = component.get("v.profileName");
                
                if(profile.Name == profileName)
                {
                    document.getElementById("clientdiv").style.display = "None";
                }
                else{
                    document.getElementById("clientdiv").style.display = "block";
                }
            }
        });
        $A.enqueueAction(action);   
    },
    //end cashflow
    //Generic Validation Method
    formatErrorMethod: function(component, regex, msg, aura_id) {       
        //Code if button is clicked
        component.set('v.FirstName_error',false);
        component.set('v.LastName_error',false);
        component.set('v.street_error',false);
        component.set('v.zip_error',false);
        var flag = false;
        var fName = component.get('v.selectedRecord.FirstName');
        var lName = component.get('v.selectedRecord.LastName');
        var streetName = component.get('v.selectedRecord.Street');
        var zipcode = component.get('v.selectedRecord.PostalCode');
        console.log('validating>>>>>>>>>>');
        var DataIs = [fName,lName,streetName,zipcode];
        console.log('DataIs ',DataIs);
        
        var fieldBooleans = ['FirstName_error','LastName_error','street_error','zip_error'];
        for (var i = 0; i < DataIs.length; i++) {
            console.log('DataIs[i] ',DataIs[i]);
            if(DataIs[i]==undefined || DataIs[i]==''){
                flag = true;    
                component.set('v.'+fieldBooleans[i],true);
            }else{
                
                component.set('v.'+fieldBooleans[i],false);
            }
        }
        /*  for (var i = 0; i < aura_id.length; i++) {
            var inputCmp = component.find(aura_id[i]);
            var value = inputCmp.get("v.value");
            var isValid = false;            
            if (typeof regex[i] != "string") {                
                isValid = regex[i](value);
            }             
            if (isValid) {
                inputCmp.set("v.errors", null); 
            } else {
                inputCmp.set("v.errors", [{ message: msg[i]   }]);              
                flag = true;                
            }
        }*/
        return flag;
    },
    //Validate Zip
    ValidZip: function(component, event, helper,id) {  
        var msgZip = '';
        var regZip =/(^\d{5}$)|(^\d{5}-\d{4}$)/;        
        var isRegZipValid = false;        
        try{
            var inputCmp = component.find(id);          
            var value = inputCmp.get("v.value");       
            
            if (typeof value == "undefined" || value==null || value=='') {
                value='';
            }
            if (value.length>0 ) { 
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
        }catch(err){}
        return isRegZipValid;
    },
    //Phone NUmber Should Not start with Zero(0).
    RestrictZeroInPhoneFirstTime:function(component, event, helper,compId) {
        var inz = component.get(compId);
        var digit = parseInt(inz[0]);
        if(digit == 0)
        {            
            component.set(compId, inz.substring(0, inz.length - 1));
        }              
    },
    //Validate Phone
    FormatPhonehelper: function(component, event, helper){        
        var a = component.get('v.selectedRecord.Phone');//.find("inputPhone").get("v.value"); 
        var rxp = new RegExp("^(\\d)\\1{9}$");        
        var  isRegValid = rxp.test(a);
        if(isRegValid)
        {
            component.set("v.selectedRecord.Phone_Number__c",'');
        }else{
            var s2 = (""+a).replace(/\D/g, '');
            var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
            var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];            
            component.set("v.selectedRecord.Phone_Number__c",result);
        }
    },
    //Validation- for either enter email or Phone
    EmailOrPhoneRequired: function(component, regex, msg, aura_id) {        
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var flagR = false;
        try{
            var EmailInput = component.find("inputEmail");
            var EmailInputValue = EmailInput.get("v.value");
            var PhoneInput = component.find("inputPhone");
            var PhoneInputValue = PhoneInput.get("v.value");
            if ($A.util.isEmpty(EmailInputValue)&&  $A.util.isEmpty(PhoneInputValue))
            {
                flagR = true;             
            }
            else{         
            }
        }catch(err){}
        return flagR
    },
    //Email Format Validation
    EmailValidation:function(component, regex, msg, aura_id) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var flagR = false;
        try{
            var EmailInput = component.find("inputEmail");
            var EmailInputValue = EmailInput.get("v.value");
            if(!$A.util.isEmpty(EmailInputValue)&& !EmailInputValue.match(regExpEmailformat))
            {
                EmailInput.set("v.errors", [{ message:"Please enter valid email id."}]); 
                flagR=true;
            }
            else{
                EmailInput.set("v.errors", null);             
            }
        }catch(err){}
        return flagR;
    },
    //Save Scenario
    SaveScenario: function(component, event, helper) {
        //   alert('saa');
        var FName, LName, Address, Zip, Phone = '',
            errorlbl, EmailVal = '';
        EmailVal = component.get('v.selectedRecord.Email');
        // errorlbl = component.find("ErrorLabel");
        FName = component.get('v.selectedRecord.FirstName');
        LName = component.get('v.selectedRecord.LastName');
        Address = component.get('v.selectedRecord.Street');
        Zip = component.get('v.selectedRecord.PostalCode');
        Phone = component.get('v.selectedRecord.Phone');
        var ClientInfoval = component.get("v.selectedRecord");
        var sceis = component.get('v.selectedSce'); //BalaC1
        var DobVal = component.get("v.DOB");
        var action = component.get("c.SaveScenario");
        var BarChartResponse= component.get("v.BarChartResponse");
        var PieChartResponse= component.get("v.PieChartResponse");
        var selectedMargin = component.get('v.Margin');//component.get("v.Margins")[parseInt(component.get("v.Scenarioindex"))];//prsn
        var lineOfCredit = component.get('v.lineOfCreditIs'); //BalaC1
        //var lineOfCredit = component.get('v.TotalAmountAvailable');//Math.round(selectedMargin.initialLOC); 
        console.log('ClientInfoval ',ClientInfoval);
        var ttl_amt  = component.get("v.TotalAmountAvailable");//parseFloat( component.get("v.TotalAmountAvailable").replace(',',''));
        var sceType;
        if(component.get('v.ScenarioType')=='FHA Traditional HECM'){
            sceType = 'FHA Traditional HECM';
            component.set('v.isTraditional',true);
        }else{
            sceType = 'HECM for Purchase';
            
            component.set('v.isTraditional',false);
        }
        //    alert(component.get('v.cashToClose'));
        console.log( "objClient",ClientInfoval);
        console.log(  "hv", component.get("v.EHV")==''?0.00:component.get("v.EHV"));
        console.log("Dob", DobVal);
        console.log("HV10yr", 0.00);
        console.log("mb", component.get("v.CMB"));
        console.log("mp", component.get("v.MMP"));
        console.log("ir", component.get("v.CMIR"));
        console.log("Index", component.get("v.Index"));
        console.log("Margin", component.get("v.Margin"));
        console.log("MIP", component.get("v.MIP"));
        console.log("IGR", component.get("v.IGR"));
        console.log("AGR", component.get("v.AGR"));
        console.log("Priority", component.get("v.Priority"));
        console.log("CF12MA", component.get("v.CF12MA")==''?0.00:component.get("v.CF12MA"));
        console.log("CF60MA", component.get("v.CF60MA")==''?0.00:component.get("v.CF60MA"));
        console.log("CFRMA", component.get("v.CFRMA")==''?0.00:component.get("v.CFRMA"));
        console.log("CFRM", component.get("v.CFRM") ==''?0.00:component.get("v.CFRM"));
        console.log("secMN", component.get("v.secMN") ==''?0.00:component.get("v.secMN")); 
        console.log( "P_Limit",ttl_amt==''?0.00:ttl_amt);
        console.log( "lineOfCredit" , lineOfCredit==''?0.00:lineOfCredit);
        //  console.log("ScenarioType",sceType);
        //  console.log( "Scenario_Response",component.get('v.senResp'));
        console.log(  'cash1',''+component.get('v.CF1MA'));
        console.log( 'cash5',''+component.get('v.CF5MA'));
        console.log(   'cash10',''+component.get('v.CF10MA'));
        console.log(   'CaC',''+component.get('v.cashToClose'));
        console.log(   'MarginType',component.get('v.MarginTypeiS'));
        console.log('EOF save scenario -> ', component.get('v.EOF'));        
        var cmIRis = 0.00;
        if(component.get("v.CMIR")){
            cmIRis   = component.get("v.CMIR");
        }
        
        var igris = 0.00;
        if(component.get("v.IGR")){
            igris   = component.get("v.IGR");
        }
        
        var AGRis = 0.00;
        if(component.get("v.AGR")){
            AGRis   = component.get("v.AGR");
        }
        //BalaC1 - save new scenario fields
            var selRec_is = component.get('v.selectedRowIs');
        	var marginType = component.get('v.MarginTypeiS');        	
            console.log('selRec_is>>>> ',selRec_is);
            sceis['Age__c'] = parseInt(component.get('v.Ageminus1'));
            sceis['Desired_Origination_for_Adjustable_Rate__c'] = parseFloat(component.get('v.ADO'));  
        	sceis['Utilization__c'] = parseFloat(selRec_is.MaxInitialUtilization);          
        	if(marginType == 'Helo'){ //SFDC - 265_new
                var upb1 = parseFloat(selRec_is.UPB);                
                if(upb1 >= 4000000 ){
                    sceis['Unpaid_Principal_Balance__c'] = parseFloat(4000000);
                }else{
                    sceis['Unpaid_Principal_Balance__c'] = parseFloat(selRec_is.UPB);      
                }            	
            }
            else{
                sceis['Unpaid_Principal_Balance__c'] = parseFloat(selRec_is.MaxInitialUPB);            	
            }        	
        	sceis['Other_Estimated_Closing_Costs__c'] = parseFloat(component.get('v.ECC'));
            sceis['Total_Compensation__c'] = parseFloat(selRec_is.TC);
            sceis['Amount_Available__c'] = parseFloat(component.get('v.TotalAmountAvailable'));
            sceis['Funds_Needed_to_Close__c'] = parseFloat(component.get('v.cashToClose'));            
            sceis['Funds_to_Close__c'] = parseFloat(component.get('v.cashToClose'));
        	sceis['Origination_to_orm__c'] = parseFloat(component.get('v.EOF'));
        	sceis['HeloMargin__c'] = parseFloat(component.get('v.HeloMargin'));//Helo New field
        console.log('sceis>>>> ',sceis);
        //BalaC1
        action.setParams({
            "objClient": ClientInfoval,
            "hv": component.get("v.EHV")==''?0.00:component.get("v.EHV"),
            "Dob": DobVal,
            "HV10yr": 0.00,//component.get("v.TenthAmount")==''?0.00:component.get("v.TenthAmount"),
            "mb": component.get("v.CMB")==''?0.00:component.get("v.CMB"),
            "mp": component.get("v.MMP")==''?0.00:component.get("v.MMP"),
            "ir": cmIRis,
            "Index": component.get("v.Index"),
            "Margin": component.get("v.Margin"),
            "MIP": component.get("v.MIP"),
            "IGR": igris,
            "AGR": AGRis,
            "Priority": component.get("v.Priority"),
            "CF12MA": component.get("v.CF12MA")==''?0.00:component.get("v.CF12MA"),
            "CF60MA": component.get("v.CF60MA")==''?0.00:component.get("v.CF60MA"),
            "CFRMA": component.get("v.CFRMA")==''?0.00:component.get("v.CFRMA"),
            "CFRM": component.get("v.CFRM") ==''?0.00:component.get("v.CFRM"),
            "secMN": component.get("v.secMN") ==''?0.00:component.get("v.secMN"), 
            "PieChartResponse":PieChartResponse, 
            "BarChartResponse":BarChartResponse,
            "P_Limit":ttl_amt==''?0.00:ttl_amt,
            "lineOfCredit" : lineOfCredit==''?0.00:parseFloat(lineOfCredit), //BalaC1
            //BalaC1 "lineOfCredit" : lineOfCredit==''?0.00:lineOfCredit,
            "ScenarioType":sceType,
            "Scenario_Response":component.get('v.senResp'),
            'cash1':''+component.get('v.CF1MA'),
            'cash5':''+component.get('v.CF5MA'),
            'cash10':''+component.get('v.CF10MA'),
            'CaC':''+component.get('v.cashAtClose'),
            'MarginType':component.get('v.MarginTypeiS'),
            'CtoC':''+component.get('v.cashToClose'),
            'Eofis':component.get('v.EOF'),
            //'ADOis':''+component.get('v.ADO')
            'sce':sceis
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            component.set("v.ScenarioID", result);
            component.set("v.senario_id",result);
            component.set("v.showError", false);  
            component.set("v.EmailPhoneMessages","");
            component.set("v.Messages", "Scenario Saved Successfully");
            component.set("v.showAlert", true);                
            document.getElementById("request").style.display = "block";
            document.getElementById("savebtn").style.display = "None";
            component.set("v.selected_record",result);
            console.log('result ',result);
        });        
        $A.enqueueAction(action);       
    },
    
    do_margins_call:function(component, event, helper){
        //  alert();
        debugger;
        var metaDataTableVales = component.get("v.metadatavalues"); 
        component.set("v.IsSpinner",true);
        
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
            "CFY":CFYVal,
            "mp": MmpVal,
            "ir": CmirVal
        });  
        console.log('action ',action);
        action.setCallback(this, function(a) {
            var jdata = a.getReturnValue();
            //   alert(jdata); 
            myObj = JSON.parse(jdata);            
            var marginsData = [];
            var pl = [];
            console.log('myObj myObj  ',myObj);
            
            var EOFis;// = EhvVal *0.02;
            var finalEOF;
            //alert(EhvVal);
            if(EhvVal<=200000){
                finalEOF= EhvVal *0.02;
            }else{
                finalEOF= (200000 *0.02) + ((EhvVal-200000)*0.01);
                
            }  
            if(finalEOF<2500){
                finalEOF = 2500;
            }else if(finalEOF>6000) {
                
                finalEOF  = 6000;
            }
            
            debugger;
            
            for(var i=0;i<myObj.pricingList.length;i++){
                var eachIs = myObj.pricingList[i];
                var eachMargin=myObj.pricingList[i].lendersMargin;
                var eachpl = myObj.pricingList[i].initialPrincipalLimit;
                var eachloc = myObj.pricingList[i].initialLOC;
                console.log('initial Loc ='+eachloc);//prsn
                var maxCFyear = myObj.pricingList[i].maxCashFirstYear;
                console.log('eachloc ',eachloc,maxCFyear);
                var FinalLoc = eachloc - maxCFyear;
                var eachAmount = myObj.pricingList[i].pricing;
                eachIs.lendersMargin = eachMargin.toFixed(3);
                eachIs.initialPrincipalLimit = eachpl.toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                eachIs.initialLOC = FinalLoc;//.toFixed(2);.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                eachIs.pricing = eachAmount.toFixed(3);
                
                
                //UPB Calculation 
                // max cash first year(response) + Upfront MIP(response) + Estimated Origination Fee (we calculate) + Other Estimated Closing Costs(we hardcode at 2500) + Current Mortgage Balance(input)		
                eachIs.initialReverseUPB = (myObj.pricingList[i].maxCashFirstYear + myObj.pricingList[i].upfrontMip + finalEOF + 2500 + CmbVal );
                if(eachIs.initialReverseUPB > parseInt(eachIs.initialPrincipalLimit.replace(',',''))){
                    eachIs.initialReverseUPB = parseInt(eachIs.initialPrincipalLimit.replace(',',''));
                }                
                //UPB Calculation ends
                
                var addingVal = 0;
                try{
                    var loc_calculation_value = metaDataTableVales[myObj.pricingList[i].lendersMargin];
                    debugger;
                    
                    //UTILIZATION logic
                    var utcal =(myObj.pricingList[i].initialReverseUPB/parseInt(eachIs.initialPrincipalLimit.replace(',','')))*100
                    eachIs.utilizationPercent= utcal;
                    //UTILIZATION logic ends
                    
                    var utilizationPercent_round =Math.ceil(( utcal)/10)*10;
                    if(isNaN(utilizationPercent_round))
                    {
                        utilizationPercent_round = 0;
                    }
                    addingVal = parseFloat(loc_calculation_value[utilizationPercent_round]);
                    if(isNaN(addingVal)){
                        addingVal = 0;
                    }
                }catch(err){
                    console.log('**** in erro *****');
                    console.log(err);
                }
                
                //Compensation Logic
                eachIs.compensation = finalEOF +(myObj.pricingList[i].initialReverseUPB *((addingVal-100)*0.01));//myObj.pricingList[i].pricing;
                //Compensation Logic Ends
                
                marginsData.push(eachIs);
            }
            component.set("v.Margins",myObj.pricingList);
            component.set("v.IsSpinner",false);  
        });
        
        $A.enqueueAction(action);
        
    },
    applyCSS: function(component, event, helper,ControlId) {
        var cmpTotalCapacity = component.find(ControlId);
        $A.util.removeClass(cmpTotalCapacity,'TextColor_green');
        $A.util.addClass(cmpTotalCapacity, 'TextColor_red');
    },
    optionChanged:function(component, event, helper){
        var lnId= component.get("v.showLoanId");
        $A.createComponent(
            "c:StartNewLoanCmp",
            
            {
                "ApplicationDate":component.get("v.ApplicationDate"),
                "LoanId":component.get("v.showLoanId"), 
                "fromPopup":true
            },
            function(newCmp){
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
    getserviceData:function(component,event,helper){
        debugger;
        console.log('ADO Value  from getserviceData-->', component.get('v.ADO'));
        var ADOVal = component.get('v.ADO');
        var dobIs = component.get('v.DOB').replace('-','/').replace('-','/');
        var action = component.get("c.getScenariData");
        if(component.get('v.ScenarioType')=='FHA Traditional HECM'){
            component.set('v.typeOfFunds','Cash at close');
            component.set('v.isTraditional',true);
            
        }else{
            component.set('v.typeOfFunds','Funds to close');
            component.set('v.isTraditional',false);
        }
        var pmIs= component.get('v.ScenarioType')=='FHA Traditional HECM'?component.get('v.CMB'):'';
        action.setParams({
            'dob':dobIs,
            'ev':''+component.get('v.EHV'),
            'pm':''+pmIs,
            'ADOValIs':''+ADOVal,
            'Tieris':component.get('v.Tier_Value') //SFDC - 289 Added this for 3rd tier backend calculator 
        });
        
        action.setCallback(this,function(data){            
            console.log('ADO Value  from getserviceData1-->', component.get('v.ADO'));
            //   var ADOVal =   component.get('v.ADO');
            var Adjmetadatavalues = component.get('v.metadatavalues');
            // alert('Adjmetadatavalues '+  JSON.parse(JSON.stringify(Adjmetadatavalues)));
            console.log('Adjmetadatavalues', JSON.parse(JSON.stringify(Adjmetadatavalues)));
            component.set('v.senResp',data.getReturnValue());
            component.set('v.Ageminus1',JSON.parse(data.getReturnValue()).YoungestBorrowerAge);
            var Parseddata = JSON.parse(data.getReturnValue()).LoanPrograms[0].margins;
            console.log('Parseddata -> ',JSON.parse(JSON.stringify(Parseddata))); 
            console.log('data >> ',JSON.parse(data.getReturnValue()));
            //Helo fix
            var ParseddataHelo =[];
            var wsData = data.getReturnValue();
            var wsJson = JSON.parse(wsData);
            wsJson.LoanPrograms.forEach(function(item){
                if(item.ProgramName == 'Home Equity Loan Optimizer'){
                 		component.set('v.isDisplayHelo',true);
            			ParseddataHelo = item.margins;
                }
                else{
                    component.set('v.isDisplayHelo',false);
                }
            });
            console.log('ParseddataHelo -> ',JSON.parse(JSON.stringify(ParseddataHelo)));             
            var AdjustableParseddata = JSON.parse(data.getReturnValue()).LoanPrograms[2].margins;
            for(var i=0;i<AdjustableParseddata.length;i++){
                console.log('>>>> ' + parseFloat(AdjustableParseddata[i].Margin).toFixed(3));
                try{
                    
                    AdjustableParseddata[i].Margin =  parseFloat(AdjustableParseddata[i].Margin).toFixed(3);
                }catch(err){
                    
                    console.log('errr1 ',err);
                }
                console.log('>>>>>>>>>>>>>>>>>>');
                var pricing = 0;
                
                var pricingValuesfromMetadata;
                try{
                    console.log(Adjmetadatavalues,AdjustableParseddata[i].Margin);
                    pricingValuesfromMetadata =    Adjmetadatavalues[AdjustableParseddata[i].Margin];
		    AdjustableParseddata[i].No_Margin = pricingValuesfromMetadata; //SFDC-377
                }catch(err){
                    
                    console.log('errr ',err);
                }
                //   console.log('pricingValuesfromMetadata ', JSON.parse(JSON.stringify(pricingValuesfromMetadata)));
                console.log('pricingValuesfromMetadata ',pricingValuesfromMetadata);
                if(pricingValuesfromMetadata){ 
                    var utilizationPercent_round =Math.ceil(( AdjustableParseddata[i].MaxInitialUtilization)/10)*10;
                    if(isNaN(utilizationPercent_round))
                    {
                        utilizationPercent_round = 0;
                    }
                    
                    console.log('Utilization ',utilizationPercent_round);//Math.floor(AdjustableParseddata[i].MaxInitialUtilization));
                    pricing = pricingValuesfromMetadata[utilizationPercent_round];
                    console.log('pricing -->', pricing);
                    
                }
                if(!pricing){
                    pricing = 0;
                }
                var each = AdjustableParseddata[i];
                console.log('Tc Calculation ',AdjustableParseddata[i].Margin,pricing,AdjustableParseddata[i].MaxInitialUPB,AdjustableParseddata[i].MaxOrigFee);
                console.log('tc value ',(((pricing-100)*0.01)*AdjustableParseddata[i].MaxInitialUPB) + AdjustableParseddata[i].MaxOrigFee);
                //  AdjustableParseddata[i].TC = (((pricing-100)*0.01)*AdjustableParseddata[i].MaxInitialUPB) + AdjustableParseddata[i].MaxOrigFee; 
                AdjustableParseddata[i].TC = (((pricing-100)*0.01)*AdjustableParseddata[i].MaxInitialUPB) + ADOVal; 
                
                if(component.get('v.ScenarioType')!='FHA Traditional HECM'){
                    //MaxAdditionalFirstYearDraw
                    //        AdjustableParseddata[i].TC = (((pricing-100)*0.01)*AdjustableParseddata[i].MaxInitialUPB) + AdjustableParseddata[i].MaxOrigFee; 
                    //	AdjustableParseddata[i].MFD  = (component.get('v.EHV') - AdjustableParseddata[i].PrincipalLimit)+10000;
                    // AdjustableParseddata[i].MFD = (component.get('v.EHV') - AdjustableParseddata[i].PrincipalLimit) + 10000;
                    AdjustableParseddata[i].MFD = (component.get('v.EHV') - AdjustableParseddata[i].PrincipalLimit) + AdjustableParseddata[i].IMIP+ADOVal+3000;
                    AdjustableParseddata[i].MFD = AdjustableParseddata[i].CashFromBorrower;
                    component.set("v.downPyt",AdjustableParseddata[i].MFD );
                    console.log('down payment not trad', component.get("v.downPyt"));
                }else{
                    
                    AdjustableParseddata[i].MFD    = AdjustableParseddata[i].MaxAdditionalFirstYearDraw;
                    //   component.set("v.downPyt",AdjustableParseddata[i].MFD );
                    console.log('down payment trad', component.get("v.downPyt"));                    
                }
            }
            
            for(var i=0;i<Parseddata.length;i++){
                var each = Parseddata[i];
                Parseddata[i].ExpectedRate =  parseFloat(Parseddata[i].ExpectedRate).toFixed(3);
                console.log('Parseddata[i].ExpectedRate  -->'+ Parseddata[i].ExpectedRate);
                
                var pricing = 0;
                var  pricing1 = 0;
                var fixedValues = component.get('v.metadatavaluesFixed');
                console.log('fixedValues ',JSON.stringify(fixedValues));
                var t =  Parseddata[i].ExpectedRate;//+'0';
                console.log('fixedmetadata1',t);
                pricing = fixedValues.fixed[t];
                pricing1 = parseInt(fixedValues.fixed_orm[t]);
                //SFDC-250
                var fixedRate = 0;
                fixedRate = fixedValues.fixed_rate_orm[t];
                Parseddata[i].FR = fixedRate;
				//End 250
				                
                console.log('fixedmetadata12', pricing1);
                //alert(pricing);
                if(!pricing){
                    pricing = 0
                }else{
                    pricing = (pricing *Parseddata[i].MaxInitialUPB)/100;
                }
                console.log('fixed tc cal ',pricing,Parseddata[i].MaxInitialUPB,Parseddata[i].MaxOrigFee);
                console.log('fixed tc cal pricing ',pricing);
                //  Parseddata[i].TC = (((pricing-100)*0.01)*Parseddata[i].MaxInitialUPB) + Parseddata[i].MaxOrigFee; 
                Parseddata[i].TC = pricing; 
                if(component.get('v.ScenarioType')!='FHA Traditional HECM'){
                    //MaxAdditionalFirstYearDraw
                    //        AdjustableParseddata[i].TC = (((pricing-100)*0.01)*AdjustableParseddata[i].MaxInitialUPB) + AdjustableParseddata[i].MaxOrigFee; 
                    //Parseddata[i].MFD  = (component.get('v.EHV') - Parseddata[i].PrincipalLimit)+10000;
                    console.log('(component.get("v.EHV") - Parseddata[i].PrincipalLimit) +Parseddata[i].IMIP+pricing1+ 3000 ',(component.get("v.EHV") - Parseddata[i].PrincipalLimit) +Parseddata[i].IMIP+pricing1+ 3000,(component.get('v.EHV'),Parseddata[i].PrincipalLimit) ,Parseddata[i].IMIP,pricing1,3000);
                    //alert((component.get('v.EHV') - Parseddata[i].PrincipalLimit) +Parseddata[i].IMIP+pricing1+ 3000);
                    Parseddata[i].MFD = (component.get('v.EHV') - Parseddata[i].PrincipalLimit) +Parseddata[i].IMIP+pricing1+ 3000;
                    console.log('parsedataevh', component.get('v.EHV'));
                    console.log('parsedataPrincipa;', Parseddata[i].PrincipalLimit);
                    console.log('parsedataIMIP', Parseddata[i].IMIP);
                    console.log('ParsedataPricing', pricing); 
                    Parseddata[i].MFD = Parseddata[i].CashFromBorrower;
                    component.set("v.downPyt",Parseddata[i].MFD);
                    console.log('down payment parse ', component.get('v.downPyt'));
                }else{
                    
                    Parseddata[i].MFD    = Parseddata[i].MaxAdditionalFirstYearDraw;
                    //       component.set("v.downPyt",Parseddata[i].MFD);
                    
                    console.log('down payment parse ', component.get('v.downPyt'));
                }
                
            }
            //Helo calculations
            for(var i=0;i<ParseddataHelo.length;i++){
                var each = ParseddataHelo[i];
                console.log('Parseddata  -->'+ ParseddataHelo[i]);
                ParseddataHelo[i].InterestRate =  parseFloat(ParseddataHelo[i].InterestRate).toFixed(3);
                ParseddataHelo[i].UPB = parseFloat(ParseddataHelo[i].UPB).toFixed(3);
                        console.log('Parseddata[i].InterestRate  -->'+ ParseddataHelo[i].InterestRate);
                        console.log('Parseddata[i].upb  -->'+ ParseddataHelo[i].UPB);  
                var pricing = 0;
                var pricing1 = 0;
                var heloValues = component.get('v.metadatavaluesHelo');
                        console.log('heloValues ',JSON.stringify(heloValues));
                var t =  ParseddataHelo[i].InterestRate;
                 
                //use upb local variable for all HELO calcs because it has a cap of 4000000 SFDC-265_new
                var upb1 = ParseddataHelo[i].UPB;                
                var upb = 0;
                if(upb1 >= 4000000){
                    var upb = 4000000;
                }
                else{
                    var upb = ParseddataHelo[i].UPB;
                } 

                //TC calculation -> Displaying in the Helo table Total Compensation
                pricing = heloValues.Helo[t]; //Broker comp price__c
                        console.log('Helo Pricing',pricing);
                pricing1 = parseFloat(heloValues.Helo_orm[t]);
                        console.log('pricing1', pricing1);   
                if(!pricing){
                    pricing = 0
                }else{
                    pricing = (pricing * upb)/100; // calculation for TC = BrokerComp% * UPB
                            console.log('fixed tc helo cal pricing ',pricing);
                }                
                ParseddataHelo[i].TC = pricing; 
				//end TC calculation
				
                var cmb = component.get("v.CMB"); //current mortgage balance                 
                var EhvVal = component.get('v.EHV');//estimated home value
                var origToOrm = ((pricing1 * upb)/100); //Origination to One Reverse Mortgage, LLC
                var ecc = ((0.5 * EhvVal)/100);  //estimated closing cost calculation
                console.log('ecc',ecc);
                var ecc1=0;
                if(ecc >= 2500 && ecc <= 15000){ 
                    var ecc1 = ecc;  
                }
                else if(ecc < 2500){
                    var ecc1 = 2500;
                }
                else{
                    var ecc1 = 15000;    
                } 
                
                //Cash at Close calculation -> Helo table Cash At Close/Funds to Close
                if(component.get('v.ScenarioType')=='FHA Traditional HECM'){			
                                 
                    var cashatclose = upb - cmb - origToOrm - ecc1;                    
                    ParseddataHelo[i].CC = cashatclose; 
                }else{                    
                    var fundstoclose = ((ecc1 + origToOrm) + EhvVal) - upb;
                 	ParseddataHelo[i].CC = fundstoclose;
                }
                
				//end cash at close calculation
				
                //Fetch Service Fee from Metadata table and display on Helo table
                var serviceFee = heloValues.Helo_service[t];
                ParseddataHelo[i].SF = serviceFee;
				//end service fee            
                
                if(component.get('v.ScenarioType')!='FHA Traditional HECM'){
                    ParseddataHelo[i].MFD = (component.get('v.EHV') - upb) +pricing1+ 3000;
                    ParseddataHelo[i].MFD = ParseddataHelo[i].CashToBorrower;
                                     console.log('MFD 2',ParseddataHelo[i].CashToBorrower);
                    component.set("v.downPyt",ParseddataHelo[i].MFD);
                }else{
                    ParseddataHelo[i].MFD    = 0;
                    console.log('down payment parse helo ', component.get('v.downPyt'));
                }
            }
            try{
                console.log('Parseddata>> ',Parseddata);
                console.log('AdjustableParseddata>> ',AdjustableParseddata);
                component.set("v.FHA_Hecm_FixedMargin",Parseddata);
                component.set("v.FHA_Hecm_HeloMargin",ParseddataHelo);
                component.set("v.FHA_Hecm_AdjustableMargin",AdjustableParseddata);
                component.set("v.Show_FHA_Hecm_FixedMargin",true);
            }catch(err){
                console.log('error is ',err);
            }
            component.set("v.showLoan",false);
            component.set('v.showSpinner',false);
        });
        $A.enqueueAction(action);
    },
    
    generate_pieChart:function(component,event,helper){
        //var downPyt =component.get('v.downPyt');
        //  alert('>>>> '+downPyt);
        var labels = ['a','b','c'];
        var insuranceFees = component.get('v.MIP');
        var eof = component.get("v.EOF"); //Origination to ORM
        console.log('EOF is ',eof);
            var marginType = component.get('v.MarginTypeiS'); //helo        
            var heloEcc = component.get("v.ECC"); //Estimated Closing Costs helo
            console.log('ECC is ',heloEcc); //helo
        if(marginType == 'Helo'){
            var financingFees = eof + heloEcc;  //financing fee for Helo for both refinance and purchase
            var downPyt = component.get('v.cashToClose'); //Down payment for Helo for Purchase
            console.log('helo dwn py',downPyt );
        }
        else{
        	var financingFees = (Math.round(eof * 100) / 100)+2500;//Math.round((2500 + eof));
            var downPyt =component.get('v.downPyt');
        }
        var EhvVal = component.get("v.EHV");
        equityReserves = (Math.round(EhvVal * 100) / 100);//added new 
        var CmbVal = component.get("v.CMB");
        var equityReserves = 0;//added new 
        if(!CmbVal){
            CmbVal = 0;
        }
        var mmb = parseInt(component.get("v.CMB"));
        var CFYVal = component.get("v.CFY");
        var cashAtClose = component.get('v.FirstAmount');//Helo Amount available after lien payoff
        		console.log('cashatclose', cashAtClose);
        component.set('v.cashAtClose',cashAtClose);
        var lineOfCredit = component.get('v.TotalAmountAvailableLoc');
        //added new
        var myObj = {};
        //  finalHome = '{"Home Value($) ":[' + jnewStr + '],"Line of Credit($) ":[' + znewStr + '],"Mortgage Balance($) ":[' +  xnewStr + ']}';
        var colors = [
            "#000080",
            "#00CED1",
            "#B22222"
        ]; 
        
        //  var labels = intArr;
        var datasets = [];
        var terms = {};
        var terms1 = {'a':10,'b':20,'c':50};//JSON.parse(finalHome);
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
        //create graph logic
        // (EhvVal -(insuranceFees + lineOfCredit + financingFees+cashAtClose+CmbVal )) old logic
        //FHA Traditional HECM
        var equity = 0;
        
        var labelsare = [];
        if(component.get('v.ScenarioType')!=='FHA Traditional HECM'){	//Purchase
            equity  =0;//(EhvVal -(insuranceFees + lineOfCredit + financingFees+cashAtClose+CmbVal ));
            	
            labelsare  = [
                'Current Mortgage Balance',
                'Insurance Fees',
                'Financing Fees',
                'Equity Reserves',
                'Loan Amount',
                'Down Payment'
            ];
            CmbVal=0;
            lineOfCredit =parseInt(downPyt);
            
            cashAtClose =parseInt(component.get('v.PrincipalLimitIs'));
            console.log('chart purchase')
            console.log('data set trad ',[CmbVal,insuranceFees,financingFees,equity , cashAtClose,  lineOfCredit]);
        }else{  //Refinance
            if(marginType == 'Helo'){ //Equity Reserve calc for helo
            	equity = EhvVal - (eof + heloEcc) - cashAtClose;
                console.log('helo equity', equity);
            }else{
            	equity  =(EhvVal -(insuranceFees + lineOfCredit + financingFees+cashAtClose+CmbVal ));       
            }
            labelsare  = [
                'Current Mortgage Balance',
                'Insurance Fees',
                'Financing Fees',
                'Equity Reserves',
                'Cash At Close',
                'Line of Credit'
            ];
            console.log('data set purchase ',[CmbVal,insuranceFees,financingFees,equity, cashAtClose,  lineOfCredit]);   
            console.log('chart trad')
        }    
        console.log('labelsare>> ',labelsare);            
        $A.createComponent(
            "c:DynamicLineChartCMP",
            {
                //   "labels": labels,
                "labels":labelsare,
                "datasets": [CmbVal,insuranceFees,financingFees,equity, cashAtClose,  lineOfCredit]
            },
            function(newChartComp, status, errorMessage){
                if(status == "SUCCESS"){
                    var body = component.get("v.body");
                    body.pop();
                    body.push(newChartComp);
                    component.set("v.body", body);
                    component.set('v.lineOfCreditIs',lineOfCredit);//BalaC1
                    // component.set("v.IsSpinner",false);
                    component.set('v.rerender_section',true);
                    document.getElementById("clientdiv").style.display = "BLOCK";
                    document.getElementById("GRA").style.display = "BLOCK";
                    document.getElementById("CashFlow").style.display = "BLOCK";      
                    document.getElementById("LOCandCashFlow").style.display = "BLOCK";         
                } 
            }
        );
        //end of create graph logic
        
    }
    
})
