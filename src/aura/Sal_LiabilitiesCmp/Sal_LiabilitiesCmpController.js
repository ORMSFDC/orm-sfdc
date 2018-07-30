({
    doInit: function(component, event, helper) {
         helper.ValidationForPills(component, event, helper) ;       
        var _Loanid = component.get("v.LiaLoanId");
        component.set("v.enableType", true);
        component.set("v.enableButton", true);
        component.set("v.client.Liability_Category__c", "Select Option");
        component.set("v.client.Liability_Type__c", "Select Option");        
        var parentVals = [
            { text: "Alimony", value: "Alimony" },
            { text: "Job Expense", value: "Job Expense" },
            { text: "Liability", value: "Liability" },
            { text: "Real Estate Schedule", value: "Real Estate Schedule" }
        ];        
        var dependentPick = {
            "Alimony": [
                { text: "Divorce", value: "Divorce" },
                { text: "Child Support", value: "Child Support" },
                { text: "Separate Maintenance.", value: "Separate Maintenance." }
            ],
            "Job Expense": [
                { text: "Job Related Expenses", value: "Job Related Expenses" },
                { text: "Other expense", value: "Other expense" }
            ],
            
            "Liability": [
                { text: "Collections/Judgements/Liens", value: "Collections/Judgments/Liens" },
                { text: "Home Equity Line of Credit", value: "Home Equity Line of Credit" },
                { text: "Installment", value: "Installment" },
                { text: "Lease Payments", value: "Lease Payments" },
                { text: "Open 30 day Charge Accounts", value: "Open 30 day Charge Accounts" },
                { text: "Revolving", value: "Revolving" },
                { text: "Taxes", value: "Taxes" },
                { text: "Mechnic Lien", value: "Mechanic lien" },
                { text: "Property Taxes", value: "Property Taxes" },
                { text: "Other", value: "Other" }
                
            ],
            "Real Estate Schedule": [
                { text: "Property", value: "Property" }
            ]
        };
        
        component.set('v.categoryOptions', parentVals);
        component.set('v.typePicklist', dependentPick);
        helper.DropdownPopulate(component, event, helper);        
        helper.PopulateSubjectPropertyAddressByLoanId(component, event, helper);
        var action = component.get("c.getclientValue");        
        var staticItem = {  Id: "",
                          Name: "---Select Client---" };
        var staticItemJoint = {  Id: "Joint",
                               Name: "Joint" };
        action.setParams({
            "LoanId": _Loanid
        });
        action.setCallback(this, function(data) {
            var result =  data.getReturnValue();
            var resultLength =  result.length; 
            component.set("v.clientListHeader", result);
            component.set("v.clientCount", resultLength);
            
            var action1=component.get("c.getPrimaryClient");
                action1.setParams({
                    LoanId: _Loanid         
                });
                action1.setCallback(this, function(data) {
                    var ResultData = data.getReturnValue();
                    
                    component.set("v.pClientList", ResultData);
                });
                $A.enqueueAction(action1); 
            
            if(resultLength==1)
            {     
                var ClientId=result[0].Id;                
                if (ClientId == "") {
                    component.set("v.enableType", true);
                    component.set("v.enableButton", true);
                    component.set("v.client.Liability_Category__c", "Select Option");
                    component.set("v.client.Liability_Type__c", "Select Option");
                    
                } else if (ClientId != "") {
                   component.set("v.enableType", true);
                    component.set("v.enableButton", true);
                }   
                component.set("v.ClientID",ClientId);
                component.set("v.ClientIDEdit",ClientId);
                component.set("v.clientList", result);
                component.set("v.enableClient",true);
           }
            else
            {                 
                result.splice(0, 0, staticItem);
                result.push(staticItemJoint);
                component.set("v.clientList", result); 
                component.set("v.enableClient",false);
            }  
            var _Loanid = component.get("v.LiaLoanId"); // dynamic LoanId            
            helper.PopulateLiabilityBasedonClient(component, event, helper,_Loanid);
            document.getElementById('targetID').innerHTML ='l7';
        });        
        $A.enqueueAction(action);
        window.scrollTo(0, 0);
    },
    
    AddRecord: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "False"
        
        
        //component.set("v.showPrimaryClient", false);
        
        component.set("v.IsdisabledClient",false);  
        component.set("v.isOpen", true);
        helper.showDiv(component, component.find('categoryPicklist').get('v.value'), event, helper);        
        component.set("v.Heading", 'Add Liability');
        component.find("ReSave").set("v.disabled", false);
        document.getElementById('clientPrimary').style.display = 'none';
    },
    
    EditRecord: function(component, event, helper) {      
        component.set("v.isOpen", true);   
        component.set("v.Heading", 'Edit Record');   
        helper.GetLiabilityforEdit(component, event, helper);
        component.find("ReSave").set("v.disabled", false);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle" 
        helper.ClearData(component, event, helper);       
        component.set("v.isOpen", false);
        component.set("v.showError", false);
        component.set("v.enableButton", true);
        component.set("v.enableType", true);
    },
    //Code Started for Story No:- ORMSFDC-1264 by Developer2
    /* PropertyTypeChage: function(component, event, helper) {   
           var propertyValue = component.find('PropertyType').get('v.value');
         //alert(propertyValue);
         if(propertyValue=='Condominium')
         {
              document.getElementById('Check_Condominium').style.display = 'block';
         }
         else
         {
              document.getElementById('Check_Condominium').style.display = 'none';
         }
     },*/
    //end
    categoryChange: function(component, event, helper) {   
        var parentValue = component.find('categoryPicklist').get('v.value'); 
                component.set("v.liabilityCategory", parentValue);
                if ( parentValue != 'Select Option') {          
            component.set("v.enableType", false);
            component.set("v.enableButton", true);
        } else {           
            component.set("v.enableType", true);
            component.set("v.enableButton", true);
        }        
        component.set('v.typeOptions', component.get('v.typePicklist')[parentValue]); 
        if(parentValue=='Real Estate Schedule')
        {
            component.find('typePicklist').set('v.text',"Property");
            component.find('typePicklist').set('v.value',"Property");
            component.set("v.enableButton", false);
        }
        else
        {
            component.find('typePicklist').set('v.text',"Select Option");
            component.find('typePicklist').set('v.value',"true");
            component.set("v.enableButton", true);
        }
    },
    
    typeChange: function(component, event, helper) {
        var parentValue = component.find('categoryPicklist').get('v.value');
        var typeValue = component.find('typePicklist').get('v.value');
        component.set("v.liabilityType", typeValue);        
        if (parentValue != 'Select Option' && typeValue != 'Select Option') {            
            component.set("v.enableType", false);
            component.set("v.enableButton", false);
        } else {
            
            component.set("v.enableType", false);
            component.set("v.enableButton", true);
        }        
        component.set('v.typeOptions', component.get('v.typePicklist')[parentValue]);
    },
    
    onClientSelectChange: function(component, event, helper) {
        var ClientIdforset = component.find('pickClient').get('v.value');         
        component.set("v.ClientID",ClientIdforset);
        var ClientId = component.get("v.ClientID");
    },
    
    propertyStatus: function(component, event, helper) {  
        var statusValue = component.find('propertyStatus').get('v.value');
        var inputAdditonalRemarks = component.find('additionalRemarks');        
        component.find("propertyAddress").set("v.errors", null); 
        component.find("realCity").set("v.errors", null);         
        if (statusValue == 'Subject Property') { 
            component.set("v.client.Liability_will_be_closed_by_Paying_RES__c" ,true);
            component.find("propertyAddress").set("v.value", component.get("v.subjectPropertyAddress"));
            component.find("realCity").set("v.value", component.get("v.subjectPropertyCity"));
            component.find("propertyState1").set("v.value", component.get("v.subjectPropertyState"));
            component.find("realZip").set("v.value", component.get("v.subjectPropertyZip")); 
            component.find("propertyAddress").set("v.disabled", true);
            component.find("realCity").set("v.disabled", true);
            component.find("propertyState1").set("v.disabled", true);
            component.find("realCounty").set("v.disabled", true);
            component.find("realZip").set("v.disabled", true);
            component.set("v.showPropertyWarning", false);
        }
        else{
            component.set("v.client.Liability_will_be_closed_by_Paying_RES__c" ,false)
            component.find("propertyAddress").set("v.disabled", false);
            component.find("realCity").set("v.disabled", false);
            component.find("propertyState1").set("v.disabled", false);
            component.find("realZip").set("v.disabled", false);
            component.set("v.showPropertyWarning", false);
        }
        
        if (statusValue == 'Other') {            
            document.getElementById("divRemarks").style.display = 'block';
            inputAdditonalRemarks.set("v.errors", null); 
        } else {
            document.getElementById("divRemarks").style.display = 'none';
            component.set("v.client.Additional_Remarks__c", '');
            inputAdditonalRemarks.set("v.errors", null); 
            // component.set("v.showPropertyWarning", true);
        }          
    },
    
    Delete: function(component, event, helper) {        
        var id = event.target.id;
        component.set("v.idIs",id);
        component.set("v.showPopup",true);        
    },
    
    doAction :function(component, event, helper) {        
        component.set("v.showPopup_2",false);
        component.set("v.showPopup",false);        
        helper.DeleteLiability(component, event, helper);
        helper.ClearData(component, event, helper);
      },
    
    closeDeleteModel : function(component, event, helper) {        
        component.set("v.showPopup",false);
    },
    
    next: function(component, event, helper) {
        helper.Loan_Next(component, event, helper);
    },
    
    previous: function(cmp, event, helper) {
        helper.prev(cmp);
    },
    
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
        var array_id_num = new Array();
        var array_mes_num = new Array();
        var array_reg_num = new Array();
        var arr_reg_num = new Array();
        var arr_func_num = new Array();
        
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
        function validateNumeric(value){
            var inz = value;
        }
        //To include multiple functions or a function with a regex you can repeat the ar_id with the regex or function
        //Please make sure the regex are formatted to account for blanks as well
        //For certain special characters please use the '\' character otherwise the regex may give errors
        var valArray = [
            { ar_id: "Amount", mes: "Please enter Amount", reg: validateRequiredField }
        ];        
        var valArrayNumeric = [
            { ar_id_num: "Amount", mes_num: "Please enter Numeric Value for Amount", regr: /[0-9]+/ }
        ];
        
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);        
        array_id_num = valArrayNumeric.map(item => item.ar_id_num);
        array_mes_num = valArrayNumeric.map(item => item.mes_num);
        array_reg_num = valArrayNumeric.map(item => item.regr);  
        var Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id) ;
        var Isclient=helper.CheckClient(component, event, helper);
        if (Isrequired || Isclient ) {
            component.set("v.showError", true);
            //What you need to do if there are errors
        } else {
            component.set("v.showError", false);
            // What you need to do if there are no errors
            //Include Save helper here
            helper.saveLiability(component, event, helper);
        }
    },    
    
    validateJob: function(component, event, helper){        
        var a_id = event.getSource().getLocalId();
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
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
        //To include multiple functions or a function with a regex you can repeat the ar_id with the regex or function
        //Please make sure the regex are formatted to account for blanks as well
        //For certain special characters please use the '\' character otherwise the regex may give errors
        var valArray = [
            { ar_id: "JobRelatedExpenses", mes: "Please enter Amount", reg: validateRequiredField }            
        ];
        
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);  
        var IsRequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
        var Isclient=helper.CheckClient(component, event, helper);
        if (IsRequired || Isclient) {
            //What you need to do if there are errors
            component.set("v.showError", true);
        } else {
            // What you need to do if there are no errors
            //Include Save helper here
            component.set("v.showError", false);
            helper.saveLiability(component, event, helper);
        }
    },
    
    validateLiability: function(component, event, helper){
        
        var a_id = event.getSource().getLocalId();
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        //var arr_reg = new Array();
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
        //To include multiple functions or a function with a regex you can repeat the ar_id with the regex or function
        //Please make sure the regex are formatted to account for blanks as well
        //For certain special characters please use the '\' character otherwise the regex may give errors
        var valArray = [
            { ar_id: "monthlyPayment", mes: "Please enter Amount", reg: validateRequiredField },
            { ar_id: "unpaidBalance", mes: "Please enter Amount", reg: validateRequiredField }
        ];        
        var valarrayregex=[
            { ar_idr: "liabilityZip", mesr: "Please enter a valid zip format (eg: 23454/23456-1234)", regr: "(^\\d{5}$)|(^\\d{5}-\\d{4}$)" },            
            { ar_idr: "remainingMonths", mesr: "Please enter a valid month (Non Negative)", regr: "^[0-9]\\d*(\\.\\d+)?$" },            
        ];
            
            array_id = valArray.map(item => item.ar_id);
            array_mes = valArray.map(item => item.mes);
            array_reg = valArray.map(item => item.reg);            
            array_idr = valarrayregex.map(item => item.ar_idr);
            array_mesr = valarrayregex.map(item => item.mesr);
            array_regr = valarrayregex.map(item => item.regr);
            
            var Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id) ;
            var IsRegex=helper.formatErrorMethodr(component, array_regr, array_mesr, array_idr);
            var Isclient=helper.CheckClient(component, event, helper);
            if (Isrequired || IsRegex || Isclient) {
            component.set("v.showError",true);            
            }
            else {
            // What you need to do if there are no errors
            //Include Save helper here
            component.set("v.showError", false);
            helper.saveLiability(component, event, helper);
            }
            },
            
            validateRealEstate: function(component, event, helper){             
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
            var valArray = [
            { ar_id: "propertyAddress", mes: "This is required field .", reg: validateRequiredField },
            { ar_id: "realCity", mes: "This is required field .", reg: validateRequiredField },
            { ar_id: "realCounty", mes: "This is required field .", reg: validateRequiredField },
            { ar_id: "RealEStateTax", mes: "This is required field .", reg: validateRequiredField },
            { ar_id: "YearBuiltId", mes: "This is required field .", reg: validateRequiredField },
            { ar_id: "SQFootage", mes: "This is required field .", reg: validateRequiredField },
            { ar_id: "PropertyHeldId", mes: "This is required field .", reg: validateRequiredField },
            { ar_id: "propertyStatus", mes: "Please select property status", reg: validateRequiredField }
            
        ];
        
        var valarrayregex=[
            { ar_idr: "realZip", mesr: "Please enter a valid zip format (eg: 23454/23456-1234)", regr: "(^\\d{5}$)|(^\\d{5}-\\d{4}$)" },
        ];
            
            array_id = valArray.map(item => item.ar_id);
            array_mes = valArray.map(item => item.mes);
            array_reg = valArray.map(item => item.reg);            
            array_idr = valarrayregex.map(item => item.ar_idr);
            array_mesr = valarrayregex.map(item => item.mesr);
            array_regr = valarrayregex.map(item => item.regr);
            
            var Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id) ;
            var IsRegex=helper.formatErrorMethodr(component, array_regr, array_mesr, array_idr);
            var ValidatePropertyStatus = helper.ValidatePropertyStatusOther(component, event, helper); 
            var Isclient=helper.CheckClient(component, event, helper);
            var  IsBuiltYearValidate=helper.validateYearBuilt(component, event, helper);
            if (Isrequired || IsRegex || ValidatePropertyStatus||Isclient ||IsBuiltYearValidate) {            
            component.set("v.showError", true);
            }
            else{
            component.set("v.showError", false);
            helper.saveLiability(component, event, helper);  
            }             
            },
            
            doAction_helper :function(component, event, helper){            
            helper.do_action_helper(component, event, helper);             
            },
            
            closeModel_helper :function(component, event, helper){
            component.set("v.showPopup_2",false);
            },
            
            NumberAccountNumbers:function(component, event, helper) {
            var inz = 'v.client.Account_Number__c';        
            helper.validateNumbersOnly(component, event, helper,inz);
            },
            //validate Square footage
             validateSquareFootage:function(component, event, helper) {
            var inz = 'v.client.Square_Footage__c';        
            helper.validateNumbersOnly(component, event, helper,inz);
            },
           
            })