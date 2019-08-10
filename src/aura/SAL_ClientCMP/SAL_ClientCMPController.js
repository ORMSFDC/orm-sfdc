({
    handleChange: function (component, event) {
        var changeValue = event.getParam("value");
        if (changeValue == 'Yes') {
            document.getElementById('Name_of_POA_Control_Div').style.display = 'block';
            if (component.get("v.MortgageAppliedForValue").includes('Purchase')) {
                component.set("v.MortgageAppliedForValueDiv", true);
            }
        }
        else {
            component.set("v.MortgageAppliedForValueDiv", false);
            document.getElementById('Name_of_POA_Control_Div').style.display = 'None';
            var POAText = component.find("POA_Name");
            POAText.set("v.errors", null);
        }
    },
    doInit: function (component, event, helper) {
        window.scrollTo(0, 0);
        component.set("v.opt2", false);

        helper.GetMortgageAppliedForValue(component, event, helper);
        helper.PopulateClients(component, event, helper);

        helper.ValidationForPills(component, event, helper);
        helper.ClientCountLoan(component, event, helper);
        helper.showSpinner(component);
        helper.CheckNBSYesNoOnLoad(component, event, helper);

        helper.CheckNBRYesNoOnLoad(component, event, helper);
        helper.hideSpinner(component);

    },
    AddNBSOnClick: function (component, event, helper) {
        helper.AddNBSOnClickhelper(component, event, helper);
    },
    DeleteNBSIteration: function (component, event, helper) {
        var listDataCount = component.get("v.NBSData").length;

        if (listDataCount <= 1) {
            // alert('You cannot delete all NBS')  ;
            document.getElementById('showSpouseDetails').style.display = 'none';
            component.set('v.NBSYesNo', 'No');
            var obj = [];
            component.set("v.NBSData", obj);
        }
        else {
            var id = event.getSource().get("v.name");
            var listData = component.get("v.NBSData");

            if (id !== -1) {
                listData.splice(id, 1);

            }
            component.set("v.NBSData", listData);
            helper.TotalClientChecktoShowBtn(component, event, helper);

            var data = component.get("v.SelectedClients");
        }
    },

    GetNBSSubjectPro_Iteration: function (component, event, helper) {

        var ID = event.getSource().getLocalId();
        var name = event.getSource().get("v.name");
        var toggleText = event.getSource().get("v.value");
        function getSecondPart(str) {
            return str.split('_')[1];
        }
        var IndexID = getSecondPart(name);
        //helper.addDelayNBS(component, event, helper);
        if (toggleText == true) {
            document.getElementById("showSpouseAddressNBS_" + IndexID).style.display = 'none';

        }
        else {

            document.getElementById("showSpouseAddressNBS_" + IndexID).style.display = 'block';

        }
    },
    GetNBSSubjectPro: function (component, event, helper) {
        debugger
        var toggleText = component.find("CheckSubjectPropertyAddressNBS").get("v.value");

        if (toggleText == true) {
            document.getElementById("showSpouseAddressNBS").style.display = 'none';
            //helper.GetSubjectPropertyDetails(component, event, helper);
        }
        else {
            document.getElementById("showSpouseAddressNBS").style.display = 'block';
            component.find("inputNBSpouseAddress").set("v.value", '');
            component.find("inputNBSpouseCity").set("v.value", '');
            component.find("inputNBSpouseState").set("v.value", '');
            component.find("ClientNonBorrowingSpousezipNBS").set("v.value", '');

        }
    },
    showSpouse: function (component, event, helper) {
        var spouseText = helper.getRadioGroupValue(component, event, helper, "inputClientSpouseFieldNBS", "v.NBSYesNo");
        if (spouseText == '' || spouseText == 'No' || typeof spouseText === 'undefined') {
            document.getElementById('showSpouseDetails').style.display = 'none';
            component.set('v.NBSYesNo', 'No');
            var obj = [];
            component.set("v.NBSData", obj);
            component.set("v.showErrorNBS", false);
            component.set("v.IsNBSPassed", true);
        } else {
            var mortgageAppliedForValue = component.get("v.MortgageAppliedForValue");
            if (-1 != ['HELO for Purchase', 'HELO Refinance'].indexOf(mortgageAppliedForValue)) {
                document.getElementById('showSpouseDetails').style.display = 'none';
                var obj = [];
                component.set("v.NBSData", obj);
                component.set("v.showErrorNBS", false);
                component.set("v.IsNBSPassed", true);
                return;
            }

            component.set('v.NBSYesNo', 'Yes');
            document.getElementById('showSpouseDetails').style.display = 'block';

            var ChkYesFromDB = component.get("v.ChkNBSYesNoFromDataBase");
            if (ChkYesFromDB == 'Yes') {
                helper.CheckNBSYesNoOnLoad(component, event, helper);
                /* helper.DelayLoadClientOnLoad(component, event, helper); 
                var result=component.get("v.NBSDataBackup"); 
                 component.set("v.NBSData",result);*/
            }
            else {
                helper.PopulateClientSpouse(component, event, helper);
                var staticItem = {
                    ClientId: '',
                    NonborrowingSpouseName: '',
                    NonborrowingSpousePhone: '',
                    NonborrowingSpouseDOB: '',
                    NonborrowingSpouseRelation: 'Married',
                    NonborrowingSpouseAddressSameAs: true,
                    NonborrowingSpouseAddress: '',
                    NonborrowingSpouseCity: '',
                    NonborrowingSpouseState: '---Select option---',
                    NonborrowingSpouseZip: '',
                    NonborrowingSpouseMonthlyIncome: '',
                    PlaceofCelebration: ''


                };

                var result = component.get("v.NBSData");

                result.push(staticItem);

                component.set("v.NBSData", result);
            }
            helper.TotalClientChecktoShowBtn(component, event, helper);

        }
    },
    showNBRDiv: function (component, event, helper) {

        var spouseText = helper.getRadioGroupValue(component, event, helper, "inputNBR", "v.NBRYesNo");
        // var spouseText = component.find("inputClientSpouseField").get("v.value");

        if (spouseText == '' || spouseText == 'No' || typeof spouseText === 'undefined') {
            document.getElementById('showNBRDetails').style.display = 'none';
            component.set('v.NBRYesNo', 'No');
            var obj = [];
            component.set("v.NBRData", obj);
            component.set("v.showErrorNBS", false);
            component.set("v.IsNBRPassed", true);
            //component.set("v.showNBR", false);

        }
        else {
            component.set('v.NBRYesNo', 'Yes');

            document.getElementById('showNBRDetails').style.display = 'block';
            var ChkYesFromDB = component.get("v.ChkNBRYesNoFromDataBase");
            if (ChkYesFromDB == 'Yes') {
                helper.CheckNBRYesNoOnLoad(component, event, helper);
                /* helper.DelayLoadClientOnLoad(component, event, helper); 
                var result=component.get("v.NBSDataBackup"); 
                 component.set("v.NBSData",result);*/
            }
            else {

                var staticItem = {
                    RecordId: '',
                    NonborrowingResidentName: '',
                    NonborrowingResidentDOB: '',
                    NonborrowingResidentRelation: '---Select option---',
                    NonborrowingResidentMonthlyIncome: ''

                };

                var result = component.get("v.NBRData");

                result.push(staticItem);

                component.set("v.NBRData", result);
            }
        }
    },

    AddNBROnClick: function (component, event, helper) {
        component.set('v.NBRYesNo', 'Yes');
        var staticItem = {
            RecordId: '',
            NonborrowingResidentName: '',
            NonborrowingResidentDOB: '',
            NonborrowingResidentRelation: '---Select option---',
            NonborrowingResidentMonthlyIncome: ''
        };
        var result = component.get("v.NBRData");
        result.push(staticItem);
        component.set("v.NBRData", null);
        component.set("v.NBRData", result);
    },
    DeleteNBRIteration: function (component, event, helper) {
        var listDataCount = component.get("v.NBRData").length;

        if (listDataCount <= 1) {
            // alert('You cannot delete all NBS')  ;
            document.getElementById('showNBRDetails').style.display = 'none';
            component.set('v.NBRYesNo', 'No');
            var obj = [];
            component.set("v.NBRData", obj);
        }
        else {
            var id = event.getSource().get("v.name");
            var listData = component.get("v.NBRData");

            if (id !== -1) {
                listData.splice(id, 1);

            }
            component.set("v.NBRData", listData);

            //var data=component.get("v.SelectedClients");
        }
    },
    //End

    showMailingAddressDetails: function (component, event, helper) {
        var toggleText = component.find("CheckMailingAddress").get("v.value");
        if (toggleText == true) {

            component.find("ClientMailingddress").set("v.disabled", true);
            component.find("ClientMailingcity").set("v.disabled", true);
            component.find("ClientMailingstate").set("v.disabled", true);
            component.find("ClientMailingzip").set("v.disabled", true);

            var ClientinputAddressValue = component.find('clientCurrentAddress').get('v.value');
            var ClientCurrentcityValue = component.find('clientCurrentcity').get('v.value');
            var ClientCurrentStateValue = component.find('clientCurrentState').get('v.value');
            var ClientCurrentZipValue = component.find('ClientCurrentZip').get('v.value');

            component.find("ClientMailingddress").set("v.value", ClientinputAddressValue);
            component.find("ClientMailingcity").set("v.value", ClientCurrentcityValue);
            component.find("ClientMailingstate").set("v.value", ClientCurrentStateValue);
            component.find("ClientMailingzip").set("v.value", ClientCurrentZipValue);
            component.find("ClientMailingddress").set("v.errors", null);
            component.find("ClientMailingcity").set("v.errors", null);
            component.find("ClientMailingstate").set("v.errors", null);
            component.find("ClientMailingzip").set("v.errors", null);
            document.getElementById("showMailingAddress").style.display = 'none';

        } else {
            document.getElementById("showMailingAddress").style.display = 'block';
            component.find("ClientMailingddress").set("v.disabled", false);
            component.find("ClientMailingcity").set("v.disabled", false);
            component.find("ClientMailingstate").set("v.disabled", false);
            component.find("ClientMailingzip").set("v.disabled", false);

            component.find("ClientMailingddress").set("v.value", "");
            component.find("ClientMailingcity").set("v.value", "");
            component.find("ClientMailingstate").set("v.value", "");
            component.find("ClientMailingzip").set("v.value", "");
        }
    },

    GetSubjectAddressDetails: function (component, event, helper) {

        var toggleText = component.find("CheckSubjectPropertyAddress").get("v.value");

        if (toggleText == true) {
            document.getElementById("showCurrentAddress").style.display = 'none';
            helper.GetSubjectPropertyDetails(component, event, helper);
        }
        else {
            document.getElementById("showCurrentAddress").style.display = 'block';
            component.find("clientCurrentAddress").set("v.value", '');
            component.find("clientCurrentcity").set("v.value", '');
            component.find("clientCurrentState").set("v.value", '');
            component.find("ClientCurrentZip").set("v.value", '');
            component.find("clientCurrentAddress").set("v.disabled", false);
            component.find("clientCurrentcity").set("v.disabled", false);
            component.find("clientCurrentState").set("v.disabled", false);
            component.find("ClientCurrentZip").set("v.disabled", false);
        }
    },

    fillPrimaryAddressDetails: function (component, event, helper) {
        // 
        var toggleText = component.find("CheckPrimaryClientMailingAddress").get("v.value");
        if (toggleText == true) {

            //component.set("v.selectedRecord.Address_Same_As_SubjectProperty__c",true);
            document.getElementById("showCurrentAddress").style.display = 'none';
            component.find("clientCurrentAddress").set("v.disabled", true);
            component.find("clientCurrentcity").set("v.disabled", true);
            component.find("clientCurrentState").set("v.disabled", true);
            component.find("ClientCurrentZip").set("v.disabled", true);

            component.find("clientCurrentAddress").set("v.value", component.get("v.primaryClientAddress"));
            component.find("clientCurrentcity").set("v.value", component.get("v.primaryClientCity"));
            component.find("clientCurrentState").set("v.value", component.get("v.primaryClientState"));
            component.find("ClientCurrentZip").set("v.value", component.get("v.primaryClientZip"));
            component.find("ClientNumberYears").set("v.value", component.get("v.clientNumberofYears"));
            component.find("clientCurrentAddress").set("v.errors", null);
            component.find("clientCurrentcity").set("v.errors", null);
            component.find("clientCurrentState").set("v.errors", null);
            component.find("ClientCurrentZip").set("v.errors", null);
            component.find("ClientNumberYears").set("v.errors", null);

            var toggleText = component.get("v.CheckifMailingAddressSameAsPresentAddress");
            if (toggleText == true) {

                component.set("v.selectedRecord.Check_if_Mailing_Address_is_similar_to_P__c", true);
                component.find("ClientMailingddress").set("v.disabled", true);
                component.find("ClientMailingcity").set("v.disabled", true);
                component.find("ClientMailingstate").set("v.disabled", true);
                component.find("ClientMailingzip").set("v.disabled", true);

                component.find("ClientMailingddress").set("v.value", component.get("v.primaryClientAddress"));
                component.find("ClientMailingcity").set("v.value", component.get("v.primaryClientCity"));
                component.find("ClientMailingstate").set("v.value", component.get("v.primaryClientState"));
                component.find("ClientMailingzip").set("v.value", component.get("v.primaryClientZip"));
                component.find("ClientMailingddress").set("v.errors", null);
                component.find("ClientMailingcity").set("v.errors", null);
                component.find("ClientMailingstate").set("v.errors", null);
                component.find("ClientMailingzip").set("v.errors", null);
                document.getElementById("showMailingAddress").style.display = 'none';
            }
            else {
                component.set("v.selectedRecord.Check_if_Mailing_Address_is_similar_to_P__c", false);
                component.find("ClientMailingddress").set("v.disabled", true);
                component.find("ClientMailingcity").set("v.disabled", true);
                component.find("ClientMailingstate").set("v.disabled", true);
                component.find("ClientMailingzip").set("v.disabled", true);
                component.find("ClientMailingddress").set("v.value", component.get("v.primaryClientMailingAddress"));
                component.find("ClientMailingcity").set("v.value", component.get("v.primaryClientMailingCity"));
                component.find("ClientMailingstate").set("v.value", component.get("v.primaryClientMailingState"));
                component.find("ClientMailingzip").set("v.value", component.get("v.primaryClientMailingZip"));
                component.find("ClientMailingddress").set("v.errors", null);
                component.find("ClientMailingcity").set("v.errors", null);
                component.find("ClientMailingstate").set("v.errors", null);
                component.find("ClientMailingzip").set("v.errors", null);
                document.getElementById("showMailingAddress").style.display = 'block';
            }
        }
        else {
            //current address fields
            document.getElementById("showCurrentAddress").style.display = 'block';
            component.find("clientCurrentAddress").set("v.disabled", false);
            component.find("clientCurrentcity").set("v.disabled", false);
            component.find("clientCurrentState").set("v.disabled", false);
            component.find("ClientCurrentZip").set("v.disabled", false);
            //Added by Nausad
            component.find("clientCurrentAddress").set("v.value", '');
            component.find("clientCurrentcity").set("v.value", '');
            component.find("clientCurrentState").set("v.value", '');
            component.find("ClientCurrentZip").set("v.value", '');
            component.find("ClientNumberYears").set("v.value", ''); //ends 
            component.find("clientCurrentAddress").set("v.errors", null);
            component.find("clientCurrentcity").set("v.errors", null);
            component.find("clientCurrentState").set("v.errors", null);
            component.find("ClientCurrentZip").set("v.errors", null);
            component.find("ClientNumberYears").set("v.errors", null);

            //mailing address fields
            //Resolved issue - mailing address was also getting unchecked when we unchecked primary client name checkbox
            /*component.set("v.selectedRecord.Check_if_Mailing_Address_is_similar_to_P__c",false);
            component.find("ClientMailingddress").set("v.disabled", false);
            component.find("ClientMailingcity").set("v.disabled", false);
            component.find("ClientMailingstate").set("v.disabled", false);
            component.find("ClientMailingzip").set("v.disabled", false);
            component.find("ClientMailingddress").set("v.value", '');
            component.find("ClientMailingcity").set("v.value", '');
            component.find("ClientMailingstate").set("v.value", '');
            component.find("ClientMailingzip").set("v.value", '');
            component.find("ClientMailingddress").set("v.errors", null); 
            component.find("ClientMailingcity").set("v.errors", null); 
            component.find("ClientMailingstate").set("v.errors", null); 
            component.find("ClientMailingzip").set("v.errors", null);
            document.getElementById("showMailingAddress").style.display = 'block'; */
        }
    },

    showSpouseMailingAddressDetails: function (component, event, helper) {
        var toggleText = component.find("CheckSpouseMailingAddress").get("v.value");
        if (toggleText == true) {

            component.find("inputNBSpouseAddress").set("v.disabled", true);
            component.find("inputNBSpouseCity").set("v.disabled", true);
            component.find("inputNBSpouseState").set("v.disabled", true);
            component.find("ClientNonBorrowingSpousezip").set("v.disabled", true);

            var ClientinputAddressValue = component.find('clientCurrentAddress').get('v.value');
            var ClientCurrentcityValue = component.find('clientCurrentcity').get('v.value');
            var ClientCurrentStateValue = component.find('clientCurrentState').get('v.value');
            var ClientCurrentZipValue = component.find('ClientCurrentZip').get('v.value');

            component.find("inputNBSpouseAddress").set("v.value", ClientinputAddressValue);
            component.find("inputNBSpouseCity").set("v.value", ClientCurrentcityValue);
            component.find("inputNBSpouseState").set("v.value", ClientCurrentStateValue);
            component.find("ClientNonBorrowingSpousezip").set("v.value", ClientCurrentZipValue);
            component.find("inputNBSpouseAddress").set("v.errors", null);
            component.find("inputNBSpouseCity").set("v.errors", null);
            component.find("inputNBSpouseState").set("v.errors", null);
            component.find("ClientNonBorrowingSpousezip").set("v.errors", null);
            document.getElementById("showSpouseAddress").style.display = 'none';

        } else {
            document.getElementById("showSpouseAddress").style.display = 'block';
            component.find("inputNBSpouseAddress").set("v.disabled", false);
            component.find("inputNBSpouseCity").set("v.disabled", false);
            component.find("inputNBSpouseState").set("v.disabled", false);
            component.find("ClientNonBorrowingSpousezip").set("v.disabled", false);

            component.find("inputNBSpouseAddress").set("v.value", "");
            component.find("inputNBSpouseCity").set("v.value", "");
            component.find("inputNBSpouseState").set("v.value", "");
            component.find("ClientNonBorrowingSpousezip").set("v.value", "");
        }
    },

    showSpouseDetailsFields: function (component, event, helper) {
        // 
        var spouseText = helper.getRadioGroupValue(component, event, helper, "inputClientSpouseField", "v.selectedRecord.Non_Borrowing_Spouse__c");
        // var spouseText = component.find("inputClientSpouseField").get("v.value");

        if (spouseText == '' || spouseText == 'No' || typeof spouseText === 'undefined') {
            component.set("v.showSpouseDetails", false);

        } else {
            component.set("v.showSpouseDetails", true);
        }
    },

    closeClientModel: function (component, event, helper) {
        component.set("v.showError", false);
        component.set("v.newclient", false);
        document.getElementById("ClientSpouse").innerText = '';
        helper.clearClientData(component, event, helper);
    },

    addClient: function (component, event, helper) {

        helper.clearClientData(component, event, helper);
        component.set("v.Heading", 'Add Client');
        component.set("v.showError", false);
        // component.set("v.showEmail", false);
        component.set("v.showSpouseDetails", false);
        component.set("v.newclient", true);
        component.set("v.socialnumber", '');
        helper.PrimaryClientAddressCheck(component, event, helper);
        document.getElementById("showMailingAddress").style.display = 'block';
    },

    EditClient: function (component, event, helper) {
        component.set("v.showSpouseDetails", true);
        helper.clearClientData(component, event, helper);
        helper.GetClientforEdit(component, event, helper);

        var onclick = component.get("v.newclient");

        if (onclick == false) {
            component.set("v.newclient", true);
        } else {
            component.set("v.newclient", false);
        }
        component.set("v.Heading", 'Edit Client');
        component.set("v.showError", false);
        helper.PopulateClients(component, event, helper);
    },

    DeleteClientbyId: function (component, event, helper) {
        var id = event.target.id;
        var action = component.get("c.getClientDetailsbyId");

        action.setParams({
            RecordId: id
        });
        action.setCallback(this, function (data) {
            var result = data.getReturnValue();

            if (result.Primary_Client_for_the_Loan__c == true) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Information!",
                    "message": "You cannot delete the primary client."
                });
                toastEvent.fire();
                return false;
            } else {
                component.set("v.deleteitemId", id);
                component.set("v.showDeletePopup", true);
            }
        });
        $A.enqueueAction(action);
    },

    do_deleteitem: function (component, event, helper) {
        var id = component.get("v.deleteitemId");
        var action2 = component.get("c.DeleteClient");
        action2.setParams({
            RecordId: id
        });

        action2.setCallback(this, function (data) {
            component.set("v.showDeletePopup", false);
            helper.PopulateClients(component, event, helper);

            helper.PopulateClientsAfterDelete(component, event, helper);
            helper.CheckNBSYesNoOnLoad(component, event, helper);
            //helper.PopulateClientSpouse(component, event, helper); 
        });
        $A.enqueueAction(action2);
    },
    close_modelPopup: function (component, event, helper) {

        component.set("v.showDeletePopup", false);
        var data = component.get('v.NBSYesNo');
        //	component.set("v.selectedRecordNBS.Non_Borrowing_Spouse__c",data);  //Ravi
        component.set("v.selectedRecord.Non_Borrowing_Spouse__c", data);  //Ravi

    },
    // To setup the following framework for validations please replicate FormatValidations and 
    // formatErrorMethod to your component's Controller and Helper respectively.
    FormatValidations: function (component, event, helper) {
        debugger;
        
        var a_id = event.getSource().getLocalId();
        var msg = "";
        var reg = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_id = new Array();
        var array_mes = new Array();
        var array_reg = new Array();
        var arr_reg = new Array();
        var arr_func = new Array();

        var regr = /^(?=[\S\s]{10,8000})[\S\s]*$/;
        var array_idr = new Array();
        var array_mesr = new Array();
        var array_regr = new Array();
        var arr_regr = new Array();
        var arr_funcr = new Array();
        function FutureDate(value) {

            var myDate = new Date(value);
            var today = new Date();

            if (myDate > today) {

                return false;

            } else {
                return true;
            }
        }

        function validateRequiredField(value) {

            if ($A.util.isEmpty(value)) {
                return false;
            }
            else {
                return true;
            }
        }

        var valArray = [
            { ar_id: "inputFName", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "inputLName", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "clientCurrentAddress", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "clientCurrentcity", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "clientCurrentState", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "ClientCurrentZip", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "ClientInputDOB", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "ClientNumberYears", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "inputHomePhone", mes: "This is a required field", reg: validateRequiredField },
            { ar_id: "ssn", mes: "This is a required field", reg: validateRequiredField },
            // { ar_id: "inputClientSpouseField", mes: "Please select a value for this field", reg: validateRequiredField } 
        ];

        array_id = valArray.map(item => item.ar_id);
        array_mes = valArray.map(item => item.mes);
        array_reg = valArray.map(item => item.reg);
        var IsAgeValidate = false;
        var Isrequired = helper.formatErrorMethod(component, array_reg, array_mes, array_id);
        var chkClientCurrentZip = helper.ValidZip(component, event, helper, 'ClientCurrentZip');
        var DOBValidation = helper.FutureDOBValidation(component, 'ClientInputDOB');
        if (DOBValidation == false) {
            IsAgeValidate = helper.checkFor62(component, event, helper);

        }
        var ssnValidation = helper.validateSSN(component, 'ssn');

        var ValidateinputClientEmail = helper.ValidateEmailRequired(component, event, helper);
        var ValidateinputMailingFields = helper.ValidateMailingAddressRequiredFields(component, event, helper);
        var CheckMailingAddress = component.find("CheckMailingAddress").get("v.value");

        var chkClientMailingzip = false;
        if (CheckMailingAddress == false || CheckMailingAddress == null || typeof CheckMailingAddress === 'undefined') {
            chkClientMailingzip = helper.ValidZip(component, event, helper, 'ClientMailingzip');
        }

        var ValidatePOA = false;
        ValidatePOA = helper.POAValidation(component, event, helper);
        
        if (Isrequired || chkClientCurrentZip || IsAgeValidate || chkClientMailingzip || DOBValidation
            || ssnValidation || ValidateinputClientEmail || ValidateinputMailingFields || ValidatePOA
        ) {
            
            component.set("v.showError", true);
        }
        else {

            component.set("v.showError", false);
            // 

            
            helper.CreateClient(component, event, helper);
            
        }
    },

    next: function (component, event, helper) {
        var mortgageAppliedForValue = component.get('v.MortgageAppliedForValue');
        //If ele vis, HELO and NBS (not valid for HELO product)
        if (mortgageAppliedForValue.includes('HELO') && $A.util.hasClass(component.find("invalidHeloNBS"), "slds-show")) {
            return;
        }

        //Code by developer2 for story-SFDC-1274

        if (event.getSource().getLocalId() == "addEmployment")//Goes to the next step if it is an actual click
        {
            helper.SAVENBS(component, event, helper);
            helper.SAVENBR(component, event, helper);

        }
        var chkNBRispass = component.get("v.IsNBRPassed");
        var chkNBSispass = component.get("v.IsNBSPassed");
        var LoanId = component.get('v.clientLoanId');
        var action1 = component.get("c.IsClientValidate");

        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function (Clientdata) {

            var result = Clientdata.getReturnValue();
            if (result.Is_Loan_Created_Manually__c == false) {
                if (result.IsClientFilled_Flag__c == false) {
                    component.set("v.IsClientValidatedPopup", true);

                }

                else {
                    if (chkNBRispass == false || chkNBSispass == false) {
                    }
                    else {
                        $A.getCallback(function (result) {
                            $('li#l5 a').click();
                        });
                        $('li#l5').addClass('active');
                        $('li#l6').removeClass('active');
                        component.set('v.itemsClicked', 'opt5');
                        component.set("v.nextOpt", "true");
                        component.set("v.currentOpt", "false");
                        // $A.getCallback(function (result) {
                        //     $('li#l5 a').click();
                        // });
                    }
                }
            }


            else {

                if (chkNBRispass == false || chkNBSispass == false) {
                }
                else {
                    helper.autoNext(component, event, helper);
                }
            }

        });
        $A.enqueueAction(action1);
    },

    previous: function (cmp, event, helper) {
        // alert();
        helper.prev(cmp);
    },

    /*validateWhitespaceFirstName:function(component, event, helper) {
     
    var inz = 'v.selectedRecord.First_Name__c';        
    helper.validateEnteredWhitespace(component, event, helper,inz);     
    },*/
    validateWhitespaceMiddleName: function (component, event, helper) {
        var inz = 'v.selectedRecord.Middle_Name__c';
        helper.validateEnteredWhitespace(component, event, helper, inz);
    },
    /*validateWhitespaceLastName:function(component, event, helper) {
    var inz = 'v.selectedRecord.Last_Name__c';        
    helper.validateEnteredWhitespace(component, event, helper,inz);     
    },*/

    validateDOB: function (component, event, helper) {
        var inz = 'v.selectedRecord.DOB__c';
        helper.validateDOB(component, event, helper, inz);
    },

    EraseTypeCharactersinDateControl: function (component, event, helper) {
        helper.EraseTypeCharactersinDate(component, event, helper, "ClientInputDOB", "v.selectedRecord.DOB__c");
    },

    RestrictZeroInHomePhoneFirstTime: function (component, event, helper) {
        var inz = 'v.selectedRecord.Home_Phone__c';
        helper.RestrictZeroInPhoneFirstTime(component, event, helper, inz);
    },

    RestrictZeroInMobilePhoneFirstTime: function (component, event, helper) {
        var inz = 'v.selectedRecord.Phone_Number__c';
        helper.RestrictZeroInPhoneFirstTime(component, event, helper, inz);
    },

    RestrictZeroInSpousePhoneFirstTime: function (component, event, helper) {
        var inz = 'v.selectedRecord.Non_Borrowing_Spouse_Phone_Number__c';
        helper.RestrictZeroInPhoneFirstTime(component, event, helper, inz);
    },

    validateWhitespaceFirstName: function (component, event, helper) {
        var inz = 'v.selectedRecord.First_Name__c';
        helper.validateEnteredWhitespace(component, event, helper, inz);
    },

    validateWhitespaceLastName: function (component, event, helper) {
        var inz = 'v.selectedRecord.Last_Name__c';
        helper.validateEnteredWhitespace(component, event, helper, inz);
    },

    validateSSNNumber: function (component, event, helper) {
        var inz = 'v.selectedRecord.Social_Security_Number__c';
        helper.validateSSNNumbersOnly(component, event, helper, inz);
    },

    hideSSNNumbers: function (component, event, helper) {
        var inz = 'v.selectedRecord.Social_Security_Number__c';
        helper.hideSSNNumbers(component, event, helper, inz);
    },

    showSSNNumbers: function (component, event, helper) {
        var inz = 'v.selectedRecord.Social_Security_Number__c';
        helper.showSSNNumbers(component, event, helper, inz);
    },

    NumberOnly: function (component, event, helper) {
        var inz = 'v.selectedRecord.Number_of_years__c';
        helper.validateNumbersOnly(component, event, helper, inz);
    },

    FormatHomePhone: function (component, event, helper) {
        helper.FormatPhonehelper(component, event, helper, "inputHomePhone", "v.selectedRecord.Home_Phone__c");
    },

    FormatMobilePhone: function (component, event, helper) {
        helper.FormatPhonehelper(component, event, helper, "inputMPhone", "v.selectedRecord.Phone_Number__c");
    },

    FormatBorrowPhone: function (component, event, helper) {
        helper.FormatPhonehelper(component, event, helper, "inputNBSpousePhone", "v.selectedRecord.Non_Borrowing_Spouse_Phone_Number__c");
    },

    FormatClientSSNNumber: function (component, event, helper) {
        helper.FormatSSNhelper(component, event, helper, "ssn", "v.selectedRecord.Social_Security_Number__c");
    },
    FormatDynamicBorrowPhoneStartwithzero: function (component, event, helper) {
        debugger
        var id = event.getSource().get("v.requiredIndicatorClass");

        var NBSUpperList = ['inputNBSpousePhone_Value'];
        for (var i = 0; i <= id; i++) {
            NBSUpperList.forEach(function (field) {
                debugger

                var elem = component.find(field);
                if (Array.isArray(elem)) {
                    elem = elem[i];
                }
                var value = elem.get("v.value");
                var digit = parseInt(value[0]);

                if (digit == 0) {
                    // $A.util.addClass(elem,  'error_border');
                    elem.set("v.value", '');
                }
                else {

                }
            })
        }

        //helper.FormatPhonehelper(component, event, helper, "inputNBSpousePhone", "v.selectedRecord.Non_Borrowing_Spouse_Phone_Number__c");
    },
    FormatDynamicBorrowPhone: function (component, event, helper) {
        debugger
        var id = event.getSource().get("v.requiredIndicatorClass");

        var NBSUpperList = ['inputNBSpousePhone_Value'];
        for (var i = 0; i <= id; i++) {
            NBSUpperList.forEach(function (field) {
                debugger

                var elem = component.find(field);
                if (Array.isArray(elem)) {
                    elem = elem[i];
                }
                var value = elem.get("v.value");
                var rxp = new RegExp("^(\\d)\\1{9}$");
                var isRegValid = rxp.test(value);
                if (isRegValid) {
                    elem.set("v.value", '');

                }
                else {
                    var s2 = ("" + value).replace(/\D/g, '');
                    var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);
                    var result = (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
                    elem.set("v.value", result);

                }
            })
        }

        //helper.FormatPhonehelper(component, event, helper, "inputNBSpousePhone", "v.selectedRecord.Non_Borrowing_Spouse_Phone_Number__c");
    },

})