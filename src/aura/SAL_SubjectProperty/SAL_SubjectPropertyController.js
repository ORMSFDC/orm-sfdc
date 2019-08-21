({
    onchange_action  :function(component, event, helper){
        
    },
    doInit: function(component, event, helper) {
        debugger;
        var LoanId = component.get('v.subjectPropertyLoanId');
        var action123 = component.get("c.getLoanOfficerLoanById");
        action123.setParams({
            "RecordId": LoanId
        });
        action123.setCallback(this, function(data) {  
            
            var result=data.getReturnValue();   
            if(result!=null)
            {
                component.set("v.LOID",result);
            }
            
        });
        $A.enqueueAction(action123); 
        //window.scrollTo(0, 0);        
        //Data for US States dropdown
        var States = [
            { text: "California", value: "California" },
            /*{ text: "Alabama", value: "Alabama" },
            { text: "Alaska", value: "Alaska" },
            { text: "Arizona", value: "Arizona" },
            { text: "Arkansas", value: "Arkansas" },
            { text: "California", value: "California" },
            { text: "Colorado", value: "Colorado" },
            { text: "Connecticut", value: "Connecticut" },
            { text: "Delaware", value: "Delaware" },
            { text: "Florida", value: "Florida" },
            { text: "Georgia", value: "Georgia" },
            { text: "Hawaii", value: "Hawaii" },
            { text: "Idaho", value: "Idaho" },
            { text: "Illinois", value: "Illinois" },
            { text: "Indiana", value: "Indiana" },
            { text: "Iowa", value: "Iowa" },
            { text: "Kansas", value: "Kansas" },
            { text: "Kentucky", value: "Kentucky" },
            { text: "Louisiana", value: "Louisiana" },
            { text: "Maine", value: "Maine" },
            { text: "Maryland", value: "Maryland" },
            { text: "Massachusetts", value: "Massachusetts" },
            { text: "Michigan", value: "Michigan" },
            { text: "Minnesota", value: "Minnesota" },
            { text: "Mississippi", value: "Mississippi" },
            { text: "Missouri", value: "Missouri" },
            { text: "Montana", value: "Montana" },
            { text: "Nebraska", value: "Nebraska" },
            { text: "Nevada", value: "Nevada" },
            { text: "New Hampshire", value: "New Hampshire" },
            { text: "New Jersey", value: "New Jersey" },
            { text: "New Mexico", value: "New Mexico" },
            { text: "New York", value: "New York" },
            { text: "North Carolina", value: "North Carolina" },
            { text: "North Dakota", value: "North Dakota" },
            { text: "Ohio", value: "Ohio" },
            { text: "Oklahoma", value: "Oklahoma" },
            { text: "Oregon", value: "Oregon" },
            { text: "Pennsylvania", value: "Pennsylvania" },
            { text: "Rhode Island", value: "Rhode Island" },
            { text: "South Carolina", value: "South Carolina" },
            { text: "South Dakota", value: "South Dakota" },
            { text: "Tennessee", value: "Tennessee" },
            { text: "Texas", value: "Texas" },
            { text: "Utah", value: "Utah" },
            { text: "Vermont", value: "Vermont" },
            { text: "Virginia", value: "Virginia" },
            { text: "Washington", value: "Washington" },
            { text: "West Virginia", value: "West Virginia" },
            { text: "Wisconsin", value: "Wisconsin" },
            { text: "Wyoming", value: "Wyoming" },*/
            
        ];
            helper.checkLoanCreatedByLoanOfficer(component, event, helper);
            helper.PopulateSubjectPropertyByLoanId(component, event, helper);
            component.set('v.UsState', States);
            
            helper.ValidationForPills(component, event, helper);
            
            var action = component.get("c.getLoanOfficerList");
            action.setCallback(this, function(data) {  
            
            var result=data.getReturnValue();   
            
            component.set("v.LoanOfficerList",result);
            
            var loanObj=component.get('v.LOID');
            
            component.set('v.subjectProperty.Originating_Loan_Officer__c',loanObj);
            if(loanObj!='')
            {
            var inputCmp = component.find('loanOfficerID');
            inputCmp.set("v.errors", null);
            }
            
            });
            $A.enqueueAction(action);
            },
            
            //Validation for Subject Property Before Saving     
            SAveAndNewTab: function(component, event, helper) {
            debugger;
            component.set("v.showError", false);
            component.set("v.LicenseState", false);
            helper.ValidZip(component, event, helper,'SP_Zip');
            document.getElementById('ClentLbl').innerHTML ='NoNeedtomove';
            component.set("v.manual",true);
            var a_id = event.getSource().getLocalId();    
            if(component.get("v.NewStartLoan")==true)
            {
            if(a_id=="addSubjectProperty")
            {
            
            }
            else
            {
            return;
            }
            } 
            var msg = "";
            var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
            var array_id = new Array();
            var array_mes = new Array();
            var array_reg = new Array();
            var arr_reg = new Array();
            var arr_func = new Array();  
            var ar_ReqId = new Array();
            var ar_ReqMsg = new Array();
            var ar_ReqReg = new Array();
            var ar_ReqFunc = new Array(); 
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
            var valArrayReq = [];
        var propertyType = component.find("auraPropertyType").get("v.value");        
        if (propertyType == 'Multifamily (more than 4 units)')
        { 
            valArrayReq = [
                { ar_id: "SP_Address", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_County", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_City", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_Zip", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "NoUnitId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "YearBuiltId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "PropertyHeldId", mes: "Please select a value for this field", reg: validateRequiredField },
                { ar_id: "RETaxes", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "HazardInsuranceId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SqFootage", mes: "This is a required field" , reg: validateRequiredField}, 
                //{ ar_id: "CondominiumName", mes: "This is a required field" , reg: validateRequiredField},
                //Code Modified by Dev4 for ORMSFDC-1401
                { ar_id: "auraPropertyType", mes: "Please select a value for this field", reg: validateRequiredField },
                //Code Ended by Dev4 for ORMSFDC-1401
                //{ ar_id: "PresentMarketId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "MortLiensId", mes: "This is a required field", reg: validateRequiredField },
                // { ar_id: "NameCompanyId", mes: "This is a required field", reg: validateRequiredField },
                // { ar_id: "AccNumberId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "GrossRentalIncomeId", mes: "This is a required field", reg: validateRequiredField },
                // { ar_id: "MonthlyMortPaymentId", mes: "This is a required field", reg: validateRequiredField }, //commented by Bala
                // { ar_id: "InsTaxesId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "NetRentalIncmId", mes: "This is a required field", reg: validateRequiredField },
            ];
                }
                else                
                {
                valArrayReq = [
                { ar_id: "SP_Address", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_County", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_City", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_Zip", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "YearBuiltId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "PropertyHeldId", mes: "Please select a value for this field", reg: validateRequiredField },
                { ar_id: "RETaxes", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "HazardInsuranceId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SqFootage", mes: "This is a required field" , reg: validateRequiredField },
                
                //{ ar_id: "CondominiumName", mes: "This is a required field" , reg: validateRequiredField},
                //Code Modified by Dev4 for ORMSFDC-1401
                { ar_id: "auraPropertyType", mes: "Please select a value for this field", reg: validateRequiredField },
                //Code Ended by Dev4 for ORMSFDC-1401
                //{ ar_id: "PresentMarketId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "MortLiensId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "NameCompanyId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "AccNumberId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "GrossRentalIncomeId", mes: "This is a required field", reg: validateRequiredField },
                //  { ar_id: "MonthlyMortPaymentId", mes: "This is a required field", reg: validateRequiredField }, //commented by Bala
                // { ar_id: "InsTaxesId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "NetRentalIncmId", mes: "This is a required field", reg: validateRequiredField },
            ];
        }        
        
        
        valArrayReq.push ({ar_id: "SolarPanelExistId", mes: "This is a required field" , reg: validateRequiredField}); 

        var valArray = [
            { ar_id: "SP_Zip", mes: "Please enter a valid zip number", reg: "(^\\d{5}$)|(^\\d{5}-\\d{4}$)" },
            { ar_id: "NoUnitId", mes: "Unit should be a valid number", reg: "^(?!0*[.,]0*$|[.,]0*$|0*$)\\d+[,.]?\\d{0,2}$" },
            { ar_id: "AccNumberId", mes: "Account Number should be a valid number", reg: "^[1-9]([0-9]{1,45}$)"},
           
        ]; 
        /*if  ( (component.get("v.subjectProperty.Solar_Panels_Paid_Off__c") == "No") && 
                   (component.get("v.subjectProperty.Product_Type__c") == "HECM"       ) ) {     
                   
            valArray.push ({ar_id: "SolarPanelPaidId" , mes: "ORM does not allow for leased solar panels on the HECM program.",reg: false});
            
        }    */    
        //else 
        if ( component.get("v.subjectProperty.Solar_Panels_Exist__c") == "Yes" ){
             valArrayReq.push ({ar_id: "SolarPanelPaidId" , mes: "This is a required field" , reg: validateRequiredField});
        }
            
            ar_ReqId = valArrayReq.map(item => item.ar_id);
            ar_ReqMsg = valArrayReq.map(item => item.mes);
            ar_ReqReg = valArrayReq.map(item => item.reg); 
            array_id = valArray.map(item => item.ar_id);
            array_mes = valArray.map(item => item.mes);
            array_reg = valArray.map(item => item.reg); 
            var Isrequired=helper.formatErrorMethodReq(component, ar_ReqReg, ar_ReqMsg, ar_ReqId) ;
            var IsRegex=helper.formatErrorMethod(component, array_reg, array_mes, array_id); 
            var IsGenericValidate= helper.validateGeneric(component, event, helper);        
            var chkZip=helper.ValidZip(component, event, helper,'SP_Zip');
            var checkFHAapproved=helper.checkCondominiumFHAApproved(component, event, helper);
            var checkSolarPanel=helper.checkSolarPanelHelp(component, event, helper);
            //var check=helper.checkCondominiumName(component, event, helper);
            
            var val=component.find("SP_Zip").get("v.value");
            var lan=0;
            if(val=="" || val==undefined)
            {
            
            }
            else
            {
            lan=val.length;
            }
            
            if(lan==5)
            {
            helper.getStateCity(component, event, helper,val);   
            }
            else
            {
            component.find("State").set("v.value",'');
            component.find("SP_City").set("v.value",'');
            }
            var IsZIPValidated= component.get("v.isZipExist");
            var IsZIPRequired= component.get("v.requiredZip");
            //SFDC-365
            var IsZIPRequired1= component.get("v.requiredZip1"); 
            var IsZIPRequired2= component.get("v.requiredZip2");
            var IsZIPRequired3= component.get("v.requiredZip3"); 
            var IsZIPRequired4= component.get("v.requiredZip4");
            var IsZIPRequired5= component.get("v.requiredZip5");
            var IsZIPRequired6= component.get("v.requiredZip6");

            //SFDC-365
            debugger;
            var IsLoanCreatedByProcessor=  component.get("v.IsLoanCreatedByLoanOfficer");
            var ValidateLoanProcessor=false;
            var inputCmp = component.find('loanOfficerID');
            
            if(IsLoanCreatedByProcessor)
            {
            var getLoanProcessor=component.find("loanOfficerID").get("v.value");
            if(getLoanProcessor=='' || getLoanProcessor==null || getLoanProcessor==undefined)
            {
            if(component.get('v.LOID')=='' || component.get('v.LOID')==null || component.get('v.LOID')==undefined)
            {
            ValidateLoanProcessor=true;
            
            inputCmp.set("v.errors", [{ message: 'This is a required field' + "."  }]);  
    }
    else
    {
    inputCmp.set("v.errors", null);
}  
 /*ValidateLoanProcessor=true;
            
            inputCmp.set("v.errors", [{ message: 'This is a required field' + "."  }]);
        if(component.get('v.LOID')!=''){
            inputCmp.set("v.errors", null); 
            ValidateLoanProcessor=false;
        }*/
 }
 else
 {
 inputCmp.set("v.errors", null);
}
}

if (Isrequired || IsRegex || chkZip || IsGenericValidate || IsZIPValidated || IsZIPRequired || IsZIPRequired1 || IsZIPRequired2 || IsZIPRequired3 || IsZIPRequired4 || IsZIPRequired5 || IsZIPRequired6 || checkFHAapproved || ValidateLoanProcessor || checkSolarPanel ) { //SFDC-365        
    
    component.set("v.showError", true);
    //What you need to do if there are errors
} 
else 
{
    //helper.SaveLoan(component, event, helper); 
    
    var val=component.find("State").get("v.value");
    var _LoanOfficerId = component.find('loanOfficerID').get('v.value');
    
    //helper.Loan_Next(component, event, helper);
    var action1 = component.get("c.getStateName");
    action1.setParams({
        "StateName": val,
        "LoanOfficerId":_LoanOfficerId
    });
    action1.setCallback(this, function(data) {
        debugger;
        var result=data.getReturnValue();
        var eMsg=result.ErrorMessage;
        var Lvalidated=result.IsLicenseValidated;
        
        if(result!=null || result!='undefined')
        {
            if(result.IsLicenseValidated==true)
            {
                //component.set("v.showError", false);
                component.set("v.LicenseState", false);
                helper.SaveLoan(component, event, helper);        
                helper.Loan_Next(component, event, helper);
            }
            else
            {
                //component.set("v.showError", true);
                component.set("v.LicenseState", true);
                component.set("v.LicenseError", result.ErrorMessage);                            
            }
        }
        
    });
    $A.enqueueAction(action1); 
}

},
    
    //Validation for Subject Property Before Saving     
    FormatValidations: function(component, event, helper) {
        debugger;
        component.set("v.manual",true);
        var a_id = event.getSource().getLocalId();    
        if(component.get("v.NewStartLoan")==true)
        {
            if(a_id=="addSubjectProperty")
            {
                
            }
            else
            {
                return;
            }
        } 
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();  
        var ar_ReqId = new Array();
        var ar_ReqMsg = new Array();
        var ar_ReqReg = new Array();
        var ar_ReqFunc = new Array(); 
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
        var valArrayReq = [];
        var propertyType = component.find("auraPropertyType").get("v.value");        
        if (propertyType == 'Multifamily (more than 4 units)')
        { 
            valArrayReq = [
                { ar_id: "SP_Address", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_County", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_City", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_Zip", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "NoUnitId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "YearBuiltId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "PropertyHeldId", mes: "Please select a value for this field", reg: validateRequiredField },
                { ar_id: "RETaxes", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "HazardInsuranceId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SqFootage", mes: "This is a required field" , reg: validateRequiredField},
                //{ ar_id: "CondominiumName", mes: "This is a required field" , reg: validateRequiredField},
                //Code Modified by Dev4 for ORMSFDC-1401
                { ar_id: "auraPropertyType", mes: "Please select a value for this field", reg: validateRequiredField },
                //Code Ended by Dev4 for ORMSFDC-1401
                // { ar_id: "PresentMarketId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "MortLiensId", mes: "This is a required field", reg: validateRequiredField },
                // { ar_id: "NameCompanyId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "AccNumberId", mes: "This is a required field", reg: validateRequiredField },
                // { ar_id: "GrossRentalIncomeId", mes: "This is a required field", reg: validateRequiredField },
                //  { ar_id: "MonthlyMortPaymentId", mes: "This is a required field", reg: validateRequiredField },
                // { ar_id: "InsTaxesId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "NetRentalIncmId", mes: "This is a required field", reg: validateRequiredField },
                
            ];
                }
                else                
                {
                valArrayReq = [
                { ar_id: "SP_Address", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_County", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_City", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "SP_Zip", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "YearBuiltId", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "PropertyHeldId", mes: "Please select a value for this field", reg: validateRequiredField },
                { ar_id: "RETaxes", mes: "This is a required field", reg: validateRequiredField },
                { ar_id: "HazardInsuranceId", mes: "This is a required field", reg: validateRequiredField },  
                { ar_id: "SqFootage", mes: "This is a required field" , reg: validateRequiredField},
                //{ ar_id: "CondominiumName", mes: "This is a required field" , reg: validateRequiredField},
                //Code Modified by Dev4 for ORMSFDC-1401
                { ar_id: "auraPropertyType", mes: "Please select a value for this field", reg: validateRequiredField },
                //Code Ended by Dev4 for ORMSFDC-1401
                //{ ar_id: "PresentMarketId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "MortLiensId", mes: "This is a required field", reg: validateRequiredField },
                //  { ar_id: "NameCompanyId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "AccNumberId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "GrossRentalIncomeId", mes: "This is a required field", reg: validateRequiredField },
                // { ar_id: "MonthlyMortPaymentId", mes: "This is a required field", reg: validateRequiredField },
                // { ar_id: "InsTaxesId", mes: "This is a required field", reg: validateRequiredField },
                //{ ar_id: "NetRentalIncmId", mes: "This is a required field", reg: validateRequiredField },
                
            ];
        }
        var valArray = [
            { ar_id: "SP_Zip", mes: "Please enter a valid zip number", reg: "(^\\d{5}$)|(^\\d{5}-\\d{4}$)" },
            { ar_id: "NoUnitId", mes: "Unit should be a valid number", reg: "^(?!0*[.,]0*$|[.,]0*$|0*$)\\d+[,.]?\\d{0,2}$" },
            { ar_id: "AccNumberId", mes: "Account Number should be a valid number", reg: "^[1-9]([0-9]{1,45}$)"},
        ]; 
            ar_ReqId = valArrayReq.map(item => item.ar_id);
            ar_ReqMsg = valArrayReq.map(item => item.mes);
            ar_ReqReg = valArrayReq.map(item => item.reg); 
            array_id = valArray.map(item => item.ar_id);
            array_mes = valArray.map(item => item.mes);
            array_reg = valArray.map(item => item.reg); 
            var Isrequired=helper.formatErrorMethodReq(component, ar_ReqReg, ar_ReqMsg, ar_ReqId) ;
            var IsRegex=helper.formatErrorMethod(component, array_reg, array_mes, array_id); 
            var IsGenericValidate= helper.validateGeneric(component, event, helper);        
            var chkZip=helper.ValidZip(component, event, helper,'SP_Zip');  
            var checkFHAapproved=helper.checkCondominiumFHAApproved(component, event, helper);
            var checkSolarPanel=helper.checkSolarPanelHelp(component, event, helper);
            // var checkCondominiumName=helper.checkCondominiumName(component, event, helper);
            
            var val=component.find("SP_Zip").get("v.value");
            var lan=0;
            if(val=="" || val==undefined)
            {
            
            }
            else
            {
            lan=val.length;
            }
            
            if(lan==5)
            {
            helper.getStateCity(component, event, helper,val);   
            }
            else
            {
            component.find("State").set("v.value",'');
            component.find("SP_City").set("v.value",'');
            }
            var IsZIPValidated= component.get("v.isZipExist");
            debugger;
            var IsLoanCreatedByProcessor=  component.get("v.IsLoanCreatedByLoanOfficer");
            var ValidateLoanProcessor=false;
            var inputCmp = component.find('loanOfficerID');
            if(IsLoanCreatedByProcessor)
            {
            var getLoanProcessor=component.find("loanOfficerID").get("v.value");
            if(getLoanProcessor=='' || getLoanProcessor==null || getLoanProcessor==undefined)
            {
            if(component.get('v.LOID')=='' || component.get('v.LOID')==null || component.get('v.LOID')==undefined)
            {
            ValidateLoanProcessor=true;
            
            inputCmp.set("v.errors", [{ message: 'This is a required field' + "."  }]);  
    }
else
{
    inputCmp.set("v.errors", null);
}  
/*ValidateLoanProcessor=true;
            
            inputCmp.set("v.errors", [{ message: 'This is a required field' + "."  }]);
        if(component.get('v.LOID')!=''){
            inputCmp.set("v.errors", null); 
            ValidateLoanProcessor=false;
        }*/
}
else
{
    inputCmp.set("v.errors", null);
}
}
if (Isrequired || IsRegex || chkZip || IsGenericValidate || IsZIPValidated || checkFHAapproved ||ValidateLoanProcessor || checkSolarPanel) {
    component.set("v.showError", true);
    //What you need to do if there are errors
} 
else {
    debugger;
    component.set("v.showError", false);
    console.log('>>>>>>>>>>>>>> 187 controller.js');
    helper.SaveLoan(component, event, helper);
    
    helper.Loan_Next(component, event, helper);//Please note this function 
    
}
},
    
    //Save Laon(Subject Property is part of a Loan) after clicking on Save&Next Button        
    LoanSave: function(component, event, helper) {
        helper.SaveLoan(component, event, helper);
    },               
        handleAppEvent: function(component, event, helper) {
            
        },
            
            //Will move to next Tab of Start a New Loan        
            next: function(component, event, helper) {
                
                component.set("v.jumpto_last",false);
                helper.Loan_Next(component, event, helper);
            },
                
                //Will move to previous Tab of Start a New Loan        
                previous: function(cmp, event, helper) {
                    helper.prev(cmp);
                },
                    
                    //Validation to allow only numeric value        
                    validateNoOfUnit:function(component, event, helper) {
                        var inz = 'v.subjectProperty.No_of_Units__c';
                        helper.validateEnteredValue(component, event, helper,inz);
                        
                        
                    },
                        
                        //Validation to allow only numeric value        
                        validateSquareFootage:function(component, event, helper) {
                            var inz = 'v.subjectProperty.Square_Footage__c';
                            helper.validateEnteredValue(component, event, helper,inz);
                            
                            
                        },
                            
                            showNumberofUnits: function(component, event, helper) 
{   
    //To check FHA approved for story 1477
    var propertyValue = component.find('auraPropertyType').get('v.value');
    if(propertyValue=='Condominium')
    {
        document.getElementById('Check_Condominium').style.display = 'block';
    }
    else
    {
        document.getElementById('Check_Condominium').style.display = 'none';
        component.set("v.subjectProperty.Condominium_Name__c","");
    }
    //////////////////////////////////////////////////
    var propertyType = component.find("auraPropertyType").get("v.value");        
    if (propertyType == 'Multifamily (more than 4 units)')
    { 
        document.getElementById("UnitsNumberDiv").style.display = 'block';
    }
    else
    {
        document.getElementById("UnitsNumberDiv").style.display = 'none';         	
    }
},
    getZipDetail : function(component, event, helper) 
{
    debugger;
    component.set("v.isZipExist",false);
    component.set("v.requiredZip",false);
    component.set("v.requiredZip1",false); //SFDC-365
    component.set("v.requiredZip2",false); //SFDC-365
    component.set("v.requiredZip3",false);
    component.set("v.requiredZip4",false);
    component.set("v.requiredZip5",false);
    component.set("v.requiredZip6",false);
    component.set("v.LicenseState", false);
    var val=component.find("SP_Zip").get("v.value");
    var lan=val.length;
    if(lan==5)
    {
        helper.getStateCity(component, event, helper,val);   
    }
    else
    {
        component.find("State").set("v.value",'');
        component.find("SP_City").set("v.value",'');
        //component.find("SP_County").set("v.value",'');
        component.set("v.isZipExist",false);
        component.set("v.requiredZip",false);
        component.set("v.requiredZip1",false); //SFDC-365
    	component.set("v.requiredZip2",false); //SFDC-365
        component.set("v.requiredZip3",false);
        component.set("v.requiredZip4",false);
        component.set("v.requiredZip5",false);
        component.set("v.requiredZip6",false);
        component.set("v.LicenseState", false);
    }
},
    validateAccountNumber:function(component, event, helper) {
        var inz = 'v.subjectProperty.Account_Number__c';
        helper.validateEnteredValue(component, event, helper,inz);
        
        
    },
    
    onSolarPanelExistChange: function(component, event, helper) {
        
        var selectSlPnl = component.find ("SolarPanelExistId").get("v.value");
        
        component.set("v.subjectProperty.Solar_Panels_Exist__c", selectSlPnl);
        
        if( selectSlPnl != 'Yes' ){            

           component.set("v.subjectProperty.Solar_Panels_Paid_Off__c", undefined);
        } 
    },
    
        
    onSolarPanelPaidChange: function(component, event, helper) {
        
        var selectSlPnlPd = component.find ("SolarPanelPaidId").get("v.value");
        
        component.set("v.subjectProperty.Solar_Panels_Paid_Off__c", selectSlPnlPd);        
        
    }  

        
})