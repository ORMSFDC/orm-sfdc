({
    doInit: function (component, event, helper) {
        $A.createComponent(
            "c:StartNewLoanPurchaseInfo", //SFDC-360
            {},
            function (newCmp) {
                if (component.isValid()) {
                    component.set("v.body", newCmp);
                }
            }
        );
    },
    NavigateComponent: function (component, event, helper) {
        var Lnumber = event.getParam("LoanNumberE");

        console.log(Lnumber);
        //var x  = JSON.stringify(id);

        // alert(id);
        component.set("v.LoanNumber", Lnumber);

        $A.createComponent(
            "c:StartNewLoanProductContainer",
            {
                "LoanId": component.get("v.LoanNumber"),
            },

            function (newCmp) {
                if (component.isValid()) {
                    // component.set("v.body", newCmp);
                }
            }
        );
    }
})