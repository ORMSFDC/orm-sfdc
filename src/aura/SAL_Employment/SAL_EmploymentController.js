({
    doInit : function(component, event, helper) {        
        helper.DropdownPopulate(component, event, helper);
        helper.PopulateClient(component, event, helper);        
    },
    onSelectChange : function(component, event, helper) {        
        var ClientIdforset = component.find('pickClient').get('v.value');     
        component.set("v.ClientID",ClientIdforset);
        var ClientId = component.get("v.ClientID");        
        if (ClientId == "") {
            component.find('addEmp').set('v.disabled', true);            
        } else if (ClientId != "") {
            component.find('addEmp').set('v.disabled', false);            
        }
        helper.PopulateEmploymentBasedonClient(component, event, helper,ClientId);
    },
    
    Edit : function(component, event, helper) {        
        component.set("v.showError",false);
        component.set("v.isOpen", true);
        component.set("v.Heading", 'Edit Employment');
        helper.ClearData(component, event, helper);
        helper.GetEmploymentforEdit(component, event, helper);
    },
    
    Delete : function(component, event, helper) {
        helper.DeleteEmployment(component, event, helper);
        var ClientId= component.get("v.ClientID");
        helper.PopulateEmploymentBasedonClient(component, event, helper,ClientId);
    },
    
    AddRecord : function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.showError",false);
        component.set("v.isOpen", true);
        component.set("v.Heading", 'Add Employment');
        helper.ClearData(component, event, helper);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);        
        helper.ClearData(component, event, helper);        
    },
    closeDeleteModel : function(component, event, helper) {
        component.set("v.showPopup",false);
    },
    doAction:function(cmp, event, helper) {
        helper.doAction(cmp, event, helper);
    },
    
    employmentSaveUpdate : function(component, event, helper) {
        if (helper.validateEmp(component)) {
            helper.SaveEmployment(component, event, helper); 
            var ClientId= component.get("v.ClientID");
            helper.PopulateEmploymentBasedonClient(component, event, helper,ClientId);
            component.set("v.isOpen", false);
        }        
    },
    
    NumberCheck : function(component, event, helper) {
        helper.validateNumber(component, event, helper);       
    },
    
    dateCheck : function(component, event, helper) {
        helper.FutureDate(component, event, helper);        
    },
    dateCheckCompare : function(component, event, helper) {
        helper.CompareDate(component, event, helper);        
    },
    FormatPhone: function(component, event, helper){
        helper.FormatPhonehelper(component, event, helper);        
    },
    // To setup the following framework for validations please replicate FormatValidations and 
    // formatErrorMethod to your component's Controller and Helper respectively.
    FormatValidations: function(component, event, helper) {        
        var a_id = event.getSource().getLocalId();
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();
        
        var regr = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
        var arr_regr = new Array();
        var arr_funcr = new Array();
        
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
        function FutureDate (value) {            
            var myDate = new Date(value);
            var today = new Date();
            if (myDate > today) {                
                return false;                
            } else {
                return true;
            }           
        }
        var valArray = [
            { ar_id: "SelfEmp", mes: "Please select a value for this field", reg: validateRequiredField },
            { ar_id: "IncomeType", mes: "Please select a value for this field", reg: validateRequiredField },
            { ar_id: "inputYear", mes: "This is a required field", reg: validateRequiredField },
            //{ ar_id: "inputMonth", mes: "This is a required field", reg: validateRequiredField },
            //{ ar_id: "Startdate", mes: "Start date Cannot be future date", reg: FutureDate },
            
        ];
            var valarrayregex=[
            { ar_idr: "inputZip", mesr: "Please enter a valid zip format (eg: 23454/23456-1234)", regr: "(^\\d{5}$)|(^\\d{5}-\\d{4}$)" },
            //{ ar_idr: "inputMonth", mesr: "Please enter a valid number of month(In two digit) ", regr: "^\\d{1,2}$" },
            { ar_idr: "inputYear", mesr: "Please enter a valid number of year(In two digit) ", regr: "^\\d{1,2}$" },
            //{ ar_idr: "inputEmpPhone", mesr: "Please enter a valid phone number (Ten digit number cannot start with 0 and not all number same)", regr: "^([1-9])(?!\\1+$)\\d{9}$" },
        ];
        
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);
        
        array_idr = valarrayregex.map(item => item.ar_idr);
        array_mesr = valarrayregex.map(item => item.mesr);
        array_regr = valarrayregex.map(item => item.regr);
        debugger;
        var Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id) ;
        var seflemployedVal=component.find('SelfEmp').get('v.value');        
        var seflemployedResult=false;
        if(seflemployedVal=="No")
        {            
            seflemployedResult=helper.ValidateSelfEmployed(component, event, helper);            
        }
        else{
            var finalResult=false;       
            var employername=component.find('inputFName');
            var positiontitle=component.find('inputPosition');
            var employerphone=component.find('inputEmpPhone');
            var employeraddress=component.find('inputEmpAddress');
            var city=component.find('inputCity');
            var state=component.find('State');
            var zip=component.find('inputZip');    
            employername.set("v.errors", null);    
            positiontitle.set("v.errors", null);    
            employerphone.set("v.errors", null);    
            employeraddress.set("v.errors", null);    
            city.set("v.errors", null);    
            state.set("v.errors", null);    
            zip.set("v.errors", null);    
        }
        var IsRegex=helper.formatErrorMethodr(component, array_regr, array_mesr, array_idr);
       // var sdatechk=helper.CompareDate(component, event, helper);
        var CheckMonth=helper.CheckMonth(component, event, helper);
        if (Isrequired || IsRegex || seflemployedResult || CheckMonth) {
            component.set("v.showError",true);            
        }
        else
        {
             
                component.set("v.showError",false);
                helper.SaveEmployment(component, event, helper);
                var ClientId= component.get("v.ClientID");
                helper.PopulateEmploymentBasedonClient(component, event, helper,ClientId);
                component.set("v.isOpen", false);
            
            
        }
    },
    IsselfEmployed:function(component,event,helper){
        var inputCmp = component.find('SelfEmp');       
        var value = inputCmp.get("v.value");
        if(value=='No')
        {
            component.set("v.Isrequired",true);
        }
        else{
            component.set("v.Isrequired",false);
        }
    }
    ,
    EmploymentValidations : function(component, event, helper) {
        var a_id = event.getSource().getLocalId();
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        switch (a_id) {
            case "inputEmpPhone":
                msg = "Invalid Phone Number";
                reg = /^[(]{0,1}[0-9]{3}[)\.\-]{0,1}[0-9]{3}[\.\-]{0,1}[0-9]{4}$/;
                break;
            case "inputZip":
                msg = "Invalid Zip Code";
                reg = /(^\d{5}$)|(^\d{5}-\d{4}$)/;
                break;
            case "inputMonth":
                msg = "Invalid No.of Months";
                reg = /^0[1-9]|1[0-2]$/;
                break;
            case "inputYear":
                msg = "Invalid Year";
                reg = /^0[1-9]|1[0-9]$/;
                break;
            default:
                ;
        }
        helper.EmpValidationMethods(component, reg, msg, a_id);
    },
    
    next: function(component,event,helper)
    {
        helper.Loan_Next(component,event,helper);
    },
    
    previous: function(cmp, event, helper) {
        helper.prev(cmp);
    },    
    RestrictZeroInEmployerPhoneFirstTime:function(component, event, helper) {
        var inz = 'v.NewEmp.EmployerPhone__c';        
        helper.RestrictZeroInPhoneFirstTime(component, event, helper,inz);     
    },    
    
})