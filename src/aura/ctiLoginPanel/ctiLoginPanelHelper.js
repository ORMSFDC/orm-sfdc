({
    // enable click to dial, and bring up the phone panel.
    handleLogin : function(cmp) {
        debugger;
        sforce.opencti.enableClickToDial({callback: function() {
            cmp.getEvent('renderPanel').setParams({
                type : 'c:phonePanel',
                attributes: { presence : 'Available'}
            }).fire();
        }
      });
    }
})