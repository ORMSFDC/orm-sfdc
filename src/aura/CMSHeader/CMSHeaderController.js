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
       
},
    doCookieSet:function(component, event, helper){
        document.cookie = "ORMSAuth=true; domain=onereversemortgageservices.com; path=/";
//window.location.href = 'http://guru.onereversemortgageservices.com';
window.open('http://guru.onereversemortgageservices.com');
        
    },
 })