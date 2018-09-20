({
    ValidationForPills: function(component, event, helper) {
        var LoanId = component.get('v.DecLoanId');
        var action1 = component.get("c.Declarartion_TabsValidatedData");  
        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function(data) {
            var result=data.getReturnValue();  
            if(result.Is_Loan_Created_Manually__c==false)
            {
                var evt=$A.get("e.c:NavPillsEvent");
                evt.setParams({"IsPillsValidationRequired":true});       
                evt.fire();     
            }
        });
        $A.enqueueAction(action1);
    },
    PopulateDeclarationBasedonClient: function(component, event, helper,ClientId) { 
        var ClientId = ClientId;
        var action1 = component.get("c.getDeclr");
        action1.setParams({
            "ClientId": ClientId
        });
        action1.setCallback(this, function(data) {
            var res = data.getReturnValue();
            var getValue = component.find("group_a").get('v.value');  
            if (res != null) {
                var result=data.getReturnValue();
                component.set("v.NewDeclaration", data.getReturnValue());
                this.validateAndOpenForm(component, event, helper);
            }
        });
        $A.enqueueAction(action1);
    },
    
    clientstatusDetails: function(component,event,helper){        
        var _Loanid = component.get("v.DecLoanId");
        var action1 = component.get("c.AllClientsName");
        action1.setParams({
            "loanID": _Loanid
        });
        action1.setCallback(this, function(data) {            
            var ReturnData = data.getReturnValue();
            component.set("v.clientRecords", data.getReturnValue());
        });
        $A.enqueueAction(action1);
    },
    
    validateAndOpenForm: function(component, event, helper) {
        
        var bringback =helper.getRadioGroupValue(component, event, helper,"group_d","v.NewDeclaration.CashtoClose__c");
        if(bringback=='Yes'){
            document.getElementById('reason_group_d').style.display = 'block';
        }
        else{ 
            component.set("v.NewDeclaration.CashtoClose_Borrowed_Money__c","No");
            document.getElementById('reason_group_d').style.display = 'None';}
        
        var delinquent =helper.getRadioGroupValue(component, event, helper,"group_c","v.NewDeclaration.Delinquent__c");      
        if(delinquent=='Yes')
        {
            document.getElementById('reason_group_c').style.display = 'block';
            
        }
        else{
            component.set("v.NewDeclaration.Delinquent_Name__c","");
            component.set("v.NewDeclaration.Delinquent_Address__c","");
            component.set("v.NewDeclaration.Delinquent_FHA_VA_Case__c","");
            component.set("v.NewDeclaration.Delinquent_Reason__c","");
            document.getElementById('reason_group_c').style.display = 'None';
            
        }
        //intend to use the Reverse Mortgage
        var intend = helper.getRadioGroupValue(component, event, helper,"group_j","v.NewDeclaration.ReverseMortgage__c");      
        
        if(intend=='Yes')
        {
            document.getElementById('reason_group_j').style.display = 'block';
            
        } 
        else{
            component.set("v.NewDeclaration.ReverseMortgage_finproduct__c","");
            component.set("v.NewDeclaration.ReverseMortgage_Cost__c","");
            document.getElementById('reason_group_j').style.display = 'None';}
        //FHA Insured Loan
        var FHA = helper.getRadioGroupValue(component, event, helper,"group_k","v.NewDeclaration.FHA_Insured_Loan__c");      
        
        if(FHA=='Yes')
        {
            document.getElementById('FHADetails').style.display = 'block';
            
        } 
        else{  
            component.set("v.NewDeclaration.FHA_Property_Address__c","");
            component.set("v.NewDeclaration.FHA_Acc_No__c","");
            component.set("v.NewDeclaration.FHA_Creditor__c","");
            component.set("v.NewDeclaration.FHA_Amount__c","");
            component.set("v.NewDeclaration.FHA_Unpaid_Loan__c","");
            
            document.getElementById('FHADetails').style.display = 'None';
        }          
        var SelectedValue = component.find('group_m').get('v.value');        
        var American=SelectedValue.indexOf("American Indian or Alaska Native");
        //var Asian=SelectedValue.indexOf("Asian");        
        if(American!=-1)
        {
            document.getElementById('DivshowRaceNative').style.display = 'block';
            
        }
        else { 
            document.getElementById('DivshowRaceNative').style.display = 'none';
        }
        
        /*if(Asian!=-1)
        {
            document.getElementById('DivshowAsian').style.display = 'block';
        }
        else{ 
            document.getElementById('DivshowAsian').style.display = 'None';
        }
        
        var SelectedEthenicity = component.find('group_l').get('v.value');
        if(SelectedEthenicity == 'Hispanic or Latino')
        {
            document.getElementById('DivshowEthnicity').style.display = 'block';           
            
        }
        else{
            document.getElementById('DivshowEthnicity').style.display = 'None';
        }*/
        var a = helper.getRadioGroupValue(component, event, helper,"group_a","v.NewDeclaration.Outstanding_Judgments__c");
        var b = helper.getRadioGroupValue(component, event, helper,"group_b","v.NewDeclaration.Lawsuit__c");
        var c = helper.getRadioGroupValue(component, event, helper,"group_c","v.NewDeclaration.Delinquent__c");
        var d = helper.getRadioGroupValue(component, event, helper,"group_d","v.NewDeclaration.CashtoClose__c");
        var e = helper.getRadioGroupValue(component, event, helper,"group_e","v.NewDeclaration.Endorser__c");
        var f = helper.getRadioGroupValue(component, event, helper,"group_f","v.NewDeclaration.US_Citizen__c");
        var g = helper.getRadioGroupValue(component, event, helper,"group_g","v.NewDeclaration.Permanent_Resident__c");
        var h = helper.getRadioGroupValue(component, event, helper,"group_h","v.NewDeclaration.Primary_Residence__c");
        var i = helper.getRadioGroupValue(component, event, helper,"group_i","v.NewDeclaration.Bankruptcy__c");
        var j = helper.getRadioGroupValue(component, event, helper,"group_j","v.NewDeclaration.ReverseMortgage__c");
        var k = helper.getRadioGroupValue(component, event, helper,"group_k","v.NewDeclaration.FHA_Insured_Loan__c");
        var l = helper.getRadioGroupValue(component, event, helper,"reason_d","v.NewDeclaration.CashtoClose_Borrowed_Money__c");
        //SFDC-282
        var l1 = helper.getRadioGroupValue(component, event, helper,"group_l1","v.NewDeclaration.Borrower_Ethnicity__c");  
        var l2 = helper.getRadioGroupValue(component, event, helper,"group_l2","v.NewDeclaration.Borrower_Sex__c");
        var l3 = helper.getRadioGroupValue(component, event, helper,"group_l3","v.NewDeclaration.Borrower_Race__c");
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes' || j=='Yes' || k=='Yes' || l=='Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            
        }
        else  {
            document.getElementById('DivshowRemarks').style.display = 'None';
        }
        
        this.removeDefaultErrorClass(component, event, helper);
    },
    
    prev: function(component) {
        if(!component.get('v.fromPopup')){
            $('li#l7 a').click();
        } else{
            $('li#l6').removeClass('active');            
            $('li#l7').addClass('active');
            $('li#l8').removeClass('active');            
        }
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    }
    ,
    Loan_Next: function(component, event, helper) {
        if(event.getSource().getLocalId() =="DeclarationNextButton")//Goes to the next step if it is an actual click
            
        {
            document.getElementById('loanD').innerHTML = 'NoNeedToMove';
            
        } 
        $('li#l8').removeClass('active');
        $('li#l9').removeClass('disabled');
        $('li#l9 a').attr("data-toggle","tab");
        if(!component.get('v.fromPopup')){
            if(!$('#p2').hasClass('autoMoved')){
                $('li#l10').attr('class','disabled');
                $('li#l10 a').attr("data-toggle","cat");
                $('li#l11').attr('class','disabled');
                $('li#l11 a').attr("data-toggle","cat");
                $('li#l12').attr('class','disabled');
                $('li#l12 a').attr("data-toggle","cat");   
            }
            $('#p2').removeClass('collapse');
            $('li#l9').addClass('active');
            
        } else{
            $('.p2').removeClass('collapse');
            $('.p2').show();
            $('li#l8').removeClass('active');
            
            $('li#l9').addClass('active');
            $('li#l10').removeClass('active');
            component.set('v.itemsClicked','opt9');
        }
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },
    getRadioGroupValue: function(component, event, helper,id,controlId){
        
        var R_ID=id;
        var getValue = component.find(R_ID).get('v.value');
        if($A.util.isUndefinedOrNull(getValue))
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
    removeDefaultErrorClass:function(component, event, helper){
        
        document.getElementById("nameadrccError").innerHTML = '';
        var nameadrcc = component.find("nameadrcc");
        $A.util.removeClass(nameadrcc, 'errorComponent');        
        document.getElementById("adrccError").innerHTML = '';
        var adrcc = component.find("adrcc");
        $A.util.removeClass(adrcc, 'errorComponent');
        
        document.getElementById("fhavacaseccError").innerHTML = '';
        var fhavacasecc = component.find("fhavacasecc");
        $A.util.removeClass(fhavacasecc, 'errorComponent');
        
        document.getElementById("reasonccError").innerHTML = '';
        var reasoncc = component.find("reasoncc");
        $A.util.removeClass(reasoncc, 'errorComponent');
        
        document.getElementById("finproductjjError").innerHTML = '';
        var finproductjj = component.find("finproductjj");
        $A.util.removeClass(finproductjj, 'errorComponent');
        
        document.getElementById("costjjError").innerHTML = '';
        var costjj = component.find("costjj");
        $A.util.removeClass(costjj, 'errorComponent');
        
        document.getElementById("propadrError").innerHTML = '';
        var propadr = component.find("propadr");
        $A.util.removeClass(propadr, 'errorComponent');
        
        document.getElementById("acnoError").innerHTML = '';
        var acno = component.find("acno");
        $A.util.removeClass(acno, 'errorComponent');
        
        document.getElementById("creditornameError").innerHTML = '';
        var creditorname = component.find("creditorname");
        $A.util.removeClass(creditorname, 'errorComponent');
        
        document.getElementById("amountError").innerHTML = '';
        var amount = component.find("amount");
        $A.util.removeClass(amount, 'errorComponent');
        
        document.getElementById("unpaidloanError").innerHTML = '';
        var unpaidloan = component.find("unpaidloan");
        $A.util.removeClass(unpaidloan, 'errorComponent');
        
        document.getElementById("EnrolledTribeError").innerHTML = '';
        var EnrolledTribecc = component.find("EnrolledTribeText");
        $A.util.removeClass(EnrolledTribecc, 'errorComponent');
        
        /*document.getElementById("groupAsianError").innerHTML = '';
        var groupAsiancc = component.find("groupAsian");
        $A.util.removeClass(groupAsiancc, 'errorComponent');*/
        
        document.getElementById("RemarksError").innerHTML = '';
        var RemarksVal = component.find("DeclComments");
        $A.util.removeClass(RemarksVal, 'errorComponent');
        
        //Code Added/Changed by Dev4 for ORMSFDC-1432
        document.getElementById("show_ethnicityError").innerHTML = '';
        var ethenicityMain_Cmp = component.find("group_mainEthnicity");
        $A.util.removeClass(ethenicityMain_Cmp, 'errorComponent');
        
        document.getElementById("subEthnicityError").innerHTML = '';
        var ethenicitycc = component.find("groupSubEthnicity");
        $A.util.removeClass(ethenicitycc, 'errorComponent');
        // Code Ended by Dev4 for ORMSFDC-1432
        document.getElementById("lbl_group_a").innerText = '';
        document.getElementById("lbl_group_b").innerText = '';
        document.getElementById("lbl_group_c").innerText = '';
        document.getElementById("lbl_group_d").innerText = '';
        document.getElementById("lbl_group_e").innerText = '';
        document.getElementById("lbl_group_f").innerText = '';
        document.getElementById("lbl_group_g").innerText = '';
        document.getElementById("lbl_group_h").innerText = '';
        document.getElementById("lbl_group_i").innerText = '';
        document.getElementById("lbl_group_j").innerText = '';
        document.getElementById("lbl_group_k").innerText = '';   
        //SFDC-282
        document.getElementById("lbl_group_l1").innerText = '';
        document.getElementById("lbl_group_l2").innerText = '';
        document.getElementById("lbl_group_l3").innerText = '';
        
        /*document.getElementById("group_lError").innerHTML = '';
        var group_lCmp = component.find("group_l");
        $A.util.removeClass(group_lCmp, 'errorComponent');*/
        
        document.getElementById("group_mError").innerHTML = '';
        var group_mCmp = component.find("group_m");
        $A.util.removeClass(group_mCmp, 'errorComponent');
        
        document.getElementById("group_nError").innerHTML = '';
        var group_nCmp = component.find("group_n");
        $A.util.removeClass(group_nCmp, 'errorComponent');
    },
    showRemarksLabel: function(id,selected_group) {
        
        if(selected_group=="Yes")
            document.getElementById(id).innerText = 'Please add an additional remark below.';
        else
            document.getElementById(id).innerText = '';
    },
    
    validateDeclarations: function(component, event, helper){
        debugger;
        var isValid = true;
        
        var group_aVal = component.find("group_a").get('v.value'); 
        var group_bVal = component.find("group_b").get('v.value'); 
        var group_cVal = component.find("group_c").get('v.value'); 
        var group_dVal = component.find("group_d").get('v.value'); 
        var group_eVal = component.find("group_e").get('v.value');
        var group_fVal = component.find("group_f").get('v.value');
        var group_gVal = component.find("group_g").get('v.value'); 
        var group_hVal = component.find("group_h").get('v.value');
        var group_iVal = component.find("group_i").get('v.value'); 
        var group_jVal = component.find("group_j").get('v.value'); 
        var group_kVal = component.find("group_k").get('v.value'); 
        //SFDC-282
        var group_l1Val = component.find("group_l1").get('v.value'); //new
        var group_l2Val = component.find("group_l2").get('v.value');
        var group_l3Val = component.find("group_l3").get('v.value');

        //Code Added/Changed by Dev4 for ORMSFDC-1432
        var ethnicityMainVal = component.find("group_mainEthnicity").get('v.value');
        var subEthnicityVal = component.find("groupSubEthnicity").get('v.value'); 
        //Code Ended by Dev4 for ORMSFDC-1432-->
        var group_mVal = component.find("group_m").get('v.value'); 
        var group_nVal = component.find("group_n").get('v.value'); 
        
        //Code Added/Changed by Dev4 for ORMSFDC-1432
        var ethnicityMainCmp=component.find('group_mainEthnicity');
        var subEthnicityCmp=component.find('groupSubEthnicity');
        //Code Added/Changed by Dev4 for ORMSFDC-1432
        var group_mCmp=component.find('group_m');
        var group_nCmp=component.find('group_n');
        
        var isValid_a=true;
        var isValid_b=true;
        var isValid_c=true;
        var isValid_d=true;
        var isValid_e=true;
        var isValid_f=true;
        var isValid_g=true;
        var isValid_h=true;
        var isValid_i=true;
        var isValid_j=true;
        var isValid_k=true;
        var isValid_l=true;
        var isValid_m=true;
        var isValid_n=true;
        //SFDC-282
        var isValid_l1=true;
        var isValid_l2=true;
        var isValid_l3=true;

        if($A.util.isUndefinedOrNull(group_aVal))
        { 
            document.getElementById("lbl_group_a").innerText = 'Please check at least one option.';
            isValid_a = false;
        }
        else
        {
            document.getElementById("lbl_group_a").innerText = '';
            isValid_a = true;
        }
        
        
        if($A.util.isUndefinedOrNull(group_bVal))
        { 
            document.getElementById("lbl_group_b").innerText = 'Please check at least one option.';
            isValid_b = false;
        }
        else
        {
            document.getElementById("lbl_group_b").innerText = '';
            isValid_b = true;
        }
        
        if($A.util.isUndefinedOrNull(group_cVal))
        { 
            document.getElementById("lbl_group_c").innerText = 'Please check at least one option.';
            isValid_c = false;
        }
        else
        {
            document.getElementById("lbl_group_c").innerText = '';
            isValid_c = true;
        }
        if($A.util.isUndefinedOrNull(group_dVal))
        { 
            document.getElementById("lbl_group_d").innerText = 'Please check at least one option.';
            isValid_d = false;
        }
        else
        {
            document.getElementById("lbl_group_d").innerText = '';
            isValid_d = true;
        }
        if($A.util.isUndefinedOrNull(group_eVal))
        { 
            document.getElementById("lbl_group_e").innerText = 'Please check at least one option.';
            isValid_e = false;
        }
        else
        {
            document.getElementById("lbl_group_e").innerText = '';
            isValid_e = true;
        }
        if($A.util.isUndefinedOrNull(group_fVal))
        { 
            document.getElementById("lbl_group_f").innerText = 'Please check at least one option.';
            isValid_f = false;
        }
        else
        {
            document.getElementById("lbl_group_f").innerText = '';
            isValid_f = true;
        }
        if($A.util.isUndefinedOrNull(group_gVal))
        { 
            document.getElementById("lbl_group_g").innerText = 'Please check at least one option.';
            isValid_g = false;
        }
        else
        {
            document.getElementById("lbl_group_g").innerText = '';
            isValid_g = true;
        }
        if($A.util.isUndefinedOrNull(group_hVal))
        { 
            document.getElementById("lbl_group_h").innerText = 'Please check at least one option.';
            isValid_h = false;
        }
        else
        {
            document.getElementById("lbl_group_h").innerText = '';
            isValid_h = true;
        }
        if($A.util.isUndefinedOrNull(group_iVal))
        { 
            document.getElementById("lbl_group_i").innerText = 'Please check at least one option.';
            isValid_i = false;
        }
        else
        {
            document.getElementById("lbl_group_i").innerText = '';
            isValid_i = true;
        }
        if($A.util.isUndefinedOrNull(group_jVal))
        { 
            document.getElementById("lbl_group_j").innerText = 'Please check at least one option.';
            isValid_j = false;
        }
        else
        {
            document.getElementById("lbl_group_j").innerText = ''; 
            isValid_j = true;
        }
        if($A.util.isUndefinedOrNull(group_kVal))
        { 
            document.getElementById("lbl_group_k").innerText = 'Please check at least one option.';
            isValid_k = false;
        }
        else
        {
            document.getElementById("lbl_group_k").innerText = '';
            isValid_k = true;
        }
        //SFDC-282
        if($A.util.isUndefinedOrNull(group_l1Val))
        { 
            document.getElementById("lbl_group_l1").innerText = 'Please check at least one option.';
            isValid_l1 = false;
        }
        else
        {
            document.getElementById("lbl_group_l1").innerText = '';
            isValid_l1 = true;
        }

        if($A.util.isUndefinedOrNull(group_l2Val))
        { 
            document.getElementById("lbl_group_l2").innerText = 'Please check at least one option.';
            isValid_l2 = false;
        }
        else
        {
            document.getElementById("lbl_group_l2").innerText = '';
            isValid_l2 = true;
        }
        
        if($A.util.isUndefinedOrNull(group_l3Val))
        { 
            document.getElementById("lbl_group_l3").innerText = 'Please check at least one option.';
            isValid_l3 = false;
        }
        else
        {
            document.getElementById("lbl_group_l3").innerText = '';
            isValid_l3 = true;
        }//end SFDC-282
        // Code Added by Dev4 for ORMSFDC-1432
        if($A.util.isUndefinedOrNull(ethnicityMainVal) || ethnicityMainVal=="")
        { 
            
            document.getElementById("show_ethnicityError").innerText = 'Please select Ethinicity.';
            $A.util.addClass(ethnicityMainCmp, 'errorComponent');
            isValid_l = false;
        }
        else
        {
            document.getElementById("show_ethnicityError").innerText = '';
            $A.util.removeClass(ethnicityMainCmp, 'errorComponent');
            isValid_l = true;
        }
        //Code Ended by Dev4 for ORMSFDC-1432-->
        // Code Changed by Dev4 for ORMSFDC-1432
        if($A.util.isUndefinedOrNull(subEthnicityVal) || subEthnicityVal=="")
        { 
            
            document.getElementById("subEthnicityError").innerText = 'Please select at least one option.';
            $A.util.addClass(subEthnicityCmp, 'errorComponent');
            isValid_l = false;
        }
        else
        {
            document.getElementById("subEthnicityError").innerText = '';
            $A.util.removeClass(subEthnicityCmp, 'errorComponent');
            isValid_l = true;
        }
        //Code Ended by Dev4 for ORMSFDC-1432
        if($A.util.isUndefinedOrNull(group_mVal) || group_mVal=="")
        { 
            
            document.getElementById("group_mError").innerText = 'Please select at least one option.';
            $A.util.addClass(group_mCmp, 'errorComponent');
            isValid_m = false;
        }
        else
        {
            document.getElementById("group_mError").innerText = '';
            $A.util.removeClass(group_mCmp, 'errorComponent');
            isValid_m = true;
        }
        if($A.util.isUndefinedOrNull(group_nVal) || group_nVal=="")          
        { 
            
            document.getElementById("group_nError").innerText = 'Please select at least one option.';
            $A.util.addClass(group_nCmp, 'errorComponent');
            isValid_n = false;
        }
        else
        {
            document.getElementById("group_nError").innerText = '';
            $A.util.removeClass(group_nCmp, 'errorComponent');
            isValid_n = true;
        }
        
        if(!isValid_a || !isValid_b || !isValid_c || !isValid_d || !isValid_e || 
           !isValid_f || !isValid_g || !isValid_h || !isValid_i || !isValid_j || 
           !isValid_k || !isValid_m || !isValid_n || !isValid_l1 || !isValid_l2 || !isValid_l3)
        {
            isValid=false;
        }
        return isValid;
        
    },
})
