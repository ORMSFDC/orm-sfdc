({
    eventhit: function(component, event, helper) {
        var selectedAccount = event.getParam("EventLoanID");        
    },
    
    doInit: function(component, event, helper) { 
        window.scrollTo(0, 0);
        helper.ValidationForPills(component, event, helper) ;
        
        helper.DropdownPopulate(component, event, helper);
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
            text: "Bonuses",
            value: "Bonuses"
        }, {
            text: "Capital Gains",
            value: "Capital Gains"
        }, {
            text: "Commissions",
            value: "Commissions"
        }, {
            text: "Disability Income",
            value: "Disability Income"
        }, {
            text: "Dividend/Interest Income",
            value: "Dividend/Interest Income"
        }, {
            text: "Employment Income",
            value: "Employment Income"
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
            text: "Housing Choice Voucher (Sec 8)",
            value: "Housing Choice Voucher (Sec 8)"
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
        }, {
            text: "Net Rental Income",
            value: "Net Rental Income"
        },{
            text: "Non-Borrower Household Income",
            value: "Non-Borrower Household Income"
        }, {
            text: "Notes Receivable/Installment",
            value: "Notes Receivable/Installment"
        }, {
            text: "Other Type Of Income",
            value: "Other Type Of Income"
        }, {
            text: "Overtime",
            value: "Overtime"
        }, {
            text: "Pension/Retirement Income",
            value: "Pension/Retirement Income"
        },{
            text: "Royalty Payment",
            value: "Royalty Payment"
        },{
            text: "Seasonal Income",
            value: "Seasonal Income"
        },{
            text: "Social Security Income",
            value: "Social Security Income"
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
            component.set("v.showErrorEmp", false);
            component.set("v.showTable", false);
            component.set('v.enableSave', false);
            document.getElementById('maindiv').style.display = 'none';                        
        } else if (ClientId != "") {
            component.set("v.showSuccess", false);
            component.set("v.showError", false);
            component.set("v.showErrorEmp", false);
            component.set("v.showTable", true);
            component.set('v.enableSave', true);
            document.getElementById('maindiv').style.display = 'block';
        }   
        
        component.set("v.ClientID",ClientId);
        component.set("v.clientList", result);
        helper.getAllIncome(component, event, helper); 
        helper.PopulateIncomeBasedonClient(component, event, helper,ClientId);     
        document.getElementById('TotalDiv').style.display = 'block';
        
        
    }
    else
    {                 
    result.splice(0, 0, staticItem);
    component.set("v.clientList", result);   
    component.set("v.showTable", true);
    document.getElementById('maindiv').style.display = 'block';
    helper.PopulateIncomeBasedonClient(component, event, helper,ClientId);     
    helper.getAllIncome(component, event, helper); 
    document.getElementById('TotalDiv').style.display = 'block';
} 
 document.getElementById('targetID').innerHTML ='l5';
//var TabRecordData= component.get('v.TabRecordData');
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
            component.set("v.showErrorEmp", false);
            component.set("v.showTable", true);
            component.set('v.enableSave', true);
            document.getElementById('maindiv').style.display = 'block';
            document.getElementById('TotalDiv').style.display = 'none';
        }
        else
        {
            component.set("v.showSuccess", false);
            component.set("v.showError", false);
            component.set("v.showErrorEmp", false);
            component.set("v.showTable", false);
            component.set('v.enableSave', false);
            document.getElementById('maindiv').style.display = 'none';
            document.getElementById('TotalDiv').style.display = 'block';
        }
        helper.PopulateIncomeBasedonClient(component, event, helper,ClientId);         
    },
        
        PickChange: function(component, event, helper) {
            
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
            
            if (incomeOption != '---Select option---')
                component.set('v.divIncome', true);  
            
            
        },
            MoveNext:function(component, event, helper) 
{
    helper.Loan_Next(component, event, helper);
},
    
    next: function(component, event, helper) {
        helper.Loan_Next(component, event, helper);
    },
        
        previous: function(cmp, event, helper) {
            helper.prev(cmp);
        },
            
            AddRecord: function(component, event, helper) {
                
                component.set("v.Heading", 'Add Income');
                
                var incomeType=component.find('incomePicklist').get('v.value');
                if(incomeType=="Social Security Income")
                {
                    component.set("v.SocialSecurityIncome", false);
                }
                else
                {
                    component.set("v.SocialSecurityIncome", true);   
                }
                
                if(incomeType=="Employment Income")
                {
                    component.set("v.showPopup", true);
                    component.set("v.disabledClient","display:block");
                    component.find('inputIncomeType').set('v.value',"Employment Income");  
                }
                else
                {
                    
                    helper.clearIncomeData(component, event, helper);
                    helper.SetId(component, event, helper);                
                    component.set("v.isOpen", true);
                    component.set("v.disabledClient","display:block");
                    var value=component.get('v.IncomeTypeId');
                    component.set("v.IncomeList.Income_Types__c", value); 
                    // Code Added by Dev4 for ORMSFDC-1401
                    if(incomeType=="Bonuses" || incomeType=="Commissions" || incomeType=="Overtime")
                    {
                        component.set('v.IncomeList.Income_Source__c','Employment');
                    }
                    // Code Ended by Dev4 for ORMSFDC-1401
                }
            },
                
                closeModel: function(component, event, helper) {
                    // for Hide/Close Model,set the "isOpen" attribute to "Fasle"       
                    component.set("v.isOpen", false);
                    component.set("v.showError", false);
                    component.set("v.showErrorEmp", false);
                    component.set("v.showPopup", false);
                    component.set("v.DeletePopup", false);
                    component.set("v.divIncome", false); 
                    component.set("v.disabledClient","display:none");
                    var ClientId = component.get("v.ClientID");        
                    helper.PopulateIncomeBasedonClient(component, event, helper,ClientId);
                    component.find("incomePicklist").set("v.value", true);
                    component.set("v.enableAddIncome", false);  
                    helper.clearIncomeData(component, event, helper);
                    helper.ClearEmpData(component, event, helper);
                },
                    
                    EditRecord : function(component, event, helper) { 
                        
                        var objType = event.target.name;                        
                        component.set("v.Heading", 'Edit Income');
                        var id=event.target.id;
                        component.set("v.RecordId",id);
                        
                        if(objType == "Income")
                        {
                            helper.getOneIncome(component, event, helper);
                            component.set("v.isOpen",true);
                            component.set("v.disabledClient","display:none");
                        }
                        else
                        {
                            component.set("v.showError",false);
                            component.set("v.showPopup", true);
                            component.set("v.disabledClient","display:none");
                            helper.ClearEmpData(component, event, helper);
                            helper.GetEmploymentforEdit(component, event, helper);
                        }
                        
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
                            
                            var valArray = [
                                { ar_id: "IncomeSource", mes: "This is a required field", reg: validateRequiredField },
                                { ar_id: "IncomeType", mes: "This is a required field", reg: validateRequiredField },
                                { ar_id: "IncomeValue", mes: "This is a required field", reg: validateRequiredField },
                                //{ ar_id: "pickClient", mes: "Please select a value for this field", reg: validateRequiredField }
                            ];
                                array_id = valArray.map(item => item.ar_id);
                                array_mes = valArray.map(item => item.mes);
                                array_reg = valArray.map(item => item.reg);
                                var requiredfieldchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
                                
                                var regexchk=helper.CurrencyRegexCheck(component);
                                var CheckZero = helper.CheckZero(component, event, helper);                                
                                var clientCmp=component.find("pickClient");
                                var ClientSel=clientCmp.get("v.value");
                                var isClientSel=false;
                                
                                if(ClientSel=="" || ClientSel==undefined || ClientSel==null)
                                {
                                
                                isClientSel=true;
                                document.getElementById("clientlbl").innerText = 'Please Select the Client.';           
                                
                                }
                                if (requiredfieldchk || regexchk || isClientSel || CheckZero) {
                                component.set("v.showError", true);
                                component.set("v.showErrorEmp", true);
                                component.set("v.showSuccess", false);
                                //What you need to do if there are errors
                                } else {
                                // What you need to do if there are no errors
                                //Include Save helper here
                                component.set("v.showError", false);
                                component.set("v.showErrorEmp", false);
                                helper.Saveincome(component, event, helper);            
                                component.find("incomePicklist").set("v.value", true); 
                                component.set("v.isOpen", false);
                                component.set("v.enableAddIncome", false);
                                helper.getAllIncome(component, event, helper);
                                helper.clearIncomeData(component, event, helper);
                                //Goes to the next Step
                                //helper.Loan_Next(component, event, helper);//Please note this function 
                                //uses certain hardcoded ids
                                }
                                },                            
                                DeleteRecord : function(component, event, helper) {
                                
                                helper.DeleteRecord(component, event, helper);
                                helper.getAllIncome(component, event, helper);
                                helper.clearIncomeData(component, event, helper);
                                
                                },
                                DeleteConfirm : function(component, event, helper)
                                { 
                                var objType = event.target.name;
                                component.set('v.DeleteObj',objType);
                                
                                var id=event.target.id;
                                component.set('v.DeleteID',id);
                                
                                component.set("v.DeletePopup",true);
                                },
                                FormatEmploymentValidations: function(component, event, helper) {   
                                
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
                                { ar_id: "inputYear", mes: "This is a required field", reg: validateRequiredField },
                                { ar_id: "inputIncomeValue", mes: "This is a required field", reg: validateRequiredField },
                            ];
                            var valarrayregex=[
                                { ar_idr: "inputZip", mesr: "Please enter a valid zip format (eg: 23454/23456-1234)", regr: "(^\\d{5}$)|(^\\d{5}-\\d{4}$)" },
                                { ar_idr: "inputYear", mesr: "Please enter a valid number of year(In two digit) ", regr: "^\\d{1,2}$" },
                            ];
                                
                                array_id = valArray.map(item => item.ar_id);
                                array_mes = valArray.map(item => item.mes);
                                array_reg = valArray.map(item => item.reg);
                                
                                array_idr = valarrayregex.map(item => item.ar_idr);
                                array_mesr = valarrayregex.map(item => item.mesr);
                                array_regr = valarrayregex.map(item => item.regr);
                                var Isrequired=helper.formatErrorMethod(component, array_reg, array_mes, array_id) ;
                                var PhoneValidation=helper.validatePhone(component,'inputEmpPhone');
                                var IsRegex=helper.formatErrorMethodr(component, array_regr, array_mesr, array_idr);
                                var CheckMonth=helper.CheckMonth(component, event, helper);
                                var CheckZero = helper.CheckEmpZero(component, event, helper);
                                
                                var clientCmp=component.find("pickClient");
                                var ClientSel=clientCmp.get("v.value");
                                var isClientSel=false;
                                if(ClientSel=="" || ClientSel==undefined || ClientSel==null)
                                {
                                isClientSel=true;
                                document.getElementById("clientlbl").innerText = 'Please Select the Client';           
                                
                                }
                                if (Isrequired || IsRegex || CheckMonth || PhoneValidation || isClientSel || CheckZero) { 
                                
                                component.set("v.showErrorEmp",true);            
                                }
                                else
                                {
                                component.set("v.showErrorEmp",false);
                                var ClientId= component.get("v.ClientID");        
                                helper.SaveEmployment(component, event, helper);
                                component.find("incomePicklist").set("v.value", true);
                                component.set("v.showPopup", false);
                                component.set("v.enableAddIncome", false);
                                helper.PopulateIncomeBasedonClient(component, event, helper,ClientId);
                                helper.getAllIncome(component, event, helper);
                                
                                helper.ClearEmpData(component, event, helper);
                                this.closeModel(component, event, helper);
                                }
                                },
                                
                                FormatPhone: function(component, event, helper){           
                                helper.FormatPhonehelper(component, event, helper,"inputEmpPhone","v.NewEmp.EmployerPhone__c");                
                                }
                                })