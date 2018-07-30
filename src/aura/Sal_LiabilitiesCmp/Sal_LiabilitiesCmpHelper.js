({
    ValidationForPills: function(component, event, helper) {
        var LoanId = component.get('v.LiaLoanId');
        var action1 = component.get("c.Liability_TabsValidatedData");  
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
    showDiv: function(component, field, event, helper) {
        var dropValue = field;        
        if (dropValue == 'Alimony') {
            component.set("v.divAlimony", true);
            component.set("v.divJob", false);
            component.set("v.divLiability", false);
            component.set("v.divRealEstate", false);
        }
        if (dropValue == 'Job Expense') {
            component.set("v.divAlimony", false);
            component.set("v.divJob", true);
            component.set("v.divLiability", false);
            component.set("v.divRealEstate", false);
        }
        if (dropValue == 'Liability') {
            component.set("v.divAlimony", false);
            component.set("v.divJob", false);
            component.set("v.divLiability", true);
            component.set("v.divRealEstate", false);
        }
        if (dropValue == 'Real Estate Schedule') {
            component.set("v.divAlimony", false);
            component.set("v.divJob", false);
            component.set("v.divLiability", false);
            component.set("v.divRealEstate", true);
            //by Nausad 
            this.GetSPDetails(component, event, helper);
            //By NAusad
        }
    },
    
    PopulateLiabilityBasedonClient: function(component, event, helper,LoanId) {
        var _LoanId = LoanId;          
        component.set("v.enableAll", true);        
        var action1 = component.get("c.getLiabilityRealEstateDetails");        
        action1.setParams({
            "LoanId": _LoanId
        });
        action1.setCallback(this, function(data) { 
            
            var total = 0;
            var totalBalance = 0;
            var finalresult = data.getReturnValue();            
            if (finalresult != undefined) {
                for (var i = 0; i < finalresult.length; i++) {
                    var e = finalresult[i];
                    if (e.Present_Mortgage_Value__c != undefined)
                    { 
                        e.Present_Mortgage_Value__c = e.Present_Mortgage_Value__c;
                    }                    
                    else
                    {
                        if (typeof e.Present_Mortgage_Value__c === 'undefined'){
                            e.Present_Mortgage_Value__c=0;
                        }
                    }
                    if (e.Mortgage_Payments__c != undefined || e.Insurance_Taxes_etc__c != undefined )
                    {
                        if (typeof e.Mortgage_Payments__c === 'undefined'){e.Mortgage_Payments__c=0}
                        if (typeof e.Insurance_Taxes_etc__c === 'undefined'){e.Insurance_Taxes_etc__c=0}
                        total += e.Mortgage_Payments__c + e.Insurance_Taxes_etc__c;
                    }
                    if (e.Mortgage_Liens__c != undefined) {
                        totalBalance += e.Mortgage_Liens__c;
                        
                    }
                    else{ e.Mortgage_Liens__c=0;}
                    if (e.Mortgage_Payments__c != undefined || e.Insurance_Taxes_etc__c != undefined )
                    { 
                        if (typeof e.Mortgage_Payments__c === 'undefined'){e.Mortgage_Payments__c=0}
                        if (typeof e.Insurance_Taxes_etc__c === 'undefined'){e.Insurance_Taxes_etc__c=0}
                        e.Mortgage_Payments__c = e.Mortgage_Payments__c + e.Insurance_Taxes_etc__c;
                    }
                    else
                    {
                        e.Mortgage_Payments__c  = 0;
                    }
                }
            }  
            
            component.set("v.totalRealEstate", total);
            component.set("v.totalBalanceRealEstate", totalBalance);
            component.set("v.LiabRealList", finalresult);
            var resultLength =  finalresult.length;
            if(resultLength==0)
            {
                document.getElementById("RealEstate").style.display = "none";
                document.getElementById("NoRealEstate").style.display = "block";
                return false;
            }
            else
            {                   
                document.getElementById("RealEstate").style.display = "block";  
                this.addDelayRealEstate(component, event, helper,finalresult); 
                document.getElementById("NoRealEstate").style.display = "none";
            }             
        });   
        
        var action2 = component.get("c.getLiabilityDetails");        
        action2.setParams({
            LoanId: _LoanId
        });
        action2.setCallback(this, function(data) {
            var total = 0;
            var totalBalance = 0;
            var finalresult = data.getReturnValue();            
            if (finalresult != undefined) {
                for (var i = 0; i < finalresult.length; i++) {
                    var e = finalresult[i];
                    if (e.Amount__c != undefined) {
                        total += e.Amount__c;
                    } else if (e.Job_Related_Expenses__c != undefined) {
                        total += e.Job_Related_Expenses__c;
                    } else if (e.Liability_Monthly_Payment__c != undefined) {
                        total += e.Liability_Monthly_Payment__c;
                    }
                    if (e.Liability_Unpaid_Balance__c != undefined) {
                        totalBalance += e.Liability_Unpaid_Balance__c;
                    }
                }
            }            
            component.set("v.total", total);
            component.set("v.totalBalance", totalBalance);
            component.set("v.LiabOtherList", data.getReturnValue());
            var resultLengthLiab =  finalresult.length;
            if(resultLengthLiab==0)
            {
                document.getElementById("LiabResult").style.display = "none";
                document.getElementById("LiabNoResult").style.display = "block";
                return false;
            }
            else
            {                   
                document.getElementById("LiabResult").style.display = "block";                    
                this.addDelayLiablity(component, event, helper,finalresult);  
                document.getElementById("LiabNoResult").style.display = "none";
            }           
        });
        
        $A.enqueueAction(action2);
        $A.enqueueAction(action1);
        
    },
    addDelayRealEstate : function(component, event, helper,finalresult,ClientCount){
        var delay=1000; //4 seconds
        setTimeout(function() {
            
            var ClientCount=component.get("v.clientCount");
            
            var table = document.getElementById("RealEstatetable");
            for(var i=6; i<ClientCount+6; i++){
                var C1= table.rows[0].cells[i].innerHTML;
                for(var j=0; j<finalresult.length; j++){
                    if(finalresult[j].IsJoint__c==true)
                    {
                        table.rows[j+1].cells[i].innerHTML ='&#10004;';//finalresult[j].RelatedClient__r.Name;//
                        
                    }
                    else
                    {
                        var rc=finalresult[j].RelatedClient__r.Name;
                        if(typeof finalresult[j].RelatedClient__r.Name ==='undefined')
                        {
                            
                        }
                        else
                        {
                            if(C1==finalresult[j].RelatedClient__r.Name)
                            {
                                table.rows[j+1].cells[i].innerHTML ='&#10004;';//finalresult[j].RelatedClient__r.Name;//
                            }
                        }
                    }                    
                }
            }
        }, delay);
    },    
    addDelayLiablity : function(component, event, helper,finalresult,ClientCount){
        var delay=1000; //4 seconds
        setTimeout(function() {
            var ClientCount=component.get("v.clientCount");
            var table = document.getElementById("mytableLiability");
            for(var i=6; i<ClientCount+6; i++){
                var C1= table.rows[0].cells[i].innerHTML;
                for(var j=0; j<finalresult.length; j++){
                    if(finalresult[j].IsJoint__c==true)
                    {
                        table.rows[j+1].cells[i].innerHTML ='&#10004;';//finalresult[j].RelatedClient__r.Name;//
                        
                    }
                    else
                    {
                        if(typeof finalresult[j].RelatedClient__r.Name ==='undefined')
                        {
                            
                        }
                        else
                        {
                            if(C1==finalresult[j].RelatedClient__r.Name)
                            {
                                table.rows[j+1].cells[i].innerHTML ='&#10004;';//finalresult[j].RelatedClient__r.Name;//
                            }
                        }
                    }
                }
            }
        }, delay);
    },
    //function addDelayPType added for Story No:- ORMSFDC-1264 by Developer2
    /*addDelayPType : function(component, event, helper){
        var delay=500; //4 seconds                                
        setTimeout(function() {
            var ln = component.get('v.client');
            if (ln.Property_Type__c=='Condominium')
            { 
                 document.getElementById('Check_Condominium').style.display = 'block';
            }
            else
            {
                 document.getElementById('Check_Condominium').style.display = 'none';       	
            }
        }, delay);
    },*/
    
    GetLiabilityforEdit: function(component, event, helper) {  
        var Result;
        var PrimaryClient;
        var id = event.target.id;
        var action = component.get("c.getLiabilityById");        
        action.setParams({
            RecordId: id         
        });
        action.setCallback(this, function(data) {
           
            var finalresult = data.getReturnValue();
            var LoanId=finalresult.RelatedLoan__c;
            var client=finalresult.RelatedClient__c;
            
            component.set("v.SP",finalresult.Property_Status__c)
            
                var action1=component.get("c.getPrimaryClient");
                action1.setParams({
                    LoanId: LoanId         
                });
                action1.setCallback(this, function(data) {
                     
                    Result = data.getReturnValue();                    
                    component.set("v.pClientList", Result);
                });
                $A.enqueueAction(action1); 
            var parentValue = finalresult.Liability_Category__c;
            if (parentValue == 'Alimony')
            {
                component.set('v.typeOptions', component.get('v.typePicklist')[parentValue]); 
            }
            if (parentValue == 'Job Expense')
            {
                component.set('v.typeOptions', component.get('v.typePicklist')[parentValue]);
            }
            if (parentValue == 'Liability')
            {
                component.set('v.typeOptions', component.get('v.typePicklist')[parentValue]); 
            }
            if (parentValue == 'Real Estate Schedule')
            {                
                component.set('v.typeOptions', component.get('v.typePicklist')[parentValue]); 
            }
            component.set("v.client", finalresult);
            
            if (finalresult.Liability_Category__c == 'Alimony') {
                component.set("v.divAlimony", true);
                component.set("v.divJob", false);
                component.set("v.divLiability", false);
                component.set("v.divRealEstate", false);
                //component.set("v.showClient", true);
                //component.set("v.showPrimaryClient", false);
                document.getElementById('clientAll').style.display = 'block';
                document.getElementById('clientPrimary').style.display = 'none';
            }
            if (finalresult.Liability_Category__c == 'Job Expense') {
                component.set("v.divAlimony", false);
                component.set("v.divJob", true);
                component.set("v.divLiability", false);
                component.set("v.divRealEstate", false);
                //component.set("v.showClient", true);
                //component.set("v.showPrimaryClient", false);
                document.getElementById('clientAll').style.display = 'block';
                document.getElementById('clientPrimary').style.display = 'none';
            }
            if (finalresult.Liability_Category__c == 'Liability') {
                component.set("v.divAlimony", false);
                component.set("v.divJob", false);
                component.set("v.divLiability", true);
                component.set("v.divRealEstate", false);
                //component.set("v.showClient", true);
                //component.set("v.showPrimaryClient", false);
                document.getElementById('clientAll').style.display = 'block';
                document.getElementById('clientPrimary').style.display = 'none';
            }
            if (finalresult.Liability_Category__c == 'Real Estate Schedule') 
            {
                component.set("v.divAlimony", false);
                component.set("v.divJob", false);
                component.set("v.divLiability", false);
                component.set("v.divRealEstate", true);
                //component.set("v.showClient", false);
                //component.set("v.showPrimaryClient", true);
                document.getElementById('clientAll').style.display = 'none';
                document.getElementById('clientPrimary').style.display = 'block';
                
                var SUbjectProperty=component.get("v.SP");
                if (SUbjectProperty == 'Other') {            
                    document.getElementById("divRemarks").style.display = 'block';
                } 
                else 
                {
                    //document.getElementById("divRemarks").style.display = 'none';
                }
                
                if (SUbjectProperty == 'Subject Property') 
                {  
                    
                    var propertyStatusList = [
                        
                        { text: "", label:'Select',value: 'false' },
                        { text: "Sold", label: "Sold", value: 'false' },
                        { text: "Listed For Sale",label: "Listed For Sale"
                         ,value: 'false'},
                        { text: "Pending Sale",label: "Pending Sale",
                         value: 'false'},
                        { text: "Rental",label: "Rental", value: 'false' },
                        { text: "2nd Home/Vacation",label: "2nd Home/Vacation",
                         value: 'false'},
                        { text: "Subject Property", label: "Subject Property", value: 'true'},
                        
                        { text: "Co-signor", label: "Co-signor",value: 'false'},
                        { text: "Other",label: "Other", value: 'false' },
                        
                    ];
                        component.set("v.propertyStatusList",propertyStatusList );
                        //div RealEstateControls
                        component.find("propertyStatus").set("v.value",SUbjectProperty);
                        component.find("propertyAddress").set("v.disabled", true);
                        component.find("realCity").set("v.disabled", true);
                        component.find("realCounty").set("v.disabled", true);
                        component.find("propertyState1").set("v.disabled", true);
                        component.find("realZip").set("v.disabled", true);
                        //////////////////
                        //component.find("ReClient").set("v.disabled", true);
                        component.find("realCategory").set("v.disabled", true);
                        component.find("realType").set("v.disabled", true);
                        component.find("propertyAddress2").set("v.disabled", true);
                        component.find("legalDescProperty").set("v.disabled", true);
                        component.find("presentMarketValue").set("v.disabled", true);
                        component.find("mortgageNliens").set("v.disabled", true);
                        component.find("companyName").set("v.disabled", true);
                        component.find("accountNumber").set("v.disabled", true);
                        component.find("grossRentalIncome").set("v.disabled", true);
                        component.find("monthlyMortgagePayment").set("v.disabled", true);
                        component.find("RealEStateTax").set("v.disabled", true);
                        component.find("annualHazardInsurance").set("v.disabled", true);
                        component.find("HoaMonthlyDues").set("v.disabled", true);
                        component.find("MonthlyPUDFeesAmount").set("v.disabled", true);
                        component.find("MonthlyGroundsRentAmount").set("v.disabled", true);
                        component.find("MonthlyFloodInsurancePremium").set("v.disabled", true);
                        component.find("NetRentalIncome").set("v.disabled", true);
                        component.find("PropertyType").set("v.disabled", true);
                        component.find("YearBuiltId").set("v.disabled", true);
                        component.find("SQFootage").set("v.disabled", true);
                        component.find("PropertyHeldId").set("v.disabled", true);
                        component.find("PTHeldNameId").set("v.disabled", true);
                        component.find("checkTitleAlsoId").set("v.disabled", true);
                        component.find("liabilityPaid").set("v.disabled", true);
                        component.find("propertyStatus").set("v.disabled", true);
                        
                        component.find("ReSave").set("v.disabled", true);
                        //component.set("v.showClient", false);
                		//component.set("v.propertyStatus", true);
                		document.getElementById('clientAll').style.display = 'none';
                        document.getElementById('clientPrimary').style.display = 'block';
                        
                        }
                        else
                        {
                        component.find("ReSave").set("v.disabled", false);
                        //component.set("v.showClient", true);
               			//component.set("v.showPrimaryClient", false);
               			document.getElementById('clientAll').style.display = 'block';
                        document.getElementById('clientPrimary').style.display = 'none';
                        this.GetSPDetailsWhileEdit(component, event, helper);
                        }                       
                        
             }  
                        component.set("v.IsdisabledClient",true);
                        
                         component.find("pickClient").set("v.value","");
                            if(finalresult.IsJoint__c== true)
                            {
                            component.find("pickClient").set("v.value","Joint");
                            component.set("v.ClientIDEdit","Joint")
                            }
                            else
                            {                          	
                        var cmp= component.find("pickClient");
                        if(cmp !=undefined)
                        {
                         cmp.set("v.value",finalresult.RelatedClient__c);
                        }
                         
                            component.set("v.ClientIDEdit",finalresult.RelatedClient__c);
                            component.set("v.ClientID",finalresult.RelatedClient__c)
                            }
                                                
                        });
                        $A.enqueueAction(action);
                        },
                        
                        DeleteLiability: function(component, event, helper) {        
                        var id = event.target.id;
                        helper.do_action_helper(component, event, helper);
                        },
                        
                        do_action_helper :function(component, event, helper) {
                        var id =  component.get("v.idIs");
                        var action2 = component.get("c.DeleteLiability");
                        action2.setParams({
                        RecordId: id         
                        });        
                        action2.setCallback(this, function(data) {            
                        component.set("v.showPopup",false);
                        var Loanid = component.get("v.LiaLoanId");
                        helper.PopulateLiabilityBasedonClient(component, event, helper,Loanid);
                        });
                        $A.enqueueAction(action2);        
                        },
                        
                        ClearData: function(component, event, helper) {
                        var newselectedRecord = {
                        'sobjectType': 'Liability__c',
                        'Account_Number__c': '',
                        'Address__c': '',
                        'Alimony_Type__c': '',
                        'Amount__c': '',
                        'Liability_Category__c': '',
                        'City__c': '',
                        'County__c': '',
                        'Gross_Rental_Income__c': '',
                        'Insurance_Taxes_etc__c': '',
                        'isActive__c': '',
                        'Job_Expense_Type__c': '',
                        'Job_Related_Expenses__c': '',
                        'Name': '',
                        'Type__c': '',
                        'Liability_willBeClosed_by_paying__c': '',
                        'Liability_will_be_closed_by_paying__c': '',
                        'Liability_will_be_closed_by_Paying_RES__c': '',
                        'Liability_will_be_closed_by_payingThis__c': '',
                        'Liability_Monthly_Payment__c': '',
                        'Mortgage_Liens__c': '',
                        'Mortgage_Payments__c': '',
                        'Name_of_Company__c': '',
                        'Net_Rental_Income_RealEstate__c': '',
                        'Other_Expense__c': '',
                        'Payments_Owed_to__c': '',
                        'Present_Mortgage_Value__c': '',
                        'Property_Address__c': '',
                        'Property_Address2__c': '',
                        'Property_City__c': '',
                        //'Property_State__c': '',
                        'Property_Type__c': '',
                        'Property_Type__c': '',
                        'Property_ZIP__c': '',
                        'Real_Estate_Liability__c': '',
                        'Related_Individual__c': '',
                        'Related_Partner__c': '',
                        'RelatedClient__c': '',
                        'RelatedLoan__c': '',
                        // 'Remaining_months__c': '',
                        'State__c': '',
                        'Liability_Type__c': '',
                        'Liability_Unpaid_Balance__c': '',
                        'Liability_Unpaid_Balance__c': '',
                        'Zip__c': ''
                        };
                        component.set("v.client", newselectedRecord);
                        },
                        
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
                        { text: "Wyoming", value: "Wyoming" }
                    ];
                    
                    component.set("v.propertyState", States);
                    component.set("v.liabilityState", States);
                },
                    Loan_Next: function(component, event, helper) {
                        $('li#l8').removeClass('disabled');
                        $('li#l8 a').attr("data-toggle","tab");
                        if(!component.get('v.fromPopup')){
                            $('li#l8 a').click();
                        } else{
                            $('li#l7').removeClass('active');
                            
                            $('li#l8').addClass('active');
                            $('li#l9').removeClass('active');
                            
                        }
                        component.set('v.itemsClicked','opt8');
                        
                        component.set("v.nextOpt", "true");
                        component.set("v.currentOpt", "false");
                        window.scrollTo(0, 0);
                    },
                        
                        prev: function(component) {
                            if(!component.get('v.fromPopup')){
                                $('li#l6 a').click();
                            } else{
                                $('li#l5').removeClass('active');
                                
                                $('li#l6').addClass('active');
                                $('li#l7').removeClass('active');
                                
                            }
                            component.set("v.prevOpt", "true");
                            component.set("v.currentOpt", "false");
                            window.scrollTo(0, 0);
                        },
                            
                            formatErrorMethod: function(component, regex, msg, aura_id) {
                                
                                var flag = false;
                                for (var i = 0; i < aura_id.length; i++) {
                                    var inputCmp = component.find(aura_id[i]);
                                    var value = inputCmp.get("v.value");
                                    var isValid = false;
                                    
                                    if (typeof regex[i] != "string") {
                                        //Checks to see if this is a function and not a regex string
                                        isValid = regex[i](value); // Please return true if there is an error or else false
                                    } else {
                                        var rxp = new RegExp(regex[i]);
                                        isValid = rxp.test(value);
                                    }
                                    if (isValid) {
                                        //component.set("v.LoanErr", false);//Please leave out this line while replicating. LoanErr may not exist on other compnents
                                        inputCmp.set("v.errors", null);
                                        
                                    } else {
                                        inputCmp.set("v.errors", [{ message: msg[i] + "."  }]); 
                                        flag = true;
                                    }
                                }
                                
                                if(!flag)
                                {
                                    component.set("v.showError", true);
                                }
                                else
                                {
                                    component.set("v.showError", false);
                                }
                                return flag;
                            },
                                
                                formatErrorMethodr: function(component, regexr, msgr, aura_idr) {        
                                    var flagR = false;
                                    for (var i = 0; i < aura_idr.length; i++) {
                                        var inputCmp = component.find(aura_idr[i]);
                                        if(typeof inputCmp==='undefined' )
                                        {}else{
                                            var value = inputCmp.get("v.value");
                                            var isRegValid = true;
                                            if(typeof value==='undefined'|| value==null || value=='' )
                                            {}else{
                                                if (value!='' ) {
                                                    var rxp = new RegExp(regexr[i]);                        
                                                    isRegValid = rxp.test(value);
                                                    if (isRegValid==true) {                            
                                                        inputCmp.set("v.errors", null);                            
                                                    } 
                                                    else {
                                                        inputCmp.set("v.errors", [{ message: msgr[i] + ":" + value }]);
                                                        flagR=true;
                                                    }                         
                                                }
                                            } 
                                        }
                                    }
                                    return flagR;
                                },
                                    CheckClient:function(component, event, helper) {
                                        
                                        var finalResult=false;
                                        var ClientCmp=component.find('pickClient');
                                        var ClientIdE=ClientCmp.get("v.value");
                                        if(ClientIdE=="" || ClientIdE == null || ClientIdE == undefined)
                                        {
                                            finalResult = true;
                                            document.getElementById("ClientError").innerHTML = 'Please Select Client.';
                                        }
                                        else
                                        {
                                            document.getElementById("ClientError").innerHTML = '';
                                        }
                                        return finalResult;
                                    },
                                        saveLiability: function(component, event, helper) {                                            
                                            if (component.find("YearBuiltId")!=undefined) 
                                            {                                                
                                                var yearBuiltval=component.find('YearBuiltId').get('v.value');
                                                if(yearBuiltval!=null || yearBuiltval!='undefined' || yearBuiltval!='')
                                                {
                                                    var yearBuiltvaltoString = yearBuiltval.toString();
                                                    component.set("v.client.Year_Built__c",yearBuiltvaltoString);
                                                }
                                            } 
                                            var ClientId ;
                                            ClientId = component.find('pickClient').get('v.value');                                            
                                            component.set("v.showPropertyWarning", false); 
                                            var liabilityVal = component.get("v.client");  
                                            var Loanid = component.get("v.LiaLoanId");
                                            var action = component.get("c.liabilitysave");
                                            action.setParams({
                                                "Objliability": liabilityVal,
                                                "ClientId": ClientId,
                                                "LoanId": Loanid
                                            });                                            
                                            action.setCallback(this, function(a) {
                                                
                                                var state = a.getState();
                                                component.set("v.recordSaved",true);
                                                component.set("v.isOpen", false); 
                                                this.ClearData(component, event, helper);
                                                component.set("v.ClientIDEdit","");
                                                component.set("v.ClientID","");
                                                helper.PopulateLiabilityBasedonClient(component, event, helper,Loanid);            
                                            });        
                                            $A.enqueueAction(action); 
                                            component.set("v.enableType", true);
                                            component.set("v.enableButton", true);
                                        },
                                            
                                            CheckMonth: function(component, event, helper){
                                                var flagR = false;        
                                                var cmp = component.find("remainingMonths");
                                                var month = cmp.get("v.value");
                                                if(month=='' || month==null ||typeof month==='undefined'){            
                                                }
                                                else{
                                                    if(month<0 || month>11)
                                                    {
                                                        flagR = true;
                                                        cmp.set("v.errors", [{ message: "Month should be between 0 to 11" }]);
                                                    }
                                                    else
                                                    {                
                                                        cmp.set("v.errors",null);
                                                    }            
                                                }
                                                return flagR;        
                                            },
                                                
                                                ValidatePropertyStatusOther: function(component, event, helper) {   
                                                    //true means error
                                                    var finalResult=false; 
                                                    var inputpropertyStatus = component.find('propertyStatus').get('v.value');
                                                    var inputAdditonalRemarks = component.find('additionalRemarks');  
                                                    var inputAdditonalRemarksValue = component.find('additionalRemarks').get('v.value'); 
                                                    if (inputpropertyStatus == 'Other') { 
                                                        if ($A.util.isEmpty(inputAdditonalRemarksValue)  || $A.util.isUndefinedOrNull(inputAdditonalRemarksValue)) 
                                                        {
                                                            finalResult = true;
                                                            inputAdditonalRemarks.set("v.errors", [{ message: "Please Enter addtional remarks" }]);
                                                        } 
                                                        else
                                                        {
                                                            inputAdditonalRemarks.set("v.errors", null); 
                                                        }  
                                                    }
                                                    return finalResult;
                                                },
                                                    
                                                    validateNumbersOnly: function(component, event, helper,compId) {
                                                        var inz = component.get(compId);   
                                                        if(isNaN(inz))
                                                        {
                                                            component.set(compId, inz.substring(0, inz.length - 1));          
                                                        }        
                                                    },
                                                        
                                                        PopulateSubjectPropertyAddressByLoanId: function(component, event, helper) {
                                                            var LoanId = component.get("v.LiaLoanId");        
                                                            var action1 = component.get("c.getSubjectPropertyAddressByLoanId");
                                                            
                                                            action1.setParams({
                                                                "RecordId": LoanId
                                                            });
                                                            action1.setCallback(this, function(data) { 
                                                                var result = data.getReturnValue();
                                                                component.set("v.subjectPropertyAddress", result.Subject_Property_Address__c);
                                                                component.set("v.subjectPropertyCity", result.Subject_Property_City__c);
                                                                component.set("v.subjectPropertyState", result.Subject_Property_State__c);
                                                                component.set("v.subjectPropertyZip", result.Subject_Property_Zip_Code__c);
                                                            });
                                                            $A.enqueueAction(action1);
                                                        },
                                                            
                                                            GetSPDetails: function(component, event, helper) {
                                                                var propertyStatusList = [
                                                                    
                                                                    { text: "", label:'Select',value: 'false' },
                                                                    { text: "Sold", label: "Sold", value: 'false' },
                                                                    { text: "Listed For Sale",label: "Listed For Sale"
                                                                     ,value: 'false'},
                                                                    { text: "Pending Sale",label: "Pending Sale",
                                                                     value: 'false'},
                                                                    { text: "Rental",label: "Rental", value: 'false' },
                                                                    { text: "2nd Home/Vacation",label: "2nd Home/Vacation",
                                                                     value: 'false'},
                                                                    { text: "Subject Property", label: "Subject Property", value: 'true'
                                                                    },
                                                                    
                                                                    { text: "Co-signor", label: "Co-signor",value: 'false'},
                                                                    { text: "Other",label: "Other", value: 'false' },
                                                                ];
                                                                    var propertyStatusList_WithoutSP = [
                                                                    
                                                                    { text: "", label:'Select',value: 'false' },
                                                                    { text: "Sold", label: "Sold", value: 'false' },
                                                                    { text: "Listed For Sale",label: "Listed For Sale"
                                                                    ,value: 'false'},
                                                                    { text: "Pending Sale",label: "Pending Sale",
                                                                    value: 'false'},
                                                                    { text: "Rental",label: "Rental", value: 'false' },
                                                                    { text: "2nd Home/Vacation",label: "2nd Home/Vacation",
                                                                    value: 'false'},
                                                                    { text: "Subject Property",label: "Subject Property", value: 'false'},   
                                                                    
                                                                    { text: "Co-signor", label: "Co-signor",value: 'false'},
                                                                    { text: "Other",label: "Other", value: 'false' },
                                                                ];
                                                                var LoanId = component.get("v.LiaLoanId");        
                                                                var action = component.get("c.getSubjectPropertyCount");
                                                                action.setParams({
                                                                    "LoanId": LoanId
                                                                });
                                                                action.setCallback(this, function(data) { 
                                                                    
                                                                    var result = data.getReturnValue();
                                                                    
                                                                    if(result>0) 
                                                                    {
                                                                        component.set("v.propertyStatusList",propertyStatusList_WithoutSP );
                                                                    }
                                                                    else{
                                                                        component.set("v.propertyStatusList",propertyStatusList ); 
                                                                    }
                                                                    
                                                                    
                                                                });
                                                                $A.enqueueAction(action);
                                                            },
                                                                GetSPDetailsWhileEdit: function(component, event, helper) {
                                                                    component.find("propertyAddress").set("v.disabled", false);
                                                                    component.find("realCity").set("v.disabled", false);
                                                                    component.find("propertyState1").set("v.disabled", false);
                                                                    component.find("realZip").set("v.disabled", false);
                                                                    
                                                                    
                                                                    var LoanId = component.get("v.LiaLoanId");        
                                                                    var action = component.get("c.getSubjectPropertyCount");
                                                                    action.setParams({
                                                                        "LoanId": LoanId
                                                                    });
                                                                    action.setCallback(this, function(data) { 
                                                                        
                                                                        var result = data.getReturnValue();
                                                                        
                                                                        if(result>0) 
                                                                        {
                                                                            var propertyStatusList_WithoutSP = [
                                                                                { text: "", label:'Select',value: 'false' },
                                                                                { text: "Sold", label: "Sold", value: 'false' },
                                                                                { text: "Listed For Sale",label: "Listed For Sale"
                                                                                 ,value: 'false'},
                                                                                { text: "Pending Sale",label: "Pending Sale",
                                                                                 value: 'false'},
                                                                                { text: "Rental",label: "Rental", value: 'false' },
                                                                                { text: "2nd Home/Vacation",label: "2nd Home/Vacation",
                                                                                 value: 'false'},
                                                                                { text: "Subject Property",label: "Subject Property",
                                                                                 value: 'false'},
                                                                                { text: "Co-signor", label: "Co-signor",value: 'false'},
                                                                                { text: "Other",label: "Other", value: 'false' },
                                                                            ];
                                                                                var SPVal=component.get("v.SP");
                                                                                
                                                                                for (var i = 0; i < propertyStatusList_WithoutSP.length; i++) {
                                                                                var e = propertyStatusList_WithoutSP[i];
                                                                            if(e.text==SPVal)
                                                                            {
                                                                                e.value='true';
                                                                            }
                                                                            
                                                                            // component.find("propertyStatus").set("v.value",SPVal);
                                                                            
                                                                        }
                                                                        component.set("v.propertyStatusList",propertyStatusList_WithoutSP);
                                                                        
                                                                    }
                                                                                       else{
                                                                                       var propertyStatusList = [
                                                                                       
                                                                                       { text: "", label:'Select',value: 'false' },
                                                                                       { text: "Sold", label: "Sold", value: 'false' },
                                                                                       { text: "Listed For Sale",label: "Listed For Sale"
                                                                                       ,value: 'false'},
                                                                                       { text: "Pending Sale",label: "Pending Sale",
                                                                                       value: 'false'},
                                                                                       { text: "Rental",label: "Rental", value: 'false' },
                                                                                       { text: "2nd Home/Vacation",label: "2nd Home/Vacation",
                                                                                       value: 'false'},
                                                                                       { text: "Subject Property", label: "Subject Property", value: 'false',disabled:"true"},
                                                                                       
                                                                                       { text: "Co-signor", label: "Co-signor",value: 'false'},
                                                                                       { text: "Other",label: "Other", value: 'false' },
                                                                                       
                                                                                       
                                                                                       ];
                                                                                       var SPVal=component.get("v.SP");
                                                                    for (var i = 0; i < propertyStatusList.length; i++) {
                                                                        var e = propertyStatusList[i];
                                                                        if(e.text==SPVal)
                                                                        {
                                                                            e.value='true';
                                                                        }
                                                                        
                                                                        // component.find("propertyStatus").set("v.value",SPVal);
                                                                        
                                                                    }
                                                                    component.set("v.propertyStatusList",propertyStatusList ); 
                                                                    
                                                                }
                
                
            });
            $A.enqueueAction(action);
        },
                           //Code Started for Story No:- ORMSFDC-1264 by Developer2                      
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
            validateYearBuilt:function(component, event, helper) {
                
                var checkYear=false;
                var yearBuilt=component.get('v.client.Year_Built__c');
                //var strYearBuilt=yearBuilt.toString();
                if(yearBuilt==null || yearBuilt=='' || typeof yearBuilt==='undefined')
                {}
                else{
                    var strYearBuilt=yearBuilt.toString();
                    if(strYearBuilt.length!=0 && strYearBuilt.length<4)
                    {
                        
                        checkYear=true;                
                        document.getElementById("YearBuiltError").innerHTML = 'This should be a valid year and should not be a future year';
                        var YearBuiltId = component.find("YearBuiltId");
                        $A.util.addClass(YearBuiltId, 'errorComponent');
                    }
                    
                    else if(yearBuilt>new Date().getFullYear())
                    {
                        checkYear=true;                
                        document.getElementById("YearBuiltError").innerHTML = 'This should be a valid year and should not be a future year';
                        var YearBuiltId = component.find("YearBuiltId");
                        $A.util.addClass(YearBuiltId, 'errorComponent');
                    }
                        else
                        {
                            document.getElementById("YearBuiltError").innerHTML = '';
                            var YearBuiltId = component.find("YearBuiltId");
                            $A.util.removeClass(YearBuiltId, 'errorComponent');
                        }
                }
                return checkYear;
            },
                //End
                
    })