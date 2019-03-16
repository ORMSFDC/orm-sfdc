({
	addPackage: function(component, event, helper)
    {
        var pipelineVal = component.get("v.loan");
        var clientName = component.get("v.ClientName");
        var IndividualId = component.get("v.IndividualId");
        var LoanOfficer = component.get("v.LoanOfficer");
        var AccountExecutive = component.get("v.AccountExecutive");
        var Loanid = component.get("v.LoanNumberId");
        var action = component.get("c.UpdatePipeline");
        
        action.setParams({
            "Objloan": pipelineVal,
            "LoanId": Loanid
        });                                            
        action.setCallback(this, function(a) {
            debugger;
            var state = a.getState();
        });  
        
        //Bala - 4/20
        var action2 = component.get("c.createLoanTask");        
        action2.setParams({           
            'LoanID':component.get("v.LoanNumberId")  
        });                                            
        action2.setCallback(this, function() {
            alert(getReturnValue());                     
        }); 
        $A.enqueueAction(action2); 
        
        /*var action1 = component.get("c.SaveTask"); //Commented by Bala - 4/20
        debugger;
        action1.setParams({
            "Objloan": pipelineVal,
            "LoanId": Loanid,
            "ClientName":clientName,
            "IndividualId":IndividualId,
            "LoanOfficer":LoanOfficer,
            "AccountExecutive":AccountExecutive
        });                                            
        action1.setCallback(this, function(a) {
            var state = a.getState();
        });                   
        $A.enqueueAction(action1); */
	    
	//update Loan status to Submitted to Lender - Don  
        var actionUpdateLoanStatus = component.get("c.updateFullPackageLoanStatus");        
        actionUpdateLoanStatus.setParams({           
            'loanId':component.get("v.LoanNumberId")  
        });                                            
        actionUpdateLoanStatus.setCallback(this, function() {                  
        }); 
        $A.enqueueAction(actionUpdateLoanStatus); 
	
	$A.enqueueAction(action);

        component.set("v.showPackage", false);
        component.set("v.showHeader", false);
        component.set("v.showFooter", false);
        component.set("v.valueStatus",true);
        component.set("v.showThanks", true);
    },
    
    onCheck: function(component, event, helper)
    {
        var fully_Signed_Application_Package = component.find("fully");
        var driver_License_and_Social_Security_Card = component.find("driver");
        var income_and_Asset_Documentation = component.find("income");
        var HECM_Counseling_Certificate = component.find("hecm");
        
        if(fully_Signed_Application_Package.get("v.value") == true && driver_License_and_Social_Security_Card.get("v.value") == true && income_and_Asset_Documentation.get("v.value") == true && HECM_Counseling_Certificate.get("v.value") == true)
        {
            component.set("v.showButton", false);
        }
        else
        {
            component.set("v.showButton", true);
        }   
    },
    closeModel: function(component, event, helper) {
       debugger;
        var status = component.get("v.valueStatus");
        var evt=$A.get("e.c:Event_PackageSave_CloseModal");
        evt.setParams({"ModalStatus":false}); 
        if(status == true)
        {
            evt.setParams({"statusValue":true}); 
        }
        evt.fire(); 
    },
})