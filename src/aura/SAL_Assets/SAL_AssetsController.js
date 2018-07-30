({
    doInit: function(component, event, helper) {  
        window.scrollTo(0, 0);
        helper.ValidationForPills(component, event, helper) ;
        helper.getAllAssets(component, event, helper);
        //Data for Category DropDown
        var assetCategoryVals = [
            { text: "Bank/Credit Union", value: "Bank/Credit Union" },
            { text: "Stock & Bonds", value: "Stock & Bonds" },
            { text: "Life Insurance", value: "Life Insurance" },
            { text: "Retirement Fund", value: "Retirement Fund" },
            { text: "Business", value: "Business" },
            { text: "Others", value: "Others" }
        ];        
        //Data for Stock type After Selecting Category from Dropdown
        var StockTypeOptionsVals = [
            { text: "Stock", value: "Stock" },
            { text: "Bond", value: "Bond" },
            { text: "Mutual fund", value: "Mutual fund" },
            { text: "Gift of Equity", value: "Gift of Equity" },
            
        ];
            //Data for Bank Account DropDown
            var BankAccountTypeOptionsVals = [
            { text: "Certificate of Deposit/Time Deposit", value: "Certificate of Deposit/Time Deposit" },
            { text: "Checking Account", value: "Checking Account" },
            { text: "Trust Account", value: "Trust Account" },
            { text: "Cash on Hand", value: "Cash on Hand" },
            { text: "Money Market Fund", value: "Money Market Fund" },
            { text: "Savings Account", value: "Savings Account" },
        ];       
        //Data for type DropDown
        var AssetsTypeOptionsVals = [
            { text: "Cash Deposit on Sales Contract", value: "Cash Deposit on Sales Contract" },
            { text: "Gifts Not Deposited", value: "Gifts Not Deposited" },
            { text: "Secured Borrower Funds not Deposited", value: "Secured Borrower Funds not Deposited" },
            { text: "Bridge Loan Not Deposited", value: "Bridge Loan Not Deposited" },
            //Code Modified by Dev4 for ORMSFDC-1542
            //{ text: "Non-Liquid Assets", value: "Non-Liquid Assets" },
            { text: "Other Non-Liquid Asset", value: "Other Non-Liquid Asset" },
            { text: "Other Liquid Asset", value:"Other Liquid Asset"},
            { text: "Net Equity", value:"Net Equity"}
            //Code Ended by Dev4 for ORMSFDC-1542
            
        ];        
        //Data for State DropDown
        var States = [
            { text: "Alabama", value: "Alabama" },
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
            { text: "Montana Nebraska", value: "Montana Nebraska" },
            //{ text: "Nebraska", value: "Nebraska" },
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
            { text: "Pennsylvania Rhode Island", value: "Pennsylvania Rhode Island" },
            // { text: "Rhode Island", value: "Rhode Island" },
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
            { text: "Wyoming", value: "Wyoming" },
            
        ];
            component.set('v.assetCategory', assetCategoryVals);
            component.set('v.StockTypeOptions', StockTypeOptionsVals);
            component.set('v.BankAccountTypeOptions', BankAccountTypeOptionsVals);
            component.set('v.AssetsTypeOptions', AssetsTypeOptionsVals);
            component.set('v.UsState', States);            
            var _Loanid = component.get("v.assetLoanId"); 
            helper.PopulateAssetBasedonClient(component, event, helper,_Loanid);
            var action = component.get("c.getClientList");            
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
            if(resultLength==1)
            {     
            var ClientId=result[0].Id;
        if (ClientId == "") {
            component.find("categoryId").set("v.disabled", true);
            component.find("addAsset").set("v.disabled", true);
            component.set("v.objAsset.Category__c", "Select one");
            
        } else if (ClientId != "") {
            component.find("categoryId").set("v.disabled", false);
            component.find("addAsset").set("v.disabled", true);
        }   
        component.set("v.ClientID",ClientId);
        component.set("v.ClientList", result);
    }
    else
    {                 
    result.splice(0, 0, staticItem);
    result.push(staticItemJoint);
    component.set("v.ClientList", result);               
}    
 document.getElementById('targetID').innerHTML ='l6';
});

$A.enqueueAction(action);

window.scrollTo(0, 0);
},
    
    //get Asset record based on Id for editing
    EditAssetbyId: function(component, event, helper) {
        helper.GetAssetforEdit(component, event, helper);
        helper.getAllAssets(component, event, helper); 
        component.set("v.Heading", 'Edit Asset');
    },
        
        //Close Modal Popup Function
        closeModel: function(component, event, helper) {
            
            component.set("v.isBankAccountOpen", false);
            component.set("v.isClentSelected", "false");
            component.set("v.isStockOpen", false);
            component.set("v.isLifeInsuaranceOpen", false);
            component.set("v.isRetirementOpen", false);
            component.set("v.isBusinessOpen", false);
            component.set("v.isOthersOpen", false);
            component.set("v.showError", false);
            helper.ClearData(component, event, helper);
            
        },
            
            //After changing the Client from dropdown Populate Record in the Table
            onClientSelectChange: function(component, event, helper) {
                var ClientIdforset = component.find('pickClient').get('v.value');     
                component.set("v.ClientID",ClientIdforset);
                var ClientId = component.get("v.ClientID");                
                if (ClientId != "") {
                    component.find("categoryId").set("v.disabled", false);
                    component.find("addAsset").set("v.disabled", true);
                } 
                else if (ClientId == "") 
                {
                    component.find("categoryId").set("v.disabled", true);
                    component.find("addAsset").set("v.disabled", true);
                    component.set("v.objAsset.Category__c", "Select one");
                }
                helper.getAllAssets(component, event, helper);
            },
                
                //Add new Asset button enabling after selecting Category from Dropdown
                addAssetBasedOnCategory: function(component, event, helper) {                    
                    var resultCmp = component.find("categoryId");
                    var category = resultCmp.get("v.value");                    
                    if (category == "") {
                        component.find("addAsset").set("v.disabled", true);
                        return false;
                    } else if (category != "") {
                        component.find("addAsset").set("v.disabled", false);
                    }
                },
                    
                    //Add Asset(displaying popup) after Clicking the Add button 
                    addAsset: function(component, event, helper) {
                        component.set("v.Heading", 'Add Asset');                        
                        var resultCmp = component.find("categoryId");                        
                        var category = resultCmp.get("v.value");
                        component.set("v.category",category);
                        if (category == 'Bank/Credit Union') {
                            component.set("v.isBankAccountOpen", true);
                        }
                        if (category == 'Stock & Bonds') {
                            component.set("v.isStockOpen", true);
                        }
                        
                        if (category == 'Life Insurance') {
                            component.set("v.BLRText", 'Face Amount *');
                            component.set("v.isLifeInsuaranceOpen", true);
                        }
                        if (category == 'Retirement Fund') {
                            component.set("v.BLRText", 'Vested Interest in Retirement Fund *');
                            component.set("v.isRetirementOpen", true);
                        }
                        if (category == 'Business') {
                            component.set("v.BLRText", 'Net Worth of Business(es) Owned *');
                            component.set("v.isBusinessOpen", true);
                        }
                        if (category == 'Others') {
                            component.set("v.isOthersOpen", true);
                        }                       
                    },
                        
                        //Validate Bank Account Data from Popup after clicking on Save Button 
                        ValidateBankAccount: function(component, event, helper) {
                            helper.ClientSelected(component, event, helper,Loan);            
                            var array_id = new Array();
                            var array_mes = new Array();
                            var array_reg = new Array();                            
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
                                { ar_id: "Bank_SrcName", mes: "This is a required field", reg: validateRequiredField },
                                { ar_id: "pickClient", mes: "This is a required field", reg: validateRequiredField },
                                { ar_id: "cashMarketValueID", mes: "This is a required field", reg: validateRequiredField },
                                { ar_id: "accountTypeID", mes: "Please select a value for this field", reg: validateRequiredField }
                                
                            ];
                            array_id = valArray.map(item => item.ar_id);
                            array_mes = valArray.map(item => item.mes);
                            array_reg = valArray.map(item => item.reg);
                            var requirdchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
                            var regexchk=helper.CurrencyRegexCheck(component);
                            
                            if (requirdchk || regexchk) {
                                component.set("v.showError", true);
                            }
                            else
                            {
                                component.set("v.showError", false);
                                helper.saveAsset(component, event, helper);
                                helper.getAllAssets(component, event, helper);
                                component.set("v.isBankAccountOpen", false);
                                var Loan = component.get("v.assetLoanId");
                                helper.PopulateAssetBasedonClient(component, event, helper,Loan);            
                            }        
                        },
                            
                            //Validate Stock Data from Popup after clicking on Save Button
                            ValidateStock: function(component, event, helper) { 
                                helper.ClientSelected(component, event, helper,Loan);            
                                var array_id = new Array();
                                var array_mes = new Array();
                                var array_reg = new Array();        
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
                                    { ar_id: "Stock_SrcName", mes: "This is a required field", reg: validateRequiredField },
                                    { ar_id: "pickClient", mes: "This is a required field", reg: validateRequiredField },
                                    { ar_id: "cashMarketStockID", mes: "This is a required field", reg: validateRequiredField },
                                    { ar_id: "assetTypeID", mes: "Please select a value for this field", reg: validateRequiredField }
                                ];
                                array_id = valArray.map(item => item.ar_id);
                                array_mes = valArray.map(item => item.mes);
                                array_reg = valArray.map(item => item.reg);                                
                                var requirdchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
                                var regexchk=helper.CurrencyRegexCheck(component);                                
                                if (requirdchk || regexchk) {
                                    component.set("v.showError", true);
                                }
                                else
                                {
                                    component.set("v.showError", false);
                                    helper.saveAsset(component, event, helper);
                                    helper.getAllAssets(component, event, helper);
                                    var Loan = component.get("v.assetLoanId");
                                    helper.PopulateAssetBasedonClient(component, event, helper,Loan);            
                                    component.set("v.isStockOpen", false);  
                                }        
                            },
                                
                                //Validate Life Insuarance Data from Popup after clicking on Save Button
                                ValidateLifeInsuarance: function(component, event, helper) { 
                                    helper.ClientSelected(component, event, helper,Loan);            
                                    var array_id = new Array();
                                    var array_mes = new Array();
                                    var array_reg = new Array();
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
                                        { ar_id: "pickClient", mes: "This is a required field", reg: validateRequiredField },
                                        { ar_id: "LifeIns_SrcName", mes: "This is a required field", reg: validateRequiredField },
                                        { ar_id: "LifeIPFVID", mes: "This is a required field", reg: validateRequiredField }
                                    ];
                                    array_id = valArray.map(item => item.ar_id);
                                    array_mes = valArray.map(item => item.mes);
                                    array_reg = valArray.map(item => item.reg);                                    
                                    var requirdchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
                                    var regexchk=helper.CurrencyRegexCheck(component);                                    
                                    if (requirdchk || regexchk) {
                                        component.set("v.showError", true);
                                    }
                                    else
                                    {
                                        component.set("v.showError", false);
                                        helper.saveAsset(component, event, helper);
                                        helper.getAllAssets(component, event, helper);
                                        var Loan = component.get("v.assetLoanId");
                                        helper.PopulateAssetBasedonClient(component, event, helper,Loan);            
                                        component.set("v.isLifeInsuaranceOpen", false);
                                    }  
                                },
                                    
                                    //Validate Retirement Data from Popup after clicking on Save Button
                                    ValidateRetirement: function(component, event, helper) {     
                                        helper.ClientSelected(component, event, helper,Loan);            
                                        var array_id = new Array();
                                        var array_mes = new Array();
                                        var array_reg = new Array();                                        
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
                                            { ar_id: "pickClient", mes: "This is a required field", reg: validateRequiredField },
                                            { ar_id: "Retire_SrcName", mes: "This is a required field", reg: validateRequiredField },
                                            { ar_id: "RetirementVestedID", mes: "This is a required field", reg: validateRequiredField }
                                        ];        
                                        array_id = valArray.map(item => item.ar_id);
                                        array_mes = valArray.map(item => item.mes);
                                        array_reg = valArray.map(item => item.reg);        
                                        var requirdchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
                                        var regexchk=helper.CurrencyRegexCheck(component);                                        
                                        if (requirdchk || regexchk) {
                                            component.set("v.showError", true);
                                        }
                                        else
                                        {
                                            component.set("v.showError", false);
                                            helper.saveAsset(component, event, helper);
                                            helper.getAllAssets(component, event, helper);
                                            var Loan = component.get("v.assetLoanId");
                                            helper.PopulateAssetBasedonClient(component, event, helper,Loan);            
                                            component.set("v.isRetirementOpen", false);            
                                        }        
                                    },
                                        
                                        //Validate Business Data from Popup after clicking on Save Button
                                        ValidateBusiness: function(component, event, helper) { 
                                            helper.ClientSelected(component, event, helper,Loan);            
                                            var array_id = new Array();
                                            var array_mes = new Array();
                                            var array_reg = new Array();     
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
                                                { ar_id: "pickClient", mes: "This is a required field", reg: validateRequiredField },
                                                { ar_id: "Buss_SrcName", mes: "This is a required field", reg: validateRequiredField },
                                                { ar_id: "BusinessNetWorthID", mes: "This is a required field", reg: validateRequiredField }
                                                
                                            ];
                                            array_id = valArray.map(item => item.ar_id);
                                            array_mes = valArray.map(item => item.mes);
                                            array_reg = valArray.map(item => item.reg);
                                            
                                            var requirdchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
                                            var regexchk=helper.CurrencyRegexCheck(component);
                                            
                                            if (requirdchk || regexchk) {
                                                component.set("v.showError", true);
                                            }
                                            else
                                            {
                                                component.set("v.showError", false);
                                                helper.saveAsset(component, event, helper);
                                                helper.getAllAssets(component, event, helper);
                                                var Loan = component.get("v.assetLoanId");
                                                helper.PopulateAssetBasedonClient(component, event, helper,Loan);            
                                                component.set("v.isBusinessOpen", false);
                                            }  
                                        },
                                            //Validate Others Data from Popup after clicking on Save Button
                                            ValidateOthers: function(component, event, helper) {
                                                helper.ClientSelected(component, event, helper,Loan);            
                                                var array_id = new Array();
                                                var array_mes = new Array();
                                                var array_reg = new Array();                                                
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
                                                    { ar_id: "pickClient", mes: "This is a required field", reg: validateRequiredField },
                                                    { ar_id: "Other_SrcName", mes: "This is a required field", reg: validateRequiredField },
                                                    { ar_id: "otherAssetAmtID", mes: "This is a required field", reg: validateRequiredField },
                                                    { ar_id: "otherAssetTypeID", mes: "Please select a value for this field", reg: validateRequiredField }
                                                    
                                                ];       
                                                
                                                array_id = valArray.map(item => item.ar_id);
                                                array_mes = valArray.map(item => item.mes);
                                                array_reg = valArray.map(item => item.reg);                                                
                                                var requirdchk=helper.formatErrorMethod(component, array_reg, array_mes, array_id);
                                                var regexchk=helper.CurrencyRegexCheck(component);                                                
                                                if (requirdchk || regexchk) {
                                                    component.set("v.showError", true);
                                                }
                                                else
                                                {
                                                    component.set("v.showError", false);
                                                    helper.saveAsset(component, event, helper);
                                                    helper.getAllAssets(component, event, helper);
                                                    var Loan = component.get("v.assetLoanId");
                                                    helper.PopulateAssetBasedonClient(component, event, helper,Loan);
                                                    component.set("v.isOthersOpen", false);
                                                }        
                                            },  
                                                
                                                //Delete Asset Based on Id After clicking on Delete from the Table
                                                DeleteAssetbyId: function(component, event, helper) {        
                                                    helper.deleteAsset(component, event, helper);
                                                    var Loan = component.get("v.assetLoanId");
                                                    helper.PopulateAssetBasedonClient(component, event, helper,Loan);            
                                                },
                                                    
                                                    //will move to next Tab of Start A new Loan
                                                    next: function(component, event, helper) {
                                                        helper.Loan_Next(component, event, helper);
                                                    },
                                                        
                                                        //will move to previous one Tab of Start A new Loan
                                                        previous: function(cmp, event, helper) {
                                                            helper.prev(cmp);
                                                        },
                                                            
                                                            //Close Delete popup 
                                                            closeMyModel :function(component, event, helper) {
                                                                component.set("v.isClentSelected", "false");
                                                                component.set("v.showPopup",false);        
                                                            },
                                                                
                                                                //Make Action for Deleting the record after clicking on "OK"  of Delete Popup
                                                                doAction:function(cmp, event, helper) { 
                                                                    helper.doAction(cmp, event, helper);
                                                                },
})