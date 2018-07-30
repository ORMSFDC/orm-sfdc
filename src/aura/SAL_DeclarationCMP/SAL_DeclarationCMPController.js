({
    //Initiate Page
    doInit: function(component, event, helper) { 
        
        window.scrollTo(0, 0);
        helper.ValidationForPills(component, event, helper) ;       
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
            document.getElementById('targetID').innerHTML ='l8';
        });
        
        $A.enqueueAction(action);
    },
    //Client PickList Change
    onClientSelectChange: function(component, event, helper) {
        component.set('v.NewDeclaration.Enrolled_tribe__c', '');
        component.set('v.NewDeclaration.Declaration_Remarks__c', '');
        var ClientIdforset = event.target.id;     
        component.set("v.ClientID",ClientIdforset);
        var ClientId= component.get("v.ClientID");       
        $('.each_row').removeClass('highlighted_row');//.css('background-color','white').css('color','black');
        $('.'+'row_'+ClientIdforset).addClass('highlighted_row');//.        
        component.set("v.showWarning",false);
        component.set("v.showSuccess",false);
        component.set("v.showError",false);
        component.set("v.showPrimaryRsdnce",false);   
        document.getElementById("lblQuestionA").className = 'LabelDiv';
        document.getElementById("lblQuestionB").className = 'LabelDiv';     
        if (ClientId == '') {
            document.getElementById('formdetails').style.display = 'none';
            
        } else {
            document.getElementById('formdetails').style.display = 'block';            
            helper.PopulateDeclarationBasedonClient(component, event, helper,ClientId);
        }        
    },    
    //Options A-I PickList Fields Change
    onAIfieldsChange: function(component, event, helper) {
        
        var selected_group = event.getParam("value")[0];
        var lblId="lbl_"+event.getSource().getLocalId();
        if(lblId=="lbl_group_f" || lblId=="lbl_group_h")
        {
            document.getElementById(lblId).innerText = '';
        }
        else
        {
            helper.showRemarksLabel(lblId,selected_group);
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
        if(h=='No')
        {
            component.set("v.showPrimaryRsdnce",true); 
            document.getElementById("lbl_group_h").innerText = '';
            return;
        }
        else
        {
            component.set("v.showPrimaryRsdnce",false);
        }
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes' || j=='Yes' || k=='Yes' || l=='Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');
            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("DeclComments");
            $A.util.removeClass(RemarksVal, 'errorComponent');
        }
        else
        {
            document.getElementById('DivshowRemarks').style.display = 'none';
        }        
    },	
    
    // delinquent PickList Change
    delinquent: function(component, event, helper) { 
        debugger
        var Value = event.getParam("value")[0];        
        var lblId="lbl_"+event.getSource().getLocalId();
        helper.showRemarksLabel(lblId,Value);
        if (Value == 'Y') {          
            document.getElementById('reason_group_c').style.display = 'block';            
        } else
        {
            component.set("v.NewDeclaration.Delinquent_Address__c","");
            component.set("v.NewDeclaration.Delinquent_Date_of_the_Debt__c}","");
            component.set("v.NewDeclaration.Delinquent_Name__c","");
            component.set("v.NewDeclaration.Delinquent_FHA_VA_Case__c","");
            component.set("v.NewDeclaration.Delinquent_Reason__c","");
            document.getElementById('reason_group_c').style.display = 'none';            
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
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes' || j=='Yes' || k=='Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("DeclComments");
            $A.util.removeClass(RemarksVal, 'errorComponent');            
        }
        else
        {
            document.getElementById('DivshowRemarks').style.display = 'none';
        }        
    },
    
    // Code changes started for Story No:- ORMSFDC-1258 by Developer3
    // cashtoclose PickList Change
    cashtoclose: function(component, event, helper) {        
        var Value = event.getParam("value")[0];
        document.getElementById('lbl_group_d').innerHTML= '';
        var lblId="lbl_"+event.getSource().getLocalId();
        //helper.showRemarksLabel(lblId,Value);
        if (Value == 'Yes') {
            document.getElementById('reason_group_d').style.display = 'block';
        } else {
            component.set("v.NewDeclaration.CashtoClose_Borrowed_Money__c","No");
            document.getElementById('reason_group_d').style.display = 'none';   
            document.getElementById("lbl_reason_d").innerText = '';
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
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes' || j =='Yes' || k =='Yes' || l =='Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("DeclComments");
            $A.util.removeClass(RemarksVal, 'errorComponent');            
        }
        else
        {
            document.getElementById('DivshowRemarks').style.display = 'None';
        }        
    },
    
    borrowthemoney: function(component, event, helper) {  
        var Value = event.getParam("value")[0];
        var lblId="lbl_"+event.getSource().getLocalId();
        helper.showRemarksLabel(lblId,Value);
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
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes' || j =='Yes' || k =='Yes' || l =='Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("DeclComments");
            $A.util.removeClass(RemarksVal, 'errorComponent');            
        }
        else
        {
            document.getElementById('DivshowRemarks').style.display = 'None';
        }     
    },
    //End of code change
    
    // ReverseMortgage PickList Change
    ReverseMortgage: function(component, event, helper) {        
        var Value = event.getParam("value")[0];
        var lblId="lbl_"+event.getSource().getLocalId();
        helper.showRemarksLabel(lblId,Value);
        if (Value == 'Y') {
            document.getElementById('reason_group_j').style.display = 'block';
        } else {
            component.set("v.NewDeclaration.ReverseMortgage_finproduct__c","");
            component.set("v.NewDeclaration.ReverseMortgage_Cost__c","");
            document.getElementById('reason_group_j').style.display = 'none';
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
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes' || j=='Yes' || k=='Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("DeclComments");
            $A.util.removeClass(RemarksVal, 'errorComponent');            
        }
        else
        {
            document.getElementById('DivshowRemarks').style.display = 'None';
        }        
    },
    
    // FHAInsuredLoan PickList Change
    FHAInsuredLoan: function(component, event, helper) {        
        var Value = event.getParam("value")[0];
        var lblId="lbl_"+event.getSource().getLocalId();
        helper.showRemarksLabel(lblId,Value);
        if (Value == 'Y') {
            document.getElementById('FHADetails').style.display = 'block';
        } else {
            component.set("v.NewDeclaration.FHA_Property_Address__c","");
            component.set("v.NewDeclaration.FHA_Acc_No__c","");
            component.set("v.NewDeclaration.FHA_Creditor__c","");
            component.set("v.NewDeclaration.FHA_Amount__c","");
            component.set("v.NewDeclaration.FHA_Unpaid_Loan__c","");
            document.getElementById('FHADetails').style.display = 'none';
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
        if(a == 'Yes' || b == 'Yes' || c == 'Yes' || d == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes' || j=='Yes' || k=='Yes')
        {
            document.getElementById('DivshowRemarks').style.display = 'block';
            var RemarksVal = component.find('DeclComments').get('v.value');            
            document.getElementById("RemarksError").innerHTML = '';
            var RemarksVal = component.find("DeclComments");
            $A.util.removeClass(RemarksVal, 'errorComponent');
            
        }
        else
        {
            document.getElementById('DivshowRemarks').style.display = 'None';
        }
    },
    
    // Save declaration
    SaveDeclarations: function(component, event, helper) {
        debugger;
        component.set("v.showWarning",false);
        component.set("v.showSuccess",false);
        component.set("v.showError",false);
        component.set("v.showPrimaryRsdnce",false);
        var validDeclr = true;
        document.getElementById("declrerror").innerHTML = '';
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
        document.getElementById("lbl_reason_d").innerText = ''; 
        var msg = '';
        var selectedClient = component.get("v.ClientID");
        
        var ValidateFields =false; 
        var Delinquent__c = helper.getRadioGroupValue(component, event, helper,"group_c","v.NewDeclaration.Delinquent__c");
        
        if ($A.util.isEmpty(selectedClient)) {
            validDeclr = false;
        } else {
            //Additional Remarks             
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
            if(h=='No')            {
                component.set("v.showPrimaryRsdnce",true);
                document.getElementById("lbl_group_h").innerText = '';
            }            
            if(a == 'No' && b == 'No' && c == 'No' && d == 'No' && e == 'No' && g == 'No' && i == 'No')
            {
                component.set('v.NewDeclaration.Declaration_Remarks__c', '');
            }
            
            if(a == 'Yes' || b == 'Yes' || c == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes' || l == 'Yes' )
            {
                document.getElementById('DivshowRemarks').style.display == 'block';
            } 
            
            //Ethenicity
            var SelectedRace = component.find('group_m').get('v.value');
                      
            //var SelectedValue = component.find('group_m').get('v.value');            
            var American=SelectedRace.indexOf("American Indian or Alaska Native");
            //var Asian=SelectedValue.indexOf("Asian");            
            if(American!=-1)
            {
                document.getElementById('DivshowRaceNative').style.display = 'block';
            }
            else
            {
                document.getElementById('DivshowRaceNative').style.display = 'None';
                component.set('v.NewDeclaration.Enrolled_tribe__c', '');
            }            
            /*if(Asian!=-1)
            {
                document.getElementById('DivshowAsian').style.display = 'block';
            }
            else
            {
                document.getElementById('DivshowAsian').style.display = 'None';
                component.set('v.NewDeclaration.Asian_race__c', '');
            }   */         
            //if(SelectedEthenicity == 'Hispanic or Latino')
            //{
            // <Code Added by Dev4 for ORMSFDC-1432
            var ethenicity_main = component.find('group_mainEthnicity').get('v.value');
            if ($A.util.isEmpty(ethenicity_main)) {
                validDeclr = false;
                document.getElementById("show_ethnicityError").innerHTML = 'This is a required field';
                var ethenicity_cmp = component.find("group_mainEthnicity");
                $A.util.addClass(ethenicity_cmp, 'errorComponent');
            } else {
                document.getElementById("show_ethnicityError").innerHTML = '';
                var ethenicitycc = component.find("group_mainEthnicity");
                $A.util.removeClass(ethenicitycc, 'errorComponent');
                
            }
            //Code Ended by Dev4 for ORMSFDC-1432
            // Code Changed by Dev4 for ORMSFDC-1432
            var ethenicitycc = component.find('groupSubEthnicity').get('v.value');
            if(ethenicity_main != 'Not Hispanic or Latino'){  //Condition added by Bala - Sub Ehtnicity is not a req field for Not Hispanic or Latino
                if ($A.util.isEmpty(ethenicitycc)) {
                    validDeclr = false;
                    document.getElementById("subEthnicityError").innerHTML = 'This is a required field';
                    var ethenicitycc = component.find("groupSubEthnicity");
                    $A.util.addClass(ethenicitycc, 'errorComponent');
                } else {
                    document.getElementById("subEthnicityError").innerHTML = '';
                    var ethenicitycc = component.find("groupSubEthnicity");
                    $A.util.removeClass(ethenicitycc, 'errorComponent');
                }                
            }
            //Code Ended by Dev4 for ORMSFDC-1432
            //}
            
            // additional remarks
            if(a == 'Yes' || b == 'Yes' || c == 'Yes' || l == 'Yes' || e == 'Yes' || g == 'Yes' || i == 'Yes')
            {
                var RemarksVal = component.find('DeclComments').get('v.value');
                if ($A.util.isEmpty(RemarksVal)) {
                    validDeclr = false;
                    document.getElementById("RemarksError").innerHTML = 'This is a required field';
                    var RemarksVal = component.find("DeclComments");
                    $A.util.addClass(RemarksVal, 'errorComponent');
                } else {
                    if(RemarksVal.length < 20)
                    {
                        validDeclr = false;
                        document.getElementById("RemarksError").innerHTML = 'This field requires a minimum of 20 characters.';
                        var RemarksVal = component.find("DeclComments");
                        $A.util.addClass(RemarksVal, 'errorComponent');
                    }
                    else{
                        document.getElementById("RemarksError").innerHTML = '';
                        var RemarksVal = component.find("DeclComments");
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
                    var EnrolledTribecc = component.find("EnrolledTribeText");
                    $A.util.addClass(EnrolledTribecc, 'errorComponent');
                } else {
                    document.getElementById("EnrolledTribeError").innerHTML = '';
                    var EnrolledTribecc = component.find("EnrolledTribeText");
                    $A.util.removeClass(EnrolledTribecc, 'errorComponent');
                }
            }            
            /*if(Asian !=-1)
            {
                var groupAsiancc = component.find('groupAsian').get('v.value');
                if ($A.util.isEmpty(groupAsiancc)) {
                    validDeclr = false;
                    document.getElementById("groupAsianError").innerHTML = 'This is a required field';
                    var groupAsiancc = component.find("groupAsian");
                    $A.util.addClass(groupAsiancc, 'errorComponent');
                } else {
                    document.getElementById("groupAsianError").innerHTML = '';
                    var groupAsiancc = component.find("groupAsian");
                    $A.util.removeClass(groupAsiancc, 'errorComponent');
                }
            } */           
            //delinquent
            if (component.find('group_c').get('v.value') == "Yes") {
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
            if (component.find('group_j').get('v.value') == "Yes") {
                var finproductjj = component.find('finproductjj').get('v.value');
                var costjj = component.find('costjj').get('v.value');
                
                if ($A.util.isEmpty(finproductjj)) {
                    validDeclr = false;
                    document.getElementById("finproductjjError").innerHTML = 'This is a required field';
                    var finproductjj = component.find("finproductjj");
                    $A.util.addClass(finproductjj, 'errorComponent');
                } else {
                    document.getElementById("finproductjjError").innerHTML = '';
                    var finproductjj = component.find("finproductjj");
                    $A.util.removeClass(finproductjj, 'errorComponent');
                }
                if ($A.util.isEmpty(costjj)) {
                    validDeclr = false;
                    document.getElementById("costjjError").innerHTML = 'This is a required field';
                    var costjj = component.find("costjj");
                    $A.util.addClass(costjj, 'errorComponent');
                } else if (costjj > 0) {
                    document.getElementById("costjjError").innerHTML = '';
                    var costjj = component.find("costjj");
                    $A.util.removeClass(costjj, 'errorComponent');
                } else {
                    validDeclr = false;
                    document.getElementById("costjjError").innerHTML = 'Cost should be a non negative number';
                    var costjj = component.find("costjj");
                    $A.util.addClass(costjj, 'errorComponent');
                }
            }
            //FHA insured loan
            if (component.find('group_k').get('v.value') == "Yes") {
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
             debugger;
            //RadioButton Validation
            ValidateFields = helper.validateDeclarations(component, event, helper); 
        }
        if (!validDeclr || !ValidateFields) {
            component.set("v.showError", true);
            var allStatus =  component.get("v.clientRecords");
        } 
        else {
            var value_h=helper.getRadioGroupValue(component, event, helper,"group_h","v.NewDeclaration.Primary_Residence__c");
            if(value_h=='No')
            {
                component.set("v.showPrimaryRsdnce",true);
                component.set("v.showError",true);
                return;
            }
            else{
                
                var reason_d = helper.getRadioGroupValue(component, event, helper,"reason_d","v.NewDeclaration.CashtoClose_Borrowed_Money__c");
                component.get("v.NewDeclaration.CashtoClose_Borrowed_Money__c",reason_d);
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
                    component.set("v.showPrimaryRsdnce",false);
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
                    document.getElementById('formdetails').style.display = 'none';
                });
                $A.enqueueAction(action);
            }
            
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
    /*changeEthnicity: function(component, event, helper) {
        
        var SelectedValue = component.find('group_l').get('v.value');      
        if(SelectedValue=='Hispanic or Latino')
        {
            document.getElementById('DivshowEthnicity').style.display = 'block';
            var ethenicitycc = component.find('groupEthnicity').get('v.value');
            document.getElementById("ethnicityError").innerHTML = '';
            var ethenicitycc = component.find("groupEthnicity");
            $A.util.removeClass(ethenicitycc, 'errorComponent');
        }
        else
        {
            document.getElementById('DivshowEthnicity').style.display = 'None';         
        }
    }, */
    
    
    
    // Race PickList Change
    changeRace: function(component, event, helper) {
        
        var SelectedValue = component.find('group_m').get('v.value');
        
        var American=SelectedValue.indexOf("American Indian or Alaska Native");
        //var Asian=SelectedValue.indexOf("Asian");
        
        if(American!=-1)
        {
            document.getElementById('DivshowRaceNative').style.display = 'block';
            var EnrolledTribecc = component.find('EnrolledTribeText').get('v.value');
            document.getElementById("EnrolledTribeError").innerHTML = '';
            var EnrolledTribecc = component.find("EnrolledTribeText");
            $A.util.removeClass(EnrolledTribecc, 'errorComponent');
        }
        else
        {
            document.getElementById('DivshowRaceNative').style.display = 'none'; 
        }
        
        /*if(Asian!=-1)
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
        }*/
    },
    
})