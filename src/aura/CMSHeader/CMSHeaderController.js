({
    doInit : function(component, event, helper) {        
			  
            debugger;
        	var articleURL = window.location.pathname; 
        
            var url = articleURL.split('/');
            if(url != null)
            {
                if(url[2] == '')
                {
                   helper.GetMessagforDisplay(component, event, helper); 
                }
            }

            //get Related AE phone number onto Homepage
            var action = component.get("c.getAEInfo");		
		    action.setCallback(this,function(response){
            var state = response.getState();            
            if (state === "SUCCESS") {
                component.set("v.Phone", response.getReturnValue());
                console.log('phone: ',component.get('v.Phone'));
            }
        });
        $A.enqueueAction(action);
       
},
    doCookieSet:function(component, event, helper){
        document.cookie = "ORMSAuth=true; domain=onereversemortgageservices.com; path=/";
//window.location.href = 'http://guru.onereversemortgageservices.com';
window.open('http://guru.onereversemortgageservices.com');
        
    },
 })