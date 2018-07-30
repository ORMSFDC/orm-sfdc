({
    //Check Appriasal Mail status and enabled/disabled mail button
    doInit : function(component, event, helper) {  
        debugger;
        var BestContact='';
        var id=component.get("v.LoanId");        
        var action = component.get("c.getEmailData");
        action.setParams({            
            "LoanID":id            
        });
        action.setCallback(this, function(data) 
                           {  
                               var result=data.getReturnValue(); 
                               var lstatus=result.LoanStatus;
                               BestContact= result.BestContact;
                               var flag=result.OrderAppFlag;  
                               var flagother=result.OtherContactFlag;  
                               component.set("v.OldContacTime",result.ContactTime);
                               component.set("v.OldContactName",result.BestContact);
                               component.set("v.Client_Name__c",result.ClientName);
                               component.set("v.Related_Individual__c",result.Individual);
                               component.set("v.LoanOfficer", result.LoanOfficer);
                               component.set("v.AccountExecutive",result.AccountExecutive)
                               
                               if(result.Fully_Signed_Application_Package == true && result.HECM_Counseling_Certificate == true && result.Driver_License_and_Social_Security_Card == true && result.Income_and_Asset_Documentation == true)
                               {
                                   component.set("v.showNext",true);
                                   component.set("v.disabledClass","disabledcls");   
                               }
                               
                               if(flagother==true)
                               {
                                   document.getElementById("other").style.display = "Block";
                               }
                               else
                               {
                                   document.getElementById("other").style.display = "None";
                               }
                               if(result==null)
                               {  
                                     component.find('inputFName').set('v.disabled', true);
                                   component.find('Contact').set('v.disabled', true);
                                   component.find('BtnMail').set('v.disabled', true);
                                   var adrcc = component.find("BtnMail");
                                   $A.util.addClass(adrcc, 'disabledcls');
                                   document.getElementById("mailsend").style.display = "None";
                               }
                               else if( lstatus =='Proposal'|| lstatus =='Waiting for Full Package'||lstatus =='Application Package Received' || lstatus =='Underwriting Clear to Close' || lstatus =='Awaiting Closing' || lstatus =='Closed - Awaiting Funding' ||lstatus =='Funded'||lstatus =='Denied'||lstatus =='Withdrawn')
                               {
                                    component.find('inputFName').set('v.disabled', true);
                                    component.find('Contact').set('v.disabled', true);
                                   component.find('BtnMail').set('v.disabled', true);
                                   var adrcc = component.find("BtnMail");
                                   $A.util.addClass(adrcc, 'disabledcls');
                                   document.getElementById("mailsend").style.display = "None";                
                               }
                                   else if(flag==true)  
                                   {
                                        component.find('inputFName').set('v.disabled', true);
                                       component.find('Contact').set('v.disabled', true);
                                       component.find('BtnMail').set('v.disabled', true);
                                       component.set("v.disabledClass","disabledcls");                    
                                      // component.set("v.showDiv1",false);
                                       //component.set("v.showDiv2",true);
                                       document.getElementById("mailsend").style.display = "Block";
                                   }
                                  else 
                                       {  
                                            component.find('inputFName').set('v.disabled', false);
                                           component.find('Contact').set('v.disabled', false);
                                           component.find('BtnMail').set('v.disabled', false);
                                           var adrcc = component.find("BtnMail");
                                           $A.util.removeClass(adrcc, 'disabledcls');
                                           document.getElementById("mailsend").style.display = "None";                        
                                       }  
                               
                               component.set("v.loan",result);
                               document.getElementById("msg").style.display = "None";   
                               component.set("v.loan.BestContact",BestContact);
                           });
        $A.enqueueAction(action);
    },
    //Send Order Appraisal Mail
    SendMail : function(component, event, helper) {
        
        //Save Contact and Time call
        
          helper.Save(component, event, helper);
        //End
     
        //Task for AE, added by Bala - 4/20
        var action = component.get("c.createTask");                 
        action.setParams({           
            'LoanID':component.get("v.LoanId")  
        });                                            
        action.setCallback(this, function() {
            alert(getReturnValue());             
        }); 
        $A.enqueueAction(action);         
    },   
    //ContactChange
    ContactChange: function(component, event, helper)
    {
        debugger;
        //document.getElementById("MSGSave").style.display = "None";
        var cmp=component.find("Contact");
        var val=cmp.get("v.value");        
        if(val=='New/Other')
        {
            document.getElementById("other").style.display = "Block";
        }
        else
        {
            document.getElementById("other").style.display = "None";            
        }
    },
    //Save
   
    FormatPhone: function(component, event, helper){
        helper.FormatPhonehelper(component, event, helper);
    },
    RestrictZeroInEmployerPhoneFirstTime:function(component, event, helper) {
        var inz = 'v.loan.OtherContactPhone';        
        helper.RestrictZeroInPhoneFirstTime(component, event, helper,inz);     
    },
    validateWhitespace:function(component, event, helper) {
        var inz = 'v.loan.ContactTime';        
        helper.validateEnteredWhitespace(component, event, helper,inz);     
    },
    ShowCIC:function(component, event, helper){
        component.set("v.showCICPopup",true);
    },
    
    getModalValue: function(component, event, helper) {
        var boolVal = event.getParam("ModalValue");    
        component.set("v.showCICPopup",boolVal);
    },
    
    getModalStatus: function(component, event, helper) {
        var boolVal = event.getParam("ModalStatus");  
        var status = event.getParam("statusValue");
        
        component.set("v.showPackagePopup",boolVal);
        
        if(status == true)
        {
            component.set("v.showNext",true);
            component.set("v.disabledClass","disabledcls");   
        }
    },
    
    ShowPopUp: function(component, event, helper) {
        component.set("v.showPackagePopup", true);
    }
})