({
    // on initialization, get the Call Center Settings and enable click to dial
    init: function(cmp, event, helper) {
       
        //cmp.set('v.searchResults', []);
        helper.handleOutgoingCalls(cmp);
    },
})