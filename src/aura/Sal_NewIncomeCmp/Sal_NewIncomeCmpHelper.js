({
    ValidationForPills: function (component, event, helper) {
        var LoanId = component.get('v.IncomeLoanId');
        var action1 = component.get("c.Income_TabsValidatedData");
        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function (data) {
            var result = data.getReturnValue();
            component.set('v.TabRecordData', result);

            if (result.Is_Loan_Created_Manually__c == false) {
                var evt = $A.get("e.c:NavPillsEvent");
                evt.setParams({ "IsPillsValidationRequired": true });
                evt.fire();
            }
        });
        $A.enqueueAction(action1);
    },
    DropdownPopulate: function (component, event, helper) {
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
            }, {
                text: "Self-Employed",
                label: "Self-Employed"

            }, {
                text: "Part-Time",
                label: "Part-Time"

            }];

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
        component.set('v.IncomeCategory', IncomeTypeList);
    },
    PopulateIncomeBasedonClient: function (component, event, helper, ClientId) {

        var ClientId = ClientId;
        var LoanId = component.get("v.IncomeLoanId");
        var action1 = component.get("c.getAllIncomeEmp");
        action1.setParams({
            "LoanID": LoanId
        });
        action1.setCallback(this, function (data) {

            var result = data.getReturnValue();
            for (var i = 0; i < result.length; i++) {
                var incomeCount = result[i].TotalIncome;
                if (incomeCount != 0) {
                    component.set("v.IncomeCount", incomeCount);
                }
            }
            //var l=result.IncomeEmpList;
            var total = 0;
            component.set("v.IncomeListNew", result);

        });
        $A.enqueueAction(action1);


    },
    VisiilityForOptionalValues: function (component, event, helper) {
        var newselectedRecord = {
            'sobjectType': 'Income_New__c',
            'Bonus_Income__c': '',
            'OverTime_Income__c': '',
            'Dividents_Interest_Income__c': '',
            'Net_Rental_Income__c': ''
        };
        component.set("v.IncomeList", newselectedRecord);
    },

    Saveincome: function (component, event, helper) {

        component.set("v.showError", false);
        var ClientId = component.find('pickClient').get('v.value');//component.get("v.ClientID");
        var incomeVal = component.get("v.IncomeList");
        var LoanId = component.get("v.IncomeLoanId");
        var action = component.get("c.incomesave");
        var nextFlag = new String();
        action.setParams({
            ObjIncome: incomeVal,
            ClientId: ClientId,
            LoanId: LoanId
        });

        action.setCallback(this, function (a) {
            var state = a.getState();
            component.set("v.recordSaved", true);
            component.set("v.showSuccess", true);
            this.PopulateIncomeBasedonClient(component, event, helper, ClientId);
        });
        $A.enqueueAction(action);
    },
    getOneIncome: function (component, event, helper) {

        var RecordId = component.get("v.RecordId");
        var action = component.get("c.getOneIncome");
        action.setParams({
            "IncomeId": RecordId
        });
        action.setCallback(this, function (data) {
            var state = data.getState();
            var result = data.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {

                var ClientId = result.RelatedClient__c;
                component.find('pickClient').set('v.value', ClientId);
                component.set("v.IncomeList", data.getReturnValue());  // open comment to edit              
            }

            var IncomeType = result.Income_Types__c;
            if (IncomeType == 'Social Security Income') {
                component.set("v.SocialSecurityIncome", false);
            }
            else {
                component.set("v.SocialSecurityIncome", true);
            }
        });
        $A.enqueueAction(action);
    },
    getAllIncome: function (component, event, helper) {

        var LoanId = component.get("v.IncomeLoanId");
        var action1 = component.get("c.getAllIncome");
        action1.setParams({
            "LoanId": LoanId
        });

        action1.setCallback(this, function (data) {

            var state = data.getState();
            var result = data.getReturnValue();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.ClientIncome", data.getReturnValue());
            }
        });
        $A.enqueueAction(action1);
    },
    CurrencyRegexCheck: function (component) {
        var flagR = false;
        var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
        var arr_regr = new Array();
        var arr_funcr = new Array();
        var valArray = [

            { ar_id: "IncomeValue", mes: "Please enter a valid number (non negative)", reg: "^[0-9]\\d*(\\.\\d+)?$" },

        ];
        array_idr = valArray.map(item => item.ar_id);
        array_mesr = valArray.map(item => item.mes);
        array_regr = valArray.map(item => item.reg);
        for (var i = 0; i < array_idr.length; i++) {

            var inputCmp = component.find(array_idr[i]);
            if (typeof inputCmp === 'undefined' || inputCmp == null || inputCmp == '') { } else {
                var value = inputCmp.get("v.value");
                var isRegValid = false;
                if (typeof value === 'undefined' || value == null || value == '') { }
                else {
                    if (value.length != 0) {

                        var rxp = new RegExp(array_regr[i]);

                        isRegValid = rxp.test(value);
                        if (isRegValid) {

                            inputCmp.set("v.errors", null);

                        }
                        else {
                            inputCmp.set("v.errors", [{ message: array_mesr[i] + "." }]);

                            flagR = true;
                        }
                    }
                }
            }
        }
        return flagR;
    },
    formatErrorMethod: function (component, regex, msg, aura_id) {

        //Code if button is clicked
        var flag = false;
        for (var i = 0; i < aura_id.length; i++) {

            var inputCmp = component.find(aura_id[i]);
            if (typeof inputCmp === 'undefined' || inputCmp == null || inputCmp == '') { } else {
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
                    //Please leave out this line while replicating. LoanErr may not exist on other compnents
                    inputCmp.set("v.errors", null);

                } else {
                    inputCmp.set("v.errors", [{ message: msg[i] + "." }]);
                    //Please leave out this line while replicating. LoanErr may not exist on other compnents
                    flag = true;
                }
            }
        }
        return flag;
    },
    formatErrorMethodr: function (component, regexr, msgr, aura_idr) {
        var flagR = false;
        for (var i = 0; i < aura_idr.length; i++) {
            var inputCmp = component.find(aura_idr[i]);
            if (typeof inputCmp === 'undefined') { } else {
                var value = inputCmp.get("v.value");
                var isRegValid = true;
                if (typeof value === 'undefined' || value == null || value == '') { } else {
                    if (value != '') {
                        var rxp = new RegExp(regexr[i]);
                        isRegValid = rxp.test(value);
                        if (isRegValid == true) {
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
    CheckMonth: function (component, event, helper) {
        var flagR = false;
        var cmp = component.find("inputMonth");
        var month = cmp.get("v.value");
        if (month == '' || month == null || typeof month === 'undefined') {
        }
        else {
            if (month < 0 || month > 11) {
                flagR = true;
                cmp.set("v.errors", [{ message: "Month should be between 0 to 11" }]);
            }
            else {
                cmp.set("v.errors", null);
            }
        }
        return flagR;
    },
    CheckZero: function (component, event, helper) {
        var flagR = false;
        var cmp = component.find("IncomeValue");
        var inc = cmp.get("v.value");
        if (inc == 0 || inc == null) {
            flagR = true;
            cmp.set("v.errors", [{ message: "Please enter a Monthly Income Value." }]);
        }
        else {
            cmp.set("v.errors", null);
        }

        return flagR;
    },
    CheckEmpZero: function (component, event, helper) {
        var flagR = false;
        var cmp = component.find("inputIncomeValue");
        var inc = cmp.get("v.value");
        if (inc == 0 || inc == null) {
            flagR = true;
            cmp.set("v.errors", [{ message: "Please enter a Monthly Income Value." }]);
        }
        else {
            cmp.set("v.errors", null);
        }

        return flagR;
    },
    Loan_Next: function (component, event, helper) {
        $('li#l6').removeClass('disabled');
        $('li#l6 a').attr("data-toggle", "tab");
        if (!component.get('v.fromPopup')) {
            $A.getCallback(function (result) {
                $('li#l6 a').click();
            });

        } else {
            $('li#l4').removeClass('active');

            $('li#l6').addClass('active');
            $('li#l7').removeClass('active');

        }
        component.set('v.itemsClicked', 'opt6');
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },

    prev: function (component) {
        //    alert('income prev');

        //   $('li#l3 a').click();
        //  $('li#l4').removeClass('active');

        if (!component.get('v.fromPopup')) {
            $A.getCallback(function (result) {
                $('li#l3 a').click();
            });
        } else {
            $('li#l2').removeClass('active');

            $('li#l3').addClass('active');
            $('li#l5').removeClass('active');

        }
        //   alert('manu al akja');
        component.set("v.manual", "false");
        //  alert('fgdfgf ');
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },

    SetId: function (component, event, helper) {
        var value = component.find('incomePicklist').get('v.value');
        component.set('v.IncomeTypeId', value);
    },
    clearIncomeData: function (component, event, helper) {
        var newselectedRecord = {
            'sobjectType': 'Income_New__c',

            'Id': null,
            'Income_Source__c': '',
            'Income_Types__c': '',
            'Income_Value__c': '',
            'IsActive__c': '',
            'RelatedClient__c': '',
            'Related_Loan__c': '',

        };
        //resetting the Values in the form
        component.set("v.IncomeList", newselectedRecord);
    },
    ValidateSelfEmployed: function (component, event, helper) {
        //true means error
        var finalResult = false;
        var employername = component.find('inputFName');
        var positiontitle = component.find('inputPosition');
        var employerphone = component.find('inputEmpPhone');
        var employeraddress = component.find('inputEmpAddress');
        var city = component.find('inputCity');
        var state = component.find('State');
        var zip = component.find('inputZip');
        var employernameVal = component.find('inputFName').get('v.value');
        var positiontitleVal = component.find('inputPosition').get('v.value');
        var employerphoneVal = component.find('inputEmpPhone').get('v.value');
        var employeraddressVal = component.find('inputEmpAddress').get('v.value');
        var cityVal = component.find('inputCity').get('v.value');
        var stateVal = component.find('State').get('v.value');
        var zipVal = component.find('inputZip').get('v.value');
        if ($A.util.isEmpty(employernameVal)) {
            finalResult = true;
            employername.set("v.errors", [{ message: "Please Enter Employer Name" }]);
        } else {
            employername.set("v.errors", null);

        }
        if ($A.util.isEmpty(positiontitleVal)) {
            finalResult = true;
            positiontitle.set("v.errors", [{ message: "Please Enter Position/Title" }]);
        } else {

            positiontitle.set("v.errors", null);
        }
        if ($A.util.isEmpty(employerphoneVal)) {
            finalResult = true;
            employerphone.set("v.errors", [{ message: "Please Enter Phone No." }]);
        } else {
            employerphone.set("v.errors", null);
        }
        if ($A.util.isEmpty(employeraddressVal)) {
            finalResult = true;
            employeraddress.set("v.errors", [{ message: "Please Enter Address" }]);
        } else {
            employeraddress.set("v.errors", null);
        }
        if ($A.util.isEmpty(cityVal)) {
            finalResult = true;
            city.set("v.errors", [{ message: "Please Enter City" }]);
        } else {
            city.set("v.errors", null);
        }
        if ($A.util.isEmpty(stateVal)) {
            finalResult = true;
            state.set("v.errors", [{ message: "Please select State" }]);
        } else {
            state.set("v.errors", null);
        }
        if ($A.util.isEmpty(zipVal)) {
            finalResult = true;
            zip.set("v.errors", [{ message: "Please Enter Zip" }]);
        } else {
            zip.set("v.errors", null);
        } return finalResult;
    },
    ClearEmpData: function (component, event, helper) {
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
            'Income_Type__c': '',
            'IncomeCategory__c': '',
            'YearEmployedinProfession__c': '',
            'EndDate__c': '',
            'StartDate__c': '',
            'IncomeValue__c': '',
            // 'SelfEmployment__c': '',
            'Years__c': '',
            'Months__c': ''

        };
        // resetting the Values in the form
        component.set("v.NewEmp", newselectedRecord);
    },
    SaveEmployment: function (component, event, helper) {

        //var ClientId= component.get("v.ClientID");
        var ClientId = component.find('pickClient').get('v.value');
        var _Loanid = component.get("v.IncomeLoanId");
        var action2 = component.get("c.SaveEmployment");
        action2.setParams({
            objEmp: component.get("v.NewEmp"),
            "ClientId": ClientId,
            "LoanId": _Loanid
        });
        action2.setCallback(this, function (data) {
            var state = data.getState();
        });
        $A.enqueueAction(action2);
    },
    GetEmploymentforEdit: function (component, event, helper) {

        var id = event.target.id;
        var action2 = component.get("c.getEmploymentById");
        action2.setParams({
            RecordId: id
        });
        action2.setCallback(this, function (data) {

            var state = data.getState();
            var result = data.getReturnValue();
            var ClientId = result.Client_id__c;
            component.find('pickClient').set('v.value', ClientId);
            component.set("v.NewEmp", data.getReturnValue());

            // To format phone number on load            
            if (!$A.util.isUndefinedOrNull(result.EmployerPhone__c)) {


                var phoneview = result.EmployerPhone__c;
                var n = phoneview.length
                if (n == 10) {
                    var finalphone = '(' + phoneview.slice(0, 3) + ') ' + phoneview.slice(3, 6) + "-" + phoneview.slice(6, 15);
                    //alert(phoneview.slice(0,3));
                    component.set("v.NewEmp.EmployerPhone__c", finalphone);
                }
                else if (n == 14) {
                    var finalphone = phoneview.slice(0, 3) + phoneview.slice(3, 6) + phoneview.slice(6, 15);

                    component.set("v.NewEmp.EmployerPhone__c", finalphone);
                }
                else {
                    component.set("v.NewEmp.EmployerPhone__c", phoneview);
                }
            }
        });
        $A.enqueueAction(action2);
    },

    FormatPhonehelper: function (component, event, helper, id, dbvalue) {
        var value = component.find(id).get("v.value");
        if (typeof value === "undefined" || value == null || value == '') {
            return false;
        }
        else {
            // Strip all characters from the input except digits
            value = value.replace(/\D/g, '');
            var digit = parseInt(value[0]);
            if (digit == 0) {
                value = value.replace(value, '');
                component.set(dbvalue, value);
                return false;
            }

            // Trim the remaining input to ten characters, to preserve phone number format
            value = value.substring(0, 16);

            // Based upon the length of the string, we add formatting as necessary
            var size = value.length;
            if (size == 0) {
                value = value;
            } else if (size < 4) {
                value = '(' + value;
            } else if (size < 7) {
                value = '(' + value.substring(0, 3) + ') ' + value.substring(3, 6);
            } else {
                value = '(' + value.substring(0, 3) + ') ' + value.substring(3, 6) + '-' + value.substring(6, 10);
            }
            //return value; 
            component.set(dbvalue, value);
        }
    },
    validatePhone: function (component, id) {

        var inputCmp = component.find(id);
        var value = inputCmp.get("v.value");
        if (value != undefined) {
            value = value.replace(/\D/g, '');
        }
        if ($A.util.isEmpty(value) || $A.util.isUndefinedOrNull(value) || value == undefined) {
            return false;
        }
        else {
            if (value.length == 10) {
                inputCmp.set("v.errors", null);
                return false;

            } else {
                inputCmp.set("v.errors", [{ message: "Please Enter 10-digit Phone Number" }]);
                return true;
            }
        }
    },
    DeleteRecord: function (component, event, helper) {

        var objType = component.get('v.DeleteObj');
        var id = component.get('v.DeleteID');
        if (objType == 'Income') {
            var action = component.get("c.DeleteIncome");
            action.setParams({
                RecordId: id
            });

            action.setCallback(this, function (data) {
                component.set("v.DeletePopup", false);
                var ClientId = component.get("v.ClientID");
                helper.PopulateIncomeBasedonClient(component, event, helper, ClientId);

            });
            $A.enqueueAction(action);
        }
        else if (objType == 'Employment') {
            var action = component.get("c.DeleteEmployment");
            action.setParams({
                RecordId: id
            });

            action.setCallback(this, function (data) {
                component.set("v.DeletePopup", false);
                var ClientId = component.get("v.ClientID");
                helper.PopulateIncomeBasedonClient(component, event, helper, ClientId);

            });
            $A.enqueueAction(action);
        }

    }

})