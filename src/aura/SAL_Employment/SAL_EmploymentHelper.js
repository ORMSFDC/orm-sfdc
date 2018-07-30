({
    DropdownPopulate: function(component, event, helper) {
        var IncomeTypeList = [
            {
                text: "Standard",
                label: "Standard"
            }, {
                text: "Foreign",
                label: "Foreign"
            }, {
                text: "Seasonal",
                label: "Seasonal"
            }, {
                text: "Temporary Leave",
                label: "Temporary Leave"
                
            } ];
        
        var States = [                         
            {
                text: "Alabama",
                
                label: "Alabama"
            }, {
                text: "Alaska",
                
                label: "Alaska"
            }, {
                text: "Arizona",
                
                label: "Arizona"
            }, {
                text: "Arkansas",
                
                label: "Arkansas"
            }, {
                text: "California",
                
                label: "California"
            }, {
                text: "Colorado",
                
                label: "Colorado"
            }, {
                text: "Connecticut",
                
                label: "Connecticut"
            }, {
                text: "Delaware",
                
                label: "Delaware"
            }, {
                text: "Florida",
                
                label: "Florida"
            }, {
                text: "Georgia",
                
                label: "Georgia"
            }, {
                text: "Hawaii",
                
                label: "Hawaii"
            }, {
                text: "Idaho",
                
                label: "Idaho"
            }, {
                text: "Illinois",
                
                label: "Illinois"
            }, {
                text: "Indiana",
                
                label: "Indiana"
            }, {
                text: "Iowa",
                
                label: "Iowa"
            }, {
                text: "Kansas",
                
                label: "Kansas"
            }, {
                text: "Kentucky",
                
                label: "Kentucky"
            }, {
                text: "Louisiana",
                
                label: "Louisiana"
            }, {
                text: "Maine",
                
                label: "Maine"
            }, {
                text: "Maryland",
                
                label: "Maryland"
            }, {
                text: "Massachusetts",
                
                label: "Massachusetts"
            }, {
                text: "Michigan",
                
                label: "Michigan"
            }, {
                text: "Minnesota",
                
                label: "Minnesota"
            }, {
                text: "Mississippi",
                
                label: "Mississippi"
            }, {
                text: "Missouri",
                
                label: "Missouri"
            }, {
                text: "Montana",
                label: "Montana"
            }, {
                text: "Nebraska",
                
                label: "Nebraska"
            }, {
                text: "Nevada",
                
                label: "Nevada"
            }, {
                text: "New Hampshire",
                
                label: "New Hampshire"
            }, {
                text: "New Jersey",
                
                label: "New Jersey"
            }, {
                text: "New Mexico",
                
                label: "New Mexico"
            }, {
                text: "New York",
                label: "New York"
            }, {
                text: "North Carolina",
                label: "North Carolina"
            }, {
                text: "North Dakota",
                label: "North Dakota"
            }, {
                text: "Ohio",
                label: "Ohio"
            }, {
                text: "Oklahoma",
                label: "Oklahoma"
            }, {
                text: "Oregon",
                label: "Oregon"
            }, {
                text: "Pennsylvania",
                label: "Pennsylvania"
            }, {
                text: "Rhode Island",
                label: "Rhode Island"
            }, {
                text: "South Carolina",
                label: "South Carolina"
            }, {
                text: "South Dakota",
                label: "South Dakota"
            }, {
                text: "Tennessee",
                label: "Tennessee"
            }, {
                text: "Texas",
                label: "Texas"
            }, {
                text: "Utah",
                label: "Utah"
            }, {
                text: "Vermont",
                label: "Vermont"
            }, {
                text: "Virginia",
                label: "Virginia"
            }, {
                text: "Washington",
                label: "Washington"
            }, {
                text: "West Virginia",
                label: "West Virginia"
            }, {
                text: "Wisconsin",
                label: "Wisconsin"
            }, {
                text: "Wyoming",
                label: "Wyoming"
            },
            
        ];
            var year = [{
            text: "1",
            label: "1"
            }, {
            text: "2",
            label: "2"
            }, {
            text: "3",
            label: "3"
            }, {
            text: "4",
            label: "4"
            }, {
            text: "5",
            label: "5"
            }, {
            text: "6",
            label: "6"
            }, {
            text: "7",
            label: "7"
            }, {
            text: "8",
            label: "8"
            }, {
            text: "9",
            label: "9"
            }, {
            text: "10",
            label: "10"
            }, {
            text: "11",
            label: "11"
            }, {
            text: "12",
            label: "12"
            }, {
            text: "13",
            label: "13"
            }, {
            text: "14",
            label: "14"
            }, {
            text: "15",
            label: "15"
            }, {
            text: "16",
            label: "16"
            }, {
            text: "17",
            label: "17"
            }, {
            text: "18",
            label: "18"
            }, {
            text: "19",
            label: "19"
            }, {
            text: "20",
            label: "20"
            }, {
            text: "21",
            label: "21"
            }, {
            text: "22",
            label: "22"
            }, {
            text: "23",
            label: "23"
            }, {
            text: "24",
            label: "24"
            }, {
            text: "25",
            label: "25"
            }, {
            text: "26",
            label: "26"
            }, {
            text: "27",
            label: "27"
            }, {
            text: "28",
            label: "28"
            }, {
            text: "29",
            label: "29"
            }, {
            text: "30",
            label: "30"
            }, {
            text: "31",
            label: "31"
            }, {
            text: "32",
            label: "32"
            }, {
            text: "33",
            label: "33"
            }, {
            text: "34",
            label: "34"
            }, {
            text: "35",
            label: "35"
            }, {
            text: "36",
            label: "36"
            }, {
            text: "37",
            label: "37"
            }, {
            text: "37",
            label: "37"
            }, {
            text: "38",
            label: "38"
            }, {
            text: "39",
            label: "39"
            }, {
            text: "40",
            label: "40"
            }, {
            text: "41",
            label: "41"
            }, {
            text: "42",
            label: "42"
            }, {
            text: "43",
            label: "43"
            }, {
            text: "44",
            label: "44"
            }, {
            text: "45",
            label: "45"
            }, {
            text: "46",
            label: "46"
            }, {
            text: "47",
            label: "47"
            }, {
            text: "48",
            label: "48"
            }, {
            text: "49",
            label: "49"
            }, {
            text: "50",
            label: "50"
            }, {
            text: "51",
            label: "51"
            }, {
            text: "52",
            label: "52"
            }, {
            text: "53",
            label: "53"
            }, {
            text: "54",
            label: "54"
            }, {
            text: "55",
            label: "55"
            }, {
            text: "56",
            label: "56"
            }, {
            text: "57",
            label: "57"
            }, {
            text: "58",
            label: "58"
            }, {
            text: "59",
            label: "59"
            }, {
            text: "60",
            label: "60"
            }, {
            text: "61",
            label: "61"
            }, {
            text: "62",
            label: "62"
            }, {
            text: "63",
            label: "63"
            }, {
            text: "64",
            label: "64"
            }, {
            text: "65",
            label: "65"
            }, {
            text: "66",
            label: "66"
            }, {
            text: "67",
            label: "67"
            }, {
            text: "68",
            label: "68"
            }, {
            text: "69",
            label: "69"
            }, {
            text: "70",
            label: "70"
            }, {
            text: "71",
            label: "71"
            }, {
            text: "72",
            label: "72"
            }, {
            text: "73",
            label: "73"
            }, {
            text: "74",
            label: "74"
            }, {
            text: "75",
            label: "75"
            }, {
            text: "76",
            label: "76"
            }, {
            text: "77",
            label: "77"
            }, {
            text: "78",
            label: "78"
            }, {
            text: "79",
            label: "79"
            }, {
            text: "80",
            label: "80"
            }, {
            text: "81",
            label: "81"
            }, {
            text: "82",
            label: "82"
            }, {
            text: "83",
            label: "83"
            }, {
            text: "84",
            label: "84"
            }, {
            text: "85",
            label: "85"
            }, {
            text: "86",
            label: "86"
            }, {
            text: "87",
            label: "87"
            }, {
            text: "88",
            label: "88"
            }, {
            text: "89",
            label: "89"
            }, {
            text: "90",
            label: "90"
            }, {
            text: "91",
            label: "91"
            }, {
            text: "92",
            label: "92"
            }, {
            text: "93",
            label: "93"
            }, {
            text: "94",
            label: "94"
            }, {
            text: "95",
            label: "95"
            }, {
            text: "96",
            label: "96"
            }, {
            text: "97",
            label: "97"
            }, {
            text: "98",
            label: "98"
            }, {
            text: "99",
            label: "99"
            }, {
            text: "100",
            label: "100"
            }            
        ];
        component.set('v.UsState', States);
        component.set('v.Year', year);
        component.set('v.IncomeType', IncomeTypeList);
    },
    
     PopulateClient: function(component, event, helper) {
        var _Loanid = component.get('v.EmploymentLoanId');
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
                if (ClientId == "") {
                    component.find('addEmp').set('v.disabled', true);
                    
                } else if (ClientId != "") {
                    component.find('addEmp').set('v.disabled', false);
                    
                }   
                component.set("v.ClientID",ClientId);
                component.set("v.clientList", result);
                this.PopulateEmploymentBasedonClient(component, event, helper,ClientId);               
            }
            else
            {                 
                result.splice(0, 0, staticItem);
                component.set("v.clientList", result);               
            }
            
        });
        $A.enqueueAction(action);
    },
    
    ClearData: function(component, event, helper) {
        var newselectedRecord = {
            'sobjectType': 'Employment__c',
            'EmployerName__c': '',
            'EmployerPhone__c': '',
            'Zip__c': '',
            'State__c': '',
            'City__c': '',
            'PositionTitle__c': '',
            'EmployerPhone__c': '',
            'EmployerAddress__c': '',
            'IncomeType__c': '',
            'YearEmployedinProfession__c': '',
            'EndDate__c': '',
            'StartDate__c': '',
           // 'CurrentPosition__c': '',
            'SelfEmployment__c': '',
            'Years__c': '',
            'Months__c': ''
            
        };
        // resetting the Values in the form
        component.set("v.NewEmp", newselectedRecord);
    },
    
    PopulateEmploymentBasedonClient: function(component, event, helper,ClientId) {
        var ClientId = ClientId;       
        if (ClientId != "") {
            var action1 = component.get("c.getEmployment");            
            action1.setParams({
                ClientId: ClientId
            });
            action1.setCallback(this, function(data) {                
                component.set("v.Employment", data.getReturnValue());
                var selfemp= component.find('SelfEmp').get('v.value');
                if(selfemp=='No')
                {
                    component.set("v.Isrequired",true);
                }
                else{
                    component.set("v.Isrequired",false);
                }                
            });
            $A.enqueueAction(action1);
        }
        else {
            component.set("v.Employment", null);
        }
    },
    
    SaveEmployment: function(component, event, helper) {
        // var emplid=component.get("v.EmploymentLoanId") ;
        var ClientId= component.get("v.ClientID");
        var _Loanid = component.get("v.EmploymentLoanId"); 
        var action2 = component.get("c.SaveEmployment");
        action2.setParams({
            objEmp: component.get("v.NewEmp") ,
            "ClientId": ClientId,
            "LoanId": _Loanid
        });        
        action2.setCallback(this, function(data) {
            var state = data.getState();
        });
        $A.enqueueAction(action2);
    },
    
    GetEmploymentforEdit: function(component, event, helper) {        
        var id = event.target.id;
        var action2 = component.get("c.getEmploymentById");        
        action2.setParams({
            RecordId: id         
        });
        action2.setCallback(this, function(data) {
            var state = data.getState();
            component.set("v.NewEmp", data.getReturnValue());
            var selfemp= component.find('SelfEmp').get('v.value');
            if(selfemp=='No')
            {
                component.set("v.Isrequired",true);
            }
            else{
                component.set("v.Isrequired",false);
            }
        });
        $A.enqueueAction(action2);
    },
    
    DeleteEmployment: function(component, event, helper) {        
        var id = event.target.id;
        component.set("v.idIs",id);
        component.set("v.showPopup",true);
    },
    doAction :function(component, event, helper) {
        
        var id =  component.get("v.idIs");
        var action2 = component.get("c.DeleteEmployment");
        action2.setParams({
            RecordId: id         
        });        
        action2.setCallback(this, function(data) {
            component.set("v.showPopup",false);  
               var ClientId= component.get("v.ClientID");
        helper.PopulateEmploymentBasedonClient(component, event, helper,ClientId);
        
        });
        $A.enqueueAction(action2);
    },
    
    closeModel : function(component, event, helper) {        
        component.set("v.showPopup",false);
    },
    validateEmp: function(component) {
        var validEmp = true;
        document.getElementById("assetserr").innerHTML = '';
        var msg = '';        
        var EmpName = component.find('inputFName').get('v.value');
        var EmpPosition = component.find('inputPosition').get('v.value');
        var EmpPhone = component.find('inputEmpPhone').get('v.value');
        var EmpAddress = component.find('inputEmpAddress').get('v.value');
        var EmpZip = component.find('inputZip').get('v.value');
        var EmpState = component.find('State').get('v.value');
        var EmpCity = component.find('inputCity').get('v.value');
        var EmpYear = component.find('inputYear').get('v.value');
        var EmpMonth = component.find('inputMonth').get('v.value');
        var SelfEmp = component.find('SelfEmp').get('v.value');
        var Incometype = component.find('IncomeType').get('v.value');
        if ($A.util.isEmpty(EmpName) || $A.util.isEmpty(EmpPosition) || $A.util.isEmpty(EmpPhone) || $A.util.isEmpty(EmpAddress) || $A.util.isEmpty(EmpZip) || $A.util.isEmpty(EmpState) || $A.util.isEmpty(EmpCity) || $A.util.isEmpty(EmpYear) || $A.util.isEmpty(EmpMonth) || $A.util.isEmpty(SelfEmp) || $A.util.isEmpty(Incometype)) {
            msg = ' Please fill in all mandatory fields.\n';
            document.getElementById("assetserr").innerHTML = msg;
            validEmp = false;
        }
        return (validEmp);
    },
    
    FutureDate: function(component, event, helper) {
        var flag = false;
        var isValid = false;       
        var msg = '';
        var inputCmp = component.find('Startdate');       
        var value = inputCmp.get("v.value");
        var myDate = new Date(value);
        var today = new Date();
        if (myDate > today) {           
            inputCmp.set("v.errors", "Start date cannot be future date.");
            isValid = false;            
        } else {
            inputCmp.set("v.errors", null);
            isValid=true;            
        }
        return isValid;        
    },
    
    CompareDate: function(component, event, helper) {
        var isValid = true; 
        var inputCmp = component.find('Startdate');       
        var values = inputCmp.get("v.value");
        var inputCmp1 = component.find('Enddate');       
        var valueend = inputCmp1.get("v.value");        
        if ($A.util.isEmpty(valueend)) {
            isValid = true;
        } else {
            if($A.util.isEmpty(valueend) ||$A.util.isEmpty(values))
            {
                isValid = true;
            }
            else
            {                var mySDate = new Date(values);
             var myEDate = new Date(valueend);
             if (myEDate < mySDate) {
                 isValid=false;
                 inputCmp1.set("v.errors",  [{ message: 'End Date cannot be less than Start Date.' }]);
             } else {
                 isValid=true;
                 inputCmp1.set("v.errors", null);
             }
            }
        }
        return isValid;        
    },
    EmpValidationMethods: function(component, regex, msg, aura_id) {        
        var inputCmp = component.find(aura_id);        
        var value = inputCmp.get("v.value");        
        var isValid = regex.test(value);
        if (isValid) {            
            component.set("v.LoanErr", false);
            inputCmp.set("v.errors", null);
        } else {            
            inputCmp.set("v.errors", [{ message: msg + ":" + value }]);
            component.set("v.LoanErr", true);
        }
    },
    
    formatErrorMethod: function(component, regex, msg, aura_id) {   
        debugger;
        var flag = false;
        for (var i = 0; i < aura_id.length; i++) {
            var inputCmp = component.find(aura_id[i]);
            var value = inputCmp.get("v.value");
            var isValid = true;
            if (typeof regex[i] != "string") {
                
                
                isValid = regex[i](value); // Please return true if there is an error or else false
            } 
            
            if (isValid) {
                inputCmp.set("v.errors", null);
            } else {
                inputCmp.set("v.errors", [{ message: msg[i] + ":" + value }]);
                flag = true;
            }
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
    
    //Validate required when Self employed is "yes" 
    ValidateSelfEmployed: function(component, event, helper) {        
        //true means error
        var finalResult=false;       
        var employername=component.find('inputFName');
        var positiontitle=component.find('inputPosition');
        var employerphone=component.find('inputEmpPhone');
        var employeraddress=component.find('inputEmpAddress');
        var city=component.find('inputCity');
        var state=component.find('State');
        var zip=component.find('inputZip');               
        var employernameVal=component.find('inputFName').get('v.value');
        var positiontitleVal=component.find('inputPosition').get('v.value');
        var employerphoneVal=component.find('inputEmpPhone').get('v.value');
        var employeraddressVal=component.find('inputEmpAddress').get('v.value');
        var cityVal=component.find('inputCity').get('v.value');
        var stateVal=component.find('State').get('v.value');
        var zipVal=component.find('inputZip').get('v.value');        
        if ($A.util.isEmpty(employernameVal)) {
            finalResult = true;
            employername.set("v.errors", [{ message: "Please Enter Employer Name" }]);
        } else{
            employername.set("v.errors", null);              
            
        }
        if ($A.util.isEmpty(positiontitleVal)) {
            finalResult = true;
            positiontitle.set("v.errors", [{ message: "Please Enter Position/Title" }]);
        } else{
            
            positiontitle.set("v.errors", null);
        }
        if ($A.util.isEmpty(employerphoneVal)) {
            finalResult = true;
            employerphone.set("v.errors", [{ message: "Please Enter Phone No." }]);
        } else{            
            employerphone.set("v.errors", null);
        }
        if ($A.util.isEmpty(employeraddressVal)) {
            finalResult = true;
            employeraddress.set("v.errors", [{ message: "Please Enter Address" }]);
        } else{            
            employeraddress.set("v.errors", null);
        }
        if ($A.util.isEmpty(cityVal)) {
            finalResult = true;
            city.set("v.errors", [{ message: "Please Enter City" }]);
        } else{            
            city.set("v.errors", null);
        }
        if ($A.util.isEmpty(stateVal)) {
            finalResult = true;
            state.set("v.errors", [{ message: "Please select State" }]);
        } else{            
            state.set("v.errors", null);
        }
        if ($A.util.isEmpty(zipVal)) {
            finalResult = true;
            zip.set("v.errors", [{ message: "Please Enter Zip" }]);
        } else{            
            zip.set("v.errors", null);
        }        return finalResult;
    },
    ////Validate required when Self employed is "yes"
    FormatPhonehelper: function(component, event, helper){       
        var Phone = component.find("inputEmpPhone").get("v.value"); 
        var rxp = new RegExp("^(\\d)\\1{9}$");        
        var  isRegValid = rxp.test(Phone);
        if(isRegValid)
        {
            component.set("v.NewEmp.EmployerPhone__c",'');
        }else{
            var s2 = (""+Phone).replace(/\D/g, '');
            var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
            var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
            
            component.set("v.NewEmp.EmployerPhone__c",result);
        }
    },
    
    Loan_Next: function(component, event, helper) {
        $('li#l5').removeClass('disabled');
        $('li#l5 a').attr("data-toggle","tab");
        $('li#l5 a').click();
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },
    prev: function(component) {
        $('li#l3 a').click();
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },
    CheckMonth: function(component, event, helper){
        var flagR = false;        
        var cmp = component.find("inputMonth");
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
    
    RestrictZeroInPhoneFirstTime:function(component, event, helper,compId) {
        var inz = component.get(compId);
        var digit = parseInt(inz[0]);
        if(digit == 0)
        {            
            component.set(compId, inz.substring(0, inz.length - 1));
        }              
    },
    
})