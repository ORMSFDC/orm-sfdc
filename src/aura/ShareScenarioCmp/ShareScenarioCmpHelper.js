({
	    //Client Search
    searchHelper: function(component, event, getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchAccount");
        // set param to method  
        console.log('getInputkeyWord ',getInputkeyWord);
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse ',storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }            
        });
        // enqueue the Action  
        $A.enqueueAction(action);        
    },
      //Client Search
    searchContactHelper: function(component, event, getInputkeyWord,Accountid) {
        // call the apex class method 
        var action = component.get("c.fetchContact");
       
        // set param to method  
        console.log('getInputkeyWord ',getInputkeyWord);
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'AccId':Accountid
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse ',storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.MessageContact", 'No Result Found...');
                } else {
                    component.set("v.MessageContact", 'Search Result...');
                }                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchContactRecords", storeResponse);
            }            
        });
        // enqueue the Action  
        $A.enqueueAction(action);        
    },

})