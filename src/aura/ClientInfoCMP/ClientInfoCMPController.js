({    
    scriptsLoaded: function(component, event, helper) {
        //   alert('123');
        var action = component.get("c.get_metadataValues");
        
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse ',storeResponse);
                component.set("v.metadatavalues",storeResponse);
                helper.do_margins_call(component, event, helper);
                
            }            
        });
        // enqueue the Action  
        $A.enqueueAction(action); 
        
        
        
        //get states
             var action1 = component.get("c.get_states");
        
        // set a callBack    
        action1.setCallback(this, function(response) {
          //  var state = response.getState();
          console.log('>>>>> ',response.getState());
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
        // alert(commentsControlvalue);        
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
       // alert()
        console.log('selectedAccountGetFromEvent ',selectedAccountGetFromEvent);
        console.log('f name ',selectedAccountGetFromEvent.FirstName);
        console.log('L name ',selectedAccountGetFromEvent.LastName);
        console.log('street ',selectedAccountGetFromEvent.street);
         console.log('email ',selectedAccountGetFromEvent.email);
         console.log('postal code ',selectedAccountGetFromEvent.postalcode);
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
    //Assign value to get in ClientCMP
    getValueFromLoanCalculator: function(cmp, event, helper) {
        var DobVal = event.getParam("DOBE");  
       // alert('>> in event ',DobVal);
        var EhvVal = event.getParam("EHVE");
        var CmbVal = event.getParam("CMBE");  
        var CFYVal = event.getParam("CFYE");  
        var CmirVal = event.getParam("CMIRE");
        var MmpVal = event.getParam("MMPE");   
        var EOFis;
        if(EhvVal<=200000){
        EOFis= EhvVal *0.02;
        }else{
            
        EOFis= (200000 *0.02) + ((EhvVal-200000)*0.01);
            
        }   
        var finalEOF;
        debugger;
        if(EOFis<2500){
            
            finalEOF  = 2500;
        }else if(EOFis>6000) {
            
            finalEOF  = 6000;
        }else{
            
            finalEOF = EOFis;
        }
        var rere = 'Date of birth' + DobVal + 'House Value' + EhvVal + 'CMB Value' + CmbVal + 'CFY Value' + CFYVal +'CMIR Value' + CmirVal + 'MMP Value' + MmpVal;
       //alert('vere-->');
        cmp.set("v.outputlbl", rere);
        cmp.set("v.DOB", DobVal);
        cmp.set("v.EHV", EhvVal);
        cmp.set("v.CMB", CmbVal);
        cmp.set("v.CFY", CFYVal);
        cmp.set("v.CMIR", CmirVal);
        cmp.set("v.MMP", MmpVal);   
        cmp.set("v.EOF",finalEOF);
    },
    //For New Scenario
    reset: function(component, event, helper) {   
        //  alert();
        $A.get('e.force:refreshView').fire();
    },
    //For Request Package
    sendmailrequest: function(component, event, helper) {
        alert('mail send');
        var ScenarioID = component.get("v.ScenarioID")
        var action = component.get("c.SendMailTMP");
        action.setParams({
            "ScenarioID": ScenarioID
        });        
        action.setCallback(this, function(data) {
            //  console.log(data.getReturnvalue());
            component.set("v.Messages", "Request Sent Successfully");
            component.set("v.showAlert", true);            
            document.getElementById("requestbtn").style.display = "None";
        });
        $A.enqueueAction(action);
        
        //Task for AE, added by Bala
        var action = component.get("c.createAETask");
        action.setCallback(this,function(){          
          alert(getReturnValue());            
        });       
        $A.enqueueAction(action);
        
    },  
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
        debugger;
      //  alert(chkZip);
        if (Isrequired ||chkZip|| IsemailPhoneWrong || IsValidEmail) {              
            component.set("v.showError", true); 
            if(IsemailPhoneWrong)
            {
                component.set("v.EmailPhoneMessages","Please enter either Email or Phone Number.");
            }
            else{
                component.set("v.EmailPhoneMessages","");
                if(IsValidEmail)
                {
                    component.set("v.EmailPhoneMessages",""); 
                }
                else{
                    component.set("v.EmailPhoneMessages","");
                }
            }
        }        
        else
        { 
            var sZip=component.get('v.stateZip');
            if(sZip==false)
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
        debugger;
        component.set("v.rerender_section",false);
        // var  elements = document.getElementsByClassName('row_0');
        // for (var i = 0; i < elements.length; i++) {
        //    elements[i].bgColor="blue";
        // }
        component.set("v.showAlert", false);                
        component.set("v.selectedRecord.FirstName","");
        component.set("v.selectedRecord.Phone","");
        component.set("v.selectedRecord.LastName","");
        component.set("v.selectedRecord.Street","");
        component.set("v.selectedRecord.PostalCode","");
        component.set("v.selectedRecord.Email","");
        // Code Added by Dev4 for ORMSFDC-1447
        component.set("v.selectedRecord.State","");
        component.set("v.showError",false);
        //Code Ended by Dev4 for ORMSFDC-1447
        //var selId = event.target.id;
        var selId = event.currentTarget.id;
        console.log('selId ',selId);
        var alm = selId;
        $('.each_row').removeClass('highlighted_row');//.css('background-color','white').css('color','black');
        $('.'+'row_'+selId).addClass('highlighted_row');//.css('background-color','blue').css('color','white');
        var selectedMargin = component.get("v.Margins")[parseInt(selId)];
      //  alert('selectedMargin-->'+selectedMargin);
        console.log(selectedMargin);
        console.log('selectedMargin---Controller--> ',selectedMargin.initialPrincipalLimit);
        var ini  =selectedMargin.initialLOC;
        if(ini<0){
            ini = 0;
        }
        component.set("v.FirstAmount",ini);
        //console.log('v.FirstAmount controller',v.FirstAmount);
        
        var lien = selectedMargin.initialLOC;//prsn
        var initPri = parseFloat(selectedMargin.initialPrincipalLimit.replace(',','').replace(',','').replace(',',''));
       // component.set("v.TotalAmountAvailable",initPri);
        component.set("v.TotalAmountAvailable",initPri);
        console.log('initPri---',initPri);
        
        var almis = ''+selectedMargin.lendersMargin;
        component.set('v.Scenarioindex',alm);//prsn
        helper.hlperscriptsLoaded(component, event, helper,almis,lien);//prsn
        
    },
    shw_capacityPopup : function(component, event, helper){
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
    },
    shw_capacityPopupClose : function(component, event, helper){
        component.set("v.show_capacity_Popup",false);
        component.set("v.capacity_qualified",fasle);
        component.set("v.show_capacityform",true);
    },
    run_capacity:function(component, event, helper){
        
        var isValidated = true;//'amount_TMI','amount_TA',
        var required_fields = ['num_HHM','amount_TML','amount_MTI','num_SFT'];
        var required_fieldsNew=  ['amount_TMI','amount_TA'];
        for(var i=0;i<required_fields.length;i++){
            var inputCmp = component.find(required_fields[i]);
            var value = inputCmp.get("v.value");
           // alert('value  '+value);
            // Is input numeric?
            if (value !='' && value != undefined) {
                // Clear error
                inputCmp.set("v.errors", null);
            } else {
                // Set error
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
                    
                    //code to remove the brackets
                    if(component.get("v.capacity_qualified")){
                                   storeResponse.CashFlow = storeResponse.CashFlow.replace('(','').replace(')','');
                 
                        storeResponse.CapacityStorage = storeResponse.CapacityStorage.replace('(','').replace(')','');
                    
                    console.log('storeResponse.CapacityStorage ',storeResponse.CapacityStorage);
                    }
                    if(CstoreResponse.apacityStorage.toString().indexOf("(") != -1 )
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
    start_newloan:function(component){
        
        var getdate = component.get("v.ApplicationDate");
        
        var fileInput = document.getElementById('fileInput').value;        
        console.log('fileInput ',fileInput);
        //  var datecontrol= component.find('expname');
        //    var date = datecontrol.get('v.value');
        var applicationDate = getdate;//component.get("v.datepick");
        //Check whether File is selected or not
        if (!$A.util.isEmpty(fileInput))
        {
            var fileInput = component.find("file").getElement();
            var file = fileInput.files[0];
            
            //        var spinner = component.find("spinner");        
            //      $A.util.toggleClass(spinner, "slds-hide");
            var data=component.get("v.filedata");
            
            var dd=document.getElementById('inputtxt').value;
            var action = component.get("c.getFNMData");
            //  alert(component.get("v.senario_id"));
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
                //          alert('in call back');
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
            //  alert('normal');
            //    alert(component.get("v.senario_id"));
            
            //   alert(component.get('v.SFT'));
            var action = component.get("c.createLoan");
            action.setParams({
                senarioid:component.get("v.senario_id"),
                hhm:component.get('v.HHM'),
                sft:component.get('v.SFT')
            });
            
            action.setCallback(this,function(data){
                
                // alert(data.getReturnValue()+'is created ');
                component.set("v.showLoanId",data.getReturnValue().Id);
                //        console.log('data.getReturnValue().Id ',data.getReturnValue().Id);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": data.getReturnValue().Name + " is Created."
                });
                toastEvent.fire();
                //$('.tabs__nav').hide();
                // 
                //           alert('application date is '+component.get("v.ApplicationDate"));
                component.set("v.render_popup",false);
                component.set("v.showLoan",true);
                component.set("v.displayTab",false);
                //     alert('ad');
                
            });
            $A.enqueueAction(action);
            // location.open('/s/startnewloan');
            // 
        }
    },    
    openchk : function(component, event, helper) {
        
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
        var val=component.find("inputZip").get("v.value");
        var lan=val.length;
        debugger;
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
            var n=result.length; //result!=null ||
            if(n!=0)
            {
                var state=result[0];
                var city=result[1];
                var action1 = component.get("c.get_states");
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
           					break;
                        }else{
                            
                                 component.set("v.selectedRecord.State","");
                              component.set("v.selectedRecord.City","");
                            component.set("v.stateZip",true);
              
                        }
                    }
                   
                });
                $A.enqueueAction(action1);          
            }
            else
            {
                component.set("v.stateZip",true);
            }
            
        });
        $A.enqueueAction(action);
        }
        else
        {
            component.set("v.stateZip",false);
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
    },
    
})