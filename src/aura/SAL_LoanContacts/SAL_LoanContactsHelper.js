({
    ValidationForPills: function(component, event, helper) {
        var LoanId = component.get('v.LoanId');
        var action1 = component.get("c.LoanContact_TabsValidatedData");  
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
    getLoanOfficerhelper : function(component, event, helper) {
        
        var id=component.get("v.LoanId");        
        var action = component.get("c.getLoanOfficerList");
        action.setCallback(this, function(data) {  
            
            var result=data.getReturnValue();   
            
			console.log('result ',result);
            component.set("v.LoanOfficerList",result);
            this.getLoanProcessorhelper(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    getLoanProcessorhelper : function(component, event, helper) {
       debugger;
        var Res=0;
        var staticItem = [{Id: "Loan Officer",
                           Name: "Loan Officer"},
                          {Id: "Loan Processor",
                           Name: "Loan Processor"}];
        var staticItem1= [{Id: "Loan Officer",
                           Name: "Loan Officer" }];
        var id=component.get("v.LoanId");        
        var action = component.get("c.getLoanProcessorList");
        action.setCallback(this, function(data) {  
             debugger;
            var result=data.getReturnValue(); 
            if(result != null || result != ''){
                Res = result.length;
            }
            else{
                Res = 0;
            }
            if (Res==0)
            {
                component.set("v.Preferredlist",staticItem1);
                
                document.getElementById('LoanProcessor').style.display = 'None';
                
            }
            else {
                //if (Res==1){
                
                //component.set("v.Preferredlist",staticItem);
                //document.getElementById('LoanProcessor').style.display = 'block';
               // component.set("v.LoanProcessorList",result);
                
               // component.set("v.LoanContactDetailsResponse.LoanProcessor",result[0].Id);
                
                
            //}else{
                    component.set("v.Preferredlist",staticItem);
                    document.getElementById('LoanProcessor').style.display = 'block';
                    var LoanProcessorList = {  Id: "",
                                             LoanProcessorName: "---Select One---" };
                    result.splice(0, 0, LoanProcessorList);
                    component.set("v.LoanProcessorList",result);
                    
                    //  component.set("v.LoanContactDetailsResponse.LoanProcessor",result[0].Id);
                }
           // alert("loan contact");
            var checkId = component.get("v.LoanId");
            if (checkId != "undefined") {
                if (checkId != null) {
                    helper.GetLoanContactsById(component, event, helper);
                    
                }
                
            }
            //component.set("v.LoanProcessorList",result);            
        });
        $A.enqueueAction(action);
    },
    getCurrentUserhelper : function(component, event, helper) {
        
        var _Loanid=component.get("v.LoanId");        
        var action = component.get("c.getUserId");
        action.setParams({
            "LoanID": _Loanid
        });
        action.setCallback(this, function(data) { 
            
            var result=data.getReturnValue();  
            if(result != null || result != ''){
                var Res = result.length;
            }
            else{
                var Res = 0;
            }
        //    alert(Res);
            // component.set("v.CurrentUser",'Partial Portal test user');  
            
            component.set("v.LoanContactDetailsResponse.LoanOfficer",result);
           
            
            
        });
        $A.enqueueAction(action);
    },
    formatErrorMethod: function(component, regex, msg, aura_id) {
        
        
        //Code if button is clicked
        var flag = false;
        for (var i = 0; i < aura_id.length; i++) {
            var inputCmp = component.find(aura_id[i]);
            var isValid = false;
            
            if(typeof inputCmp ==='undefined' || typeof inputCmp === null || typeof inputCmp === ''){
                //isValid = false;
                
            }
            else{
                var value = inputCmp.get("v.value");
                
                if (typeof regex[i] != "string") {
                    //Checks to see if this is a function and not a regex string
                    isValid = regex[i](value); // Please return true if there is an error or else false
                    
                } 
                if (isValid) {
                    //component.set("v.LoanErr", false);//Please leave out this line while replicating. LoanErr may not exist on other compnents
                    inputCmp.set("v.errors", null);
                    
                    
                    
                    
                } else {
                    inputCmp.set("v.errors", [{ message: msg[i] + "."  }]); 
                    
                    flag = true;
                    
                }
            }
        }
        return flag;
    },
    LoanContactsSave: function(component, event, helper) {
        debugger;
        var data = component.get("v.LoanContactDetailsResponse");
        
        //alert(' data - '+data.LoanOfficer+" LP - " +data.LoanProcessor+" PC - "+ data.PreferredContact);
        //if(data.PreferredContact == "Loan Officer"){
        //    data.LoanProcessor = "";
        //}
        //if(data.PreferredContact == "Loan Processor"){
        //    data.LoanOfficer = "";
        //}
        var LoanId = component.get("v.LoanId");
        var action = component.get("c.SavePreferredContact");
        
        action.setParams({
            "LO": data.LoanOfficer,
            "LP": data.LoanProcessor,
            "PC": data.PreferredContact,
            "LoanID": LoanId
            
        });
        action.setCallback(this, function(data) {
            var res = data.getReturnValue();
            //alert(res);
            var state = data.getState();
            console.log("state is" + state);
            //Goes to the next Step
            this.Loan_Next(component, event, helper);
        });
        
        $A.enqueueAction(action);
    },
    GetLoanContactsById: function(component, event, helper) {
        debugger;
        var _Loanid=component.get("v.LoanId");
        //alert(_Loanid);
        var action = component.get("c.GetLoanContactsById");
        action.setParams({
            "LoanID": _Loanid
        });
        //var opts = [];
        action.setCallback(this, function(data) {
            debugger;
            var result=data.getReturnValue();
			
			console.log('>>>>>>>>  result ',result);
			if(result.Preferred_Contact_Type__c!=undefined){
			component.set('v.nextDataExist',true);
                 
			}
            if(typeof result.LoanOfficer__c==='undefined')
            {
                helper.getCurrentUserhelper(component, event, helper);  
             if(typeof result.Preferred_Contact_Type__c==='undefined' && typeof result.Loan_Processor__c==='undefined')
                {
                    component.set("v.LoanContactDetailsResponse.PreferredContact","")
                }else if(typeof result.Preferred_Contact_Type__c==='undefined'){
                    component.set("v.LoanContactDetailsResponse.PreferredContact","Loan Officer");
                }else{
                    component.set("v.LoanContactDetailsResponse.PreferredContact",result.Preferred_Contact_Type__c);
                    component.set("v.LoanContactDetailsResponse.LoanProcessor",result.Loan_Processor__c);
                }
            }
            else{
                if(typeof result.Loan_Processor__c==='undefined' )
                {
                    component.set("v.LoanContactDetailsResponse.LoanProcessor","");
                }
                else
                {
                    component.set("v.LoanContactDetailsResponse.LoanProcessor",result.Loan_Processor__c);
                }
                    component.set("v.LoanContactDetailsResponse.LoanOfficer",result.LoanOfficer__c);
               		component.set("v.LoanContactDetailsResponse.PreferredContact",result.Preferred_Contact_Type__c);
           }
		    component.set("v.Incomplete",false);
		   
		 /*   if(component.get("v.nextDataExist")  && !component.get('v.manual')){
				$('li#l11').removeClass('disabled');
        $('li#l11 a').attr("data-toggle","tab");
        
        $('li#l11 a').click();
        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
		   }*/
        });
        $A.enqueueAction(action);
    },
    prev: function(component) {
        
         document.getElementById('CapacityLbl').innerHTML = 'NoNeedToMove';
        component.set("v.prevOpt", "true");
        component.set("v.currentOpt", "false");
        $('li#l11').removeClass('active');
      //  $('li ul li#l10 a').click();
        if(!component.get('v.fromPopup')){
             $('li ul li#l10 a').click();
        } else{
            $('li#l9').removeClass('active');
           
            $('li#l10').addClass('active');
            $('li#l11').removeClass('active');
            
        }
        
        
        window.scrollTo(0, 0);
    },
    Loan_Next: function(component, event, helper) {
        
        
        //$('li#l12 a').click();
        if(!component.get('v.fromPopup')){
        //    alert(1);
              $('li#l12').removeClass('disabled');
        $('li#l12 a').attr("data-toggle","tab");
      
             $('li#l12 a').click();
            
        } else{
          //  alert(2);
            $('li#l11').removeClass('active');
           
            $('li#l12').addClass('active');
            $('li#l13').removeClass('active');
                          component.set('v.itemsClicked','opt12');
             }

        component.set("v.nextOpt", "true");
        component.set("v.currentOpt", "false");
        window.scrollTo(0, 0);
    },
    
})