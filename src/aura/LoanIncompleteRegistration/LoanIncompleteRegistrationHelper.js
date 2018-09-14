({
    LoanLoad: function (component) {
        var action = component.get("c.getName");
        action.setCallback(this, function (data) {
            var state = data.getState();
            var result = data.getReturnValue();

            if (component.isValid() && state === "SUCCESS") {
                component.set("v.loan", result);
            }
            else {
            }
            document.getElementById('spinner').style.display = 'none';
        });
        $A.enqueueAction(action);

    },
    getUrlParameter: function (sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }

        return undefined;
    }
})