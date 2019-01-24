({

    myAction: function (component, event, helper) {
        document.getElementById("error").innerHTML = "";
        var validDate = true;
        component.set("v.isOpen_c", false);
        component.set("v.isOpen_c1", false);
        component.set("v.fileupload", true);
        var findid = component.find("expname");
        console.log("value is: " + findid);
        var getdate = findid.get("v.value");
        console.log(getdate);
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
            }
            else {
                var currdate = new Date();
                var mydate = new Date(getdate);
                if (currdate.getTime() < mydate.getTime()) {
                    component.set("v.text", "We apologize for the inconvenience. Date cannot be in future. Please enter a valid date.");
                    component.set("v.isOpen", false);
                }
                else {
                    var timeDiff = Math.abs(currdate.getTime() - mydate.getTime());
                    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                    console.log("day difference is: " + diffDays);
                    if (diffDays > 3) {
                        component.set("v.text", "We apologize for the inconvenience. One Reverse Mortgage Services requires 1 day to send out Good Faith\nEstimate to meet regulatory requirements and the date you selected exceeds the tolerance.");
                        component.set("v.isOpen", false);
                    }
                    else {
                        component.set("v.text", "");
                        component.set("v.isOpen", true);
                    }
                }
            }
        }

    }
    ,

    openchk: function (component, event, helper) {

        var t = component.get("v.isOpen_c");

        var m = component.find("checkbox1");
        m.set("v.disabled", false);

        var a = component.find("file");
        var b = component.find("btn");
        var t = component.get("v.isOpen_c");

        var s = component.get("v.isOpen_c1");

        if (t == true && s == true) {
            a.set("v.disabled", false);
            b.set("v.disabled", false);
        }
        else {
            a.set("v.disabled", true);
            b.set("v.disabled", true);
        }


    },
    openchk1: function (component, event, helper) {

        //component.set("v.isOpen_c1",true);
        var a = component.find("file");
        var b = component.find("btn");
        var t = component.get("v.isOpen_c");

        var s = component.get("v.isOpen_c1");

        if (t == true && s == true) {
            a.set("v.disabled", false);
            b.set("v.disabled", false);
        }
        else {
            a.set("v.disabled", true);
            b.set("v.disabled", true);
        }

    },

    LoanMenu: function (component, event, helper) {

        var evt = $A.get("e.c:NavigatetoLoanMenu");
        evt.fire();
    },

    save: function (component, event, helper) {
        debugger;
        component.set("v.IsSpinner", true)
        var fileInput = document.getElementById('fileInput').value;

        var datecontrol = component.find('expname');
        var date = datecontrol.get('v.value');
        // var LoanMortgageAppliedFor = component.find("LoanMortgageAppliedFor").get("v.value");//component.get('LoanMortgageAppliedFor','v.value');
        // var RateType = component.find("RateType").get("v.value");//component.get('RateType','v.value');

        //Check whether File is selected or not
        if ($A.util.isEmpty(fileInput)) {
            var evt = $A.get("e.c:NavigatetoLoanMenu");
            evt.setParams({ ApplicationDate: date });
            // evt.setParams({ERateType:RateType})
            // evt.setParams({EMortgageAppliedFor:LoanMortgageAppliedFor})
            evt.fire();
        }
        //if file selected, then this will run
        else {
            debugger;
            //Code Modified by Dev4 for ORMSFDC-1471
            helper.Loan_Obj1(component, event, helper, date);
            //Code Ended by Dev4 for ORMSFDC-1471
        }
    },
    BindData: function (component, event, helper) {
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

    upload_attachment: function (component, event, helper) {
        console.log('>>>>> 1');
        var fileInput = component.find("myFile").getElement();
        var file = fileInput.files[0];
        console.log('file ', file);
        var _size = file.size;
        if (file.size < (3197743)) {
            var helperis = helper;
            var fileName = file.name;
            var fr = new FileReader();
            //  fr.readAsText(file);  
            fr.readAsDataURL(file);
            fr.onload = function () {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                console.log('fileContents ', fileContents);
                component.set('v.fileString', fileContents);
                component.set('v.fileName', fileName);

                component.set("v.upload_file", fileName);

            };
        } else {
            document.getElementById("upFile").value = "";
            alert('please upload a file which is less than 3 mb');
        }
    },
    upload_file: function (component, event, helper) {
        var action = component.get("c.sendEmail");
        action.setParams({
            "filename": component.get("v.fileName"),
            "fileData": component.get("v.fileString")
        });
        action.setCallback(this, function (a) {
            component.set("v.attFile", false);
            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title": "Success!",
                "message": "Thank you for submitting an application package! Your Account Executive will be in touch shortly."
            });

            toastEvent.fire();
            component.set("v.attFile", true);
            component.set('v.fileString', '');
            //component.set('v.fileName', 'notExist');
            component.set("v.upload_file", "choose file");
            
            //SFDC-370
            var action2 = component.get("c.createAETask");
            action2.setParams({
                "filename": component.get("v.fileName"),
                "fileData": component.get("v.fileString")          
            });
            action2.setCallback(this,function(){          
            });       
            $A.enqueueAction(action2);
        });
        $A.enqueueAction(action);

         
    },
})
