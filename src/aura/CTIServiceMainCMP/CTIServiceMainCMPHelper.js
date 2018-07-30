({
    // show spinner until the panel is fully rendered
    // render panel of a certain type (i.e. c:phonePanel)
    // optionally, show a toast on top of the new component
    renderPanel : function(cmp, params) {
        debugger;
        cmp.set('v.showSpinner', true);
        if (params.toast) {
            cmp.find('toast-message').set('v.content', params.toast);
        }
        if (params.type) {
            $A.createComponent(params.type, params.attributes, function(newPanel) {
                if (cmp.isValid() || !cmp.isValid()) {
                    cmp.set('v.body', [ newPanel ]);
                    cmp.set('v.showSpinner', false);
                }
            });
        } else {
            cmp.set('v.showSpinner', false);
        }
    },

    // use open CTI to update the panel label
    setPanelLabel : function(cmp, panelLabel) {
        if (panelLabel) {
            sforce.opencti.setSoftphonePanelLabel({
                label : panelLabel
            });
        }
    },
    
    // first time this method is called, it will fetch the settings using opencti.getCallCenterSettings 
    getCallCenterSettings: function(cmp, callbackFunc) {
        if (callbackFunc && cmp.get('v.settings')) {
            callbackFunc(cmp.get('v.settings'));
        } else {   //first time call
            sforce.opencti.getCallCenterSettings({
                callback : function(response) {
                    if (response.success) {
                        cmp.set('v.settings', response.returnValue);
                        callbackFunc(cmp.get('v.settings'));
                    } else {
                        throw new Error(
                            'Unable to load call center settings. Contact your admin.')
                    }
                }
            })
        }
   }

})