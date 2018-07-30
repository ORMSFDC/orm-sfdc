({
    ValidationForPills: function(component, event, helper) {
        var LoanId = component.get('v.LoanId');
        var action1 = component.get("c.Capacity_TabsValidatedData");  
        action1.setParams({
            "RecordId": LoanId
        });
        action1.setCallback(this, function(data) {
            var result=data.getReturnValue();  
            if(result.Is_Loan_Created_Manually__c==false)
            {
                var evt=$A.get("e.c:NavPillsEvent");
                evt.setParams({"IsPillsValidationRequired":true});       
                evt.fire();     
            }
        });
        $A.enqueueAction(action1);
    },
    applyCSS: function(component, event, helper,ControlId) {
        var cmpTotalCapacity = component.find(ControlId);
        $A.util.addClass(cmpTotalCapacity, 'TextColor');
    },    
    Loan_Next: function(component, event, helper) 
    {    
        if(event.getSource().getLocalId() =="NextbtntoCapacity")//Goes to the next step if it is an actual click
        
     {
         document.getElementById('LoanContactLbl').innerHTML = 'NoNeedToMove';
          
     } 
        $('li#l11').removeClass('disabled');
        $('li#l11 a').attr("data-toggle","tab");
      
      if(!component.get('v.fromPopup')){
             $('li#l11 a').click();
        } else{
            $('li#l10').removeClass('active');
           
            $('li#l11').addClass('active');
            $('li#l9').removeClass('active');
            
        }
            component.set('v.itemsClicked','opt11');
         
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },
    prev: function(component) 
    {        
        document.getElementById('loanD').innerHTML = 'NoNeedToMove';
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        $('li#l10').removeClass('active');
          if(!component.get('v.fromPopup')){
 $('li ul li#l9 a').click();       
        } else{
            $('li#l8').removeClass('active');
           
            $('li#l9').addClass('active');
            $('li#l10').removeClass('active');
            
        }
    
        window.scrollTo(0, 0);
    },
    GetCashFlowViewedStatus : function(component, event, helper) 
    {
        var _Loanid=component.get("v.LoanId");
        var action = component.get("c.GetCashFlowStatus");
        action.setParams({
            "LoanID": _Loanid
        });        
        action.setCallback(this, function(data) {          
            var result = data.getReturnValue();
            if(result.Is_CashFlow_Viewed__c)
            {
                component.set("v.Incomplete",true)  ;              
            }
        });
        $A.enqueueAction(action);
    },
})