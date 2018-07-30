({
    myAction: function (component, event, helper) {
        document.getElementById('spinner').style.display = 'block';
        var onclick = component.get("v.onclick");

        if (onclick == false) {
            component.set("v.onclick", true);
        } else {
            component.set("v.onclick", false);
        }
        helper.LoanLoad(component);
    },

    doIn: function (component, event, helper) {
        var action = component.get("c.getCount");

        action.setCallback(this, function (data) {
            var state_count = data.getState();
            if (component.isValid() && state_count === "SUCCESS") {
                var val = data.getReturnValue();
                if (val == 0) {
                    component.set("v.count", false);
                } else {
                    component.set("v.count", true);
                }
            } else {
                console.log("Failed with state: " + state_count);

            }

        });
        $A.enqueueAction(action);

    },

    onclick: function (component, event, helper) {
        var onclick = component.get("v.onclick");
        console.log("value is" + onclick);

        if (onclick == false) {
            component.set("v.onclick", true);
        } else {
            component.set("v.onclick", false);
        }

    },

    LoanMenu: function (component, event, helper) {
        debugger
        var x = event.target.id;
        var RType = event.target.name;

        var evt = $A.get("e.c:NavigatetoLoanMenu");
        evt.setParams({ LoanId: x })
        evt.setParams({ ERateType: RType })
        evt.fire();
    },

    LoanDel: function (component, event, helper) {
        debugger;
        var id = event.target.id;
        component.set("v.idIs", id);
        component.set("v.showPopup", true);
    },

    closeModel: function (component, event, helper) {

        component.set("v.showPopup", false);

    },
    doDelete: function (component, event, helper) {
        var id = component.get("v.idIs");
        var action = component.get("c.deleteData");
        action.setParams({

            "id": id
        });
        action.setCallback(this, function (data) {
            var state_count = data.getState();
            if (component.isValid() && state_count === "SUCCESS") {
                helper.LoanLoad(component);
                component.set("v.showPopup", false);

            } else {
                console.log("Failed with state: " + state_count);
            }

        });
        $A.enqueueAction(action);
    }
})