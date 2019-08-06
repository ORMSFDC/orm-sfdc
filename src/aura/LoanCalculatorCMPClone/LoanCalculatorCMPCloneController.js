({
    onSelectChange : function(component, event, helper) {
        component.set('v.DOB','');
        component.set('v.EHV','');
        component.set('v.PP','');
        component.set('v.CMB','');
        component.set('v.CMIR','');
        component.set('v.MMP','');
        component.set('v.ADO', '');
        
        component.set('v.ClientDiv',false);
        component.set('v.Show_FHA_Hecm',false);
        
        component.set('v.Show_FHA_Purchase',false);
        component.set('v.show_MaxAdo',false);
        var selected = component.find("levels").get("v.value");
        //  alert(selected);
        if( selected =='FHA Traditional HECM'){
            // component.set('v.ClientDiv',false);
            component.set('v.ScenarioType','FHA Traditional HECM');
            component.set('v.Show_FHA_Hecm',true);
            
        }else{
            
            component.set('v.ScenarioType','HECM for Purchase');
            component.set('v.Show_FHA_Purchase',true);
        }
        
    },
    //Validate Estimate Home Value
    validateEHV:function(component, event, helper) {
        debugger;
        var EhvVal = component.get('v.EHV'); // 300000
        console.log('EhvVal  -->', EhvVal);
      //var HUDeof = (EhvVal <= 200000) ? (EhvVal * 0.02) : ((200000 * 0.02) + ((EhvVal - 200000) * 0.01));
      //var finalEOF1 = (HUDeof <= 2500) ? 2500 : ((HUDeof >= 10000) ? 10000 : HUDeof);
        component.set("v.ADO", '');
      //component.set("v.MaxAdo",finalEOF1);        
        var inz = component.get('v.EHV');
        console.log('inz ',inz);
        
        if(isNaN(inz) && inz)
        {
            component.set('v.EHV', inz.substring(0, inz.length - inz.length));
        }
    },
    //Validate Current Mortgage Balance
    validateCMB:function(component, event, helper) {
        debugger;
        var EhvVal = component.get('v.EHV'); // 300000
        console.log('EhvVal  -->', EhvVal);
      //var HUDeof = (EhvVal <= 200000) ? (EhvVal * 0.02) : ((200000 * 0.02) + ((EhvVal - 200000) * 0.01));
      //var finalEOF1 = (HUDeof <= 2500) ? 2500 : ((HUDeof >= 10000) ? 10000 : HUDeof);
        component.set("v.ADO", '');
      //component.set("v.MaxAdo",finalEOF1);
        var inz = component.get('v.CMB');
        console.log('CMB ',inz);
        if(isNaN(inz) && inz)
        {
            component.set('v.CMB', inz.substring(0, inz.length - inz.length));
            component.set("v.ErrorMsg","");
        }
    },
    //Validate Current Mortgage Interest Rate
    validateCMIR:function(component, event, helper) {
        debugger;
        var inz = component.get('v.CMIR');
        var digit = inz.toString()[0];
        if(typeof digit ==='undefined')
        {
        }
        if(digit==' ' ){
            component.set('v.CMIR', inz.substring(0, inz.length - inz.length));  
        }
        else{
            if(isNaN(inz))
            {
                component.set('v.CMIR', inz.substring(0, inz.length - inz.length));
                
            }          
        }      
    },
    //Validate Monthly Mortgage Payment
    validateMMP:function(component, event, helper) {
        var inz = component.get('v.MMP');
        if(isNaN(inz) && inz)
        {
            component.set('v.MMP', inz.substring(0, inz.length - inz.length));
            component.set("v.ErrorMsg","");
        }    
    },
    //Validate Origination
    validateADO: function (component, event, helper) {
        // SFDC-231
        helper.validateAdo(component, event, helper);
    },
    AdoOnblur:function(component,event,helper){
        helper.validateAdo(component,event,helper);        
    },
    
    //Validate Required Field
    Validations: function(component, event, helper) {
    debugger;
        console.log('validations method');
        component.set('v.Show_table',true);
        
        //   debugger;
        // alert('validations ');
        var msg = "";
        var reg = '';
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();
        var valArray = [
            { ar_id: "inputDOB", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputEHV", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputCMB", mes: "This is a required field.", reg: validateRequiredField },
            { ar_id: "inputADO", mes: "This is a required field.", reg: validateRequiredField }        
        ]; 
        
        
        var bothFilled = false;
        var CMIRIs = component.get('v.CMIR');
        var MMPIs = component.get('v.MMP');
        if((CMIRIs=='' || CMIRIs==undefined) && (MMPIs=='' || MMPIs==undefined) ){
            component.set('v.Show_table',false);
            try{
                var inputCmp = component.find('inputMMP');    
                inputCmp.set("v.errors", null);  
                var inputCmp1 = component.find('inputCMIR');    
                inputCmp1.set("v.errors",null);   
            }catch(err){}
            
            //  bothFilled = true;
        }else{
            try{ 
                if((CMIRIs!='' &&  CMIRIs!=undefined && CMIRIs!=0) && (MMPIs=='' ||  MMPIs==undefined)){
                    bothFilled = true;
                    
                    var inputCmp = component.find('inputMMP');    
                    inputCmp.set("v.errors", [{ message: "This is a required field" }]);   
                    
                }else{
                    var inputCmp = component.find('inputMMP');    
                    inputCmp.set("v.errors", null);   
                    
                }
                
                if((MMPIs!='' &&  MMPIs!=undefined && MMPIs!=0) && (CMIRIs=='' ||  CMIRIs==undefined)){
                    bothFilled = true;
                    
                    var inputCmp = component.find('inputCMIR');    
                    inputCmp.set("v.errors", [{ message: "This is a required field" }]);   
                }else{
                    var inputCmp = component.find('inputCMIR');    
                    inputCmp.set("v.errors",null);   
                    
                }
                
            }catch(err){}
            
        }
        
        //   alert(1);
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
        //     { ar_id: "inputCMIR", mes: "This is a required field.", reg: validateRequiredField },
        //       { ar_id: "inputMMP", mes: "This is a required field." , reg: validateRequiredField},
        
        
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg); 
        
        //   alert(2);
        var Isrequired = false;
        try{
            Isrequired =helper.formatErrorMethod(component, array_reg, array_mes, array_id) ;
        }catch(err){}
        
        //    alert(3);
        var isdateworng = false;
        try{
            isdateworng=helper.validateDate(component, event, helper);
        }catch(err){}
        var IsCurrenyWorng = false;
        try{
            IsCurrenyWorng= helper.CurrencyRegexCheck(component) ;
        }catch(err){}
        
        //   alert(4);
        var IsInterestrateWorng = false;
        try{
            IsInterestrateWorng=helper.validateCMIRValue(component, event, helper);
        }catch(err){}
        //    alert(5);
        var adoError= false;
        try{            
            adoError = helper.validateAdo(component, event, helper);
        }catch(err){}
        //      alert(6);
        if (Isrequired || IsCurrenyWorng || isdateworng || IsInterestrateWorng || adoError || bothFilled) {            
            //          alert(7);
            console.log('Isrequired || IsCurrenyWorng || isdateworng || IsInterestrateWorng || adoError || bothFilled',Isrequired , IsCurrenyWorng , isdateworng,IsInterestrateWorng,adoError,bothFilled)
            component.set("v.showError", true);            
        }        
        else
        { 
            //          alert(8);
            component.set("v.showError", false);
            helper.checkFor62(component,event,helper);          
        } 
        if(component.get("v.Show_FHA_Hecm")  || component.get("v.Show_FHA_Purchase")){ 
            if(component.get("v.EHV") >= 250000){
                component.set("v.displayHelo", true);
                component.set("v.displayHeloArm", true);
            }else{
                component.set("v.displayHelo", false);
                component.set("v.displayHeloArm", false);
            }
        } 
    },
    get_loanFor_margin:function(component,event,helper){
        debugger;
        component.set("v.ClientDiv",true);
        
        var selectedItem = event.currentTarget;
        var recId = selectedItem.dataset;
        console.log('selectedItem.dataset ',selectedItem.dataset.type);
        var selId = event.currentTarget.id;
        console.log('selId ',selId);
        var alm = selId;
        
        $('.each_row').removeClass('highlighted_row');//.css('background-color','white').css('color','black');
        $('.'+'row_'+selId).addClass('highlighted_row');//.css('background-color','blue').css('color','white');
    },
    
    //Validate Required Field
    ValidationsNew: function(component, event, helper) {
        debugger;
        console.log('validationsnew method');
        var isValidatePP = false;
        try{
            isValidatePP =   helper.validatePP(component, event, helper);
        }catch(err){}
        
        var isdateworng = false;
        try{
            isdateworng=helper.validateDatenew(component, event, helper);
        }catch(err){}
        
        var adoError= false;
        try{
            
            adoError =    helper.validateAdo(component, event, helper);
        }catch(err){}
        if (isdateworng || adoError || isValidatePP) {            
            component.set("v.showError", true);            
        }        
        else{
            component.set("v.VisibleDefaultDiv", true);
            component.set("v.showPopup", false);
            component.set("v.ClientDiv", false);
            component.set("v.ClientDiv", true); 
            component.set("v.showPrintOption",true);
            helper.checkFor62(component,event,helper); //Added Age Error for Purchase - Bala
        }  
        if(component.get("v.Show_FHA_Hecm")  || component.get("v.Show_FHA_Purchase")){ 
            console.log('show fha Hecm',component.get("v.Show_FHA_Hecm"));
            console.log('show fha Purchase',component.get("v.Show_FHA_Purchase"));
            //alert('init'+component.get("v.EHV"));
            if(component.get("v.EHV") >= 250000){
                component.set("v.displayHelo", true);
                component.set("v.displayHeloArm", true);
            } else{
                component.set("v.displayHelo", false);
                component.set("v.displayHeloArm", false);
            }
        } 
        //   alert();
      /*  var msg = "";
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
            { ar_id: "inputDOB", mes: "This is a required field.", reg: validateRequiredField }        
        ];         
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);        
        var Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id) ;
        var isdateworng=helper.validateDate(component, event, helper);
        var IsCurrenyWorng= helper.CurrencyRegexCheck(component) ;
        var IsInterestrateWorng=helper.validateCMIRValue(component, event, helper);
        if (Isrequired || IsCurrenyWorng || isdateworng || IsInterestrateWorng) {            
            component.set("v.showError", true);            
        }        
        else
        { 
            component.set("v.showError", false);
            helper.checkFor62(component,event,helper);          
        } */
    },
    optionChanged:function(component, event, helper){
        var lnId= component.get("v.showLoanId");
        
        // SFDC-567
        if(lnId!=null && lnId!=undefined && lnId!=''){  
            $A.createComponent(
                "c:StartNewLoanProductContainer",
                
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
        }
    },
    
    onSingleSelectChange:function(component){ // Bala 
        console.log('>> tier is ',component.get("v.Tier_Value"));        
    }
})