({
    //Required field validation
    formatErrorMethod: function(component, regex, msg, aura_id) {       
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
                inputCmp.set("v.errors", [{ message: msg[i]   }]);              
                flag = true;                
            }
        }
        return flag;
    }, 
    //Check for Currency
    CurrencyRegexCheck: function(component) {
        var flagR = false;
        var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
        var arr_regr = new Array();
        var arr_funcr = new Array();
        var valArray = [           
            { ar_id: "inputEHV", mes: "Value must be greater than or equal to 1.", reg: "^[1-9]\\d*(\\.\\d+)?$" },
            { ar_id: "inputCMB", mes: "Please enter a valid number (non negative).", reg: "^[0-9]\\d*(\\.\\d+)?$" },            
          //  { ar_id: "inputCFY", mes: "Please enter a valid number (non negative).", reg: "^[0-9]\\d*(\\.\\d+)?$" },            
            { ar_id: "inputMMP", mes: "Please enter a valid number (non negative).", reg: "^[0-9]\\d*(\\.\\d+)?$" }            
        ];
        array_idr = valArray.map(item => item.ar_id);
        array_mesr = valArray.map(item => item.mes);
        array_regr = valArray.map(item => item.reg);
        for (var i = 0; i < array_idr.length; i++) {
            var inputCmp = component.find(array_idr[i]);      
            var value = inputCmp.get("v.value");  
            var isRegValid = false;
            if(typeof value==='undefined')
            {
                
            }
            else{
                if (value.length !=0 ) {
                    var rxp = new RegExp(array_regr[i]);                    
                    isRegValid = rxp.test(value);
                    if (isRegValid) {                        
                        inputCmp.set("v.errors", null);                   
                    } 
                    else {
                        inputCmp.set("v.errors", [{ message: array_mesr[i]   }]);                        
                        flagR = true;                        
                    }                    
                } 
            }   
        }
        return flagR;    
    },
    //Validate CMIR Value
    validateCMIRValue:function(component, event, helper) {
        var flagR=false;       
        var inputCmp = component.find('inputCMIR');      
        var value = inputCmp.get("v.value");
        if(typeof value==='undefined'  || value=='' || value==null )
        {}else{
            if(value<0 || value >100)
            {
                inputCmp.set("v.errors", [{ message: "Please enter valid Interest Rate."  }]);                        
                flagR = true; 
                
            }
        }
        return flagR;    
    },
    //Validate Date format and future date
    validateDate:function(component, event, helper) {
        var DOBValue;
        var flagR=false;       
        var inputCmp = component.find('inputDOB');      
        var value = inputCmp.get("v.value");
        if(typeof value==='undefined' || value=='' || value==null)
        {}else{
            var year=value.substring(0,4);  
            var month=value.substring(5,7);
            var day=value.substring(8,10);
            DOBValue=month+'/'+day+'/'+year;
            var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/ ;
            if(!(date_regex.test(DOBValue)))
            {
                inputCmp.set("v.errors", [{ message: "Please enter Date of Birth in MM/DD/YYYY format."  }]);                        
                flagR = true; 
            }
            else{
                var selectedDate = new Date(DOBValue),
                    todayDate   = new Date(),
                    diff  = new Date(selectedDate-todayDate),
                    days = (diff) / (1000 * 60 * 60 * 24);       
                if (days < -1) {  
                    inputCmp.set("v.errors", null);
                    flagR = false;                 
                } else {
                    inputCmp.set("v.errors", [{ message: "Date of Birth cannot be today's date or future date." }]);   
                    flagR = true; 
                } 
            }}          
        return flagR;  
    },
    //check for age 62
    checkFor62: function(component,event,helper){
       component.set("v.showCalculation_info",false);
        var currdate = new Date();   
        var DOB = component.find("inputDOB");
        var DOBValue = DOB.get("v.value");
        if(!$A.util.isEmpty(DOBValue))
        {
            var year=DOBValue.substring(0,4);  
            var month=DOBValue.substring(5,7);
            var day=DOBValue.substring(8,10);
            DOBValue=month+'/'+day+'/'+year;
        }
        var mydate = new Date(DOBValue); 
        var diffYr = currdate.getFullYear() - mydate.getFullYear();
        var m = currdate.getMonth() - mydate.getMonth();
        
        if (m < 0 || (m === 0 && currdate.getDate() < mydate.getDate())) 
        {
            diffYr--;
        }  
       // alert(diffYr);
        if(diffYr >= 62)
        {
//            alert();
            var EHV = component.find("inputEHV");
            var EHVValue = EHV.get("v.value");
            var DOB = component.find("inputDOB");
            var DOBValue = DOB.get("v.value");
            if(!$A.util.isEmpty(DOBValue))
            {
                var year=DOBValue.substring(0,4);  
                var month=DOBValue.substring(5,7);
                var day=DOBValue.substring(8,10);
                DOBValue=month+'/'+day+'/'+year;
            }
            var CMB = component.find("inputCMB");
            var CMBValue = CMB.get("v.value");  
          //  var CFY = component.find("inputCFY");
          //  var CFYValue = CFY.get("v.value");
            var CMIR = component.find("inputCMIR");
            var CMIRValue = CMIR.get("v.value");        
            var MMP = component.find("inputMMP");
            var MMPValue = MMP.get("v.value");
            component.set("v.VisibleDefaultDiv", true);
            component.set("v.showPopup", false);
            component.set("v.ClientDiv", false);
            component.set("v.ClientDiv", true); 
            component.set("v.showPrintOption",true);
            var evt=$A.get("e.c:LoanCalculatorEvent");
           // alert(DOBValue);
            evt.setParams({"DOBE":DOBValue});
            evt.setParams({"EHVE":EHVValue}); 
            evt.setParams({"CMBE":CMBValue});
         //   evt.setParams({"CFYE":CFYValue});
            evt.setParams({"CMIRE":CMIRValue});
            evt.setParams({"MMPE":MMPValue});
            evt.fire();
         //   alert('fired');
        }
        else if(diffYr <62 && diffYr >=18)
        {
            var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Error !",
        "message": "At least one client should be above the age of 62",
		"type":"error"
    });
    toastEvent.fire();
               var EHV = component.find("inputEHV");
            var EHVValue = EHV.get("v.value");
            var DOB = component.find("inputDOB");
            var DOBValue = DOB.get("v.value");
            if(!$A.util.isEmpty(DOBValue))
            {
                var year=DOBValue.substring(0,4);  
                var month=DOBValue.substring(5,7);
                var day=DOBValue.substring(8,10);
                DOBValue=month+'/'+day+'/'+year;
            }
            var CMB = component.find("inputCMB");
            var CMBValue = CMB.get("v.value");  
          //  var CFY = component.find("inputCFY");
          //  var CFYValue = CFY.get("v.value");
            var CMIR = component.find("inputCMIR");
            var CMIRValue = CMIR.get("v.value");        
            var MMP = component.find("inputMMP");
            var MMPValue = MMP.get("v.value");
            component.set("v.VisibleDefaultDiv", true);
            component.set("v.showPopup", false);
            component.set("v.ClientDiv", false);
            component.set("v.ClientDiv", true); 
            component.set("v.showPrintOption",true);
            var evt=$A.get("e.c:LoanCalculatorEvent");
           // alert(DOBValue);
            evt.setParams({"DOBE":DOBValue});
            evt.setParams({"EHVE":EHVValue}); 
            evt.setParams({"CMBE":CMBValue});
         //   evt.setParams({"CFYE":CFYValue});
            evt.setParams({"CMIRE":CMIRValue});
            evt.setParams({"MMPE":MMPValue});
            evt.fire();
        

            //component.set("v.VisibleDefaultDiv", true);
           // component.set("v.showPopup", true);
           // component.set("v.ClientDiv", false);
        }
     else    if( diffYr <18)
        {
            component.set("v.VisibleDefaultDiv", true);
          component.set("v.showPopup", true);
            component.set("v.ClientDiv", false);
        }
    }
})