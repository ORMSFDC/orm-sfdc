({
    helperMethod: function () {

    },

    closeAllSteps: function (component, event) {
        //  alert();
        document.getElementById("l1").classList.remove("active");
        document.getElementById("l2").classList.remove("active");
        document.getElementById("l3").classList.remove("active");
        //document.getElementById("l4").classList.remove("active");
        document.getElementById("l5").classList.remove("active");
        document.getElementById("l6").classList.remove("active");
        document.getElementById("l7").classList.remove("active");
        document.getElementById("l8").classList.remove("active");
        document.getElementById("l9").classList.remove("active");
        document.getElementById("l10").classList.remove("active");
        document.getElementById("l11").classList.remove("active");
        // <!--Code Started for Story No:- ORMSFDC-1275 by Dev4-->
        // document.getElementById("l12").classList.remove("active");
        // <!--Code Ended for Story No:- ORMSFDC-1275 by Dev4-->

        /*   document.getElementById("Loan").classList.remove("active");
        document.getElementById("subject").classList.remove("active");
        document.getElementById("client").classList.remove("active");
        document.getElementById("income").classList.remove("active");
        document.getElementById("assets").classList.remove("active");
        document.getElementById("liabilities").classList.remove("active");
        document.getElementById("declarations").classList.remove("active");
        document.getElementById("LoanDetails").classList.remove("active");
        document.getElementById("Capacity").classList.remove("active");
        document.getElementById("LoanContact").classList.remove("active");
        document.getElementById("CreditInfo").classList.remove("active");
        document.getElementById("LoanDetails").classList.remove("active");
        
        
        document.getElementById("Loan").classList.remove("in");
        document.getElementById("subject").classList.remove("in");
        document.getElementById("client").classList.remove("in");
        document.getElementById("income").classList.remove("in");
        document.getElementById("assets").classList.remove("in");
        document.getElementById("liabilities").classList.remove("in");
        document.getElementById("declarations").classList.remove("in");
        document.getElementById("LoanDetails").classList.remove("in");
        document.getElementById("Capacity").classList.remove("in");
        document.getElementById("LoanContact").classList.remove("in");
        document.getElementById("CreditInfo").classList.remove("in");
        document.getElementById("LoanDetails").classList.remove("in");
       */
        component.set("v.opt1", "false");
        component.set("v.opt2", "false");
        component.set("v.opt3", "false");
        //component.set("v.opt4","false");
        component.set("v.opt5", "false");
        component.set("v.opt6", "false");
        component.set("v.opt7", "false");
        component.set("v.opt8", "false");
        component.set("v.opt9", "false");
        component.set("v.opt10", "false");
        component.set("v.opt11", "false");
        // <!--Code Started for Story No:- ORMSFDC-1275 by Dev4-->
        //  component.set("v.opt12","false");
        // <!--Code Ended for Story No:- ORMSFDC-1275 by Dev4-->
        //  alert('closing');   
    },

    changeValue: function (component, event, id) {
        // handle value change
        var lid = component.get("v.LoanId");
        // alert('Loan Menu call'+lid);
        component.set("v.LoanId", id);
        component.set("v.opt1", "false");

        console.log("old value: " + event.getParam("oldValue"));
        console.log("current value: " + event.getParam("value"));
    },
    testDecimals: function (currentVal) {
        var count;
        currentVal.match(/\./g) === null ? count = 0 : count = currentVal.match(/\./g);
        return count;
    }

    ,

    replaceCommas: function (yourNumber) {
        var components = yourNumber.toString().split(".");
        if (components.length === 1)
            components[0] = yourNumber;
        components[0] = components[0].replace(/\D/g, "").replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        if (components.length === 2)
            components[1] = components[1].replace(/\D/g, "");
        return components.join(".");
    }
    ,

    checkDisabled: function (cmp, evt) {
        var cid = evt.target.id;
        var cls = document.getElementById(cid).getAttribute("class");
        if (cls.includes("disabled")) {

            return true;
        }
        return false;
    },

    disableSteps: function (component) {

    },

    openOpt1: function (component, event, helper) {
        //  helper.closeAllSteps(component,event);
        $('li').not('.active').find('a')[0].setAttribute("data-toggle", "tab");
        $A.getCallback(function (result) {
            $('li#l1 a').click();
        });
        $('li#l1').addClass('active');
        // this.closeAllSteps(component,event);
        component.set("v.opt1", "true");
    }
    ,
    openOpt2: function (component, event, helper) {
        // helper.closeAllSteps(component,event);
        // alert('in opt2');
        var id = component.get("v.LoanId");
        // if($('li#l2 a').attr("data-toggle")=="cat")
        //     return  ;

        //this.closeAllSteps(component,event);
        $('li#l2').addClass('active');
        component.set("v.opt2", "true");

    }
    ,
    openOpt3: function (component, event, helper) {

        $('li#l3').addClass('active');
        component.set("v.opt3", "true");
        debugger;
        if (event.getSource().getLocalId() != "clientOption") {
            component.set("v.clientClicked", true);

        }


    }
    /* ,
    openOpt4: function(component, event, helper)
    {
        if($('li#l4 a').attr("data-toggle")=="cat")
            return  ;
        
        helper.closeAllSteps(component,event);
        component.set("v.opt4","true");    
    }*/
    ,
    openOpt5: function (component, event, helper) {

        $('li#l5').addClass('active');
        component.set("v.opt5", "true");
    }
    ,
    openOpt6: function (component, event, helper) {

        $('li#l6').addClass('active');
        component.set("v.opt6", "true");
    }
    ,
    openOpt7: function (component, event, helper) {
        helper.closeAllSteps(component, event);

        $('li#l7').addClass('active');
        component.set("v.opt7", "true");
    }
    ,
    openOpt8: function (component, event, helper) {

        $('li#l8').addClass('active');
        component.set("v.opt8", "true");
    }
    ,
    openOpt9: function (component, event, helper) {


        if ($('li#l9 a').attr("data-toggle") == "cat")
            return;

        $('li#l9').addClass('active');
        component.set("v.opt9", "true");

        if (event.target.id = "loandeatailclk") {
            document.getElementById('loanD').innerHTML = 'NoNeedToMove';
        }
    }
    ,
    openOpt10: function (component, event, helper) {

        if ($('li#l10 a').attr("data-toggle") == "cat")
            return;

        $('li#l10').addClass('active');
        component.set("v.opt10", "true");
        if (event.target.id = "CapacityTab") {
            document.getElementById('CapacityLbl').innerHTML = 'NoNeedToMove';
        }
    }
    ,
    openOpt11: function (component, event, helper) {

        if ($('li#l11 a').attr("data-toggle") == "cat")
            return;

        $('li#l11').addClass('active');
        component.set("v.opt11", "true");

        if (event.target.id = "LoanContactTab") {
            document.getElementById('LoanContactLbl').innerHTML = 'NoNeedToMove';
        }
    }
    ,
    openOpt12: function (component, event, helper) {

        if ($('li#l12 a').attr("data-toggle") == "cat")
            return;
        $('li#l2').addClass('active');
        component.set("v.opt12", "true");
    }
})