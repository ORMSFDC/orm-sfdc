({
    populateLoanid: function (component, event, helper) {
        debugger;
        var id = component.get("v.showLoanId");
        var senid = component.get("v.senario_id");
        //  alert(senid);
        helper.helperMethod(component, id, senid);


    },
    doinit: function (component, event, helper) {
        debugger;
        $A.createComponent(
            "c:LoanIncompleteRegistration",

            {

            },

            function (newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
    close: function (component, event, helper) {
        component.set("v.render_popup", false);
    },
        
    //SFDC-360
    start_newloan: function (component) {
        component.set('v.showSpinnerLoan',true);
        //  debugger;
        var getdate = component.get("v.ApplicationDate");

        var fileInput = document.getElementById('fileInput').value;
        var applicationDate = getdate;//component.get("v.datepick");
        //Check whether File is selected or not
        if (!$A.util.isEmpty(fileInput)){
            var fileInput = component.find("file").getElement();
            var file = fileInput.files[0];
            var data = component.get("v.filedata");
            var dd = document.getElementById('inputtxt').value;
            var action = component.get("c.getFNMData");
            action.setParams({
                "filedata": dd,
                fileName: file.name,
                base64Data: encodeURIComponent(data),
                contentType: file.type,
                applicationDate: applicationDate,
                senario_id: component.get("v.senario_id")
            });

            action.setCallback(this, function (a) {
                component.set('v.showSpinnerLoan', false);
                var errors = action.getError();
                if (errors && errors[0]) {
                    console.error("getFNMData error", errors);
                    // display error in toast
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "mode": "sticky",
                        "title": "Upload Failed!",
                        "message": errors[0].message
                    });
                    toastEvent.fire();

                    // hide loading spinner
                    var spinner = component.find("spinner");
                    $A.util.toggleClass(spinner, "slds-hide");

                } else {
                    var Id = a.getReturnValue();
                    component.set("v.myBool", true);
                    component.set("v.showLoanId", Id);
                    component.set("v.render_popup", false);
                    component.set("v.showLoan", true);
                    component.set("v.displayTab", false);
                }
            });
            $A.enqueueAction(action);
        }
        else {
            var action = component.get("c.createLoan");
            action.setParams({
                senarioid: component.get("v.senario_id")
            });
            action.setCallback(this, function (data) {
                component.set('v.showSpinnerLoan',false);
                component.set("v.showLoanId",data.getReturnValue().Id);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": data.getReturnValue().Name + " is Created."
                });
                toastEvent.fire();
                component.set("v.render_popup",false);
                component.set("v.showLoan",true);
                component.set("v.displayTab",false);  
            });
            $A.enqueueAction(action);
        }
    },
    
    openchk: function (component, event, helper) {
        debugger;
        var t = component.get("v.isOpen_c");

        var m = component.find("checkbox1");
        m.set("v.disabled", false);

        var a = component.find("file");
        var b = component.find("btn");
        var t = component.get("v.isOpen_c");

        var s = component.get("v.isOpen_c1");

        if (t == true && s == true) {
            a.set("v.disabled", false);
            component.set("v.fileupload", false);
            //  b.set("v.disabled",false);  
            component.set("v.isDisabled", false);
        }
        else {
            a.set("v.disabled", true);
            component.set("v.fileupload", true);
            //b.set("v.disabled",true); 
            component.set("v.isDisabled", true);
        }


    },
    openchk1: function (component, event, helper) {
        debugger;
        //component.set("v.isOpen_c1",true);
        var a = component.find("file");
        //var b = component.find("btn");
        var t = component.get("v.isOpen_c");

        var s = component.get("v.isOpen_c1");

        if (t == true && s == true) {
            a.set("v.disabled", false);
            component.set("v.fileupload", false);
            //  b.set("v.disabled",false);  
            component.set("v.isDisabled", false);
        }
        else {
            a.set("v.disabled", true);
            component.set("v.fileupload", true);
            //b.set("v.disabled",true); 
            component.set("v.isDisabled", true);
        }

    },
    myAction: function (component, event, helper) {
        component.set("v.isDisabled", false);
        debugger;
        document.getElementById("error").innerHTML = "";
        var validDate = true;
        component.set("v.isOpen_c", false);
        component.set("v.isOpen_c1", false);
        component.set("v.fileupload", true);
        var findid = component.find("expname");
        var getdate = findid.get("v.value");
        //      alert("value is: " + getdate);
        component.set("v.ApplicationDate", '' + getdate);
        console.log('getdate getdate ', getdate);
        if ($A.util.isEmpty(getdate)) {
            validDate = false;
            console.log("no val");
        }
        else {
            var year = getdate.substring(0, 4);
            var month = getdate.substring(5, 7);
            var day = getdate.substring(8, 10);
            getdate = month + '/' + day + '/' + year;
            var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/;
            if (!(date_regex.test(getdate))) {
                document.getElementById("error").innerHTML = "Please enter a valid date format in MM/DD/YYYY!"
                component.set("v.isOpen", false);
                component.set("v.isDisabled", true);
            }
            else {
                var currdate = new Date();
                var mydate = new Date(getdate);
                if (currdate.getTime() < mydate.getTime()) {
                    component.set("v.text", "We apologize for the inconvenience. Date cannot be in future. Please enter a valid date.");
                    component.set("v.isOpen", false);
                    component.set("v.isDisabled", true);
                    console.log("text ", component.get("v.text"));
                }
                else {
                    var timeDiff = Math.abs(currdate.getTime() - mydate.getTime());
                    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                    console.log("day difference is: " + diffDays);
                    if (diffDays > 3) {
                        component.set("v.text", "We apologize for the inconvenience. One Reverse Mortgage Services requires 1 day to send out Good Faith\nEstimate to meet regulatory requirements and the date you selected exceeds the tolerance.");
                        component.set("v.isOpen", false);
                        component.set("v.isDisabled", true);
                    }
                    else {
                        component.set("v.text", "");
                        component.set("v.isOpen", true);
                        component.set("v.isDisabled", false);
                    }
                }
            }
        }

    },

    BindData: function (component, event, helper) {
        debugger;
        var jsondata = '';
        var fileInput = document.getElementById('fileInput');
        var inputtxtid = document.getElementById('inputtxt');
        var file = fileInput.files[0];
        var reader = new FileReader();
        reader.onload = function (e) {
            jsondata = '{"IncludeFields": true,"ValidateOnly": false,"AddressValidationLevel": "None","TenOhThree": "' + reader.result + '"}';
            document.getElementById('inputtxt').value = jsondata;
        }
        reader.readAsText(file);
        var fr1 = new FileReader();
        fr1.onload = function () {
            var fileContents = fr1.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            component.set("v.filedata", fileContents);
        };
        fr1.readAsDataURL(file);
    },

})