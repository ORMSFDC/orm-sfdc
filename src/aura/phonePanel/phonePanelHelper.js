({
    // adds an onCLickToDial listener
    // This listener brings up the softphone every time click to dial is fired
    // and renders the callInitiatedPanel panel with the event payload
    handleOutgoingCalls : function(cmp) {
       var listener = function(payload) {
            sforce.opencti.setSoftphonePanelVisibility({
                visible : true,
                callback : function() {
                   
                    if (cmp.isValid() && cmp.get('v.presence') != 'Unavailable') {
                        cmp.getEvent('Alert').setParams({
            messagealert: '',
            showhide:false,
        }).fire();
                        debugger;
                        var attributes = {
                            'state' : 'Dialing',
                            'recordName' : payload.recordName,
                            'phone' : payload.number,
                            'title' : '',
                            'recordId': payload.recordId,
                            'account' : '',
                            'presence' : cmp.get('v.presence')
                        };
                        cmp.getEvent('renderPanel').setParams({
                             
                            type : 'c:callInitiatedPanel',
                            attributes : attributes
                        }).fire();
                    }
                   
                    
                }
            });
        };
         sforce.opencti.onClickToDial({
            listener : listener
        });
    },

    

})