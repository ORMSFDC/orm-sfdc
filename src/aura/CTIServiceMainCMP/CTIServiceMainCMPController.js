({
    // store call center settings, so they're easily accessible ny all panels. Bring up the CTI login panel.
    init: function(cmp, event, helper) {
        debugger;
        cmp.getEvent('renderPanel').setParams({
            type: 'c:ctiLoginPanel',
        }).fire();
    },
    messaggeAlert:function(cmp, event, helper) {
       var params = event.getParams();
        cmp.set('v.showAlert', params.showhide);
        cmp.set('v.Messagealerttext', params.messagealert);
       setTimeout(function(){ 
           cmp.set('v.showAlert', false);
       }, 3000);
    },

    // renderPanel event handler. Used to replace the current view with a given panel.
    renderPanel: function(cmp, event, helper) {
        var params = event.getParams();
        helper.renderPanel(cmp, params);
    },

    // getSettings event handler. Returns the stored call center settings.
    getSettings: function(cmp, event, helper) {
       var callback = event.getParams().callback;
        helper.getCallCenterSettings(cmp, callback);
    },

    // editPanel event handler. Updates the softphone panel label.
    editPanel: function(cmp, event, helper) {
        var params = event.getParams();
        if (params.label) {
            sforce.opencti.setSoftphonePanelLabel({
                label: params.label
            });
        }
    }
})