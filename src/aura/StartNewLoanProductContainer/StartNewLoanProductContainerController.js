({
    doint: function (component, event, helper) {
        component.get("v.nextOpt", false);
        var id = component.get("v.LoanId");
    },

    openOpt1: function (component, event, helper) {
        $('li').not('.active').find('a')[0].setAttribute("data-toggle", "tab");
//        $A.getCallback(function (result) {
//            $('li#l1 a').click();
//        });
        helper.closeAllSteps(component, event);
        component.set("v.opt1", "true");
        if (event.target.id = "loantab") {
            document.getElementById('targetID').innerHTML = 'l1';

        }
    },
    openOpt2: function (component, event, helper) {
        var id = component.get("v.LoanId");
        component.set('v.manual', false);
        if ($('li#l2 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);

        component.set("v.opt2", "true");
        debugger;
        if (event.target.id = "SPTab") {
            document.getElementById('targetID').innerHTML = 'l2';
            document.getElementById('SubjectPropertyLbl').innerHTML = 'NoNeedtomove';

        }
    }
    ,
    openOpt3: function (component, event, helper) {
        if ($('li#l3 a').attr("data-toggle") == "cat") {
            return;
        }
        component.set('v.manual', false);
        helper.closeAllSteps(component, event);
        component.set("v.opt3", "true");
        if (event.target.id != "clientOption") {
            component.set("v.clientClicked", true);

        }

        if (event.target.id = "clientOption") {

            document.getElementById('ClentLbl').innerHTML = 'NoNeedtomove';
            document.getElementById('targetID').innerHTML = 'l3';

        }


    },
    openOpt5: function (component, event, helper) {

        if ($('li#l5 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);
        component.set("v.opt5", "true");
        if (event.target.id = "IncomeTab") {
            document.getElementById('targetID').innerHTML = 'l5';

        }
    }
    ,
    openOpt6: function (component, event, helper) {

        if ($('li#l6 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);
        component.set("v.opt6", "true");
        if (event.target.id = "AssetsTab") {
            document.getElementById('targetID').innerHTML = 'l6';

        }
    }
    ,
    openOpt7: function (component, event, helper) {
        if ($('li#l7 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);
        component.set("v.opt7", "true");
        if (event.target.id = "LaibilityTab") {
            document.getElementById('targetID').innerHTML = 'l7';

        }
    }
    ,
    openOpt8: function (component, event, helper) {
        if ($('li#l8 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);
        component.set("v.opt8", "true");
        if (event.target.id = "DeclarationTab") {
            document.getElementById('targetID').innerHTML = 'l8';

        }
    }
    ,
    openOpt9: function (component, event, helper) {

        if ($('li#l9 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);
        component.set("v.opt9", "true");

        if (event.target.id = "loandeatailclk") {
            document.getElementById('loanD').innerHTML = 'NoNeedToMove';
            document.getElementById('targetID').innerHTML = 'l9';
        }
    }
    ,
    openOpt10: function (component, event, helper) {
        //component.set("v.manual","true");
        if ($('li#l10 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);
        component.set("v.opt10", "true");
        if (event.target.id = "CapacityTab") {
            document.getElementById('CapacityLbl').innerHTML = 'NoNeedToMove';
            document.getElementById('targetID').innerHTML = 'l10';
        }
    }
    ,
    openOpt11: function (component, event, helper) {

        if ($('li#l11 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);
        component.set("v.opt11", "true");

        if (event.target.id = "LoanContactTab") {
            document.getElementById('LoanContactLbl').innerHTML = 'NoNeedToMove';
            document.getElementById('targetID').innerHTML = 'l11';
        }
    }
    ,
    openOpt12: function (component, event, helper) {

        if ($('li#l12 a').attr("data-toggle") == "cat")
            return;
        helper.closeAllSteps(component, event);
        component.set("v.opt12", "true");
        if (event.target.id = "CreditInfoTab") {

            document.getElementById('targetID').innerHTML = 'l12';
        }

    }
    ,
    activatePills: function (component, event, helper) {

        $(document).ready(function () {
            /*disable non active tabs*/
            var i = 1;
            for (i = 1; component.get('v.Opt' + i) == false; i++) {
            }
            //   alert(i);      
            $('li ul li#' + 'l' + i).nextAll('li ul li').not('.active').addClass('disabled');
            $('li ul li#' + 'l' + i).nextAll('li ul li').not('.active').find('a').attr("data-toggle", "cat");
            $('ul #step2Lock').not('.active').addClass('disabled');
            $('ul #step2Lock').not('.active').find('a').attr("data-toggle", "cat");
            //   $('li#l1').attr("data-toggle","tab");
            $('.uiButton').click(function () {
                /*enable next tab*/
                //  $('li.active').find('a').attr("data-toggle","tab");
                $('li ul li.active').next('li').removeClass('disabled');
                $('li ul li.active').next('li').find('a').attr("data-toggle", "tab")
            });
        });
    },
    addCommaToNum: function (component, event, helper) {
        this.doint(component, event, helper);
        $("#comma").keyup(function (ev) {

            // skip for arrow keys
            if (ev.which >= 37 && ev.which <= 40) {
                ev.preventDefault();
            }

            var currentVal = $(this).val();
            var testDecimal = helper.testDecimals(currentVal);
            if (testDecimal.length > 1) {
                console.log("You cannot enter more than one decimal point");
                currentVal = currentVal.slice(0, -1);
            }
            $(this).val(helper.replaceCommas(currentVal));

        });


    },
    handleValueChange: function (component, event, helper) {

        var lnerror = component.get("v.LoanErr");
        //alert(lnerror);
        var id = component.get("v.LoanId");
        // alert("In Loan Menu After change:" + id);


        if (lnerror === true) {
            document.getElementById('l1').getElementsByTagName('a')[0].setAttribute("style", "background-color:red");
        }
        else {
            document.getElementById('l1').getElementsByTagName('a')[0].setAttribute("style", "background-color:#337ab7");

        }


    },
    disableSteps: function (cmp, evt, help) {


        $(document).ready(function () {

            $('.nav li').not('.active').addClass('disabled');
            $('.nav li').not('.active').find('a').removeAttr("data-toggle");


        });

    },
    itemsChange: function (component, event, helper) {
        //    alert('moving in item change');
        helper.closeAllSteps(component, event);
        //  location.href="#subject";
        //  alert('loc');
        var selopt = component.get("v.itemsClicked");
        //alert(selopt);
        if (selopt == 'opt1')
            helper.openOpt1(component, event, helper);
        else if (selopt == 'opt2')
            helper.openOpt2(component, event, helper);
        else if (selopt == 'opt3')
            helper.openOpt3(component, event, helper);
        else if (selopt == 'opt5')
            helper.openOpt5(component, event, helper);
        else if (selopt == 'opt6')
            helper.openOpt6(component, event, helper);
        else if (selopt == 'opt7')
            helper.openOpt7(component, event, helper);
        else if (selopt == 'opt8')
            helper.openOpt8(component, event, helper);
        else if (selopt == 'opt9')
            helper.openOpt9(component, event, helper);
        else if (selopt == 'opt10')
            helper.openOpt10(component, event, helper);
        else if (selopt == 'opt11')
            helper.openOpt11(component, event, helper);
        //Code Started for Story No:- ORMSFDC-1275 by Dev4-->                           
        // else  if(selopt ==  'opt12')
        // helper.openOpt12(component,event,helper);
        //Code Ended for Story No:- ORMSFDC-1275 by Dev4-->

    },
    ValidatePills: function (component, event, helper) {

        $('li#l2').removeClass('disabled');
        $('li#l2 a').attr("data-toggle", "tab");
        $('li#l3').removeClass('disabled');
        $('li#l3 a').attr("data-toggle", "tab");
        $('li#l5').removeClass('disabled');
        $('li#l5 a').attr("data-toggle", "tab");
        $('li#l6').removeClass('disabled');
        $('li#l6 a').attr("data-toggle", "tab");
        $('li#l7').removeClass('disabled');
        $('li#l7 a').attr("data-toggle", "tab");
        $('li#l8').removeClass('disabled');
        $('li#l8 a').attr("data-toggle", "tab");

        var id = component.get("v.LoanId");

        document.getElementById("l1").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        document.getElementById("l2").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        document.getElementById("l3").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        document.getElementById("l5").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        document.getElementById("l6").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        document.getElementById("l7").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        document.getElementById("l8").getElementsByTagName('a')[0].setAttribute("style", "background-color:");

        document.getElementById("l9").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        document.getElementById("l10").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        document.getElementById("l11").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        //Code Started for Story No:- ORMSFDC-1275 by Dev4-->
        //document.getElementById("l12").getElementsByTagName('a')[0].setAttribute("style", "background-color:");
        //Code Ended for Story No:- ORMSFDC-1275 by Dev4-->

        var action = component.get("c.TabsValidatedData");
        action.setParams({
            "RecordId": id
        });
        action.setCallback(this, function (data) {

            var result = data.getReturnValue();
            //Loan Tab
            if (result.IsLoanFilled_Flag__c == false) {
                document.getElementById('l1').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else { }
            //Subject Property Tab
            if (result.IsSubjectPropertyFilled_Flag__c == false) {
                document.getElementById('l2').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else {
                // document.getElementById('l2').getElementsByTagName('a')[0].setAttribute("style", "background-color:transparent");
            }
            //Client Tab
            if (result.IsClientFilled_Flag__c == false) {
                // alert('isSPfilled__c');
                document.getElementById('l3').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else {
                // document.getElementById('l3').getElementsByTagName('a')[0].setAttribute("style", "background-color:transparent");
            }
            //Income Tab
            if (result.IsEmploymentFilled_Flag__c == false || result.IsIncomeFilled_Flag__c == false) {
                document.getElementById('l5').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else { }
            //Assets Tab
            if (result.IsAssetsFilled_Flag__c == false) {
                document.getElementById('l6').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else { }
            //Laibility Tab
            if (result.IsLaibilitiesFilled_Flag__c == false) {
                document.getElementById('l7').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else { }
            //Declaration Tab
            if (result.IsDeclarationFilled_Flag__c == false) {
                document.getElementById('l8').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else {
                $('#p2').addClass('nav nav-pills nav-stacked out clc autoMoved collapse in');
                $('li#step2Lock').removeClass('disabled');
                $('li#step2Lock a').attr("data-toggle", "collapse");
                $('li#l9 a').attr("data-toggle", "tab");
                $('li#l9').removeClass('disabled');
                $('li#l10 a').attr("data-toggle", "tab");
                $('li#l10').removeClass('disabled');
                $('li#l11 a').attr("data-toggle", "tab");
                $('li#l11').removeClass('disabled');
                //Code Started for Story No:- ORMSFDC-1275 by Dev4-->
                //  $('li#l12 a').attr("data-toggle","tab");
                // $('li#l12').removeClass('disabled');
                //Code Ended for Story No:- ORMSFDC-1275 by Dev4-->
            }

            //Loan Details Tab
            if (result.IsLoanDetailsFilled_Flag__c == false) {
                document.getElementById('l9').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else { }

            //Capacity Tab
            if (result.Is_CashFlow_Viewed__c == false) {
                document.getElementById('l10').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else { }
            //Loan Contact Tab
            //Code Started for Story No:- ORMSFDC-1275 by Dev4-->
            if (result.IsLoanContactFilled_Flag__c == false || result.IsCreditInfoFilled_Flag__c == false) {
                document.getElementById('l11').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
            } else { }
            /*//Credit Info Tab
             if(  ) 
             {   
                 document.getElementById('l12').getElementsByTagName('a')[0].setAttribute("style", "color:white;background-color:rgb(194, 57, 52)");
             } else
             {  } */
            //Code Ended Started for Story No:- ORMSFDC-1275 by Dev4-->
            var el = document.getElementById('targetID');
            if (el.innerText != 'Blank') {
                document.getElementById(el.innerText).getElementsByTagName('a')[0].setAttribute("style", "background-color:#337ab7;color:white");
            }
            document.getElementById('targetID').innerHTML = 'Blank';
        });
        $A.enqueueAction(action);
    }

})