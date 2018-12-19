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
        
        document.getElementById("RemarksError").innerHTML = '';
        var RemarksVal = component.find("DeclComments");
        $A.util.removeClass(RemarksVal, 'errorComponent');
        
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
         var appTaken = component.get("v.appTakenBy"); //SFDC-578
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
        if(appTaken == 'Face to Face'){
            var group_l1Val = component.find("group_l1").get('v.value'); 
            var group_l2Val = component.find("group_l2").get('v.value');
            var group_l3Val = component.find("group_l3").get('v.value');
        }
        
        //SFDC-579
        var ethGroup1 = component.find("ethnicitymain").get('v.value');
        var ethGroup2 = component.find("mexicanEth").get('v.value');
        var ethGroup3 = component.find("puertoEth").get('v.value');
        var ethGroup4 = component.find("cubanEth").get('v.value');
        var ethGroup5 = component.find("otherHispEth").get('v.value');
        var ethGroup6 = component.find("notHispLatino").get('v.value');
        var ethGroup7 = component.find("doNotWishEth").get('v.value');
        var raceGroup1 = component.find("americanIndRace").get('v.value');
        var raceGroup2 = component.find("asianRace").get('v.value');
        var raceGroup3 = component.find("asianIndRace").get('v.value');
        var raceGroup4 = component.find("chineseRace").get('v.value');
        var raceGroup5 = component.find("filipinoRace").get('v.value');
        var raceGroup6 = component.find("japRace").get('v.value');
        var raceGroup7 = component.find("koreanRace").get('v.value');
        var raceGroup8 = component.find("vietnamRace").get('v.value');
        var raceGroup9 = component.find("othAsianRace").get('v.value');
        var raceGroup10 = component.find("blackAfrRace").get('v.value');
        var raceGroup11 = component.find("nativeHawaPacRace").get('v.value');
        var raceGroup12 = component.find("nativeHawRace").get('v.value');
        var raceGroup13 = component.find("guamanianRace").get('v.value');
        var raceGroup14 = component.find("otherPacificRace").get('v.value');
        var raceGroup15 = component.find("whiteRace").get('v.value');
        var raceGroup16 = component.find("doesNotWishRace").get('v.value');
        var raceGroup17 = component.find("samoanRace").get('v.value');
        var sexGroup1 = component.find("femaleSex").get('v.value');
        var sexGroup2 = component.find("maleSex").get('v.value');
        var sexGroup3 = component.find("doesNotWishSex").get('v.value');

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
        //SFDC-282
        var isValid_l1=true;
        var isValid_l2=true;
        var isValid_l3=true;
        //SFDC-579      
        var isValid_l4=true;
        var isValid_l5=true;
        var isValid_l6=true;

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
        if(appTaken == 'Face to Face'){//SFDC_578
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
            }
        }//end SFDC-282
        
        //SFDC-579
        if(ethGroup1 == false && ethGroup2 == false && ethGroup3 == false && ethGroup4 == false && ethGroup5 == false && ethGroup6 == false && ethGroup7 == false){
            document.getElementById("ethnicityGroup").innerText = 'Please check at least one option.';
            isValid_l4 = false;
        }else{
            document.getElementById("ethnicityGroup").innerText = '';
            isValid_l4 = true;
        }

        if(raceGroup1 == false && raceGroup2 == false && raceGroup3 == false && raceGroup4 == false && raceGroup5 == false && raceGroup6 == false && raceGroup7 == false &&
            raceGroup8 == false && raceGroup9 == false && raceGroup10 == false && raceGroup11 == false && raceGroup12 == false && raceGroup13 == false && raceGroup14 == false && 
            raceGroup15 == false && raceGroup16 == false && raceGroup17 == false){
            document.getElementById("RaceGroup").innerText = 'Please check at least one option.';
            isValid_l5 = false;
        }else{
            document.getElementById("RaceGroup").innerText = '';
            isValid_l5 = true;
        }

        if(sexGroup1 == false && sexGroup2 == false && sexGroup3 == false){
            document.getElementById("sexGroup").innerText = 'Please check at least one option.';
            isValid_l6 = false;
        }else{
            document.getElementById("sexGroup").innerText = '';
            isValid_l6 = true;
        }
        
        if(!isValid_a || !isValid_b || !isValid_c || !isValid_d || !isValid_e || 
           !isValid_f || !isValid_g || !isValid_h || !isValid_i || !isValid_j || 
           !isValid_k || !isValid_l1 || !isValid_l2 || !isValid_l3 || !isValid_l4 || 
           !isValid_l5 || !isValid_l6)
        {
            isValid=false;
        }
        return isValid;
        
    },
})