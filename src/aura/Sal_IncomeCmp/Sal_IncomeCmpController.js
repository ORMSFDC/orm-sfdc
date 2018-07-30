({
    myAction: function(component, event, helper) {
        
    },
    eventhit: function(component, event, helper) {
        var selectedAccount = event.getParam("EventLoanID");
        
    },
   
    doInit: function(component, event, helper) {
                             
                             var loid = component.get("{!v.IncomeLoanId}");
                             
                             var incomeOptions = [{
                             text: "Accessory Unit Income",
                             value: "Accessory Unit Income"
                             },{
                             text: "Alimony/Child Support Income",
                             value: "Alimony/Child Support Income"
                             }, {
                             text: "Automobile Expense Amount",
                             value: "Automobile Expense Amount"
                             }, {
                             text: "Boarder Income",
                             value: "Boarder Income"
                             }, {
                             text: "Capital Gains",
                             value: "Capital Gains"
                             }, {
                             text: "Disability Income",
                             value: "Disability Income"
                             }, {
                             text: "Employment Related Assets",
                             value: "Employment Related Assets"
                             },{
                             text: "Foreign Income",
                             value: "Foreign Income"
                             }, {
                             text: "Foster Care",
                             value: "Foster Care"
                             },{
                             text: "Housing Choice Voucher",
                             value: "Housing Choice Voucher"
                             }, {
                             text: "Millitary Base Pay",
                             value: "Millitary Base Pay"
                             }, {
                             text: "Millitary Clothes Allowance",
                             value: "Millitary Clothes Allowance"
                             }, {
                             text: "Millitary Combat Pay",
                             value: "Millitary Combat Pay"
                             }, {
                             text: "Millitary Flight Pay",
                             value: "Millitary Flight Pay"
                             }, {
                             text: "Millitary Hazard Pay",
                             value: "Millitary Hazard Pay"
                             }, {
                             text: "Millitary Overseas Pay",
                             value: "Millitary Overseas Pay"
                             }, {
                             text: "Millitary Prop Pay",
                             value: "Millitary Prop Pay"
                             }, {
                             text: "Millitary Quarters Allowance",
                             value: "Millitary Quarters Allowance"
                             }, {
                             text: "Millitary Rations Allowance",
                             value: "Millitary Rations Allowance"
                             }, {
                             text: "Millitary Variable Housing Allowance",
                             value: "Millitary Variable Housing Allowance"
                             }, {
                             text: "Mortgage Credit Certificate",
                             value: "Mortgage Credit Certificate"
                             }, {
                             text: "Mortgage Differential",
                             value: "Mortgage Differential"
                             },{
                             text: "Non-Borrower Household Income",
                             value: "Non-Borrower Household Income"
                             }, {
                             text: "Notes Receivable/Installment",
                             value: "Notes Receivable/Installment"
                             }, {
                             text: "Other Type Of Income",
                             value: "Other Type Of Income"
                             },{
                             text: "Royalty Payment",
                             value: "Royalty Payment"
                             },{
                             text: "Seasonal Income",
                             value: "Seasonal Income"
                             },{
                             text: "Subject Property Net Cash Flow",
                             value: "Subject Property Net Cash Flow"
                             },  {
                             text: "Temporary Leave Income",
                             value: "Temporary Leave Income"
                             },{
                             text: "Tip Income",
                             value: "Tip Income"
                             }, {
                             text: "Trust",
                             value: "Trust"
                             }, {
                             text: "Unemployment/Public Assistance Income",
                             value: "Unemployment/Public Assistance Income"
                             }, {
                             text: "VA Benefits (Non Educational)",
                             value: "VA Benefits (Non Educational)"
                             }, ];
        
        component.set('v.incomeOptions', incomeOptions);
        var _Loanid = component.get("v.IncomeLoanId");
        var action = component.get("c.getclientValue");
        var staticItem = {  Id: "",
            	Name: "---Select Client---" };
        action.setParams({
            "LoanId": _Loanid
        });
        
        action.setCallback(this, function(data) {
           	   var result =  data.getReturnValue();
               var resultLength =  result.length;                 
               if(resultLength==1)
               {     
                    var ClientId=result[0].Id;
                    if (ClientId == "") {
                        component.set("v.showSuccess", false);
                        component.set("v.showError", false);
                        component.set("v.showTable", false);
                        component.set('v.enableSave', false);
                        document.getElementById('maindiv').style.display = 'none';                        
                    } else if (ClientId != "") {
                        component.set("v.showSuccess", false);
                        component.set("v.showError", false);
                        component.set("v.showTable", true);
                        component.set('v.enableSave', true);
                        document.getElementById('maindiv').style.display = 'block';
                    }   
                    component.set("v.ClientID",ClientId);
                    component.set("v.clientList", result);
        			helper.getAllIncome(component, event, helper);
                    helper.PopulateIncomeBasedonClient(component, event, helper,ClientId); 
         			document.getElementById('TotalDiv').style.display = 'none';
                }
                else
                {                 
                    result.splice(0, 0, staticItem);
                    component.set("v.clientList", result);     
     				//helper.getAllIncome(component, event, helper); 
    				document.getElementById('TotalDiv').style.display = 'block';
                } 
        });        
        $A.enqueueAction(action);
        window.scrollTo(0, 0);          
    },
        
    onClientSelectChange: function(component, event, helper) {
        var ClientIdforset = component.find('pickClient').get('v.value');     
        component.set("v.ClientID",ClientIdforset);
        var ClientId = component.get("v.ClientID");
        
        if(ClientId!=''){
            component.set("v.showSuccess", false);
            component.set("v.showError", false);
            component.set("v.showTable", true);
            component.set('v.enableSave', true);
            document.getElementById('maindiv').style.display = 'block';
            document.getElementById('TotalDiv').style.display = 'none';
        }
        else
        {
            component.set("v.showSuccess", false);
            component.set("v.showError", false);
            component.set("v.showTable", false);
            component.set('v.enableSave', false);
            document.getElementById('maindiv').style.display = 'none';
            document.getElementById('TotalDiv').style.display = 'block';
        }
        helper.PopulateIncomeBasedonClient(component, event, helper,ClientId);         
    },
    
    PickChange: function(component, event, helper) {
        helper.HideIncome(component, event, helper);
        var incomeOption = component.find('incomePicklist').get('v.value');      
        component.set("v.showSuccess",false);
        
        if(incomeOption!='---Select option---')
        {
            component.set('v.enableAddIncome', true);
        }
        else
        {
            component.set('v.enableAddIncome', false);
        }
            
        
        if (incomeOption == 'Alimony/Child Support Income')
            component.set('v.divAlimony', true);
        
        else if (incomeOption == 'Automobile Expense Amount')
            component.set('v.divAutomobile', true);
        
            else if (incomeOption == 'Boarder Income')
                component.set('v.divBoarder', true);
        
                else if (incomeOption == 'Capital Gains')
                    component.set('v.divCapitalGains', true);
        
                    else if (incomeOption == 'Foster Care')
                        component.set('v.divFaosterCare', true);
                        
                        else if (incomeOption == 'Disability Income')
                        component.set('v.divDisability', true);
        
                        else if (incomeOption == 'Millitary Base Pay')
                            component.set('v.divMilitaryBasePay', true);
        
                            else if (incomeOption == 'Millitary Clothes Allowance')
                                component.set('v.divMilitaryClothAllowance', true);
        
                                else if (incomeOption == 'Millitary Combat Pay')
                                    component.set('v.divMilitaryCombatPay', true);
        
                                    else if (incomeOption == 'Millitary Flight Pay')
                                        component.set('v.divMilitaryFlightPay', true);
        
                                        else if (incomeOption == 'Millitary Hazard Pay')
                                            component.set('v.divMilitaryHazardPay', true);
        
                                            else if (incomeOption == 'Millitary Overseas Pay')
                                                component.set('v.divMilitaryOverseasPay', true);
        
                                                else if (incomeOption == 'Millitary Prop Pay')
                                                    component.set('v.divMilitaryPropPay', true);
        
                                                    else if (incomeOption == 'Millitary Quarters Allowance')
                                                        component.set('v.divMilitaryQuartersAllowance', true);
        
                                                        else if (incomeOption == 'Millitary Rations Allowance')
                                                            component.set('v.divMilitaryRationsAllowance', true);
        
                                                            else if (incomeOption == 'Millitary Variable Housing Allowance')
                                                                component.set('v.divMilitaryVariableHousigAllowance', true);
        
                                                                else if (incomeOption == 'Mortgage Credit Certificate')
                                                                    component.set('v.divMortgageCreditCertificate', true);
        
                                                                    else if (incomeOption == 'Mortgage Differential')
                                                                        component.set('v.divMortgageDifferentialCertificate', true);
        
                                                                        else if (incomeOption == 'Notes Receivable/Installment')
                                                                            component.set('v.divNotesRecievableInstallment', true);
        
                                                                            else if (incomeOption == 'Other Type Of Income')
                                                                                component.set('v.divOtherTypeOfIncome', true);
        
                                                                                /*else if (incomeOption == 'Overtime Income')
                                                                                    component.set('v.divOverTime', true);
                                                                                
                                                                                else if (incomeOption == 'Bonus Income')
                                                                                    component.set('v.divBonus', true);
                                                                                    
                                                                                    else if (incomeOption == 'Pension Retirement')
                                                                                    component.set('v.divPensionRetirement', true);
        
                                                                                    else if (incomeOption == 'Social Security/Permanent DIsability')
                                                                                        component.set('v.divSocialSecurity', true);*/
        
                                                                                        else if (incomeOption == 'Subject Property Net Cash Flow')
                                                                                            component.set('v.divSubjectProperty', true);
        
                                                                                            else if (incomeOption == 'Temporary Disability')
                                                                                                component.set('v.divTemporaryDisability', true);
        
                                                                                                else if (incomeOption == 'Temporary Leave Income')
                                                                                                    component.set('v.divTemporaryLeave', true);
        
                                                                                                    else if (incomeOption == 'Trust')
                                                                                                        component.set('v.divTrust', true);
        
                                                                                                        else if (incomeOption == 'Unemployment/Public Assistance Income')
                                                                                                            component.set('v.divUnemployment', true);
        
                                                                                                            else if (incomeOption == 'VA Benefits (Non Educational)')
                                                                                                                component.set('v.divVABenefits', true);
    },
    MoveNext:function(component, event, helper) {
        helper.Loan_Next(component, event, helper);
    },
    
    FormatValidations1: function(component, event, helper) {
        var a_id = event.getSource().getLocalId();
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();
        function validateRequiredField(value) {
            debugger;
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
            { ar_id: "socialIncome", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "pensionIncome", mes: "This is a required field", reg: validateRequiredField },
 			{ ar_id: "dividendInterest", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "baseEmpIncome", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "netRentalIncome", mes: "This is a required field", reg: validateRequiredField }
        ];
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);
        var requiredfieldchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
        
        var regexchk=helper.CurrencyRegexCheck(component);       
        if (requiredfieldchk || regexchk) {
            component.set("v.showError", true);
            component.set("v.showSuccess", false);
            //What you need to do if there are errors
        } else {
            // What you need to do if there are no errors
            //Include Save helper here
            component.set("v.showError", false);
            
            helper.Saveincome(component, event, helper);
                        
            helper.HideIncome(component, event, helper); 
            component.set("v.isOpen", false);
            //Goes to the next Step
            //helper.Loan_Next(component, event, helper);//Please note this function 
            //uses certain hardcoded ids
        }
        
    },
    
    next: function(component, event, helper) {
        helper.Loan_Next(component, event, helper);
    },
    
    previous: function(cmp, event, helper) {
        helper.prev(cmp);
    },
    
    IncomeValidations: function(component, event, helper) {
        debugger; 
        var a_id = event.getSource().getLocalId();
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        switch (a_id) {
            case "overTime":
                msg = "Amount cannot be Negative";
                reg = /^(?!(?:0|0\.0|0\.00)$)[+]?\d+(\.\d|\.\d[0-9])?$/;
                break;
            default:
                ;
        }
        helper.IncomeFormatValidations(component, reg, msg, a_id);
    },

    AddRecord: function(component, event, helper) {
         helper.SetId(component, event, helper); 
        component.set("v.isOpen", true);
        component.set("v.Heading", 'Add Income');
    },

    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"       
        component.set("v.isOpen", false);
        component.set("v.showError", false);
        component.set("v.showPopup", false);        
        var ClientId = component.get("v.ClientID");        
        helper.PopulateIncomeBasedonClient(component, event, helper,ClientId);
        component.find("incomePicklist").set("v.value", true);
        component.set("v.enableAddIncome", false);        
    },
        
    EditRecord : function(component, event, helper) { 
        component.set("v.Heading", 'Add Income');
        var id=event.target.id;
        var CntrlId=event.target.title;
        component.set("v.CntrlId",null);
        component.set("v.CntrlId",CntrlId);        
        var name=event.target.name;
        var CmpId="v."+name;
        helper.HideIncome(component, event, helper);
        component.set(CmpId,true);
        component.set("v.isOpen",true);
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
         
        var auraId= component.get("v.CntrlId");
        var valArray = [
            { ar_id: auraId, mes: "This is a required field", reg: validateRequiredField }
             ];
        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);
        var requiredfieldchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
        
        var regexchk=helper.CurrencyRegexCheck(component);
                 
        if (requiredfieldchk || regexchk) {
            component.set("v.showError", true);
            component.set("v.showSuccess", false);
            //What you need to do if there are errors
        } else {
            // What you need to do if there are no errors
            //Include Save helper here
            component.set("v.showError", false);            
            helper.Saveincome(component, event, helper);            
            component.find("incomePicklist").set("v.value", true);
            helper.HideIncome(component, event, helper); 
            component.set("v.isOpen", false);
            component.set("v.enableAddIncome", false);
            helper.getAllIncome(component, event, helper);
            //Goes to the next Step
            //helper.Loan_Next(component, event, helper);//Please note this function 
            //uses certain hardcoded ids
        }
    },
        
    DeleteRecord : function(component, event, helper) {         
        /*var id=event.target.id;        
        var name=event.target.name;
        
        var CmpId="v."+name;
        helper.HideIncome(component, event, helper);
        component.set(CmpId,true);
        //component.set("v.isOpen",true);
        set params({
            id:id,
            name:''            
        })
        helper.Saveincome(component, event, helper);*/
    },
        
    DeleteConfirm : function(component, event, helper) { 
        component.set("v.showPopup",true);
    }
    
})