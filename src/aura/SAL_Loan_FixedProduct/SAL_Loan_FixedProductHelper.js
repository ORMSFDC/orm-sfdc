({
    DropdownPopulate: function(component, event, helper) {        
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
            { text: "Wyoming", value: "Wyoming" },
            
        ];
            var Num = [
            { text: "1", Label: "1" },
            { text: "2", Label: "2" },
            { text: "3", Label: "3" },
            { text: "4", Label: "4" },
            { text: "5", Label: "5" },
            { text: "6", Label: "6" },
            { text: "7", Label: "7" },
            { text: "8", Label: "8" },
            { text: "9", Label: "9" },
            { text: "10", Label: "10" }
        ];
        
        component.set('v.UsState', States);
        component.set('v.Number', Num);        
        
    },
    SaveLoans: function(component, event, helper) {
        
        var ratevalue=component.find("Ratedata").get("v.value");
        component.set("v.NewLoan.Rate__c",ratevalue);
        var action = component.get("c.SaveLoan");
        var valueChildren_Under_the_age = helper.getRadioGroupValue(component, event, helper,"Children_Under_the_age","v.NewLoan.Children_Under_the_age_of_6_living_in_th__c");
        var loid;
        var RelationshipDDvalue = component.find("relationshipContact").get("v.value");
        if(RelationshipDDvalue!='Other'){
            component.set("v.NewLoan.Other_Relationship_Alternative_Contact__c",'');            
        }
        console.log('component.get("v.NewLoan") ',component.get("v.NewLoan"));
        //var Val=component.get("v.NewLoan");
        action.setParams({
            "ObjLoan": component.get("v.NewLoan")
        });
        action.setCallback(this, function(data) {
            var state = data.getState();            
            var loanid = data.getReturnValue();
            var savedLoanObject = data.getReturnValue();
            component.set("v.NuLoan", component.get("v.NewLoan"));
            component.set("v.LoanId", data.getReturnValue());
            this.PopulateLoanName(component, event, helper);
            this.ValidationForPills(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    
    PopulateLoanName : function(component, event, helper) {
        var LoanId ;
        if(component.get("v.popupLoanId") == "default"){
            LoanId = component.get("v.LoanId");
        }
        else
            LoanId = component.get("v.popupLoanId");
        var action2 = component.get("c.getLoanName");
        action2.setParams({
            "LoanID": LoanId
        });
        
        action2.setCallback(this, function(data) {
            var state = data.getState();            
            document.getElementById("lblLoanID").innerHTML="Loan ID &nbsp;&nbsp;"+data.getReturnValue();
            this.PopulateLoanBasedonId(component, event, helper);
            //Goes to the next Step
            
            
            this.Loan_Next(component, event, helper);
        });
        $A.enqueueAction(action2);
    }, 
    
    PopulateLoanBasedonId: function(component, event, helper) {
        
        var LoanId ;
        if(component.get("v.popupLoanId") == "default"){
            LoanId = component.get("v.LoanId");
        }
        else
            LoanId = component.get("v.popupLoanId");
        var action1 = component.get("c.getLoanById");        
        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function(data) {
            
            var result=data.getReturnValue();
            if(result.Rate__c =='' || result.Rate__c==undefined || result.Rate__c==null)
            {
               component.find("Ratedata").set("v.value",''); 
            }
            else{
          	var rateval=result.Rate__c;
            var val=rateval.toString();
            var r=val.split(".");
            var nume=r[0];
            var deci=r[1];
            
            if(deci.length==2)
            {
                deci=deci.concat('0');
                  rateval=nume.concat(".",deci);
            }
            if(deci.length==1)
            {
                 deci=deci.concat('00');
                  rateval=nume.concat(".",deci);
            }
           
			            
          
            component.find("Ratedata").set("v.value",rateval);
            }
           //component.set("v.NewLoan.Rate__c",3.990);
            //var val= component.get("v.NewLoan.Rate__c");
            if(result.Children_Under_the_age_of_6_living_in_th__c=="" || result.Children_Under_the_age_of_6_living_in_th__c==undefined || result.Children_Under_the_age_of_6_living_in_th__c==null)
            {
                result.Children_Under_the_age_of_6_living_in_th__c='No';
            }
            
              if(result.Mortgage_Applied_for__c=='HECM for Purchase')
            {
                
                var fundSource=result.Source_Of_Funds__c;
                if(fundSource!=undefined)
                {
                    if(fundSource.includes("Sale Of Other Property"))
                    {
                        document.getElementById("SalDate").style.display='block';   
                    }
                    else
                    {
                        document.getElementById("SalDate").style.display='none';   
                    }
                    
                    if(fundSource.includes("Assets"))
                    {
                        document.getElementById("Assets").style.display='block';   
                    }
                    else
                    {
                        document.getElementById("Assets").style.display='none';   
                    }
                    if(fundSource.includes("Gift"))
                    {
                        document.getElementById("Gift").style.display='block';   
                    }
                    else
                    {
                        document.getElementById("Gift").style.display='none';   
                    } 
                    if(fundSource.includes("Others"))
                    {
                        document.getElementById("Others").style.display='block';   
                    }
                    else
                    {
                        document.getElementById("Others").style.display='none';   
                    } 
                }
            }
            component.set("v.NewLoan", result);
            var loanCalaculayionType = component.find("newSelectlist").get("v.value");
            if(loanCalaculayionType=='Calculate Maximum Fee' || loanCalaculayionType == 'Enter Fee Value ($0 - $6,000)'){
                
                component.set("v.show_originate_fee",true);
                if(loanCalaculayionType === 'Calculate Maximum Fee')
                    component.set("v.show_originate_fee_disable",true);
                else
                    component.set("v.show_originate_fee_disable",false);
            }
            var RelationshipDDvalue = component.find("relationshipContact").get("v.value");
            if(RelationshipDDvalue=='Other'){
                component.set("v.Relationship_to_Alternative_Contact",true);
            }
            component.set("v.newSelectlistdisable",false);
            var state = data.getState();
            
            if (state === "SUCCESS"&& component.get('v.NewStartLoan')==false) {
                helper.ValidationForPills(component, event, helper);
                
                component.set('v.Incomplete',false);
            }
        });
        $A.enqueueAction(action1);
    },
    
    DateCheck : function(component, event, helper) {
        
        var isValid = false; 
      
        var contractDateCmp=component.find("ContractDate");
        var ClosingContractCmp= component.find("ContractClosingDate");
        var StartDate= component.find("ContractDate").get("v.value");
        var EndDate = component.find("ContractClosingDate").get("v.value");
         
        
        if (StartDate == undefined  || StartDate=='')
        {
            isValid = true;
        }
        else
        {
            if ((StartDate == undefined  || StartDate=='')&&
                (EndDate == undefined || EndDate==''))
            {
                isValid = true;
            }
            else{  // var EndDate= ContractClosingDate.get("v.value");
                var eDate = new Date(EndDate);
                var sDate = new Date(StartDate);
                
                if(StartDate!= '' && EndDate!= '' && sDate> eDate)
                {
                    document.getElementById("errorcontractClosingDate").innerHTML = "Contract Closing Date must be greater or equal to the Contract Date.!";
                    //ClosingContractCmp.set("v.errors", [{ message: 'Contract Closing Date must be greater or equal to the Contract Date.' }]);
                    isValid = true;  
                }
                else
                {
                    document.getElementById("errorcontractClosingDate").innerHTML = "";
                    //ClosingContractCmp.set("v.errors", null);
                    isValid = false;   
                }
                
            }
        }
        return isValid;
    },
    
    interviewdatevalidation: function(component, event, helper) {
        var isValid = false;    
        var inputCmp = component.find('ApplicationDate');       
        var value = inputCmp.get("v.value");
        if (typeof value ==='undefined' || value==null || value=='')
        {
            inputCmp.set("v.errors", [{ message: 'This is a required field.' }]);
            isValid = true;
            
        } else {
            inputCmp.set("v.errors", null);
            isValid=false;
        }
        return isValid;
        
    },    
    FutureDate: function(component, event, helper) {
        var isValid = false;      
        var inputCmp = component.find('ApplicationDate');       
        var value = inputCmp.get("v.value");
        if (typeof value ==='undefined' || value==null || value=='')
        {}
        else{
            var myDate = new Date(value);
            var today = new Date();
            var timeDiff = Math.abs(today.getTime() - myDate.getTime());
            var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
            if (myDate > today) {
                
                inputCmp.set("v.errors", [{ message: 'Application date cannot be a future date.' }]);
                isValid = true;
                
            }
            else if(diffDays > 3)
            {
                inputCmp.set("v.errors", [{ message: 'We apologize for the inconvenience. One Reverse Mortgage Services requires 1 day to send out Good Faith\nEstimate to meet regulatory requirements and the date you selected exceeds the tolerance.' }]);
                isValid = true;  
            }
                else {
                    inputCmp.set("v.errors", null);
                    isValid=false;
                    
                }}
        return isValid;
        
    },
    formatErrorMethod: function(component, regex, msg, aura_id) {
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
                inputCmp.set("v.errors", [{ message: msg[i] + "."  }]);              
                flag = true;
            }
        }
        return flag;
    },
    formatErrorMethodr: function(component, regexr, msgr, aura_idr) {
        //Code if button is clicked
        var flagR = false;
        console.log('aura_idr',aura_idr);
        for (var i = 0; i < aura_idr.length; i++) {
            var inputCmp = component.find(aura_idr[i]);
            if(typeof inputCmp==='undefined' )
            {}else {
                var value = inputCmp.get("v.value");
                var isRegValid = false;
                if(typeof value==='undefined' || value==null || value=='')
                {}
                else{
                    
                    if (value.length !=0 ) {
                        var rxp = new RegExp(regexr[i]);
                        isRegValid = rxp.test(value);
                        if (isRegValid) {
                            inputCmp.set("v.errors", null);
                        } 
                        else {
                            inputCmp.set("v.errors", [{ message: msgr[i] + ":" + value }]);
                            flagR = true;
                            
                        } 
                        
                    } 
                }
            }
        }
        return flagR;
    },
    
    ZipFormat: function(component, event) {
        var inputCmp = component.find("Zip");
        var value = inputCmp.get("v.value");
        var isValidZip = /(^\d{5}$)|(^\d{5}-\d{4}$)/.test(value);
        if (isValidZip || value.length == 0) {
            component.set("v.LoanErr", false);
            inputCmp.set("v.errors", null);
        } else {
            inputCmp.set("v.errors", [{ message: "Not a valid Zip Code: " + value }]);
            component.set("v.LoanErr", true);
        }
        
    },
    
    doErrorAction: function(component, event) {
        var inputCmp = component.find("LoanOriginationFee");
        var value = inputCmp.get("v.value");
        if (value < 0) {
            inputCmp.set("v.errors", [{ message: "Input is negative: " + value }]);
            component.set("v.LoanErr", true);
            
        } else {
            component.set("v.LoanErr", false);
            inputCmp.set("v.errors", null);
        }
    },
    
    //Phone format validation
    PhoneFormatValidation: function(component, regex, msg, aura_id) {
        var inputCmp = component.find(aura_id);
        var value = inputCmp.get("v.value");
        var isValid = regex.test(value);
        if (isValid) {
            
            component.set("v.LoanErr", false);
            inputCmp.set("v.errors", null);
        } else {
            
            inputCmp.set("v.errors", [{ message: msg + value }]);
            component.set("v.LoanErr", true);
        }
    },
    
    Loan_Next: function(component, event, helper) {
        $('li#l2').removeClass('disabled');
        $('li#l2 a').attr("data-toggle","tab");
        $('li#l2 a').click();
        component.set('v.itemsClicked','opt2');
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        
    },
    loanFormatErrorMethod: function(component, regex, msg, aura_id) {
        //Code if button is clicked
        var flag = false;
        for (var i = 0; i < aura_id.length; i++) {
            var inputCmp = component.find(aura_id[i]);
            var value = inputCmp.get("v.value");
            var isValid = false;
            
            if (typeof regex[i] != "string") {
                isValid = regex[i](value); // Please return true if there is an error or else false
            } else {
                var rxp = new RegExp(regex[i]);
                isValid = rxp.test(value);
            }
            if (isValid) {
                inputCmp.set("v.errors", null);
                
            } else {
                inputCmp.set("v.errors", [{ message: msg[i] }]);
                flag = true;
            }
        }
        return flag;
        
    },
    validateEnteredValue:function(component, event, helper,compId) {
        var inz = component.get(compId);
        var digit = inz.toString()[0];
        if(digit=='0')
        {
            
            component.set(compId, inz.substring(0, inz.length - 1));
        }
        if(isNaN(inz))
        {
            component.set(compId, inz.substring(0, inz.length - 1));
        }
    },
    
    FormatPhonehelper: function(component, event, helper){
        var a = component.find("AltConphoneName").get("v.value"); 
        var rxp = new RegExp("^(\\d)\\1{9}$");
        var  isRegValid = rxp.test(a);
        if(isRegValid)
        {
            component.set("v.NewLoan.Alternate_Contact_Phone_number__c",'');
        }else{
            var s2 = (""+a).replace(/\D/g, '');
            var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
            var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
            component.set("v.NewLoan.Alternate_Contact_Phone_number__c",result);
        }
    },
    
    RestrictZeroInPhoneFirstTime:function(component, event, helper,compId) {
        var inz = component.get(compId);
        var digit = parseInt(inz[0]);
        if(digit == 0)
        {            
            component.set(compId, inz.substring(0, inz.length - 1));
        }              
    },
    calculate_fee:function(component, event, helper) {
        var amountIs = component.find("LoanEstimateAppVal").get("v.value");
        var amount = parseInt(amountIs);
        if(!isNaN(amount) && amount !=0 ){
            component.set("v.newSelectlistdisable",false);
        }else{
            component.set("v.show_originate_fee",false);
            component.set("v.newSelectlistdisable",true);
        }
        if(amount <= 200000){
            var loanfee = amount * 0.02;
            if(loanfee > 6000){
                component.set('v.NewLoan.Loan_Origination_Fee__c',6000);
            }else if(loanfee <=2500 ){
                component.set('v.NewLoan.Loan_Origination_Fee__c',2500);
            } else{   
                component.set('v.NewLoan.Loan_Origination_Fee__c', Math.round(loanfee));
            }
        }else{
            
            var initialAmount = 200000;
            var remaining = amount - initialAmount;            
            var loanfeeonInitial = initialAmount * 0.02;
            var loanfeeonRemaining = remaining * 0.01;
            var totalLoanFee1 = loanfeeonInitial + loanfeeonRemaining;
            var totalLoanFee = Math.round(totalLoanFee1);
            if(totalLoanFee <=6000 && totalLoanFee >2500){
                component.set('v.NewLoan.Loan_Origination_Fee__c',totalLoanFee);
            }else if(totalLoanFee < 2500){
                
                if(!isNaN(amount) && amount !=0 ){
                    component.set('v.NewLoan.Loan_Origination_Fee__c',2500);
                }else{
                    component.set('v.NewLoan.Loan_Origination_Fee__c',0);
                    
                }
            }else{
                if(!isNaN(amount) && amount !=0 ){
                    component.set('v.NewLoan.Loan_Origination_Fee__c',6000);
                }else{
                    component.set('v.NewLoan.Loan_Origination_Fee__c',0);
                    
                }
                
            }
            
        }
    },
    
    calculate_feeforCustomValue:function(component, event, helper) {
        var amountIs = component.find("LoanEstimateAppVal").get("v.value");
        var amount = parseInt(amountIs);
        if(amount <= 200000){
            var loanfee = amount * 0.02;
            if(loanfee > 6000){
                component.set('v.PropertyValue',6000);
            }else if(loanfee <=2500 ){
                component.set('v.PropertyValue',2500);
            } else{   
                component.set('v.PropertyValue', Math.round(loanfee));
            }
        }else{
            
            var initialAmount = 200000;
            var remaining = amount - initialAmount;
            var loanfeeonInitial = initialAmount * 0.02;
            var loanfeeonRemaining = remaining * 0.01;
            var totalLoanFee1 = loanfeeonInitial + loanfeeonRemaining;
            var totalLoanFee = Math.round(totalLoanFee1);
            if(totalLoanFee <=6000 && totalLoanFee >2500){
                component.set('v.PropertyValue',totalLoanFee);
                
            }else if(totalLoanFee < 2500){
                
                if(!isNaN(amount) && amount !=0 ){
                    component.set('v.PropertyValue',2500);
                }else{
                    component.set('v.PropertyValue',0);
                }
            }else{
                if(!isNaN(amount) && amount !=0 ){
                    component.set('v.PropertyValue',6000);
                }else{
                    component.set('v.PropertyValue',0);
                    
                }
                
            }
            
        }
        
    },
    Relationship_to_Alternative_Contact__Check:function(component, event, helper) {
        var inputCmp = component.find('othRlsnshp');       
        var value = inputCmp.get("v.value");       
        var isValid = false;        
        if (typeof value === "undefined" || value==null || value=='') {
            inputCmp.set("v.errors", [{ message: 'This is a required field.' }]);
            isValid = true;   
        }
        else
        {
            inputCmp.set("v.errors", null);
            isValid = false; 
        }
        return isValid;       
    },
    calculate_fee_Value:function(component, event, helper) {
        
        var finalFlg=false;
        var inputCmp= component.find("LoanOriginationFee")
        var amountIs = component.find("LoanEstimateAppVal").get("v.value");
        var amountEntered = component.find("LoanOriginationFee").get("v.value");
        var amount = parseInt(amountIs);               
        if(amount <= 200000){
            var loanfee = amount * 0.02;
            if(amountEntered>loanfee){
                var msg='Loan origination fee is capped at $6,000.00 but the max amount allowed in this case is $'+ loanfee +' based on 2% of the first $200,000.00 of your home value plus 1% of the amount over $200,000.00';
                inputCmp.set("v.errors", [{ message: msg }]);
                finalFlg=true;
            } 
            else{   
                inputCmp.set("v.errors",null);
                finalFlg= false;
            }
        }else{            
            var initialAmount = 200000;
            var remaining = amount - initialAmount;            
            var loanfeeonInitial = initialAmount * 0.02;
            var loanfeeonRemaining = remaining * 0.01;
            var totalLoanFee1 = loanfeeonInitial + loanfeeonRemaining;
            //var totalLoanFee = Math.round(totalLoanFee1);
            if(amountEntered <=6000 && amountEntered>totalLoanFee1 ){ 
                var msg='Loan origination fee is capped at $6,000.00 but the max amount allowed in this case is $'+ totalLoanFee1 +' based on 2% of the first $200,000.00 of your home value plus 1% of the amount over $200,000.00';
                
                inputCmp.set("v.errors", [{ message: msg}]);
                
                finalFlg=true;                
            } else{
                
                inputCmp.set("v.errors", null);
                finalFlg=false;
            }            
        }
        return finalFlg;
    },
    ValidationForPills: function(component, event, helper) {
        
        var LoanId = component.get('v.LoanId');
        var action1 = component.get("c.TabsValidatedData");        
        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function(data) {
            var result=data.getReturnValue();  
            if(result.IsLoanFilled_Flag__c==false)
            {
                document.getElementById('targetID').innerHTML ='l1';    
            }
            if(result.Is_Loan_Created_Manually__c==false)
            {
                var evt=$A.get("e.c:NavPillsEvent");
                evt.setParams({"IsPillsValidationRequired":true});       
                evt.fire();     
            }
        });
        $A.enqueueAction(action1);
    },
    getRadioGroupValue: function(component, event, helper,id,controlId){
        
        var R_ID=id;
        var getValue = component.find(R_ID).get('v.value');
        if($A.util.isUndefinedOrNull(getValue) || getValue=="")
        {
            
        }
        else
        {
            if(getValue[0].length<2)
            {
                component.set(controlId,getValue);
                return getValue;
            }
            else
            { component.set(controlId,getValue[0]);
             return getValue[0];  
            }
        }
    },
         PopulateRate: function(component, event, helper) {       
        var action = component.get('c.getRateFixProduct');
      
         action.setCallback(this, function(data) { 
             
            var result =  data.getReturnValue();
            var resultLength =  result.length; 
            component.set("v.RateList", result); 
      
        });
        $A.enqueueAction(action);
    },
     
    getORMOrigination: function(component, event, helper,Rate) { 
        
        var rateval=Rate;
           var action1 = component.get("c.getOrigination");        
        action1.setParams({
            "rate": rateval
        });
          action1.setCallback(this, function(data) { 
             
            var result =  data.getReturnValue();          
            component.set("v.NewLoan.Loan_Origination_Fee__c", result);      
      
            
        });
        $A.enqueueAction(action1);
        
    },
     getORMBorrower: function(component, event, helper,Rate) { 
        
        var rateval=Rate;
           var action1 = component.get("c.getBorrower");        
        action1.setParams({
            "rate": rateval
        });
          action1.setCallback(this, function(data) { 
             
            var result =  data.getReturnValue();          
            component.set("v.NewLoan.Credit_to_Borrower__c", result);      
      
            
        });
        $A.enqueueAction(action1);
        
    },
    
    showHideMortgage:function(component,event,helper)
    {
        
        this.addDelayMortgage(component, event, helper);
    },
    addDelayMortgage: function(component, event, helper){
        var delay=1000; //4 seconds
        setTimeout(function() {
            
            var mortgageValue=component.find("LoanMortgageAppliedFor").get("v.value"); 
            if(mortgageValue=='HECM for Purchase')
            {
                document.getElementById("loanPurpose").style.display='none';
                document.getElementById("hecm").style.display='block';
            }
            else
            {
                document.getElementById("loanPurpose").style.display='block';
                document.getElementById("hecm").style.display='none';
            }  
        }, delay);
    },  
  ValidateDateFormat : function(component, event, helper,controlID) {   
         
         var flag=false;
        
         var contractDate = component.find(controlID);
         var getcontractDate = contractDate.get("v.value");
         if(!$A.util.isEmpty(getcontractDate))
         {
             var yearcontractDate=getcontractDate.substring(0,4);         
             var monthcontractDate=getcontractDate.substring(5,7);         
             var daycontractDate=getcontractDate.substring(8,10);         
             getcontractDate=monthcontractDate+'/'+daycontractDate+'/'+yearcontractDate;        
             var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/ ;        
             if(!(date_regex.test(getcontractDate)))
             {
                 contractDate.set("v.errors", [{ message: "Please enter a valid date format in MM/DD/YYYY!"}]);
                 flag=true;
             }
             else{
                 contractDate.set("v.errors", null); 
             }
         }
         else{
             if(controlID=='ContractClosingDate')
             {
                 contractDate.set("v.errors", null);   
             }
         }
         return flag;
    },
    changeSource : function(component, event, helper,controlID) {
        debugger;
        var fundSource=component.find("SourceOfFunds").get("v.value");
        var fSource=fundSource.split(';');        
        if(fundSource.includes("Sale Of Other Property"))
        {
            document.getElementById("SalDate").style.display='block';
            
        }
        else
        {
            document.getElementById("SalDate").style.display='none';
            component.set("v.NewLoan.Sale_Date__c",'');
            component.set("v.NewLoan.Sale_Proceeds__c",'');
        }
        
        if(fundSource.includes("Assets"))
        {
            document.getElementById("Assets").style.display='block';   
        }
        else
        {
            document.getElementById("Assets").style.display='none';
            component.set("v.NewLoan.Assets_Amount__c",'');
        }
        if(fundSource.includes("Gift"))
        {
            document.getElementById("Gift").style.display='block';   
        }
        else
        {
            document.getElementById("Gift").style.display='none';
            component.set("v.NewLoan.Gift_Amount__c",'');
        } 
        if(fundSource.includes("Others"))
        {
            document.getElementById("Others").style.display='block';   
        }
        else
        {
            document.getElementById("Others").style.display='none'; 
            component.set("v.NewLoan.Other_Source_Of_Funds__c",'');
            component.set("v.NewLoan.Amount_Of_Other_Funds__c",'');
        }
    },
})