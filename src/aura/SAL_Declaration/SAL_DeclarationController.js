({
    //Initiate Page
    doInit: function(component, event, helper) {  
        var _Loanid = component.get("v.DecLoanId");
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
                component.set("v.ClientID",ClientId);
                component.set("v.clientList", result);
                document.getElementById('formdetails').style.display = 'block';
                helper.PopulateDeclarationBasedonClient(component, event, helper,ClientId);               
            }
            else
            {                 
                result.splice(0, 0, staticItem);
                component.set("v.clientList", result);               
            }
            
            var action1 = component.get("c.AllClientsName");
            action1.setParams({
                "loanID": _Loanid
            });
            action1.setCallback(this, function(data) {
                
                var ReturnData = data.getReturnValue();
                
                component.set("v.clientRecords", data.getReturnValue());
                var allStatus =  component.get("v.clientRecords");
                
                for(var i=0;i<allStatus.length;i++)
                {
                    if(allStatus[i].ClientDeclarationStatus==true)
                    {
                        component.set("v.skipValidate", true);
                    }
                }
            });
            $A.enqueueAction(action1);
        });
        
        $A.enqueueAction(action);
    },
    //Client PickList Change
    onClientSelectChange: function(component, event, helper) {
        component.set('v.NewDeclaration.Enrolled_tribe__c', '');
        component.set('v.NewDeclaration.Declaration_Remarks__c', '');
        var ClientIdforset = component.find('pickClient').get('v.value');     
        component.set("v.ClientID",ClientIdforset);
        var ClientId= component.get("v.ClientID");       
        
        component.set("v.showWarning",false);
        component.set("v.showSuccess",false);
        component.set("v.showError",false);
        
        if (ClientId == '') {
            document.getElementById('formdetails').style.display = 'none';
            
        } else {
            document.getElementById('formdetails').style.display = 'block';            
            helper.PopulateDeclarationBasedonClient(component, event, helper,ClientId);
        }
        
    },
    //Options A-I PickList Fields Change
    onAIfieldsChange: function(component, event, helper) {
        var a = component.find('groupa').get('v.value');
        var b = component.find('grouph').get('v.value');
        var c = component.find('groupb').get('v.value');
        var d = component.find('groupc').get('v.value');
        var e = component.find('groupg').get('v.value');
        var f = component.find('groupe').get('v.value');
        var g = component.find('groupf').get('v.value');
        var h = component.find('groupalien').get('v.value');
        var i = component.find('groupd').get('v.value');
        
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || f == 'Yes' || g == 'Yes' || h == 'Yes' || i == 'Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');
            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("RemarksVal");
            $A.util.removeClass(RemarksVal, 'errorComponent');
            
            
        }
        else if(a == 'No' && b == 'No' && c == 'No' && d == 'No' && e == 'No' && f == 'No' && g == 'No' && h == 'No' && i == 'No')
        {
            document.getElementById('DivshowRemarks').style.display = 'none';
        }
        
        
    },	
    // delinquent PickList Change
    delinquent: function(component, event, helper) {
        var Value = component.find('groupc').get('v.value');
        
        if (Value == 'Yes') {          
            document.getElementById('reasonc').style.display = 'block';
            
        } else
        {
            component.set("v.NewDeclaration.Delinquent_Address__c","");
            component.set("v.NewDeclaration.Delinquent_Date_of_the_Debt__c}","");
            component.set("v.NewDeclaration.Delinquent_Name__c","");
            component.set("v.NewDeclaration.Delinquent_FHA_VA_Case__c","");
            component.set("v.NewDeclaration.Delinquent_Reason__c","");
            document.getElementById('reasonc').style.display = 'none';
            
        }
        
        var a = component.find('groupa').get('v.value');
        var b = component.find('grouph').get('v.value');
        var c = component.find('groupb').get('v.value');
        var d = component.find('groupc').get('v.value');
        var e = component.find('groupg').get('v.value');
        var f = component.find('groupe').get('v.value');
        var g = component.find('groupf').get('v.value');
        var h = component.find('groupalien').get('v.value');
        var i = component.find('groupd').get('v.value');
        
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || f == 'Yes' || g == 'Yes' || h == 'Yes' || i == 'Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');
            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("RemarksVal");
            $A.util.removeClass(RemarksVal, 'errorComponent');
            
        }
        else if(a == 'No' && b == 'No' && c == 'No' && d == 'No' && e == 'No' && f == 'No' && g == 'No' && h == 'No' && i == 'No')
        {
            document.getElementById('DivshowRemarks').style.display = 'none';
        }
        
    },
    // cashtoclose PickList Change
    cashtoclose: function(component, event, helper) {
        var Value = component.find('groupd').get('v.value');
        if (Value == 'Yes') {
            document.getElementById('reasond').style.display = 'block';
        } else {
            document.getElementById('reasond').style.display = 'none';
            
        }
        
        var a = component.find('groupa').get('v.value');
        var b = component.find('grouph').get('v.value');
        var c = component.find('groupb').get('v.value');
        var d = component.find('groupc').get('v.value');
        var e = component.find('groupg').get('v.value');
        var f = component.find('groupe').get('v.value');
        var g = component.find('groupf').get('v.value');
        var h = component.find('groupalien').get('v.value');
        var i = component.find('groupd').get('v.value');
        
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || f == 'Yes' || g == 'Yes' || h == 'Yes' || i == 'Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');
            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("RemarksVal");
            $A.util.removeClass(RemarksVal, 'errorComponent');
            
        }
        else if(a == 'No' && b == 'No' && c == 'No' && d == 'No' && e == 'No' && f == 'No' && g == 'No' && h == 'No' && i == 'No')
        {
            document.getElementById('DivshowRemarks').style.display = 'None';
        }
        
    },
    // ReverseMortgage PickList Change
    ReverseMortgage: function(component, event, helper) {
        var Value = component.find('groupi').get('v.value');
        if (Value == 'Yes') {
            document.getElementById('reasoni').style.display = 'block';
        } else {
            component.set("v.NewDeclaration.ReverseMortgage_finproduct__c","");
            component.set("v.NewDeclaration.ReverseMortgage_Cost__c","");
            document.getElementById('reasoni').style.display = 'none';
        }
    },
    // FHAInsuredLoan PickList Change
    FHAInsuredLoan: function(component, event, helper) {
        var Value = component.find('groupj').get('v.value');
        if (Value == 'Yes') {
            document.getElementById('FHADetails').style.display = 'block';
        } else {
            component.set("v.NewDeclaration.FHA_Property_Address__c","");
            component.set("v.NewDeclaration.FHA_Acc_No__c","");
            component.set("v.NewDeclaration.FHA_Creditor__c","");
            component.set("v.NewDeclaration.FHA_Amount__c","");
            component.set("v.NewDeclaration.FHA_Unpaid_Loan__c","");
            document.getElementById('FHADetails').style.display = 'none';
        }
    },
    // Save declaration
    SaveDeclarations: function(component, event, helper) {
        
        component.set("v.showWarning",false);
        component.set("v.showSuccess",false);
        component.set("v.showError",false);
        var validDeclr = true;
        document.getElementById("declrerror").innerHTML = '';
        var msg = '';
        var selectedClient = component.get("v.ClientID");
        var Delinquent__c = component.find('groupc').get('v.value');
        
        if ($A.util.isEmpty(selectedClient)) {
            validDeclr = false;
        } else {
            //Additional Remarks 
            
            var a = component.find('groupa').get('v.value');
            var b = component.find('grouph').get('v.value');
            var c = component.find('groupb').get('v.value');
            var d = component.find('groupc').get('v.value');
            var e = component.find('groupg').get('v.value');
            var f = component.find('groupe').get('v.value');
            var g = component.find('groupf').get('v.value');
            var h = component.find('groupalien').get('v.value');
            var i = component.find('groupd').get('v.value');
            
            if(a == 'No' && b == 'No' && c == 'No' && d == 'No' && e == 'No' && f == 'No' && g == 'No' && h == 'No' && i == 'No')
            {
                component.set('v.NewDeclaration.Declaration_Remarks__c', '');
            }
            if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || f == 'Yes' || g == 'Yes' || h == 'Yes' || i == 'Yes')
            {
                document.getElementById('DivshowRemarks').style.display == 'block';
            }
            
            
            //Ethenicity
            var SelectedRace = component.find('groupl').get('v.value');
            var SelectedEthenicity = component.find('groupk').get('v.value');
            
            if(SelectedEthenicity != 'Hispanic or Latino'){
                component.set('v.NewDeclaration.Sub_Ethnicity__c', '');
            }
            
            var SelectedValue = component.find('groupl').get('v.value');
            
            var American=SelectedValue.indexOf("American Indian or Alaska Native");
            var Asian=SelectedValue.indexOf("Asian");
            
            if(American!=-1)
            {
                document.getElementById('DivshowRaceNative').style.display = 'block';
            }
            else
            {
                document.getElementById('DivshowRaceNative').style.display = 'None';
                component.set('v.NewDeclaration.Enrolled_tribe__c', '');
            }
            
            if(Asian!=-1)
            {
                document.getElementById('DivshowAsian').style.display = 'block';
            }
            else
            {
                document.getElementById('DivshowAsian').style.display = 'None';
                component.set('v.NewDeclaration.Asian_race__c', '');
            }
            
            if(SelectedEthenicity == 'Hispanic or Latino')
            {
                var ethenicitycc = component.find('groupEthnicity').get('v.value');
                if ($A.util.isEmpty(ethenicitycc)) {
                    validDeclr = false;
                    document.getElementById("ethnicityError").innerHTML = 'This is a required field';
                    var ethenicitycc = component.find("ethenicitycc");
                    $A.util.addClass(ethenicitycc, 'errorComponent');
                } else {
                    document.getElementById("ethnicityError").innerHTML = '';
                    var ethenicitycc = component.find("ethenicitycc");
                    $A.util.removeClass(ethenicitycc, 'errorComponent');
                    
                }
            }
            // additional remarks
            
            if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || f == 'Yes' || g == 'Yes' || h == 'Yes' || i == 'Yes')
            {
                var RemarksVal = component.find('DeclComments').get('v.value');
                if ($A.util.isEmpty(RemarksVal)) {
                    validDeclr = false;
                    document.getElementById("RemarksError").innerHTML = 'This is a required field';
                    var RemarksVal = component.find("RemarksVal");
                    $A.util.addClass(RemarksVal, 'errorComponent');
                } else {
                    if(RemarksVal.length < 20)
                    {
                        validDeclr = false;
                        document.getElementById("RemarksError").innerHTML = 'This field requires a minimum of 20 characters.';
                        var RemarksVal = component.find("RemarksVal");
                        $A.util.addClass(RemarksVal, 'errorComponent');
                    }
                    else{
                        document.getElementById("RemarksError").innerHTML = '';
                        var RemarksVal = component.find("RemarksVal");
                        $A.util.removeClass(RemarksVal, 'errorComponent');
                    }
                }
            }
            
            //Race
            if(American !=-1)
            {
                var EnrolledTribecc = component.find('EnrolledTribeText').get('v.value');
                if ($A.util.isEmpty(EnrolledTribecc)) {
                    validDeclr = false;
                    document.getElementById("EnrolledTribeError").innerHTML = 'This is a required field';
                    var EnrolledTribecc = component.find("EnrolledTribecc");
                    $A.util.addClass(EnrolledTribecc, 'errorComponent');
                } else {
                    document.getElementById("EnrolledTribeError").innerHTML = '';
                    var EnrolledTribecc = component.find("EnrolledTribecc");
                    $A.util.removeClass(EnrolledTribecc, 'errorComponent');
                }
            }
            
            if(Asian !=-1)
            {
                var groupAsiancc = component.find('groupAsian').get('v.value');
                if ($A.util.isEmpty(groupAsiancc)) {
                    validDeclr = false;
                    document.getElementById("groupAsianError").innerHTML = 'This is a required field';
                    var groupAsiancc = component.find("groupAsiancc");
                    $A.util.addClass(groupAsiancc, 'errorComponent');
                } else {
                    document.getElementById("groupAsianError").innerHTML = '';
                    var groupAsiancc = component.find("groupAsiancc");
                    $A.util.removeClass(groupAsiancc, 'errorComponent');
                }
            }
            
            //delinquent
            if (component.find('groupc').get('v.value') == "Yes") {
                var dateFieldcc = component.find('dateFieldcc').get('v.value');
                var nameadrcc = component.find('nameadrcc').get('v.value');
                var adrcc = component.find('adrcc').get('v.value');
                var fhavacasecc = component.find('fhavacasecc').get('v.value');
                var reasoncc = component.find('reasoncc').get('v.value');
                
                if ($A.util.isEmpty(dateFieldcc)) {
                    validDeclr = false;
                    document.getElementById("dateFieldccError").innerHTML = 'This is a required field';
                    var dateFieldcc = component.find("dateFieldcc");
                    $A.util.addClass(dateFieldcc, 'errorComponent');
                } else {
                    document.getElementById("dateFieldccError").innerHTML = '';
                    var dateFieldcc = component.find("dateFieldcc");
                    $A.util.removeClass(dateFieldcc, 'errorComponent');
                }
                
                if ($A.util.isEmpty(nameadrcc)) {
                    validDeclr = false;
                    document.getElementById("nameadrccError").innerHTML = 'This is a required field';
                    var nameadrcc = component.find("nameadrcc");
                    $A.util.addClass(nameadrcc, 'errorComponent');
                } else {
                    document.getElementById("nameadrccError").innerHTML = '';
                    var nameadrcc = component.find("nameadrcc");
                    $A.util.removeClass(nameadrcc, 'errorComponent');
                }
                
                if ($A.util.isEmpty(adrcc)) {
                    validDeclr = false;
                    document.getElementById("adrccError").innerHTML = 'This is a required field';
                    var adrcc = component.find("adrcc");
                    $A.util.addClass(adrcc, 'errorComponent');
                } else {
                    document.getElementById("adrccError").innerHTML = '';
                    var adrcc = component.find("adrcc");
                    $A.util.removeClass(adrcc, 'errorComponent');
                }
                
                if ($A.util.isEmpty(fhavacasecc)) {
                    validDeclr = false;
                    document.getElementById("fhavacaseccError").innerHTML = 'This is a required field';
                    var fhavacasecc = component.find("fhavacasecc");
                    $A.util.addClass(fhavacasecc, 'errorComponent');
                } else {
                    document.getElementById("fhavacaseccError").innerHTML = '';
                    var fhavacasecc = component.find("fhavacasecc");
                    $A.util.removeClass(fhavacasecc, 'errorComponent');
                }
                
                if ($A.util.isEmpty(reasoncc)) {
                    validDeclr = false;
                    document.getElementById("reasonccError").innerHTML = 'This is a required field';
                    var reasoncc = component.find("reasoncc");
                    $A.util.addClass(reasoncc, 'errorComponent');
                } else {
                    document.getElementById("reasonccError").innerHTML = '';
                    var reasoncc = component.find("reasoncc");
                    $A.util.removeClass(reasoncc, 'errorComponent');
                }
            }
            //Intent to loan
            if (component.find('groupi').get('v.value') == "Yes") {
                var finproductii = component.find('finproductii').get('v.value');
                var costii = component.find('costii').get('v.value');
                
                if ($A.util.isEmpty(finproductii)) {
                    validDeclr = false;
                    document.getElementById("finproductiiError").innerHTML = 'This is a required field';
                    var finproductii = component.find("finproductii");
                    $A.util.addClass(finproductii, 'errorComponent');
                } else {
                    document.getElementById("finproductiiError").innerHTML = '';
                    var finproductii = component.find("finproductii");
                    $A.util.removeClass(finproductii, 'errorComponent');
                }
                if ($A.util.isEmpty(costii)) {
                    validDeclr = false;
                    document.getElementById("costiiError").innerHTML = 'This is a required field';
                    var costii = component.find("costii");
                    $A.util.addClass(costii, 'errorComponent');
                } else if (costii > 0) {
                    document.getElementById("costiiError").innerHTML = '';
                    var costii = component.find("costii");
                    $A.util.removeClass(costii, 'errorComponent');
                } else {
                    validDeclr = false;
                    document.getElementById("costiiError").innerHTML = 'Cost should be a non negative number';
                    var costii = component.find("costii");
                    $A.util.addClass(costii, 'errorComponent');
                }
            }
            //FHA insured loan
            if (component.find('groupj').get('v.value') == "Yes") {
                var propadr = component.find('propadr').get('v.value');
                var acno = component.find('acno').get('v.value');
                var creditorname = component.find('creditorname').get('v.value');
                var amount = component.find('amount').get('v.value');
                var unpaidloan = component.find('unpaidloan').get('v.value');
                
                if ($A.util.isEmpty(propadr)) {
                    validDeclr = false;
                    document.getElementById("propadrError").innerHTML = 'This is a required field';
                    var propadr = component.find("propadr");
                    $A.util.addClass(propadr, 'errorComponent');
                } else {
                    document.getElementById("propadrError").innerHTML = '';
                    var propadr = component.find("propadr");
                    $A.util.removeClass(propadr, 'errorComponent');
                }
                
                if ($A.util.isEmpty(acno)) {
                    validDeclr = false;
                    document.getElementById("acnoError").innerHTML = 'This is a required field';
                    var acno = component.find("acno");
                    $A.util.addClass(acno, 'errorComponent');
                } else if (acno > 0) {
                    document.getElementById("acnoError").innerHTML = '';
                    var acno = component.find("acno");
                    $A.util.removeClass(acno, 'errorComponent');
                } else {
                    validDeclr = false;
                    document.getElementById("acnoError").innerHTML = 'Account Number should be a non negative number';
                    var acno = component.find("acno");
                    $A.util.addClass(acno, 'errorComponent');
                }
                
                if ($A.util.isEmpty(creditorname)) {
                    validDeclr = false;
                    document.getElementById("creditornameError").innerHTML = 'This is a required field';
                    var creditorname = component.find("creditorname");
                    $A.util.addClass(creditorname, 'errorComponent');
                } else {
                    document.getElementById("creditornameError").innerHTML = '';
                    var creditorname = component.find("creditorname");
                    $A.util.removeClass(creditorname, 'errorComponent');
                }
                
                if ($A.util.isEmpty(amount)) {
                    validDeclr = false;
                    document.getElementById("amountError").innerHTML = 'This is a required field';
                    var amount = component.find("amount");
                    $A.util.addClass(amount, 'errorComponent');
                } else if (amount > 0) {
                    document.getElementById("amountError").innerHTML = '';
                    var amount = component.find("amount");
                    $A.util.removeClass(amount, 'errorComponent');
                } else {
                    validDeclr = false;
                    document.getElementById("amountError").innerHTML = 'Amount of Mortgages and Liens should be a non negative number';
                    var amount = component.find("amount");
                    $A.util.addClass(amount, 'errorComponent');
                }
                
                if ($A.util.isEmpty(unpaidloan)) {
                    validDeclr = false;
                    document.getElementById("unpaidloanError").innerHTML = 'This is a required field';
                    var unpaidloan = component.find("unpaidloan");
                    $A.util.addClass(unpaidloan, 'errorComponent');
                } else if (unpaidloan > 0) {
                    document.getElementById("unpaidloanError").innerHTML = '';
                    var unpaidloan = component.find("unpaidloan");
                    $A.util.removeClass(unpaidloan, 'errorComponent');
                } else {
                    validDeclr = false;
                    document.getElementById("unpaidloanError").innerHTML = 'Unpaid Loan Balance should be a non negative number';
                    var unpaidloan = component.find("unpaidloan");
                    $A.util.addClass(unpaidloan, 'errorComponent');
                }
            }
        }
        if (!validDeclr) {
            component.set("v.showError", true);
            var allStatus =  component.get("v.clientRecords");
        } 
        else {
            
            var ClientId = component.get('v.ClientID');
            
            var _Loanid = component.get("v.DecLoanId");
            var action = component.get("c.saveDeclr");
            action.setParams({
                "declr": component.get("v.NewDeclaration"),
                "ClientId": ClientId,
                "LoanId": _Loanid
            });
            action.setCallback(this, function(data) {
                var state = data.getState();
                var returnval = data.getReturnValue();
                component.set("v.showWarning",false);
                component.set("v.showSuccess",true);
                component.set("v.showError",false);
                var allStatus =  component.get("v.clientRecords");                       
                component.set("v.incompleteSection",false);               
                
                helper.clientstatusDetails(component, event, helper);
                //new logic start
                if (state !== "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please Fill all the fields"
                    });
                    toastEvent.fire();
                }
                //new logic end
            });
            $A.enqueueAction(action);
        }
    },
    next: function(component, event, helper) {
        
        var allStatus =  component.get("v.clientRecords");
        
        for(var i=0;i<allStatus.length;i++)
        {
            if(allStatus[i].ClientDeclarationStatus==true)
            {
                component.set("v.skipValidate", true);
                component.set("v.incompleteSection",false);
            }
        }
        
        
        if(component.get("v.skipValidate")==false)
        {
            var toastEvent = $A.get("e.force:showToast");
            component.set("v.incompleteSection",true);
            return;
        }
        var _Loanid = component.get("v.DecLoanId");
        var action = component.get("c.CheckDeclaration");
        action.setParams({
            "LoanId": _Loanid
        });
        action.setCallback(this, function(data) {
            var IsDeclarationMade = data.getReturnValue(); 
            if(!IsDeclarationMade){
                
                component.set("v.showWarning",true);
                component.set("v.showSuccess",false);
                component.set("v.showError",false);     
            }
            else{
                component.set("v.showWarning",false);
                component.set("v.showSuccess",false);
                component.set("v.showError",false);
                helper.Loan_Next(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    previous: function(cmp, event, helper) {
        helper.prev(cmp);
    },
    // Ethnicity PickList Change
    changeEthnicity: function(component, event, helper) {
        
        var SelectedValue = component.find('groupk').get('v.value');      
        if(SelectedValue=='Hispanic or Latino')
        {
            document.getElementById('DivshowEthnicity').style.display = 'block';
            var ethenicitycc = component.find('groupEthnicity').get('v.value');
            document.getElementById("ethnicityError").innerHTML = '';
            var ethenicitycc = component.find("ethenicitycc");
            $A.util.removeClass(ethenicitycc, 'errorComponent');
        }
        else
        {
            document.getElementById('DivshowEthnicity').style.display = 'None';         
        }
        
        
    },
    // Race PickList Change
    changeRace: function(component, event, helper) {
        
        var SelectedValue = component.find('groupl').get('v.value');
        
        var American=SelectedValue.indexOf("American Indian or Alaska Native");
        var Asian=SelectedValue.indexOf("Asian");
        
        if(American!=-1)
        {
            document.getElementById('DivshowRaceNative').style.display = 'block';
            var EnrolledTribecc = component.find('EnrolledTribeText').get('v.value');
            document.getElementById("EnrolledTribeError").innerHTML = '';
            var EnrolledTribecc = component.find("EnrolledTribecc");
            $A.util.removeClass(EnrolledTribecc, 'errorComponent');
        }
        else
        {
            document.getElementById('DivshowRaceNative').style.display = 'none';
        }
        
        if(Asian!=-1)
        {
            document.getElementById('DivshowAsian').style.display = 'block';
            var groupAsiancc = component.find('groupAsian').get('v.value');
            document.getElementById("groupAsianError").innerHTML = '';
            var groupAsiancc = component.find("groupAsiancc");
            $A.util.removeClass(groupAsiancc, 'errorComponent');
        }
        else
        {
            document.getElementById('DivshowAsian').style.display = 'none';
        }
    },
})