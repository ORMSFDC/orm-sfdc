({
    doInit : function(component, event, helper) {         
        var action = component.get("c.getYoutubeLinks");        
        action.setCallback(this, function(a) {
             var links=a.getReturnValue();
             console.log(links);
           
 
                
                var objj=links[0];
console.log(objj.YoutubeURL__c);                
               //alert( links.count);
                component.set("v.url",objj.YoutubeURL__c); 
                   
            component.set("v.Links", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
   
    //Use for set value src of iframe
    seeVideo : function(cmp, event, helper) {          
        var VID= event.getSource().get("v.name");
        var title= event.getSource().get("v.title");
        cmp.set("v.VideoDetails",title);
        
        var action = cmp.get("c.getYoutubeLinkDetailById");     
        action.setParams({"recid":VID});        
        action.setCallback(this, function(a) {
            cmp.set("v.url", a.getReturnValue());            
        });        
        $A.enqueueAction(action);      
    }    
})