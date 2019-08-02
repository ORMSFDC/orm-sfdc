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
	var alphabet = (""+inz).replace(/\D/g, ''); //SFDc-378
        if(digit == 0)
        {            
            component.set(compId, inz.substring(0, inz.length - 1));
        }   
	else{ //SFDc-378
            component.set(compId, alphabet);
        }
    },
    
    //Validate Phone //SFDC-378
    FormatPhonehelper: function(component, event, helper){     
        var a = component.get('v.selectedRecord.Phone');
        var rxp = new RegExp("^(\\d)\\1{9}$");        
        var isRegValid = rxp.test(a);
        var flagR = false;
        if(isRegValid)
        {
            flagR = true;
        }else{
            var s2 = (""+a).replace(/\D/g, '');
            var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
            var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];  
	    var EmailInputValue = component.get("v.selectedRecord.Email"); //SFDc-378
            if (result == null && $A.util.isEmpty(EmailInputValue)){
                flagR = true;
            }else{
            	component.set("v.selectedRecord.Phone",result); 
            	flagR = false;
            }
        }
        return flagR;
    },
    
    //Validation- for either enter email or Phone //SFDC-378
    EmailOrPhoneRequired: function(component, regex, msg, aura_id) {        
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var flagR = false;
        try{            
            var EmailInputValue = component.get("v.selectedRecord.Email");
            var PhoneInputValue = component.get("v.selectedRecord.Phone");
            if ($A.util.isEmpty(EmailInputValue)&&  $A.util.isEmpty(PhoneInputValue))
            {
                flagR = true;             
            }
            else{         
            }
        }catch(err){}
        return flagR
    },
    //Email Format Validation  //SFDC-378
    EmailValidation:function(component, regex, msg, aura_id) { 
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        try{
            var flagR = false;        
            var EmailInput = component.get("v.selectedRecord.Email");
            if(!EmailInput == "" && !EmailInput.match(regExpEmailformat)){; 
                flagR = true;
            }else{
                component.set("v.errors",null);
            }
        }catch(err){}
        return flagR;
    },

    //Save Scenario
    SaveScenario: function(component, event, helper) {   
        debugger;
        component.set('v.showSpinner',true);
        var FName, LName, Address, Zip, Phone = '',
            errorlbl, EmailVal = '';
            //different ADO for ARM(min 2500 and max 600)
            var ADOVal = component.get('v.ADO');            
            var EhvVal = component.get('v.EHV');
            var HUDeof = (EhvVal <= 200000) ? (EhvVal * 0.02) : ((200000 * 0.02) + ((EhvVal - 200000) * 0.01));
            var armADOVal2 = (HUDeof < 2500) ? 2500 : ((HUDeof > 6000) ? 6000 : HUDeof);
            console.log('armADOVal',armADOVal2);
            var armADOVal = 0;
            if(ADOVal > 6000){
                armADOVal = 6000;
            }else if(ADOVal < 2500){
                armADOVal = 2500;
            }else{
                armADOVal = armADOVal2;
            }
            //end of arm ADO Val

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
            if(marginType == 'Adjust'){
                sceis['Desired_Origination_for_Adjustable_Rate__c'] = armADOVal;
            }else{
                sceis['Desired_Origination_for_Adjustable_Rate__c'] = parseFloat(component.get('v.ADO'));  
            }
            
            sceis['Utilization__c'] = parseFloat(selRec_is.MaxInitialUtilization);          
        	if(marginType == 'Helo'){ //SFDC - 265_new
                var upb1 = parseFloat(selRec_is.UPB);                
                if(upb1 >= 4000000 ){
                    sceis['Unpaid_Principal_Balance__c'] = parseFloat(4000000);
                }else{
                    sceis['Unpaid_Principal_Balance__c'] = parseFloat(selRec_is.UPB);      
                }            	
            }
            else if(marginType == 'HeloArm'){
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
            sceis['HeloArmMargin__c'] = parseFloat(component.get('v.HeloArmMargin'));
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
            "lineOfCredit" : lineOfCredit==''?0.00:parseFloat(lineOfCredit), 
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
            //component.set('v.showSpinner',false);  SFDC-487
            component.set('v.printcounter',0);//SFDC-566
	    component.set('v.capacitycounter',0);
            //SFDC-487 start
            var comm = component.get("v.Environment");
            if(comm == "Community"){
            var ScenarioID = component.get("v.ScenarioID")
            var action2 = component.get("c.SendMailTMP");
            
            console.log('comm',comm);
            action2.setParams({
                "ScenarioID": ScenarioID
            });        
            action2.setCallback(this, function(data) {
                component.set("v.Messages", "Scenario saved, request was sent successfully and will be emailed to you within 5 minutes. If you do not receive it, please check your junk and spam folders. If you cannot locate your scenario package, please contact your AE.");
                component.set("v.showAlert", true);            
                document.getElementById("requestbtn").style.display = "None";
                component.set('v.showSpinner',false); //Helo fix
            });
            $A.enqueueAction(action2);
            
            //SFDC-396
            var action3 = component.get("c.createAETask");
	    action3.setParams({
                "ScenarioID": ScenarioID
            }); 
            action3.setCallback(this,function(){          
            });       
            $A.enqueueAction(action3);
        }
            //SFDC-487 end
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
            "c:StartNewLoanProductContainer",
            
            {
                "ApplicationDate":component.get("v.ApplicationDate"),
                "LoanId":component.get("v.showLoanId"), 
                "fromPopup":false
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

        //different ADO for ARM(min 2500 and max 600)
        var EhvVal = component.get('v.EHV');
        var HUDeof = (EhvVal <= 200000) ? (EhvVal * 0.02) : ((200000 * 0.02) + ((EhvVal - 200000) * 0.01));
        var armADOVal2 = (HUDeof < 2500) ? 2500 : ((HUDeof > 6000) ? 6000 : HUDeof);
        console.log('armADOVal',armADOVal2);
        var armADOVal = 0;
        if(ADOVal > 6000){
            armADOVal = 6000;
        }else if(ADOVal < 2500){
            armADOVal = 2500;
        }else{
            armADOVal = armADOVal2;
        }
        //end of arm ADO Val
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
            var ParseddataHeloArm =[];
            var wsData = data.getReturnValue();
            var wsJson = JSON.parse(wsData);
            console.log('asdfsf',wsJson);            
            wsJson.LoanPrograms.forEach(function(item){
                console.log('item.programname-2-',item.ProgramName);                 
                if(item.ProgramName == 'Home Equity Loan Optimizer' || item.ProgramName == 'Home Equity Loan Optimizer Adjustable' ){
                    console.log('item.programname--',item.ProgramName);
                        component.set('v.isDisplayHelo',true);
                        component.set('v.isDisplayHeloArm',true); 
                        ParseddataHelo = JSON.parse(data.getReturnValue()).LoanPrograms[5].margins;
                        ParseddataHeloArm = JSON.parse(data.getReturnValue()).LoanPrograms[6].margins;
                }
                else{
                    console.log('item.programname--3',item.ProgramName);
                    component.set('v.isDisplayHelo',false);
                    component.set('v.isDisplayHeloArm',false);
                }
            });
            
            console.log('ParseddataHelo --- ',JSON.parse(JSON.stringify(ParseddataHelo)));        
            console.log('ParseddataHeloArm --- ',JSON.parse(JSON.stringify(ParseddataHeloArm)));             
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
                AdjustableParseddata[i].TC = (((pricing-100)*0.01)*AdjustableParseddata[i].MaxInitialUPB) + armADOVal; 
                
                if(component.get('v.ScenarioType')!='FHA Traditional HECM'){
                    //MaxAdditionalFirstYearDraw
                    AdjustableParseddata[i].MFD = (component.get('v.EHV') - AdjustableParseddata[i].PrincipalLimit) + AdjustableParseddata[i].IMIP+ armADOVal +3000;
                    AdjustableParseddata[i].MFD = AdjustableParseddata[i].CashFromBorrower;
                    component.set("v.downPyt",AdjustableParseddata[i].MFD );
                    console.log('down payment not trad', component.get("v.downPyt"));
                }else{
                    
                    AdjustableParseddata[i].MFD    = AdjustableParseddata[i].MaxAdditionalFirstYearDraw;
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
                console.log('fixed pricing value', pricing);
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
                console.log('Parseddata helo  -->'+ ParseddataHelo[i]);
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
                var ecc = ((0.25 * EhvVal)/100);  //estimated closing cost calculation
                console.log('ecc',ecc);
                var ecc1=0;
                if(ecc >= 2500 && ecc <= 10000){ 
                    var ecc1 = ecc;  
                }
                else if(ecc < 2500){
                    var ecc1 = 2500;
                }
                else{
                    var ecc1 = 10000;    
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

            //HELO ARM CALCULATIONS
            for(var i=0;i<ParseddataHeloArm.length;i++){
                var each = ParseddataHeloArm[i];
                console.log('Parseddata heloarm -->'+ ParseddataHeloArm[i]);
                ParseddataHeloArm[i].InterestRate =  parseFloat(ParseddataHeloArm[i].InterestRate).toFixed(3);
                ParseddataHeloArm[i].UPB = parseFloat(ParseddataHeloArm[i].UPB).toFixed(3);
                        console.log('Parseddata[i].InterestRate  -->'+ ParseddataHeloArm[i].InterestRate);
                        console.log('Parseddata[i].upb  -->'+ ParseddataHeloArm[i].UPB);  
                var pricing = 0;
                var pricing1 = 0;
                var pricing2 = 0;
                var heloValues = component.get('v.metadatavaluesHeloArm');
                        console.log('heloArmValues ',heloValues);
                var t =  ParseddataHeloArm[i].InterestRate;
                 
                //use upb local variable for all HELO calcs because it has a cap of 4000000 SFDC-265_new
                var upb1 = ParseddataHeloArm[i].UPB;                
                var upb = 0;
                if(upb1 >= 4000000){
                    var upb = 4000000;
                }
                else{
                    var upb = ParseddataHeloArm[i].UPB;
                } 

                //TC calculation -> Displaying in the Helo table Total Compensation
                pricing = heloValues.HeloArmPrice[t]; //Broker comp price__c
                pricing2 = pricing - 100;
                if(!pricing){
                    pricing = 0
                }else{
                    pricing = ((pricing2 * upb)/100)+ADOVal; // calculation for TC = BrokerComp% * UPB
                            console.log('fixed tc helo cal pricing ',pricing);
                }                
                ParseddataHeloArm[i].TC = pricing; 
				//end TC calculation
				pricing1 = parseFloat(heloValues.HeloArm_orm[t]);
                var cmb = component.get("v.CMB"); //current mortgage balance                 
                var EhvVal = component.get('v.EHV');//estimated home value
                var origToOrm = ((pricing1 * upb)/100); //Origination to One Reverse Mortgage, LLC
                var ecc = ((0.25 * EhvVal)/100);  //estimated closing cost calculation
                console.log('ecc',ecc);
                var ecc1=0;
                if(ecc >= 2500 && ecc <= 10000){ 
                    var ecc1 = ecc;  
                }
                else if(ecc < 2500){
                    var ecc1 = 2500;
                }
                else{
                    var ecc1 = 10000;    
                } 
                
                //Cash at Close calculation -> Helo table Cash At Close/Funds to Close
                if(component.get('v.ScenarioType')=='FHA Traditional HECM'){			
                                 
                    var cashatclose = upb - cmb - ADOVal - ecc1;                    
                    ParseddataHeloArm[i].CC = cashatclose; 
                }else{                    
                    var fundstoclose = ((ecc1 + ADOVal) + EhvVal) - upb;
                 	ParseddataHeloArm[i].CC = fundstoclose;
                }
                
				//end cash at close calculation
				
                //Fetch Service Fee from Metadata table and display on Helo table
                var serviceFee = heloValues.HeloArm_service[t];
                ParseddataHeloArm[i].SF = serviceFee;
				//end service fee            
                
                if(component.get('v.ScenarioType')!='FHA Traditional HECM'){
                    ParseddataHeloArm[i].MFD = (component.get('v.EHV') - upb) +pricing1+ 3000;
                    ParseddataHeloArm[i].MFD = ParseddataHeloArm[i].CashToBorrower;
                                     console.log('MFD 2',ParseddataHeloArm[i].CashToBorrower);
                    component.set("v.downPyt",ParseddataHeloArm[i].MFD);
                }else{
                    ParseddataHeloArm[i].MFD    = 0;
                    console.log('down payment parse helo ', component.get('v.downPyt'));
                }
            }

            try{
                console.log('Parseddata>> ',Parseddata);
                console.log('AdjustableParseddata>> ',AdjustableParseddata);
                component.set("v.FHA_Hecm_FixedMargin",Parseddata);
                component.set("v.FHA_Hecm_HeloMargin",ParseddataHelo);
                component.set("v.FHA_Hecm_HeloMargin_Arm",ParseddataHeloArm);
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
        debugger;
        var labels = ['a','b','c'];
        var insuranceFees = component.get('v.MIP');
        var eof = component.get("v.EOF"); //Origination to ORM
        var ADOVal = component.get('v.ADO');
        console.log('EOF is ',eof);
            var marginType = component.get('v.MarginTypeiS'); //helo        
            var heloEcc = component.get("v.ECC"); //Estimated Closing Costs helo
            console.log('ECC is ',heloEcc); //helo
        if(marginType == 'Helo'){
            var financingFees = eof + heloEcc;  //financing fee for Helo for both refinance and purchase
            var downPyt = component.get('v.cashToClose'); //Down payment for Helo for Purchase
            console.log('helo dwn py',downPyt );
        }else if(marginType == 'HeloArm'){
            var financingFees = ADOVal + heloEcc;  //financing fee for Helo ARM for both refinance and purchase
            var downPyt = component.get('v.cashToClose'); //Down payment for Helo for Purchase
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
            }else if(marginType == 'HeloArm'){
                equity = EhvVal - CmbVal - heloEcc - cashAtClose - ADOVal;
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