({
    Isdataavailableforpipeline : function(component, event, helper) {
        
        var action2 = component.get("c.IsDataAvailable");        
        
        action2.setCallback(this, function(data) {  
            
            var result= data.getReturnValue();          
            if(result>0)
            {
                component.set("v.IsdataAvailableInPipeLine",true);
                 component.set("v.DataMessage",''); 
                var action = component.get("c.getLoanOrigination");
                var actionP = component.get("c.getLoanProcessing");
                var actionU = component.get("c.getLoanUnderWriting");
                var actionS = component.get("c.getLoanSuspended");
                var actionCl = component.get("c.getLoanClosing");
                var actionF = component.get("c.getLoanFunded");
                var actionC = component.get("c.getLoanCancelled");
                
                action.setCallback(this, function(data) {
                    
                    var state = data.getState();
                    var result=data.getReturnValue();
                    console.log(result);
                    if(result.length==0)
                    {
                        document.getElementById("divOrigination").style.display = "None";                   
                        
                    }
                    else
                    { 
                        
                        document.getElementById("divOrigination").style.display = "Block";
                    }
                    
                    component.set("v.loan",result); 
                    
                    
                    
                }); 
                actionP.setCallback(this, function(data) {
                    
                    var state = data.getState();
                    var result=data.getReturnValue();
                    console.log(result);
                    
                    
                    if(result.length==0)
                    {
                        document.getElementById("divProcessing").style.display = "None";
                        
                        
                    }
                    else
                    {
                        
                        document.getElementById("divProcessing").style.display = "Block";
                    }
                    
                    component.set("v.loanP",result);
                    //alert("data present");
                    
                    
                    
                }); 
                actionU.setCallback(this, function(data) {
                    
                    var state = data.getState();
                    var result=data.getReturnValue();
                    console.log(result);
                    
                    
                    if(result.length==0)
                    {
                        document.getElementById("divUnderwriting").style.display = "None";
                        
                        
                    }
                    else
                    {
                        
                        document.getElementById("divUnderwriting").style.display = "Block";
                    }
                    
                    component.set("v.loanU",result);
                    //alert("data present");
                    
                    
                    
                }); 
                actionS.setCallback(this, function(data) {
                    
                    var state = data.getState();
                    var result=data.getReturnValue();
                    console.log(result);
                    
                    
                    if(result.length==0)
                    {
                        document.getElementById("divSuspended").style.display = "None";
                        
                        
                    }
                    else
                    {
                        
                        document.getElementById("divSuspended").style.display = "Block";
                    }
                    
                    component.set("v.loanS",result);
                    //alert("data present");
                    
                    
                    
                }); 
                actionCl.setCallback(this, function(data) {
                    
                    var state = data.getState();
                    var result=data.getReturnValue();
                    console.log(result);
                    
                    
                    if(result.length==0)
                    {
                        document.getElementById("divClosing").style.display = "None";
                        
                        
                    }
                    else
                    {
                        
                        document.getElementById("divClosing").style.display = "Block";
                    }
                    
                    component.set("v.loanCl",result);
                    //alert("data present");
                    
                    
                    
                }); 
                actionF.setCallback(this, function(data) {
                    
                    var state = data.getState();
                    var result=data.getReturnValue();
                    console.log(result);
                    
                    
                    if(result.length==0)
                    {
                        document.getElementById("divFunded").style.display = "None";
                        
                        
                    }
                    else
                    {
                        
                        document.getElementById("divFunded").style.display = "Block";
                    }
                    
                    component.set("v.loanF",result);
                    //alert("data present");
                    
                    
                    
                }); 
                actionC.setCallback(this, function(data) {
                    
                    var state = data.getState();
                    var result=data.getReturnValue();
                    console.log('try to fetch value');
                    console.log(result);
                    
                    
                    if(result.length==0)
                    {
                        document.getElementById("divCancelled").style.display = "None";
                        
                        
                    }
                    else
                    {
                        
                        document.getElementById("divCancelled").style.display = "Block";
                    }
                    
                    component.set("v.loanC",result);
                    //alert("data present");
                    
                    
                    
                }); 
                $A.enqueueAction(action);
                $A.enqueueAction(actionP);
                $A.enqueueAction(actionU); 
                $A.enqueueAction(actionS);
                $A.enqueueAction(actionCl);
                $A.enqueueAction(actionF); 
                $A.enqueueAction(actionC);
                
                
            }
            else{
                component.set("v.DataMessage",'You currently do not have loans in the pipeline.'); 
                 
                component.set("v.IsdataAvailableInPipeLine",false);  
            } 
        });
        $A.enqueueAction(action2);  
        
    },
})