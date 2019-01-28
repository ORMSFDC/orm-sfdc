({    
    doinit:function(component, event, helper) { //Helo fix  		  
    },
    scriptsLoaded: function(component, event, helper) {
		//alert('scipts loaded');
        var action = component.get("c.get_metadataValues");
        action.setParams({ //Bala
            'Tieris':component.get('v.Tier_Value')           
        });        
              
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state ',state);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                component.set("v.metadatavalues",storeResponse[0]);
                component.set("v.metadatavaluesFixed",storeResponse[1]);
                component.set("v.metadatavaluesHelo",storeResponse[2]); //Helo                
                helper.getserviceData(component, event, helper);
            }           
        });
        // enqueue the Action  
        $A.enqueueAction(action); 
        
        //get states
        var action1 = component.get("c.get_states");       
        // set a callBack    
        action1.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.states_list",response.getReturnValue());                
            }            
        });
        // enqueue the Action  
        $A.enqueueAction(action1); 
        
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
    // function for clear the Record Selaction 
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
        component.set("v.showAlert", false);
        component.set("v.showError", false);
        if (commentsControlvalue == '') {
            var newselectedRecord = {
                'sobjectType': 'Lead',
                'FirstName': '',
                'LastName': '',
                'street': '',
                'State': '',
                'postalcode': '',
                'email': '',
                'phone': '',
                'City':''
            };
            //resetting the Values in the form
            component.set("v.selectedRecord", newselectedRecord);          
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
        component.set('{v.showSpinner}',false);
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible: true });
        evt.fire();
    },
    //Assign value to get in ClientCMP
    getValueFromLoanCalculator: function(cmp, event, helper) {        
        helper.getserviceData(cmp, event, helper);
    },
    //For New Scenario
    reset: function(component, event, helper) {   
        //   alert('ClientInfo cmp reset');
        //  alert();
        $A.get('e.force:refreshView').fire();
    },
    //For Request Package  SFDC - 487 commented this
    /*sendmailrequest: function (component, event, helper) {
        component.set('v.showSpinner',true); //Helo fix
        var ScenarioID = component.get("v.ScenarioID")
        var action2 = component.get("c.SendMailTMP");
        console.log('email sent');
        action2.setParams({
            "ScenarioID": ScenarioID
        });        
        action2.setCallback(this, function(data) {
            component.set("v.Messages", "Request sent successfully and will be emailed to you within 5 minutes. If you do not receive it, please check your junk and spam folders. If you cannot locate your scenario package, please contact your AE.");
            component.set("v.showAlert", true);            
            document.getElementById("requestbtn").style.display = "None";
            component.set('v.showSpinner',false); //Helo fix
        });
        $A.enqueueAction(action2);
        
        //Task for AE, added by Bala
        var action = component.get("c.createAETask");
        action.setCallback(this,function(){          
        });       
        $A.enqueueAction(action);
        
    }, */  
    //Validate Form and SAve Scenario
    Save: function(component, event, helper) {        
        var msg = "";
        var reg = '';
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();
        function validateRequiredField(value) {          
            if ($A.util.isEmpty(value))
            {
                return false; 
            }
            else
            {
                return true;
            }            
        }
        var valArray = [
            { ar_id: "inputFName", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputLName", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputAddress", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputZip", mes: "This is a required field.", reg: validateRequiredField },
            //Code Added by Dev4 for ORMSFDC-1447
            { ar_id: "SelectState", mes: "Please select a value for this field.", reg: validateRequiredField }
            //Code Ended by Dev4 for ORMSFDC-1447
        ];         
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);  
        
        var Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id) ;
        var chkZip=helper.ValidZip(component, event, helper,'inputZip');
        var IsemailPhoneWrong=helper.EmailOrPhoneRequired(component, event, helper);
        var IsValidEmail= helper.EmailValidation(component, event, helper);
        var IsValidPhone= helper.FormatPhonehelper(component, event, helper); //SFDC-378
        //  debugger;
        if (Isrequired ||chkZip|| IsemailPhoneWrong || IsValidEmail || IsValidPhone) {   //SFDC-378           
            component.set("v.showError", true); 
            if(IsemailPhoneWrong)
            {
                component.set("v.EmailPhoneMessages","Please enter either Email or Phone Number.");
                component.set("v.EmailMessage",""); //SFDC-378, email error
            }
            else{
                component.set("v.EmailPhoneMessages","");
                if(IsValidEmail)
                {
                    component.set("v.EmailPhoneMessages",""); 
                    component.set("v.EmailMessage","Please enter a valid email address"); //SFDC-378, email error
                }
                else{
                    component.set("v.EmailPhoneMessages","");
                    component.set("v.EmailMessage",""); //SFDC-378, email error
                }
            }
        }        
        else
        { 
            var sZip=component.get('v.stateZip');
            //SFDC-363
            var sZip2=component.get('v.stateZip2'); //Helo Refi Error
            var sZip3=component.get('v.stateZip3'); //Helo Purchase error
            var sZip4=component.get('v.stateZip4'); //HECM Purchase error
            var sZip5=component.get('v.stateZip5'); //HECM Refi error
            if(sZip==false && sZip2==false && sZip3==false && sZip4 ==false && sZip5 ==false)
            {
                helper.SaveScenario(component,event,helper);
            }
            else
            {
                component.set("v.showError", true);   
            }
            
        }    
    },
    //Validate PhoneFormat
    FormatPhone: function(component, event, helper){
        helper.FormatPhonehelper(component, event, helper);        
    },
    //Phone Number Should not start with Zero(0)
    RestrictZeroInAlternatePhoneFirstTime:function(component, event, helper) {
        var inz = 'v.selectedRecord.Phone';        
        helper.RestrictZeroInPhoneFirstTime(component, event, helper,inz);     
    },  
    get_loanFor_margin :function(component, event, helper){
        //   debugger;
        component.set("v.rerender_section",false);
        component.set("v.showAlert", false);                
        component.set("v.selectedRecord.FirstName","");
        component.set("v.selectedRecord.Phone","");
        component.set("v.selectedRecord.LastName","");
        component.set("v.selectedRecord.Street","");
        component.set("v.selectedRecord.PostalCode","");
        component.set("v.selectedRecord.Email","");
	//SFDC-363
	component.set("v.stateZip",false);
        component.set("v.stateZip2",false);
        component.set("v.stateZip3",false);
        component.set("v.stateZip4",false);
        component.set("v.stateZip5",false);
        // Code Added by Dev4 for ORMSFDC-1447
        component.set("v.selectedRecord.State","");
        component.set("v.showError",false);
        //Code Ended by Dev4 for ORMSFDC-1447
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset.type.toLowerCase();
        
        console.log('recId ', component.get('v.recId'));
        component.set('v.downPyt',selectedItem.dataset.mfd);
        var selId = event.currentTarget.id;
        
        var alm = selId;
        document.getElementById("GRA").style.display = "BLOCK";
        document.getElementById("clientdiv").style.display = "BLOCK";
        document.getElementById("CashFlow").style.display = "BLOCK";      
        document.getElementById("LOCandCashFlow").style.display = "BLOCK";         
        
        var AdjustMargins = component.get('v.FHA_Hecm_AdjustableMargin');
        var FixedMargins = component.get('v.FHA_Hecm_FixedMargin');
        var HeloMargins = component.get('v.FHA_Hecm_HeloMargin'); //Bala 7_15
        
        if(recId == 'adjust'){   
            component.set('v.selectedRowIs',AdjustMargins[selId]);//BalaC1
            				console.log('adjust sel row',AdjustMargins[selId]);
            component.set('v.LRateType','ARM');                     
            component.set('v.MarginTypeiS','Adjust');
            component.set('v.MarginType','Margin');
            component.set("v.Index", AdjustMargins[selId].Index);
            component.set("v.Margin", AdjustMargins[selId].Margin);
            component.set("v.MIP", AdjustMargins[selId].IMIP);
            component.set("v.EOF",AdjustMargins[selId].MaxOrigFee);
            component.set("v.ECC",AdjustMargins[selId].OtherClosingCosts);
            component.set("v.TotalAmountAvailable",AdjustMargins[selId].PrincipalLimit);
            component.set("v.FirstAmount",AdjustMargins[selId].MaxAdditionalFirstYearDraw);
            component.set('v.CF1MA',component.get('v.MMP')*(1*12));
            component.set('v.CF5MA',component.get('v.MMP')*(5*12));
            component.set('v.CF10MA',component.get('v.MMP')*(10*12));
            var ADOVal = component.get('v.ADO'); 
            component.set("v.EOF",ADOVal);
            component.set("v.TotalAmountAvailableLoc", AdjustMargins[selId].SecondYearAvailableFunds);
            component.set("v.typeOfEOF", 'Desired Origination for Adjustable Rate Product');
            
            //    component.set('v.initialLOC',)
        }else if(recId == 'fixed'){                       
            component.set('v.selectedRowIs',FixedMargins[selId]); //BalaC1
            			console.log('fixed sel row',FixedMargins[selId]);
            component.set('v.MarginTypeiS','Fixed');            
            component.set('v.LRateType','Fixed');
            component.set('v.MarginType','Rate');
            component.set("v.Index", FixedMargins[selId].IndexValue);
            component.set("v.Margin", FixedMargins[selId].ExpectedRate);
            component.set("v.MIP", FixedMargins[selId].IMIP);
            var fixedValues = component.get('v.metadatavaluesFixed');                     
            var t =  FixedMargins[selId].ExpectedRate;
            var pricing = fixedValues.fixed_orm[t];
            var ADOVal = component.get('v.ADO'); 
            component.set("v.TotalAmountAvailableLoc", 0);            
            var EhvVal 		= component.get('v.EHV'); 
            var HUDeof 		=(EhvVal <=200000)?(EhvVal *0.02):((200000 *0.02) + ((EhvVal-200000)*0.01));
            var origToOrm	= pricing;
            var finalEOF 	=(origToOrm > HUDeof)?HUDeof: origToOrm;
            var finalEOF1 = (finalEOF < 2500) ? finalEOF:((finalEOF>6000)?6000:finalEOF);
            component.set("v.EOF",finalEOF1);
            component.set("v.typeOfEOF",'Origination to One Reverse Mortgage, LLC');
            component.set("v.ECC",FixedMargins[selId].OtherClosingCosts);
            component.set("v.TotalAmountAvailable",FixedMargins[selId].PrincipalLimit);
            component.set("v.FirstAmount",FixedMargins[selId].MaxAdditionalFirstYearDraw);            
            component.set('v.CF1MA',component.get('v.MMP')*(1*12));
            component.set('v.CF5MA',component.get('v.MMP')*(5*12));
            component.set('v.CF10MA',component.get('v.MMP')*(10*12));
        }
       else {         //Helo onClick events              
           component.set('v.selectedRowIs',HeloMargins[selId]);
           console.log('Helo SelectedRow',component.get('v.selectedRowIs'));
           component.set('v.LRateType','Helo');
           component.set('v.MarginTypeiS','Helo');
           component.set('v.MarginType','Rate');  //Helo Interst Rate
           component.set("v.Index", HeloMargins[selId].Index);  //Helo Index  
           component.set("v.MIP", 0); //There is no MIP for Helo
           component.set("v.HeloMargin",HeloMargins[selId].Margin); //Helo Margin new
           var heloValues = component.get('v.metadatavaluesHelo');
           console.log('Helo values',heloValues);            
           var t =  HeloMargins[selId].InterestRate; 
           var rate = heloValues.Helo_rate[t];
           component.set("v.Margin",rate); //Helo Interst Rate
           var pricing = heloValues.Helo_orm[t];  
           console.log('pricing helo val', pricing );
           var ADOVal = component.get('v.ADO'); // Desired Origination Value
           console.log('ADOVal Helo', ADOVal);
           component.set("v.TotalAmountAvailableLoc", 0);   
           var EhvVal = component.get('v.EHV'); 
           
           //use upb local variable for all HELO calcs because it has a cap of 4000000 SFDC-265_new
           var upb1 = HeloMargins[selId].UPB;
           var upb = 0;
           if(upb1 >= 4000000){
               var upb = 4000000;
           }else{
               var upb = HeloMargins[selId].UPB;
           }

           //Origination to ORM calc
           var origToOrm = ((upb * pricing)/100) ;
           console.log('oorm', origToOrm );
           component.set("v.EOF",origToOrm);           
           component.set("v.typeOfEOF",'Origination to One Reverse Mortgage, LLC');
           console.log('estimated Origination for fixed ', component.get('v.EOF'));
           //end of OORM calc
           
           //Other Estimated closing costs calc
           var ecc = ((0.25 * EhvVal)/100);  
           console.log('ecc',ecc);
           var ecc1 = 0;
           if(ecc >= 2500 && ecc <= 10000){ //.5% of Home value or purchase price with a floor of $2,500 and a cap of $15,000
               component.set("v.ECC",ecc);  
               var ecc1 = ecc;
           }
           else if(ecc < 2500){
               component.set("v.ECC",2500);
               var ecc1 = 2500;
           }
           else{
               component.set("v.ECC",10000);    
               var ecc1 = 10000;
           }
           //end of ECC calc
           
           //Helo Amount Available after Lien payoff & Funds needed to close calc
           var cmb = component.get("v.CMB"); //current mortgage balance
           var amtAvail = upb - cmb - origToOrm - ecc1;
           if (amtAvail < 0){
               component.set("v.FirstAmount",0);
               var amtAvail1 = amtAvail*-1;
               component.set("v.cashToClose",amtAvail1);
               console.log('@@@',amtAvail1);
           }
           else{
               component.set("v.FirstAmount",amtAvail);
               component.set("v.cashToClose",0);
           }           
           //end of amt avail calc
           
           //use Principal limit local variable for all HELO calcs because it has a cap of 4000000 SFDC-265
           var pl1 = HeloMargins[selId].PrincipalLimit;
           var pl = 0;
           if(pl1 >= 4000000){
               var pl = 4000000;
           }else{
               var pl = pl1;
           }
           component.set("v.TotalAmountAvailable",pl); //265
           component.set('v.CF1MA',component.get('v.MMP')*(1*12));
           component.set('v.CF5MA',component.get('v.MMP')*(5*12));
           component.set('v.CF10MA',component.get('v.MMP')*(10*12));
        }
         debugger; 
        //Funds needed to Close calculations
        //for traditional loan
        if(component.get('v.isTraditional')){ //SFDC-232
            component.set('v.LMortgageAppliedFor', 'FHA Traditional HECM');
            if (recId == 'adjust') {
                if (AdjustMargins[selId].MaxAdditionalFirstYearDraw >= 0) {
                    component.set('v.cashToClose', AdjustMargins[selId].CashFromBorrower);
                } else {
                    //component.set('v.cashToClose',AdjustMargins[selId].MaxAdditionalFirstYearDraw*-1);
                    component.set('v.cashToClose', AdjustMargins[selId].CashFromBorrower * -1);
                }
            }
            else if(recId == 'fixed'){
                if(FixedMargins[selId].MaxAdditionalFirstYearDraw >= 0 ){
                    component.set('v.cashToClose', FixedMargins[selId].CashFromBorrower);
                }else{
                    component.set('v.cashToClose', FixedMargins[selId].CashFromBorrower*-1);
                }
            } //end SFDC-232
            //for Purchase
        } else {
            component.set('v.LMortgageAppliedFor', 'HECM for Purchase');
            if (recId == 'adjust') {
                component.set('v.PrincipalLimitIs', AdjustMargins[selId].PrincipalLimit);
                var pfnc = AdjustMargins[selId].CashFromBorrower;
                component.set('v.cashToClose', pfnc);
            } else if (recId == 'fixed') {
                component.set('v.PrincipalLimitIs', FixedMargins[selId].PrincipalLimit);
                var pfnc = FixedMargins[selId].CashFromBorrower;
                component.set('v.cashToClose', pfnc);
            }else if(recId =='fixed'){
                component.set('v.PrincipalLimitIs',FixedMargins[selId].PrincipalLimit);
                var pfnc = FixedMargins[selId].CashFromBorrower ;
                component.set('v.cashToClose',pfnc);
                console.log('pfnc fixed',pfnc);
            }
            else { //Helo
                component.set('v.PrincipalLimitIs',pl); //265
                var pfnc = ((ecc1 + origToOrm) + EhvVal) - upb;
                component.set('v.cashToClose',pfnc);
                console.log('pfnc Helo',pfnc);
            }
        } //End of FNC, CAC calc 
       
        helper.generate_pieChart(component,event,helper); 
        $('.each_row').css('background-color','white').css('color','black');
        var selRowIS = 'row_'+recId+'_'+selId;
        console.log('selRowIS ',selRowIS);
        $('.'+selRowIS).css('background-color','blue').css('color','white');
        
        var p = $("#LOCandCashFlow");
        var offset = p.offset();
        var yaxis=offset.top-200;
        window.scroll(0, yaxis);
        //  var selectedMargin = component.get("v.Margins")[parseInt(selId)];
        // alert('selectedMargin-->'+selectedMargin);
        //console.log(selectedMargin);
        //   console.log('selectedMargin---Controller--> ',selectedMargin.initialPrincipalLimit);
        /* var ini  =selectedMargin.initialLOC;
        if(ini<0){
            ini = 0;
        }
        component.set("v.FirstAmount",ini);
        
        var lien = selectedMargin.initialLOC;//prsn
        var initPri = parseFloat(selectedMargin.initialPrincipalLimit.replace(',','').replace(',','').replace(',',''));
        component.set("v.TotalAmountAvailable",initPri);
        console.log('initPri---',initPri);
        
        var almis = ''+selectedMargin.lendersMargin;
        component.set('v.Scenarioindex',alm);//prsn
        helper.hlperscriptsLoaded(component, event, helper,almis,lien);//prsn
        */
    },
    shw_capacityPopup : function(component, event, helper){
        //    alert('ClientInfo cmp shw_capacityPopup');
        component.set("v.client_info_header","Enter Client Information");
        
        component.set('v.TA',null);
        component.set('v.TMI',null);
        component.set('v.TML',null);
        component.set('v.MTI',null);
        component.set('v.SFT',null);
        var res = {};
        res['CashFlow'] = '';
        res['TotalCapacity'] = '';
        res['RequiredCashFlow'] = '';
        res['CapacityStorage'] = '';
        component.set("v.Respon",res);
        
        // component.set("v.senario_id",null);
        component.set('v.HHM',null);
        component.set("v.show_capacityform",true);        
        component.set("v.show_capacity_Popup",true);
	
     	var counterval = component.get('v.capacitycounter')+1;
        var action = component.get("c.getcapacityCount");
        action.setParams({
            scenarioID:component.get("v.senario_id"),
            runcounterval: counterval
        });
        
        action.setCallback(this,function(data){            
            component.set("v.capacitycounter",counterval);            
        });
        $A.enqueueAction(action);
    },
    shw_capacityPopupClose : function(component, event, helper){
        //   alert('ClientInfo shw_capacityPopupClose ');
        component.set("v.show_capacity_Popup",false);
        component.set("v.capacity_qualified",fasle);
        component.set("v.show_capacityform",true);
    },
    run_capacity:function(component, event, helper){
        //    alert('ClientInfo run_capacity ');
        var isValidated = true;//'amount_TMI','amount_TA',
        var required_fields = ['num_HHM','amount_TML','amount_MTI','num_SFT'];
        var required_fieldsNew=  ['amount_TMI','amount_TA'];
        for(var i=0;i<required_fields.length;i++){
            var inputCmp = component.find(required_fields[i]);
            var value = inputCmp.get("v.value");
            if (value !='' && value != undefined) {
                inputCmp.set("v.errors", null);
            } else {
                isValidated  = false;
                inputCmp.set("v.errors", [{message:"This is a required field" }]);                
            }
        }
        if((component.find(required_fieldsNew[0]).get("v.value")=='0' || component.find(required_fieldsNew[0]).get("v.value")==null || component.find(required_fieldsNew[0]).get("v.value")==undefined ) && ( component.find(required_fieldsNew[1]).get("v.value")=='0' || component.find(required_fieldsNew[1]).get("v.value")==null || component.find(required_fieldsNew[1]).get("v.value")==undefined)){
            isValidated  = false;
            component.find(required_fieldsNew[0]).set("v.errors", [{message:"This is a required field" }]);
            component.find(required_fieldsNew[1]).set("v.errors", [{message:"This is a required field" }]);
            
        }
        if(isValidated){ 
            debugger; 
            // alert(component.get("v.senario_id"));
            var action= component.get("c.getCashFlowData");
            action.setParams({
                MonthlyAssetIncome:component.get('v.TA'),
                MonthlyIncome:component.get('v.TMI'),
                MonthlyExpense:component.get('v.TML'),
                MonthlyPropertyCharge:component.get('v.MTI'),
                MonthlyMaintenance:component.get('v.SFT'),
                senarioid:component.get("v.senario_id"),
                Household_Members:component.get('v.HHM')
            });
            // alert();
            action.setCallback(this, function(response) {
                var state = response.getState();
                //    alert(state);
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    console.log('return data ',storeResponse);
                    component.set("v.Respon",storeResponse);
                    component.set("v.client_info_header","Results");
                    
                    component.set("v.show_capacityform",false);
                    component.set("v.capacity_qualified",true);
                    
                    if(storeResponse.CashFlow.toString().indexOf("(") != -1)
                    {
                        helper.applyCSS(component, event, helper,'CashFlowVal');
                        
                    }        
                    if(storeResponse.TotalCapacity.toString().indexOf("(") != -1 )
                    {
                        component.set("v.capacity_qualified",false);
                        helper.applyCSS(component, event, helper,'TotalCapacityVal');                
                    }
                    
                    /* SFDC-207
                    //code to remove the brackets
                    if(component.get("v.capacity_qualified")){
                        storeResponse.CashFlow = storeResponse.CashFlow.replace('(','').replace(')','');
                        
                        storeResponse.CapacityStorage = storeResponse.CapacityStorage.replace('(','').replace(')','');
                        
                        console.log('storeResponse.CapacityStorage ',storeResponse.CapacityStorage);
                    }
                    */
                    
                    // SFDC-207
                    if(storeResponse.CapacityStorage.toString().indexOf("(") != -1 )
                    {
                        component.set("v.capacity_qualified",false);
                        helper.applyCSS(component, event, helper,'CapacityShortageVal');                
                    }
                }            
            });
            // enqueue the Action  
            $A.enqueueAction(action);
        }
    },
    
    //For SaNL SFDC - 487 
    Start_newloan2: function (component, event, helper) { 
        component.set("v.render_popup", true);
    },

    //SFDC-567
    start_newloan:function(component){        
        component.set('v.showSpinnerLoan',true);
        var getdate = component.get("v.ApplicationDate");
        
        var fileInput = document.getElementById('fileInput').value;        
        console.log('fileInput ',fileInput);
        var applicationDate = getdate;
        //Check whether File is selected or not
        if (!$A.util.isEmpty(fileInput))
        {
            var fileInput = component.find("file").getElement();
            var file = fileInput.files[0];
            var data=component.get("v.filedata");
            
            var dd=document.getElementById('inputtxt').value;
            var action = component.get("c.getFNMData");
            action.setParams({
                "filedata" : dd,
                fileName: file.name,
                base64Data: encodeURIComponent(data), 
                contentType: file.type,
                applicationDate: applicationDate,
                senario_id:component.get("v.senario_id"),
                hhm:component.get('v.HHM'),
                sft:component.get('v.SFT')                
            });            
            action.setCallback(this, function(a) {                
                component.set('v.showSpinnerLoan',false);
                var errors = action.getError();
                //alert(errors);
                if (errors && errors[0]) {                    
                    console.error("getFNMData error", errors);
                    // display error in toast
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "mode": "sticky",
                        "title": "Upload Failed!",
                        "message": errors[0].message
                    });
                    toastEvent.fire();                    
                    // hide loading spinner
                    var spinner = component.find("spinner");
                    $A.util.toggleClass(spinner, "slds-hide");
                    
                } else {
                    var Id = a.getReturnValue();
                    component.set("v.myBool",true);
                    component.set("v.showLoanId",Id);
                    component.set("v.render_popup",false);
                    component.set("v.showLoan",true);
                    component.set("v.displayTab",false);                    
                }
            });
            $A.enqueueAction(action);
            
        }
        else
        {   
            var action = component.get("c.createLoan");
            action.setParams({
                senarioid:component.get("v.senario_id"),
                hhm:component.get('v.HHM'),
                sft:component.get('v.SFT')
            });
            
            action.setCallback(this,function(data){
                
                component.set('v.showSpinnerLoan',false);
                component.set("v.showLoanId",data.getReturnValue().Id);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": data.getReturnValue().Name + " is Created."
                });
                toastEvent.fire();
                component.set("v.render_popup",false);
                component.set("v.showLoan",true);
                component.set("v.displayTab",false);
                
            });
            $A.enqueueAction(action);
        }
    },    
    openchk : function(component, event, helper) {
        //   alert('ClientInfo cmp openchk');
        
        var t = component.get("v.isOpen_c");
        
        var m = component.find("checkbox1");
        m.set("v.disabled",false);
        
        var a = component.find("file");
        var b = component.find("btn");
        var t = component.get("v.isOpen_c");
        
        var s = component.get("v.isOpen_c1");
        
        if (t == true && s == true ) {
            a.set("v.disabled",false);
            component.set("v.fileupload",false);
            //  b.set("v.disabled",false);  
            component.set("v.isDisabled",false);
        }
        else {
            a.set("v.disabled",true);
            component.set("v.fileupload",true);
            //b.set("v.disabled",true); 
            component.set("v.isDisabled",true);
        }
        
        
    },
    openchk1 : function(component, event, helper) {
        //    alert('ClientInfo cmp openchk1');
        
        //component.set("v.isOpen_c1",true);
        var a = component.find("file");
        //var b = component.find("btn");
        var t = component.get("v.isOpen_c");
        
        var s = component.get("v.isOpen_c1");
        
        if (t == true && s == true ) {
            a.set("v.disabled",false);
            component.set("v.fileupload",false);
            //  b.set("v.disabled",false);  
            component.set("v.isDisabled",false);
        }
        else {
            a.set("v.disabled",true);
            component.set("v.fileupload",true);
            //b.set("v.disabled",true); 
            component.set("v.isDisabled",true);
        }
        
    },
    myAction : function(component, event, helper) {
        //    alert('ClientInfo cmp myAction');
        
        component.set("v.isDisabled",false);
        document.getElementById("error").innerHTML = "";        
        var validDate = true;        
        component.set("v.isOpen_c",false);
        component.set("v.isOpen_c1",false);
        component.set("v.fileupload",true);        
        var findid = component.find("expname");
        var getdate = findid.get("v.value");
        //      alert("value is: " + getdate);
        component.set("v.ApplicationDate",''+getdate);
        console.log(getdate);        
        if ($A.util.isEmpty(getdate)){
            validDate = false;
            console.log("no val");            
        }
        else {            
            var year=getdate.substring(0,4);         
            var month=getdate.substring(5,7);         
            var day=getdate.substring(8,10); 
            getdate=month+'/'+day+'/'+year;
            var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/ ;
            if(!(date_regex.test(getdate)))
            {
                document.getElementById("error").innerHTML = "Please enter a valid date format in MM/DD/YYYY!"
                component.set("v.isOpen",false);
                
                component.set("v.isDisabled",true);
            }
            else
            {
                var currdate = new Date();
                var mydate = new Date(getdate);
                if (currdate.getTime() < mydate.getTime()){
                    component.set("v.text","We apologize for the inconvenience. Date cannot be in future. Please enter a valid date.");   
                    component.set("v.isOpen",false);
                    
                    component.set("v.isDisabled",true);
                }
                else
                {
                    var timeDiff = Math.abs(currdate.getTime() - mydate.getTime());
                    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                    console.log("day difference is: " + diffDays);
                    if (diffDays > 3){
                        component.set("v.text","We apologize for the inconvenience. One Reverse Mortgage Services requires 1 day to send out Good Faith\nEstimate to meet regulatory requirements and the date you selected exceeds the tolerance.");  
                        component.set("v.isOpen",false);
                        
                        component.set("v.isDisabled",true);
                    }
                    else
                    {
                        component.set("v.text",""); 
                        component.set("v.isOpen",true);
                        
                        component.set("v.isDisabled",false);
                    }
                }
            }
        }
        
    },
    
    BindData : function(component, event, helper) {  
        //    alert('ClientInfo cmp BindData');
        
        var jsondata='';
        var fileInput = document.getElementById('fileInput');        
        var inputtxtid = document.getElementById('inputtxt');
        var file = fileInput.files[0];
        var reader = new FileReader();
        reader.onload = function(e) {          
            jsondata='{"IncludeFields": true,"ValidateOnly": false,"AddressValidationLevel": "None","TenOhThree": "'+reader.result+'"}';
            document.getElementById('inputtxt').value = jsondata;
        }
        reader.readAsText(file);
        var fr1 = new FileReader();
        fr1.onload = function() {
            var fileContents = fr1.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            component.set("v.filedata",fileContents);            
        };
        fr1.readAsDataURL(file); 
    },
    checkZip : function(component, event, helper){
        //    alert('ClientInfo cmp checkZip');
        //  alert(component.get('v.selectedRecord.PostalCode'));
        var val=component.get('v.selectedRecord.PostalCode');//component.find("inputZip").get("v.value");
        //   alert(val);
        var lan=val.length;
        //   debugger;
        if(lan==5)
        {
            var action = component.get("c.getZipData");  
            action.setParams({
                "ZIP": val
            });
            action.setCallback(this, function(data) {
                debugger;
                var result=data.getReturnValue(); 
                console.log('states ',result);
                var n=result.length; 
                if(n!=0)
                {
                    var state=result[0];
                    var city=result[1];
                   
                    //SFDC-275 start
                    var rateType = component.get('v.LRateType'); 
                    var mortType = component.get("v.LMortgageAppliedFor");
                    //Helo Purchase states
                    if (rateType == 'Helo' && mortType == 'HECM for Purchase'){ 
                        var action1 = component.get("c.get_heloStatesPur");                         
                    }
                    //Helo Refinance States
                    else if (rateType == 'Helo' && mortType == 'FHA Traditional HECM'){ 
                        var action1 = component.get("c.get_helostatesRefi");
                    }
                    //ARM and Fixed Purchase states
                    else if((rateType == 'ARM' && mortType == 'HECM for Purchase') || (rateType == 'Fixed' && mortType == 'HECM for Purchase')){ 
                        var action1 = component.get("c.get_statesPur");
                    }
                    //ARM and Fixed Refinance states
                    else if((rateType == 'ARM' && mortType == 'FHA Traditional HECM') || (rateType == 'Fixed' && mortType == 'FHA Traditional HECM')){ 
                        var action1 = component.get("c.get_states");
                    }
                    //SFDC-275 end
                    action1.setCallback(this,function(data){
                        var result1=data.getReturnValue();
                        var i;
                        console.log('states 1 ',result1);
                        
                        for(i=0;i<result1.length;i++)
                        {     
                            if(result[0]==result1[i])
                            {   
                                
                                component.set("v.selectedRecord.State",state);
                                component.set("v.selectedRecord.City",city);
                                
                                component.set("v.stateZip",false);
                                //SFDC-363
                                component.set("v.stateZip2",false);
                                component.set("v.stateZip3",false);
                                component.set("v.stateZip4",false);
                                component.set("v.stateZip5",false);
                                break;
                            }else{                                
                                component.set("v.selectedRecord.State","");
                                component.set("v.selectedRecord.City","");
                                component.set("v.stateZip",true);
                                //SFDC-363
                                if (rateType == 'Helo' && mortType == 'FHA Traditional HECM'){
                                    component.set("v.stateZip2",true);
                                    component.set("v.stateZip",false);
                                }else if (rateType == 'Helo' && mortType == 'HECM for Purchase'){ 
                                    component.set("v.stateZip3",true);
                                    component.set("v.stateZip",false);
                                }
                                else if((rateType == 'ARM' && mortType == 'HECM for Purchase') || (rateType == 'Fixed' && mortType == 'HECM for Purchase')){
                                    component.set("v.stateZip4",true);
                                    component.set("v.stateZip",false);
                                }
                                else if((rateType == 'ARM' && mortType == 'FHA Traditional HECM') || (rateType == 'Fixed' && mortType == 'FHA Traditional HECM')){
                                    component.set("v.stateZip5",true);
                                    component.set("v.stateZip",false);
                                }
                                //SFDC-363
                            }
                        }
                        
                    });
                    $A.enqueueAction(action1);          
                }
                else
                {
                    component.set("v.stateZip",true);
                    //SFDC-363
                    component.set("v.stateZip2",false);
                    component.set("v.stateZip3",false);
                    component.set("v.stateZip4",false);
                    component.set("v.stateZip5",false);                    
                }
                
            });
            $A.enqueueAction(action);
        }
        else
        {
            component.set("v.stateZip",false);
            //SFDC-363
            component.set("v.stateZip2",false);
            component.set("v.stateZip3",false);
            component.set("v.stateZip4",false);
            component.set("v.stateZip5",false);
        }
    },
    share_popup:function(component, event, helper){
        //  alert();
        component.set("v.show_sharing_popup",true);
    },
    
    //prsn
    printDocument: function(component, event, helper){
        var host = window.location.hostname;
        var frameSrc = 'https://' + host + '/apex/pdfSavedScenario?id=' + component.get('v.ScenarioID');
        window.open(frameSrc, '_blank'); 
       
        //SFDC-566
        var counterval = component.get('v.printcounter')+1;
        var action = component.get("c.getPrintCount");
        action.setParams({
            scenarioID:component.get("v.senario_id"),
            countval: counterval
        });        
        action.setCallback(this,function(data){            
            component.set("v.printcounter",counterval);            
        });
        $A.enqueueAction(action);
        //SFDC-566 end
    },
    getserviceData :function(component,event,helper){
        //    alert('ClientInfo cmp getserviceData');
        helper.getserviceData(component,event,helper);
    },
    optionChanged:function(component, event, helper){
        //    alert('ClientInfo cmp optionChanged');
        //   helper.optionChanged(component, event, helper);
    }
})
