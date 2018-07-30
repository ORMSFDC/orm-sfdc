({
    doInit : function(component, event, helper) { 
        window.scrollTo(0, 0);    
        var action = component.get("c.getProcessVideoLinks");        
        action.setCallback(this, function(a) {
            var links=a.getReturnValue();
            console.log(links);
            if(links=='')
            {
                document.getElementById("processvideo").style.display = "none";
            }
            else{
                
                var objj=links[0];
                console.log(objj.ProcessVideoURL__c);                
                //alert( links.count);
                component.set("v.url",objj.ProcessVideoURL__c); 
                document.getElementById("processvideo").style.display = "Block";
            }
            component.set("v.Links", a.getReturnValue());
        });
        
        $A.enqueueAction(action);  
    },
    
    //Use for set value src of iframe
    seeVideo : function(cmp, event, helper) {          
        var VID= event.getSource().get("v.name");
        var title= event.getSource().get("v.title");
        cmp.set("v.VideoDetails",title);
        
        var action = cmp.get("c.getProcessVideoLinksById");     
        action.setParams({"recid":VID});        
        action.setCallback(this, function(a) {
            cmp.set("v.url", a.getReturnValue());            
        });        
        $A.enqueueAction(action);      
    }    
})