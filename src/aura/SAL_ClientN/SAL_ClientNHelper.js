({      
    PopulateClients: function(component, event, helper) {
       var _Loanid = component.get("v.clientLoanId");        
        var action1 = component.get("c.getClientDetails");
        action1.setParams({
            "loanID": _Loanid
        });
        action1.setCallback(this, function(data) {
            var Result=data.getReturnValue();
            if(Result.length>0);
            {
              
                component.set("v.TotalCLient",Result.length);
            }
            component.set("v.clientRecords", Result);
            component.set("v.opt2",false);
            if(data.getState()==='SUCCESS'&&component.get("v.clientRecords").length>0)
            {
                this.AutoValidateandmovetonext(component, event, helper);
            }            
        });
        $A.enqueueAction(action1);
    },
     PopulateClientsAfterDelete: function(component, event, helper) {
     
         var id =  component.get("v.deleteitemId");
        var _Loanid = component.get("v.clientLoanId");        
        var action1 = component.get("c.getClientDetails");
        action1.setParams({
            "loanID": _Loanid
        });
        action1.setCallback(this, function(data) {
            var Result=data.getReturnValue();
            if(Result.length>0);
            {
                
                component.set("v.TotalCLient",Result.length);
            }
            
            helper.DeleteClientFrom_NBS(component, event, helper,id);
                        
        });
        $A.enqueueAction(action1);
    },
    PopulateClientSpouse: function(component, event, helper) {
        var _Loanid = component.get("v.clientLoanId");
        var action = component.get('c.getclientValue');
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
                var resultAfterClientSet= component.get("v.NBSData");
                resultAfterClientSet[0].ClientId=ClientId;
                 component.set("v.NBSData",null);
                 component.set("v.NBSData",resultAfterClientSet);
               
                
            }
            else
            {                 
                result.splice(0, 0, staticItem);
                   component.set("v.clientList", result); 
                              
            }
            
        });
        $A.enqueueAction(action);
    },
    //this method is getting used when we add a new client
    PrimaryClientAddressCheck: function(component, event, helper) {
        var _Loanid = component.get("v.clientLoanId");        
        var action1 = component.get("c.getPrimaryClientCheck");
        action1.setParams({
            loanID: _Loanid
        });
        action1.setCallback(this, function(data) {
            var result = data.getReturnValue();
            //checking primary client condition
            if(result == false)
            {
                document.getElementById("CheckPrimaryClientAddress").style.display = 'block'; 
                document.getElementById("CheckSubjectPropertyAddressDIV").style.display = 'none'; 
                this.GetPrimaryClientDetails(component, event, helper);
                document.getElementById("showCurrentAddress").style.display = 'none';
                document.getElementById("showMailingAddress").style.display = 'none';
            }
            else
            {                
                document.getElementById("CheckPrimaryClientAddress").style.display = 'none'; 
                document.getElementById("CheckSubjectPropertyAddressDIV").style.display = 'block';  
                
                //added default subject property condition
                component.set("v.selectedRecord.Address_Same_As_SubjectProperty__c",true);                
                var toggleText = component.find("CheckSubjectPropertyAddress").get("v.value");        
                if (toggleText == true) { 
                    document.getElementById("showCurrentAddress").style.display = 'none';
                    this.GetSubjectPropertyDetailsOnLoad(component, event, helper);             		
                    document.getElementById("showMailingAddress").style.display = 'none';
                }
            }            
        });
        $A.enqueueAction(action1);
    },
    
    //this method is getting used when we add a new client
    GetPrimaryClientDetails:function(component, event, helper){        
        var _Loanid = component.get("v.clientLoanId");
        var action2 = component.get("c.getPrimaryClientAddressDetails");
        action2.setParams({
            "loanID": _Loanid
        });
        action2.setCallback(this, function(data) {
            var result1 = data.getReturnValue();
            component.set("v.primaryClientName", result1.Name);
            component.set("v.primaryClientAddress", result1.Street_Address__c);
            component.set("v.primaryClientCity", result1.City__c);
            component.set("v.primaryClientState", result1.Client_State__c);
            component.set("v.primaryClientZip", result1.Zip__c);
            component.set("v.ClientAddressSameAsPrimaryClient", result1.Client_Address_Same_As_Primary_Client__c);
            component.set("v.CheckifMailingAddressSameAsPresentAddress", result1.Check_if_Mailing_Address_is_similar_to_P__c);
            component.set("v.primaryClientMailingAddress", result1.Address_Mailing__c);
            component.set("v.primaryClientMailingCity", result1.City_Mailing__c);
            component.set("v.primaryClientMailingState", result1.State_Mailing__c);
            component.set("v.primaryClientMailingZip", result1.Zip_Mailing__c);
            component.set("v.clientNumberofYears", result1.Number_of_years__c);
            
            //setting default checkboxes true when we add a secondary client
            component.find("CheckMailingAddress").set("v.value", true);
            component.find("CheckPrimaryClientMailingAddress").set("v.value", true);
            component.find("clientCurrentAddress").set("v.value", component.get("v.primaryClientAddress"));
            component.find("clientCurrentcity").set("v.value", component.get("v.primaryClientCity"));
            component.find("clientCurrentState").set("v.value", component.get("v.primaryClientState"));
            component.find("ClientCurrentZip").set("v.value", component.get("v.primaryClientZip")); 
            component.find("ClientMailingddress").set("v.value", component.get("v.primaryClientAddress"));
            component.find("ClientMailingcity").set("v.value", component.get("v.primaryClientCity"));
            component.find("ClientMailingstate").set("v.value", component.get("v.primaryClientState"));
            component.find("ClientMailingzip").set("v.value", component.get("v.primaryClientZip"));
            //ends
            
            // component.set("v.selectedRecord.Check_if_Mailing_Address_is_similar_to_P__c", result1.Check_if_Mailing_Address_is_similar_to_P__c);
            /* if(result1.Check_if_Mailing_Address_is_similar_to_P__c==true)
                {
                    document.getElementById("showMailingAddress").style.display = 'none';
                }  
                else
                {
                    document.getElementById("showMailingAddress").style.display = 'block';
                }*/
            
        });
        $A.enqueueAction(action2);
    },
    
    GetSubjectPropertyDetails:function(component, event, helper){        
        var _Loanid = component.get("v.clientLoanId");
        var action2 = component.get("c.getSubjectPropertyAddressData");
        action2.setParams({
            "loanID": _Loanid
        });
        action2.setCallback(this, function(data) {
            var result1 = data.getReturnValue(); 
            component.find("clientCurrentAddress").set("v.value", result1.Subject_Property_Address__c);
            component.find("clientCurrentcity").set("v.value", result1.Subject_Property_City__c);
            component.find("clientCurrentState").set("v.value", result1.Subject_Property_State__c);
            component.find("ClientCurrentZip").set("v.value", result1.Subject_Property_Zip_Code__c);   
            component.find("clientCurrentAddress").set("v.disabled", true);
            component.find("clientCurrentcity").set("v.disabled", true);
            component.find("clientCurrentState").set("v.disabled", true);
            component.find("ClientCurrentZip").set("v.disabled", true);
            
        });
        $A.enqueueAction(action2);
    },
    
    GetSubjectPropertyDetailsOnLoad:function(component, event, helper){        
        var _Loanid = component.get("v.clientLoanId");
        var action2 = component.get("c.getSubjectPropertyAddressData");
        action2.setParams({
            "loanID": _Loanid
        });
        action2.setCallback(this, function(data) {
            var result1 = data.getReturnValue(); 
            component.find("clientCurrentAddress").set("v.value", result1.Subject_Property_Address__c);
            component.find("clientCurrentcity").set("v.value", result1.Subject_Property_City__c);
            component.find("clientCurrentState").set("v.value", result1.Subject_Property_State__c);
            component.find("ClientCurrentZip").set("v.value", result1.Subject_Property_Zip_Code__c);   
            component.find("clientCurrentAddress").set("v.disabled", true);
            component.find("clientCurrentcity").set("v.disabled", true);
            component.find("clientCurrentState").set("v.disabled", true);
            component.find("ClientCurrentZip").set("v.disabled", true);
            
            //adding default condition for mailing address
            component.set("v.selectedRecord.Check_if_Mailing_Address_is_similar_to_P__c", true);
            var toggleText = component.find("CheckMailingAddress").get("v.value");        
            if (toggleText == true) { 
                component.set("v.subjectPropertyAddress", result1.Subject_Property_Address__c);
                component.set("v.subjectPropertyCity", result1.Subject_Property_City__c);
                component.set("v.subjectPropertyState", result1.Subject_Property_State__c);
                component.set("v.subjectPropertyZip", result1.Subject_Property_Zip_Code__c);
                component.set("v.selectedRecord.Address_Mailing__c", component.get("v.subjectPropertyAddress"));
                component.set("v.selectedRecord.City_Mailing__c", component.get("v.subjectPropertyCity"));
                component.set("v.selectedRecord.State_Mailing__c", component.get("v.subjectPropertyState"));
                component.set("v.selectedRecord.Zip_Mailing__c", component.get("v.subjectPropertyZip"));
            }
            //adding default condition for mailing address ends
        });
        $A.enqueueAction(action2);
    },
    
    GetPrimaryClientName:function(component, event, helper){
        var _Loanid = component.get("v.clientLoanId");
        var action2 = component.get("c.getPrimaryClientAddressDetails");
        action2.setParams({
            "loanID": _Loanid
        });
        action2.setCallback(this, function(data) {
            var result1 = data.getReturnValue();
            component.set("v.primaryClientName", result1.Name);
            component.set("v.primaryClientAddress", result1.Street_Address__c);
            component.set("v.primaryClientCity", result1.City__c);
            component.set("v.primaryClientState", result1.Client_State__c);
            component.set("v.primaryClientZip", result1.Zip__c);
            component.set("v.ClientAddressSameAsPrimaryClient", result1.Client_Address_Same_As_Primary_Client__c);
            component.set("v.CheckifMailingAddressSameAsPresentAddress", result1.Check_if_Mailing_Address_is_similar_to_P__c);
            component.set("v.primaryClientMailingAddress", result1.Address_Mailing__c);
            component.set("v.primaryClientMailingCity", result1.City_Mailing__c);
            component.set("v.primaryClientMailingState", result1.State_Mailing__c);
            component.set("v.primaryClientMailingZip", result1.Zip_Mailing__c);  
            component.set("v.clientNumberofYears", result1.Number_of_years__c);
        });
        $A.enqueueAction(action2);
    },
    
    CreateClient: function(component, event, helper) { 
        
        var newClient = component.get("v.selectedRecord");
        /* var CheckEmail = component.find("CheckEmail").get("v.value");
        if (CheckEmail == false) {
            component.set("v.selectedRecord.Email_Optional__c", '');
        }   */     
        
        var ClientinputAddressValue=component.find('clientCurrentAddress').get('v.value');
        var ClientCurrentcityValue=component.find('clientCurrentcity').get('v.value');
        var ClientCurrentStateValue=component.find('clientCurrentState').get('v.value');
        var ClientCurrentZipValue=component.find('ClientCurrentZip').get('v.value');
        
        var toggleText = component.find("CheckMailingAddress").get("v.value");
        if (toggleText == true) {         
            
            component.set("v.selectedRecord.Address_Mailing__c", ClientinputAddressValue);
            component.set("v.selectedRecord.City_Mailing__c", ClientCurrentcityValue);
            component.set("v.selectedRecord.State_Mailing__c", ClientCurrentStateValue);
            component.set("v.selectedRecord.Zip_Mailing__c", ClientCurrentZipValue);
        }
        
        //var spouseText = component.find("inputClientSpouseField").get("v.value");  
       /* var spouseText = helper.getRadioGroupValue(component, event, helper,"inputClientSpouseField","v.selectedRecord.Non_Borrowing_Spouse__c");
        if (spouseText == 'Yes')
        {  
            var toggleSpouseText = component.find("CheckSpouseMailingAddress").get("v.value");
            if (toggleSpouseText == true) {         
                
                component.set("v.selectedRecord.Non_Borrowing_Spouse_Addres__c", ClientinputAddressValue);
                component.set("v.selectedRecord.Non_Borrowing_Spouse_City__c", ClientCurrentcityValue);
                component.set("v.selectedRecord.Non_Borrowing_Spouse_State__c", ClientCurrentStateValue);
                component.set("v.selectedRecord.Non_Borrowing_Spouse_Zip__c", ClientCurrentZipValue);
            }
        }
        
        // var spouseText = component.find("inputClientSpouseField").get("v.value");
        var spouseText = helper.getRadioGroupValue(component, event, helper,"inputClientSpouseField","v.selectedRecord.Non_Borrowing_Spouse__c");
        if (spouseText == ''  || spouseText == 'No' || typeof spouseText ==='undefined')
        {  
            component.set("v.selectedRecord.Non_Borrowing_Spouse_Addres__c", '');
            component.set("v.selectedRecord.Non_Borrowing_Spouse_City__c", '');
            component.set("v.selectedRecord.Non_Borrowing_Spouse_State__c", '');
            component.set("v.selectedRecord.Non_Borrowing_Spouse_Zip__c", '');   
            component.set("v.selectedRecord.Spouse_Mailing_Address_same_as_client__c", ''); 
            component.set("v.selectedRecord.Non_Borrowing_Relation__c", ''); 
            component.set("v.selectedRecord.Non_Borrowing_Date_of_Birth__c", ''); 
            component.set("v.selectedRecord.Non_Borrowing_Spouse_Phone_Number__c", ''); 
            component.set("v.selectedRecord.Non_Borrowing_Spouse_Name__c", ''); 
        } 
        */
        var ssnvalue = component.find("ssn").get("v.value");
        ssnvalue = ssnvalue.replace(/\D/g, '');
        component.set("v.selectedRecord.Social_Security_Number__c", ssnvalue); 
        
        var action2 = component.get("c.SaveClient"); 
        action2.setParams({
            objClient: newClient,
            loanID: component.get("v.clientLoanId")            
        });
        action2.setCallback(this, function(data) {
            var state = data.getState();
            component.set("v.newclient", false);
            this.PopulateClients(component, event, helper);
            this.ValidationForPills(component, event, helper);
            
             helper.ClientCountLoan(component, event, helper);
            this.PopulateClientSpouse(component, event, helper); 
           helper.PopulateClientsAfterDelete(component, event, helper);
            this.DelayPrimaryClientNBSY(component, event, helper);
           
            
           
            
        });        
        $A.enqueueAction(action2);       
    },
 
    GetClientforEdit: function(component, event, helper) {
        var result;
        var id = event.target.id;
        var action2 = component.get("c.getClientDetailsbyId");        
        action2.setParams({
            RecordId: id         
        });
        action2.setCallback(this, function(data) {
            result = data.getReturnValue();
            component.set("v.selectedRecord", result);    
            // To format SSN number on load
            if(!$A.util.isUndefinedOrNull(result.Social_Security_Number__c))
            {
                var ssnview  = result.Social_Security_Number__c;
                var finalssn = ssnview.slice(0,3) + "-" + ssnview.slice(3,5) + "-" + ssnview.slice(5,9);
                component.set("v.selectedRecord.Social_Security_Number__c", finalssn);
            }
            //check subject property condition
            if(result.Address_Same_As_SubjectProperty__c==true){
                
                document.getElementById("showCurrentAddress").style.display = 'none';
                component.find("clientCurrentAddress").set("v.disabled", true);
                component.find("clientCurrentcity").set("v.disabled", true);
                component.find("clientCurrentState").set("v.disabled", true);
                component.find("ClientCurrentZip").set("v.disabled", true);           
            }
            else{
                document.getElementById("showCurrentAddress").style.display = 'block';
                component.find("clientCurrentAddress").set("v.disabled", false);
                component.find("clientCurrentcity").set("v.disabled", false);
                component.find("clientCurrentState").set("v.disabled", false);
                component.find("ClientCurrentZip").set("v.disabled", false);
            }
            
            //check primary client condition
            if(result.Primary_Client_for_the_Loan__c==false){
                document.getElementById("CheckSubjectPropertyAddressDIV").style.display = 'none'; 
                document.getElementById("CheckPrimaryClientAddress").style.display = 'block'; 
                this.GetPrimaryClientName(component, event, helper);               
            }
            else{
                document.getElementById("CheckSubjectPropertyAddressDIV").style.display = 'block'; 
                document.getElementById("CheckPrimaryClientAddress").style.display = 'none'; 
                component.set("v.primaryClientName", '');
            }
            
            //check email condition
            /* var toggleEmailText = component.find("CheckEmail").get("v.value");
            if (toggleEmailText == true) {
                component.set("v.showEmail", true);                      
            } else {
                component.set("v.showEmail", false);
            }*/
            
            //check mailing address condition
            var toggleText = component.find("CheckMailingAddress").get("v.value");
            if (toggleText == true) {
                //changed By Nausad
                //document.getElementById("showMailingAddress").style.display = 'block';
                document.getElementById("showMailingAddress").style.display = 'none';
                component.find("ClientMailingddress").set("v.disabled", true);
                component.find("ClientMailingcity").set("v.disabled", true);
                component.find("ClientMailingstate").set("v.disabled", true);
                component.find("ClientMailingzip").set("v.disabled", true);
                
            } else {
                document.getElementById("showMailingAddress").style.display = 'block';
                component.find("ClientMailingddress").set("v.disabled", false);
                component.find("ClientMailingcity").set("v.disabled", false);
                component.find("ClientMailingstate").set("v.disabled", false);
                component.find("ClientMailingzip").set("v.disabled", false);                
            }
            
            //check spouse condition
            //var spouseText = component.find("inputClientSpouseField").get("v.value"); 
         /*   var spouseText = helper.getRadioGroupValue(component, event, helper,"inputClientSpouseField","v.selectedRecord.Non_Borrowing_Spouse__c");
            if (spouseText == ''  || spouseText == 'No' || typeof spouseText ==='undefined')
            {  
                component.set("v.showSpouseDetails", false);                
            } 
            else {
                component.set("v.showSpouseDetails", true); 
                var toggleText = component.find("CheckSpouseMailingAddress").get("v.value");
                if (toggleText == true) {
                    document.getElementById("showSpouseAddress").style.display = 'none';
                    component.find("inputNBSpouseAddress").set("v.disabled", true);
                    component.find("inputNBSpouseCity").set("v.disabled", true);
                    component.find("inputNBSpouseState").set("v.disabled", true);
                    component.find("ClientNonBorrowingSpousezip").set("v.disabled", true);
                    
                } else {
                    document.getElementById("showSpouseAddress").style.display = 'block';
                    component.find("inputNBSpouseAddress").set("v.disabled", false);
                    component.find("inputNBSpouseCity").set("v.disabled", false);
                    component.find("inputNBSpouseState").set("v.disabled", false);
                    component.find("ClientNonBorrowingSpousezip").set("v.disabled", false);
                }
            } */
            
            //check primary client condition
            var toggleText = component.find("CheckPrimaryClientMailingAddress").get("v.value");
            if (toggleText == true) { 
                document.getElementById("showCurrentAddress").style.display = 'none';
                component.find("clientCurrentAddress").set("v.disabled", true);
                component.find("clientCurrentcity").set("v.disabled", true);
                component.find("clientCurrentState").set("v.disabled", true);
                component.find("ClientCurrentZip").set("v.disabled", true);
                
                component.find("clientCurrentAddress").set("v.errors", null); 
                component.find("clientCurrentcity").set("v.errors", null); 
                component.find("clientCurrentState").set("v.errors", null); 
                component.find("ClientCurrentZip").set("v.errors", null); 
                
                component.find("ClientMailingddress").set("v.errors", null); 
                component.find("ClientMailingcity").set("v.errors", null); 
                component.find("ClientMailingstate").set("v.errors", null); 
                component.find("ClientMailingzip").set("v.errors", null);
            }  
        });
        $A.enqueueAction(action2);
    },
    
    formatErrorMethodClient: function(component, regex, msg, aura_id) {        
        var inputCmp = component.find(aura_id);
        var value = inputCmp.get("v.value");
        var isValid = regex.test(value);        
        if (isValid) {            
            component.set("v.LoanErr", false); 
            inputCmp.set("v.errors", null);
        } else {            
            if(component.get("v.NewStartLoan"))
            {}
            else
            {
                inputCmp.set("v.errors", [{ message: msg + ":" + value }]);
            }
            component.set("v.LoanErr", true);
        }
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
            } 
            if (isValid) {
                inputCmp.set("v.errors", null);
            }
            else {
                inputCmp.set("v.errors", [{ message: msg[i] + "."  }]);
                flag = true;
            }
        }        
        return flag;
    },
    
    ValidZip: function(component, event, helper,id) {  
     
        var isRegZipValid = false;
        var msgZip = '';
        var inputCmp = component.find(id);          
        var value = inputCmp.get("v.value"); 
        if (typeof value === "undefined" || value==null || value=='') {
        }
        else{
            var regZip =/(^\d{5}$)|(^\d{5}-\d{4}$)/;        
            
            if (value.length>0 ) { 
                var rxp = new RegExp(regZip);               
                isRegZipValid = rxp.test(value);         
                if (isRegZipValid) {
                    inputCmp.set("v.errors", null); 
                    isRegZipValid = false;
                } 
                else {                    
                    inputCmp.set("v.errors", [{ message: "Please enter a valid zip format (eg: 23454/23456-1234)" }]);               
                    isRegZipValid = true;
                } 
            }
            else{
                isRegZipValid = false;
            }            
        }        
        return isRegZipValid;
    },
    
    ContinuenextTab : function(component, event, helper) 
    {
        
        var _Loanid=component.get("v.LoanId");
        var action = component.get("c.GetTabtatus");
        action.setParams({
            "loanID": _Loanid
        });        
        action.setCallback(this, function(data) {    
            var result=data.getReturnValue();
        });
        $A.enqueueAction(action);  
        
    },
    prev: function(component) {
        //  debugger;
        
        $('li#l1').removeClass('active');
        
        $('li#l2').addClass('active');
        $('li#l3').removeClass('active');
        
        if(!component.get('v.fromPopup'))
        {        $('li#l1').removeClass('active');
         $('li#l3').removeClass('active');
         
         $('li#l2 a').click();
        }
        else{
            //     alert('asd');
            $('li#l1').removeClass('active');
            
            $('li#l2').addClass('active');
            $('li#l3').removeClass('active');
        }
        // alert('last');
        component.set("v.jumpto_last","false");
        
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        $('li#l3').removeClass('active');
        $('li#l2').addClass('active');
        window.scrollTo(0, 0);
        document.getElementById('ClentLbl').innerHTML ='NoNeedtomove';
        
        //document.getElementById('targetID').innerHTML ='l2';
    },
    
    FutureDOBValidation:  function(component,id) {
        
        debugger
        var inputCmp = component.find(id);          
        var value = inputCmp.get("v.value");
        
        if (typeof value === "undefined"  || value==null || value=='') {
            return false;
        }
        else{
            var selectedDate = new Date(value),
                todayDate   = new Date(),
                diff  = new Date(selectedDate-todayDate),
                days = (diff) / (1000 * 60 * 60 * 24);
            
            if (days < -1) {  
                inputCmp.set("v.errors", null);
                return false; 
                
            } else {
                inputCmp.set("v.errors", [{ message: "Future Date not allowed" }]);   
                return true;
            } 
        }   
    },
    
    //check for age 62
    checkFor62: function(component,event,helper){
        
        var flag=false;
        var currdate = new Date();   
        var DOB = component.find("ClientInputDOB");
        var DOBValue = DOB.get("v.value");
        if(!$A.util.isEmpty(DOBValue))
        {
            var year=DOBValue.substring(0,4);  
            var month=DOBValue.substring(5,7);
            var day=DOBValue.substring(8,10);
            DOBValue=month+'/'+day+'/'+year;
        }
        var mydate = new Date(DOBValue); 
        var diffYr = currdate.getFullYear() - mydate.getFullYear();
        var m = currdate.getMonth() - mydate.getMonth();
        
        if (m < 0 || (m === 0 && currdate.getDate() < mydate.getDate())) 
        {
            diffYr--;
        }  
        
        if(diffYr >= 62)
        {
            DOB.set("v.errors", null); 
        }
        else if(diffYr <62)
        {
            DOB.set("v.errors", [{ message: "Age must be greater then 62 Years." }]);
            flag=true; 
        } 
        return flag;
    },
    EraseTypeCharactersinDate:function(component, event, helper,id, dbvalue) {
        var value = component.find(id).get("v.value"); 
        if (typeof value === "undefined"  || value==null || value=='') {
            return false;
        }
        else
        {  
            var rxp = new RegExp("^[a-zA-Z0-9-!@#$%^&*()_+-={}<>?/]+$");               
            var  isRegValid = rxp.test(value);
            if(isRegValid)
            {
                component.set(dbvalue,'');
            }
        } 
    },
    
    validateEnteredWhitespace:function(component, event, helper,compId) {
        var inz = component.get(compId);        
        var digit = inz.toString()[0];
        if(digit == ' ')
        {            
            component.set(compId, inz.substring(0, inz.length - 1));
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
    
    validateNumbersOnly: function(component, event, helper,compId) {
        var inz = component.get(compId);   
        if(isNaN(inz))
        {
            component.set(compId, inz.substring(0, inz.length - 1));          
        }        
    },
    
    validateSSNNumbersOnly: function(component, event, helper,compId) {
        
        var inz = component.get(compId);  
        var regSSN = /(\d{3}-\d{2}|\*{3}-\*{2})-\d{4}/;
        if(isNaN(inz))
        {
            component.set(compId, inz.substring(0, inz.length));          
        }  
    },
    
    hideSSNNumbers: function(component, event, helper,compId) {
        
        var inz = component.get(compId);
        if ($A.util.isEmpty(inz)  || $A.util.isUndefinedOrNull(inz)) {
            return false;
        }
        else
        {
            component.set("v.socialnumber", inz);
            if (inz.length==9)
            {
                var s2 = (""+inz).replace(/^\d{5}/, '*****');   
                inz = s2;       
                component.set(compId,inz); 
            }
        }
    },
    
    showSSNNumbers: function(component, event, helper,compId) {
        
        var inz = component.get(compId);
        if ($A.util.isEmpty(inz)  || $A.util.isUndefinedOrNull(inz)) {
            return false;
        }
        else
        {
            var s2 = component.get("v.socialnumber"); 
            if(s2 != '')
            {
                inz = s2;
            }
            component.set(compId,inz);  
        }
    },
    
    validateSSN:  function(component,id) {
        
        var inputCmp = component.find(id);          
        var value = inputCmp.get("v.value");
        value = value.replace(/\D/g, '');
        if ($A.util.isEmpty(value)  || $A.util.isUndefinedOrNull(value)) {
            return false;
        }
        else
        {       
            if (value.length==9) {  
                inputCmp.set("v.errors", null);
                return false; 
                
            } else {
                inputCmp.set("v.errors", [{ message: "Please Enter 9-digit SSN Number" }]);   
                return true;
            } 
        }   
    },
    
    FormatPhonehelper: function(component, event, helper, id, dbvalue){     
        var value = component.find(id).get("v.value"); 
        if (typeof value === "undefined"  || value==null || value=='') {
            return false;
        }
        else
        {  
            var rxp = new RegExp("^(\\d)\\1{9}$");               
            var  isRegValid = rxp.test(value);
            if(isRegValid)
            {
                component.set(dbvalue,'');
            }
            else
            {
                var s2 = (""+value).replace(/\D/g, '');
                var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
                var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
                component.set(dbvalue,result);  
            }  
        }  
    },
    
    FormatSSNhelper: function(component, event, helper, id, dbvalue){
        
        var value = component.find(id).get("v.value"); 
        if (typeof value === "undefined"  || value==null || value=='') {
            return false;
        }
        else
        {  
            var rxp = new RegExp("^[0-9-]*$");               
            var  isRegValid = rxp.test(value);
            if(!isRegValid)
            {
                component.set(dbvalue,'');
                return;
            }
            
            var lvNumber = value.replace(/\D/g, '');
            var lvLength = lvNumber.length;
            if(lvLength > 3 && lvLength < 6)
            {
                var lvSegmentA = lvNumber.slice(0,3);
                var lvSegmentB = lvNumber.slice(3,5);
                value = lvSegmentA + "-" + lvSegmentB;
            }
            else
            {
                if(lvLength > 5)
                {
                    var lvSegmentA = lvNumber.slice(0,3);
                    var lvSegmentB = lvNumber.slice(3,5);
                    var lvSegmentC = lvNumber.slice(5,9);
                    value = lvSegmentA + "-" + lvSegmentB + "-" + lvSegmentC;
                }                
            }
            component.set(dbvalue,value); 
        }  
    },
    
    ValidateEmailRequired: function(component, event, helper) {               
        //true means error
        var finalResult=false; 
        var inputClientEmail=component.find('inputClientEmail');
        var inputClientEmailValue=component.find('inputClientEmail').get('v.value');
        var regEmail = /[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}/;      
        
        /* if ($A.util.isEmpty(inputClientEmailValue)  || $A.util.isUndefinedOrNull(inputClientEmailValue)) 
        {
            finalResult = true;
            inputClientEmail.set("v.errors", [{ message: "Please Enter Email" }]);
        } 
        else
        {
            inputClientEmail.set("v.errors", null); 
        }  */
        
        if(!$A.util.isEmpty(inputClientEmailValue)) 
        {
            var rxp = new RegExp(regEmail);
            var emailResult = rxp.test(inputClientEmailValue);
            
            if(!emailResult)
            {
                finalResult = true;
                inputClientEmail.set("v.errors", [{ message: "Please enter valid Email" }]);
            }             
            else
            {
                inputClientEmail.set("v.errors", null); 
            } 
        } 
        
        return finalResult;
    },
    
    ValidateMailingAddressRequiredFields: function(component, event, helper) {
        //true means error
        var finalResult=false;   
        
        var ClientMailingddress=component.find('ClientMailingddress');
        var ClientMailingddressValue=component.find('ClientMailingddress').get('v.value');
        
        var ClientMailingcity=component.find('ClientMailingcity');
        var ClientMailingcityValue=component.find('ClientMailingcity').get('v.value');
        
        var ClientMailingstate=component.find('ClientMailingstate');
        var ClientMailingstateValue=component.find('ClientMailingstate').get('v.value');
        
        var ClientMailingzip=component.find('ClientMailingzip');
        var ClientMailingzipValue=component.find('ClientMailingzip').get('v.value');         
        var CheckMailingAddress = component.find("CheckMailingAddress").get("v.value");      
        
        if (CheckMailingAddress == false || CheckMailingAddress == null || typeof CheckMailingAddress ==='undefined')
        {
            if ($A.util.isEmpty(ClientMailingddressValue)) 
            {
                finalResult = true;
                ClientMailingddress.set("v.errors", [{ message: "This is a required field" }]);
            } 
            else
            {
                ClientMailingddress.set("v.errors", null); 
            }  
            
            if ($A.util.isEmpty(ClientMailingcityValue)) 
            {
                finalResult = true;
                ClientMailingcity.set("v.errors", [{ message: "This is a required field" }]);
            } 
            else
            {
                ClientMailingcity.set("v.errors", null); 
            }
            
            if ($A.util.isEmpty(ClientMailingstateValue)) 
            {
                finalResult = true;
                ClientMailingstate.set("v.errors", [{ message: "This is a required field" }]);
            } 
            else
            {
                ClientMailingstate.set("v.errors", null); 
            }
            
            
            if ($A.util.isEmpty(ClientMailingzipValue)) 
            {
                finalResult = true;
                ClientMailingzip.set("v.errors", [{ message: "This is a required field" }]);
            } 
            else
            {
                ClientMailingzip.set("v.errors", null); 
            }
        }
        else
        {
            finalResult = false;
            ClientMailingddress.set("v.errors", null); 
            ClientMailingcity.set("v.errors", null); 
            ClientMailingstate.set("v.errors", null); 
            ClientMailingzip.set("v.errors", null);
        }
        return finalResult;
    },
    
    ValidateClientSpouseRequiredFields: function(component, event, helper) {
        //true means error
        var finalResult=false;   
        
        var inputNBSpouseName=component.find('inputNBSpouseName');
        var inputNBSpouseNameValue=component.find('inputNBSpouseName').get('v.value');
        
        var inputNBSpousePhone=component.find('inputNBSpousePhone');
        var inputNBSpousePhoneValue=component.find('inputNBSpousePhone').get('v.value');
        
        var inputNBSpouseDOB=component.find('inputNBSpouseDOB');
        var inputNBSpouseDOBValue=component.find('inputNBSpouseDOB').get('v.value');
        
        var inputNBSpouseMaritalStatus=component.find('inputNBSpouseMaritalStatus');
        var inputNBSpouseMaritalStatusValue=component.find('inputNBSpouseMaritalStatus').get('v.value'); 
        
        var inputNBSpouseAddress=component.find('inputNBSpouseAddress');
        var inputNBSpouseAddressValue=component.find('inputNBSpouseAddress').get('v.value'); 
        
        var inputNBSpouseCity=component.find('inputNBSpouseCity');
        var inputNBSpouseCityValue=component.find('inputNBSpouseCity').get('v.value'); 
        
        var inputNBSpouseState=component.find('inputNBSpouseState');
        var inputNBSpouseStateValue=component.find('inputNBSpouseState').get('v.value'); 
        
        var ClientNonBorrowingSpousezip=component.find('ClientNonBorrowingSpousezip');
        var ClientNonBorrowingSpousezipValue=component.find('ClientNonBorrowingSpousezip').get('v.value'); 
        
        //var spouseText = component.find("inputClientSpouseField").get("v.value");
        var spouseText = helper.getRadioGroupValue(component, event, helper,"inputClientSpouseField","v.selectedRecord.Non_Borrowing_Spouse__c");
        if (spouseText == 'Yes')
        {  
            if ($A.util.isEmpty(inputNBSpouseNameValue)) 
            {
                finalResult = true;
                inputNBSpouseName.set("v.errors", [{ message: "This is a required field" }]);
            } 
            else
            {
                inputNBSpouseName.set("v.errors", null); 
            }  
            
            if ($A.util.isEmpty(inputNBSpousePhoneValue)) 
            {
                finalResult = true;
                inputNBSpousePhone.set("v.errors", [{ message: "This is a required field" }]);
            } 
            else
            {
                inputNBSpousePhone.set("v.errors", null); 
            }
            
            if ($A.util.isEmpty(inputNBSpouseDOBValue)) 
            {
                finalResult = true;
                inputNBSpouseDOB.set("v.errors", [{ message: "This is a required field" }]);
            } 
            else
            {
                inputNBSpouseDOB.set("v.errors", null); 
            }            
            
            if ($A.util.isEmpty(inputNBSpouseMaritalStatusValue)) 
            {
                finalResult = true;
                inputNBSpouseMaritalStatus.set("v.errors", [{ message: "This is a required field" }]);
            } 
            else
            {
                inputNBSpouseMaritalStatus.set("v.errors", null); 
            }
            
            var toggleSpouseText = component.find("CheckSpouseMailingAddress").get("v.value");
            if (toggleSpouseText == false || $A.util.isUndefinedOrNull(toggleSpouseText)) 
            {                 
                if ($A.util.isEmpty(inputNBSpouseAddressValue)) 
                {
                    finalResult = true;
                    inputNBSpouseAddress.set("v.errors", [{ message: "This is a required field" }]);
                } 
                else
                {
                    inputNBSpouseAddress.set("v.errors", null); 
                }
                
                if ($A.util.isEmpty(inputNBSpouseCityValue)) 
                {
                    finalResult = true;
                    inputNBSpouseCity.set("v.errors", [{ message: "This is a required field" }]);
                } 
                else
                {
                    inputNBSpouseCity.set("v.errors", null); 
                }
                
                if ($A.util.isEmpty(inputNBSpouseStateValue)) 
                {
                    finalResult = true;
                    inputNBSpouseState.set("v.errors", [{ message: "This is a required field" }]);
                } 
                else
                {
                    inputNBSpouseState.set("v.errors", null); 
                }
                
                if ($A.util.isEmpty(ClientNonBorrowingSpousezipValue)) 
                {
                    finalResult = true;
                    ClientNonBorrowingSpousezip.set("v.errors", [{ message: "This is a required field" }]);
                } 
                else
                {
                    ClientNonBorrowingSpousezip.set("v.errors", null); 
                }
            }
        }
        else
        {
            finalResult = false;
            inputNBSpouseName.set("v.errors", null); 
            inputNBSpousePhone.set("v.errors", null); 
            inputNBSpouseDOB.set("v.errors", null); 
            inputNBSpouseMaritalStatus.set("v.errors", null);
            inputNBSpouseAddress.set("v.errors", null);
            inputNBSpouseCity.set("v.errors", null);
            inputNBSpouseState.set("v.errors", null);
            ClientNonBorrowingSpousezip.set("v.errors", null);
        }
        return finalResult;
    },
    
    clearClientData: function(component, event, helper) {        
        var newselectedRecord = {
            'sobjectType': 'Client__c',
            'Name': '',
            'Last_Name__c': '',
            'Street_Address__c': '',
            'State__c': '',
            'City__c': '',
            'Zip__c': '',
            'Email_Optional__c': '',
            'Phone_Number__c': '',
            //'Client_has_Email_Address__c': '',
            'Client_State__c': '',
            'Zip__c': '',
            'DOB__c': '',
            'FHA_Insured_Loan__c': '',
            'First_Name__c': '',
            'Home_Phone__c': '',
            'is_Active__c': '',
            'Address_Mailing__c': '',
            'Check_if_Mailing_Address_is_similar_to_P__c': '',
            'City_Mailing__c': '',
            'State_Mailing__c': '',
            'Zip_Mailing__c': '',
            'Marital_Status__c': '',
            'Middle_Name__c': '',
            'Phone_Number__c': '',
            'Non_Borrowing_Spouse__c': '',
            'Non_Borrowing_Spouse_Addres__c': '',
            'Non_Borrowing_Spouse_City__c': '',
            'Non_Borrowing_Date_of_Birth__c': '',
            'Non_Borrowing_Spouse_Name__c': '',
            'Non_Borrowing_Spouse_Phone_Number__c': '',
            'Non_Borrowing_Spouse_State__c': '',
            'Non_Borrowing_Spouse_Zip__c': '',          
            'Number_of_years__c': '',
            'Primary_Client_for_the_Loan__c': '',
            'Property_type__c': '',
            'Residence__c': '',
            'Social_Security_Number__c': ''            
        };
        //resetting the Values in the form
        component.set("v.selectedRecord", newselectedRecord);
    },  
    
    AutoValidateandmovetonext: function(component, event, helper) {
        //  debugger;
        var LoanId = component.get('v.clientLoanId');
        var action1 = component.get("c.IsClientValidate"); 
        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function(Clientdata) {
            // debugger;
            var result=Clientdata.getReturnValue(); 
            if(result.Is_Loan_Created_Manually__c==false)
            {
                if(result.IsClientFilled_Flag__c==false )
                {
                    component.set("v.IsClientValidatedPopup", true);
                    this.addDelay(component, event, helper);  
                    return false;
                } 
                else{  
                    var el = document.getElementById('ClentLbl');
                    var text=el.innerText;
                    if(text=="NoNeedtomove")
                    {
                        //document.getElementById('ClentLbl').innerHTML ='Move';
                        
                    }
                    else{
                        if(result.IsDeclarationFilled_Flag__c==true){
                            $('#p2').addClass('autoMoved');
                            $('li#step2Lock').removeClass('disabled');
                            $('li#step2Lock a').attr("data-toggle","collapse");
                            $('li#l3').removeClass('active'); 
                            $('a#step2').click(); 
                            $('li#l9').removeClass('disabled'); 
                            $('li#l9 a').attr("data-toggle","tab"); 
                            $('li#l10 a').attr("data-toggle","tab");
                            $('li#l10').removeClass('disabled');
                            $('li#l11 a').attr("data-toggle","tab");
                            $('li#l11').removeClass('disabled');
                            $('li#l12 a').attr("data-toggle","tab");
                            $('li#l12').removeClass('disabled');  
                            $('#l9 a').click();
                            component.set("v.nextDecOpt", "true");
                            component.set("v.currentOpt", "false");
                            // $('#l9').addClass('active');
                            
                        }
                        else{} 
                    }
                    
                }
                
            }
            
            
            else{ 
                component.set('v.clientIncomplete',false);
                
                this.ManualNext(component, event, helper);
            }
            
        });
        $A.enqueueAction(action1);
    },
    
    
    Loan_Next: function(component,event) {    
        //  debugger;
        
        if(component.get('v.clientIncomplete')==true)
        {
            component.set("v.showWarning", true);
            return;            
        }        
        component.set("v.showWarning", false);
        $('li#l5').removeClass('disabled');
        $('li#l5 a').attr("data-toggle","tab");
        
        if(event.getSource().getLocalId() =="addEmployment")//Goes to the next step if it is an actual click
        {
            //$('li#l5 a').click();
            if(!component.get('v.fromPopup')){
                $('li#l5 a').click();
            } else{
                $('li#l4').removeClass('active');
                
                $('li#l5').addClass('active');
                $('li#l6').removeClass('active');
                
            }
            component.set('v.itemsClicked','opt5'); 
            component.set("v.nextOpt", "true");
            component.set("v.currentOpt", "false");
        }
        window.scrollTo(0, 0);
        
        // $('li#l5').removeClass('disabled');
        // $('li#l5 a').attr("data-toggle","tab");        
        $('li#l6').removeClass('disabled');
        $('li#l6 a').attr("data-toggle","tab");        
        $('li#l7').removeClass('disabled');
        $('li#l7 a').attr("data-toggle","tab");        
        $('li#l8').removeClass('disabled');
        $('li#l8 a').attr("data-toggle","tab");  
        var jumpToLoanDetails = component.get("v.DeclarationStatus"); 
        //alert('jumpToLoanDetails '+jumpToLoanDetails);
        //	alert('was clicked '+component.get("v.wasClicked"));
        // debugger;
        // this.Continue(component, event, helper);
        //   alert(component.get("v.manual"));
        if(component.get("v.jumpto_last")==true  && jumpToLoanDetails==true && component.get("v.wasClicked")==false && component.get("v.manual")==true)
        {    
            //alert('inside 123');
            $('#p2').addClass('autoMoved');
            $('li#step2Lock').removeClass('disabled');
            $('li#step2Lock a').attr("data-toggle","collapse");
            $('li#l3').removeClass('active');
            
            $('a#step2').click();
            
            $('li#l9').removeClass('disabled');
            
            $('li#l9 a').attr("data-toggle","tab");
            if(!component.get('v.fromPopup'))
            { 
                
                $('#l9 a').click();
                
            }else{
                
                $('.p2').show();
                $('#l9').addClass('active');
            }
            var element = document.getElementById("menudiv");
            element.scrollTop = element.scrollHeight;
            $('li#l10').attr('class','disabled');
            $('li#l10 a').attr("data-toggle","cat");
            $('li#l11').attr('class','disabled');
            $('li#l11 a').attr("data-toggle","cat");
            $('li#l12').attr('class','disabled');
            $('li#l12 a').attr("data-toggle","cat");
            
            
            component.set("v.nextDecOpt", "true");
            component.set("v.currentOpt", "false");
            /*var p = $("#menudiv");
        var offset = p.offset();
        var yaxis=offset.top-50;
        window.scroll(0, yaxis);*/
            //window.scrollTo(0, 0);        
        }      
    },
    addDelay : function(component, event, helper){
        var delay=500; //4 seconds
        
        setTimeout(function() {
            document.getElementById("l3").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
            
        }, delay);
    },
    
    ValidationForPills: function(component, event, helper) {
        // debugger;
        var LoanId = component.get('v.clientLoanId');
        var action1 = component.get("c.IsClientValidate"); 
        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function(data) {
            // debugger;
            var result=data.getReturnValue();
            //False means FNM Loan
            if(result.Is_Loan_Created_Manually__c==false)
            {
                var evt=$A.get("e.c:NavPillsEvent");
                evt.setParams({"IsPillsValidationRequired":true});       
                evt.fire();     
            }
        });
        $A.enqueueAction(action1);
    },
    
    ManualNext: function(component, event, helper){
        var _Loanid = component.get("v.clientLoanId");
        
        var declarationAction = component.get("c.AllClientsName");
        declarationAction.setParams({
            "loanID": _Loanid
        });
        //alert('1');
        declarationAction.setCallback(this, function(data) {
            //alert('dec '+component.get("v.manual"));
            var ReturnData = data.getReturnValue();
            if(component.get("v.manual")){ 
                component.set("v.DeclarationStatus", data.getReturnValue());
                component.set("v.wasClicked",false);
                this.Loan_Next(component,event,helper);
            }
        });
        
        $A.enqueueAction(declarationAction);
    },
    
    autoNext: function(component, event, helper){
        
        var _Loanid = component.get("v.clientLoanId");
        var declarationAction = component.get("c.AllClientsName");
        declarationAction.setParams({
            "loanID": _Loanid
        });
        declarationAction.setCallback(this, function(data) {
            var ReturnData = data.getReturnValue();
            component.set("v.DeclarationStatus", data.getReturnValue());
            helper.Loan_Next(component,event,helper);
        });
        $A.enqueueAction(declarationAction);
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
   
    ClientCountLoan: function(component, event, helper){
        
        var _Loanid = component.get("v.clientLoanId");
        var Action = component.get("c.getClientCount");
        Action.setParams({
            "LoanId": _Loanid
        });
        Action.setCallback(this, function(data) {
          
            var ReturnData = data.getReturnValue();
            if(ReturnData>0)
            {
                document.getElementById('NBSNBR').style.display = 'block';
                
            }
            else
            { 
                component.set("v.IsClientCountLoan",0);
                
                document.getElementById('NBSNBR').style.display = 'none';
            }
            component.set("v.ClientCount",ReturnData);
            
            
        });
        $A.enqueueAction(Action);
    },
     PopulateClientSpouseOnload: function(component, event, helper) {
        var _Loanid = component.get("v.clientLoanId");
        var action = component.get('c.getclientValue');
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
                /*var resultAfterClientSet= component.get("v.NBSData");
                resultAfterClientSet[0].ClientId=ClientId;
                 component.set("v.NBSData",null);
                 component.set("v.NBSData",resultAfterClientSet);*/
               
                
            }
            else
            {                 
                result.splice(0, 0, staticItem);
                   component.set("v.clientList", result); 
                              
            }
            
        });
        $A.enqueueAction(action);
    },
   
      CheckNBSYesNoOnLoad: function(component, event, helper){
         
            var _Loanid = component.get("v.clientLoanId");
        var Action = component.get("c.ShowNBS");
        Action.setParams({
            "LoanId": _Loanid
        });
           Action.setCallback(this, function(data) {
               
           debugger;
            var ReturnData = data.getReturnValue();
               component.set("v.ChkNBSYesNoFromDataBase",ReturnData);
            if(ReturnData=='Yes')
            {
                this.PopulateClientSpouseOnload(component, event, helper); 
                this.getNBSDataOnLoad(component, event, helper);
                this.addDelayNBS(component, event, helper);
                
               document.getElementById('showSpouseDetails').style.display = 'block';
                
            }
            else
            { 
                document.getElementById('showSpouseDetails').style.display = 'none';
            }
            component.set("v.NBSYesNo",ReturnData);
            
            
        });
        $A.enqueueAction(Action);
      },
       getNBSDataOnLoad: function(component, event, helper){
              var _Loanid = component.get("v.clientLoanId");
        var Action = component.get("c.ShowNBSData");
        Action.setParams({
            "LoanId": _Loanid
        });
        Action.setCallback(this, function(data) {
           debugger;
            var ReturnData = data.getReturnValue();
          
            component.set("v.NBSData",ReturnData);
                    
            this.TotalClientChecktoShowBtn(component, event, helper);
        });
        $A.enqueueAction(Action);
       },
      ValidateNBR:function(component, event, helper) {
           var finalResult=false; 
          var NBRList = ['inputNameNBR', 'inputRelationNBR','inputDOBNBR','inputMonthlyIncomeNBR'];
           var lastIndex = component.get("v.NBRData").length - 1;
           for(var i = 0; i <= lastIndex; i++){
                 NBRList.forEach(function(field) {
                      var elem = component.find(field);
                     if(field=='inputDOBNBR')
                     {
                          if (Array.isArray(elem)) {
                        elem = elem[i];
                    }
                    var value = elem.get("v.value");
                    
                    if(value=='' || value == null || value == undefined ){
                        $A.util.addClass(elem,  'error_border');
                        elem.set("v.errors", [{message:"This is required field."}]);
                        finalResult = true;
                    }
                    else{
                       
                        var chkDOBFuture=helper.FutureDOBValidationNBS(value);
                        if(chkDOBFuture==true)
                        {
                            $A.util.addClass(elem,  'error_border');
                            elem.set("v.errors", [{message:"Date of Birth cannot be a future date."}]);
                            finalResult = true;
                        }
                        else
                        {
                            elem.set("v.errors", null);
                            $A.util.removeClass(elem,  'error_border');
                        }
                        
                    }
                     }
                      else{
                            
                            
                            //var elem = component.find(field);
                            
                            console.log(field);
                            //alert(elem);
                            if (Array.isArray(elem)) {
                                elem = elem[i];
                            }
                            var value = elem.get("v.value");
                            
                            if(value=='' || value == null || value == undefined ){
                                $A.util.addClass(elem,  'error_border');
                                elem.set("v.errors", [{message:"This is required field."}]);
                                finalResult = true;
                            } else{
                                elem.set("v.errors", null);
                                $A.util.removeClass(elem,  'error_border');
                            }
                        }
                      });
           }
           return finalResult;
      },
    ValidateNBS:function(component, event, helper) {
        // debugger
        var finalResult=false; 
        var NBSUpperList = ['pickClient_Value', 'inputNBSpouseName_Value','inputNBSpousePhone_Value','inputNBSpouseDOB_Value','inputNBSpouseMaritalStatus_Value','CheckSubjectPropertyAddressNBS_Value'];
        var NBSSubjectProAddressList = ['inputNBSpouseAddress_Value', 'inputNBSpouseCity_Value','inputNBSpouseState_Value','ClientNonBorrowingSpousezipNBS_Value'];
        var lastIndex = component.get("v.NBSData").length - 1;
        //   alert(lastIndex);
        for(var i = 0; i <= lastIndex; i++){
            
            NBSUpperList.forEach(function(field) {
              
                var elem = component.find(field);
                if(field=='pickClient_Value')
                {
                    
                    if (Array.isArray(elem)) {
                        elem = elem[i];
                    }
                    var value = elem.get("v.value");        
                    if(value=='' || value == null || value == undefined ){
                        //$A.util.addClass(elem,  'error_border');
                        //elem.set("v.errors", [{message:"please enter value"}]);
                        var id='pickClient_ValueLabelNBS_'+i;
                        document.getElementById(id).innerHTML = 'This is required field.';
                        
                        finalResult = true;
                    } else{
                        var id='pickClient_ValueLabelNBS_'+i;
                        document.getElementById(id).innerHTML = '';
                        //elem.set("v.errors", null);
                        //$A.util.removeClass(elem,  'error_border');
                    }
                    
                    
                }
                else if(field=='inputNBSpouseDOB_Value')
                {
                    debugger
                    if (Array.isArray(elem)) {
                        elem = elem[i];
                    }
                    var value = elem.get("v.value");
                    
                    if(value=='' || value == null || value == undefined ){
                        $A.util.addClass(elem,  'error_border');
                        elem.set("v.errors", [{message:"This is required field."}]);
                        finalResult = true;
                    }
                    else{
                       
                        var chkDOBFuture=helper.FutureDOBValidationNBS(value);
                        if(chkDOBFuture==true)
                        {
                            $A.util.addClass(elem,  'error_border');
                            elem.set("v.errors", [{message:"Date of Birth cannot be a future date."}]);
                            finalResult = true;
                        }
                        else
                        {
                            elem.set("v.errors", null);
                            $A.util.removeClass(elem,  'error_border');
                        }
                        
                    }
                }
                    else if(field=='CheckSubjectPropertyAddressNBS_Value')
                    {
                     
                        if (Array.isArray(elem)) {
                            elem = elem[i];
                        }
                        var value = elem.get("v.value");   
                        if(value==false){
                            
                            NBSSubjectProAddressList.forEach(function(field) {
                                var elemA = component.find(field);
                                if(field =='ClientNonBorrowingSpousezipNBS_Value')
                                {
                                    
                                    if (Array.isArray(elemA)) {
                                        elemA = elemA[i];
                                    }
                                    
                                    
                                    var value = elemA.get("v.value");
                                    
                                    if(value=='' || value == null || value == undefined ){
                                        $A.util.addClass(elemA,  'error_border');
                                        elemA.set("v.errors", [{message:"This is required field."}]);
                                        finalResult = true;
                                    } 
                                    
                                    else{
                                        var chkZipFormat=helper.ValidZipNBS(value); 
                                        if(chkZipFormat==true)
                                        {
                                            elemA.set("v.errors", [{message:"Please enter a valid zip format (eg: 23454/23456-1234)"}]);
                                            finalResult = true;
                                        }
                                        else
                                        {
                                            elemA.set("v.errors", null);
                                            $A.util.removeClass(elemA,  'error_border');
                                        }
                                        
                                        
                                    }
                                    
                                }
                                else
                                {
                                    if (Array.isArray(elemA)) {
                                        elemA = elemA[i];
                                    }
                                    var value = elemA.get("v.value");
                                    
                                    if(value=='' || value == null || value == undefined ){
                                        $A.util.addClass(elemA,  'error_border');
                                        elemA.set("v.errors", [{message:"This is required field."}]);
                                        finalResult = true;
                                    } else{
                                        elemA.set("v.errors", null);
                                        $A.util.removeClass(elemA,  'error_border');
                                    }
                                    
                                }
                                
                                
                            });
                            
                        }
                        else
                        {
                            NBSSubjectProAddressList.forEach(function(field) {
                                var elemA = component.find(field);
                                if (Array.isArray(elemA)) {
                                    elemA = elemA[i];
                                }
                                
                                var value = elemA.get("v.value");
                              
                                if(value=='' || value == null || value == undefined ){
                                    elemA.set("v.errors", null);
                                    $A.util.removeClass(elemA,  'error_border');
                                } else{
                                    elemA.set("v.errors", null);
                                    $A.util.removeClass(elemA,  'error_border');
                                }
                                
                                
                                
                            })
                        }
                    }
                        else{
                            
                            
                            //var elem = component.find(field);
                            
                            console.log(field);
                            //alert(elem);
                            if (Array.isArray(elem)) {
                                elem = elem[i];
                            }
                            var value = elem.get("v.value");
                            
                            if(value=='' || value == null || value == undefined ){
                                $A.util.addClass(elem,  'error_border');
                                elem.set("v.errors", [{message:"This is required field."}]);
                                finalResult = true;
                            } else{
                                elem.set("v.errors", null);
                                $A.util.removeClass(elem,  'error_border');
                            }
                        }
                
            });
            
        }
        return finalResult;
        
    },
    TotalClientChecktoShowBtn:function(component, event, helper) {
        debugger
   var TotalCLient= component.get("v.TotalCLient");
             var TotalNBSCount=component.get("v.NBSData").length;  
       
        if(TotalCLient==TotalNBSCount)
        {
             document.getElementById('showSpouseAdd').style.display = 'none';
        }
        else if(TotalNBSCount==0){
             document.getElementById('showSpouseAdd').style.display = 'none';
            
        }
         else  {
            
            document.getElementById('showSpouseAdd').style.display = 'block';
        }
        
   
},
    DeleteExtraClientfromPanel:function(component, event, helper) {
      
   var TotalCLient= component.get("v.TotalCLient");
        
             var TotalNBSCount=component.get("v.NBSData").length;  
       var setdefault=true;
         var result=component.get("v.NBSData");
        if(TotalCLient<TotalNBSCount)
        {
         
         for (var i = 0; i <result.length; i++) {
        if(result[i]["ClientId"] == ''){
            setdefault=false;
            result.splice(i,1);
            break;
        }
}      
            if(setdefault==true){
                var length=result.length;
                length=length-1;
             result.splice(length,1);
            }
        }
         component.set("v.NBSData",result);
        
   
},
     ResetDynamicClientDropDown:function(component, event, helper) {
       var _Loanid = component.get("v.clientLoanId");
        var action = component.get('c.getclientValue');
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
                var resultAfterClientSet= component.get("v.NBSData");
                resultAfterClientSet[0].ClientId=ClientId;
                 component.set("v.NBSData",null);
                 component.set("v.NBSData",resultAfterClientSet);
                
            }
            else
            {                 
                result.splice(0, 0, staticItem);
                   component.set("v.clientList", result); 
                 
                 var resultAfterClientSet= component.get("v.NBSData");
                 component.set("v.NBSData",null);
                 component.set("v.NBSData",resultAfterClientSet);
            }
            
        });
        $A.enqueueAction(action);
         
         
         
         
     },
     DeleteClientFrom_NBS : function(component, event, helper,deleteClientId) {        
       
         var setdefault=false;
        var result=component.get("v.NBSData");
         for (var i = 0; i <result.length; i++) {
        if(result[i]["ClientId"] == deleteClientId){
            setdefault=true;
            result.splice(i,1);
            break;
        }
}         if(setdefault==true){
   
    if(result.length==0)
    {
        component.set('v.NBSYesNo','No');
            var obj=[];
             component.set("v.NBSData",obj);
    }
    else{
            for (var i = 0; i <result.length; i++) {            
        if(result[i]["ClientId"] == deleteClientId){
            result[i]["ClientId"]='';
        }
            }          }  }
          if(result.length==0)
    {
        component.set('v.NBSYesNo','No');
            var obj=[];
             component.set("v.NBSData",obj);
    }
         else
         {
         component.set("v.NBSData",result);
         }
         
           helper.DeleteExtraClientfromPanel(component, event, helper);
          helper.ResetDynamicClientDropDown(component, event, helper); 
         helper.TotalClientChecktoShowBtn(component, event, helper);
          this.addDelayNBS(component, event, helper);
     },
    
     FutureDOBValidationNBS:  function(value) {
        
        debugger
       
               
        var valuetochk  = value;
        
     
       
            var selectedDate = new Date(valuetochk),
                todayDate   = new Date(),
                diff  = new Date(selectedDate-todayDate),
                days = (diff) / (1000 * 60 * 60 * 24);
            
            if (days < -1) {  
               
                return false; 
                
            } else {
                  
                return true;
            } 
        
    },
     ValidZipNBS: function(value) {  
     debugger
                
        var valuetoChk = value; 
     var isRegZipValid=false;
    
            var regZip =/(^\d{5}$)|(^\d{5}-\d{4}$)/;        
            
            if (valuetoChk.length>0 ) { 
                var rxp = new RegExp(regZip);               
                isRegZipValid = rxp.test(value);         
                if (isRegZipValid) {
                   
                    isRegZipValid = false;
                } 
                else {                    
                    
                    isRegZipValid = true;
                } 
            }
            else{
                isRegZipValid = false;
            }            
              
        return isRegZipValid;
    },
       AddNBSOnClickhelper:function(component, event, helper) {
        component.set('v.NBSYesNo','Yes');
        //helper.PopulateClientSpouse(component, event, helper); 
        var staticItem = { 
            ClientId:'',
            NonborrowingSpouseName:'' ,
            NonborrowingSpousePhone:'',
            NonborrowingSpouseDOB:'',
            NonborrowingSpouseRelation:'---Select option---',
            NonborrowingSpouseAddressSameAs:true,
            NonborrowingSpouseAddress:'',
            NonborrowingSpouseCity:'' ,
            NonborrowingSpouseState:'---Select option---' ,
            NonborrowingSpouseZip:'' 
        };
        debugger
        var result=component.get("v.NBSData");  
        result.push(staticItem);
        component.set("v.NBSData",null);
        component.set("v.NBSData",result);
         
   		
        
        helper.TotalClientChecktoShowBtn(component, event, helper);
           this.addDelayNBS(component, event, helper);
    },
    addDelayNBS : function(component, event, helper){
        debugger;
        var delay=1000; //2 seconds                                
        setTimeout(function() {
       var Newresult=component.get("v.NBSData");  
        for (var i = 0; i <Newresult.length; i++) {
            if(Newresult[i].NonborrowingSpouseAddressSameAs==false)
            { 
                
               var divID= 'showSpouseAddressNBS_'+i;
               document.getElementById(divID).style.display = 'block'; 
              //document.getElementById('showSpouseAddressNBS_0').style.display = 'block !important'; 
            }
        }
        }, delay);
    },
     DelayPrimaryClientNBSY: function(component, event, helper){
          debugger;
        var delay=1000; //2 seconds                                
        setTimeout(function() {
        var _Loanid = component.get("v.clientLoanId");
        var Action = component.get("c.getPrimaryClientNBSYes");
        Action.setParams({
            "loanID": _Loanid
        });
         Action.setCallback(this, function(data) {
          
            var ReturnData = data.getReturnValue();
           
            component.set("v.NBSYesNo",ReturnData);
            
            
        });
        $A.enqueueAction(Action);
        }, delay);
     },
    PrimaryClientNBSY: function(component, event, helper){
         var _Loanid = component.get("v.clientLoanId");
        var Action = component.get("c.getPrimaryClientNBSYes");
        Action.setParams({
            "loanID": _Loanid
        });
         Action.setCallback(this, function(data) {
          
            var ReturnData = data.getReturnValue();
           
            component.set("v.NBSYesNo",ReturnData);
            
            
        });
        $A.enqueueAction(Action);
    },
   
    
    
})