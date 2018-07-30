({
    FormatPhonehelper: function(component, event, helper){        
        var Phone = component.find("OtherContactPhone").get("v.value"); 
        var rxp = new RegExp("^(\\d)\\1{9}$");        
        var  isRegValid = rxp.test(Phone);
        if(isRegValid)
        {
            component.set("v.loan.OtherContactPhone",'');
        }else{
            var s2 = (""+Phone).replace(/\D/g, '');
            var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
            var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];            
            component.set("v.loan.OtherContactPhone",result);
        }
    },
    RestrictZeroInPhoneFirstTime:function(component, event, helper,compId) {        
        var inz = component.get(compId);        
        var digit = parseInt(inz[0]);
        if(digit == 0)
        {            
            component.set(compId, inz.substring(0, inz.length - 1));
        }              
    },    
    ValidateOther:function(component, event, helper) {        
        var finalResult=false;  
        var othername=component.find('OtherContactName');
        var otherphone=component.find('OtherContactPhone');
        var othernameval=othername.get("v.value");
        var otherphoneval=otherphone.get("v.value");
        if ($A.util.isEmpty(othernameval)) 
        {
            finalResult = true;            
            othername.set("v.errors", [{ message: "This is a required field." }]);
        } 
        else
        {
            othername.set("v.errors", null);             
        }
        if ($A.util.isEmpty(otherphoneval))
        {
            finalResult = true;
            otherphone.set("v.errors", [{ message: "This is a required field." }]);
        } 
        else
        {
            otherphone.set("v.errors", null); 
        }
        return finalResult;
    },
    validateEnteredWhitespace:function(component, event, helper,compId) {
        var inz = component.get(compId);        
        var IsZero = inz.toString()[0];
        if(IsZero == ' ')
        {            
            component.set(compId, inz.substring(0, inz.length - 1));
        }        
    },
    //Save
     Save:function(component, event, helper)
    {  
        debugger;
        var oldContactTime= component.get("v.OldContacTime");
        var OldContactName= component.get("v.OldContactName");
        var CurrentContactTime='';var CurrentContactName= '';        
        var cmp=component.find("Contact");
        var valdd=cmp.get("v.value");        
        var OtherFlag=false;        
        if(valdd=="New/Other")
        {            
            OtherFlag=helper.ValidateOther(component, event, helper); 
        } 
        else{
            component.set("v.loan.OtherContactPhone",'');
            component.set("v.loan.OtherContactName",'');
        }
        if(OtherFlag==true)
        {            
        }
        else
        {            
            var responsedata=component.get("v.loan");
            debugger;
            CurrentContactTime=responsedata.ContactTime
            CurrentContactName=responsedata.BestContact;            
            var action = component.get("c.UpdateLoanPipeLineEmail");
            action.setParams({
                "responseString": JSON.stringify(responsedata),
                'LoanID':component.get("v.LoanId")                
            });
            action.setCallback(this, function(data) {
                
                this.sendEmail(component, event, helper);
                
            });
            $A.enqueueAction(action);
        }        
    }, 
    sendEmail:function(component, event, helper)
    {
         var id=component.get("v.LoanId");
        var loanval=component.get('v.loan');
        var loannum=loanval.LoanNumberDetails;        
        var contacttime=loanval.ContactTime;
        var Browername=loanval.BorrowerName;
        var pNum=loanval.Phone;
        var partner=loanval.partnerName;
        var loanoff=loanval.LoanOfficerName;
        var emailto='';       
        var action = component.get("c.sendMail");        
        action.setParams({           
            "BorrowerName":Browername,
            "Email":emailto,
            "LoanNumber":loannum,
            "PhoneNumber":pNum,
            "PartnerName":partner,
            "LoanOfficerName":loanoff,
            "ContactTime":contacttime,
            "LoanId":id
        });
        action.setCallback(this, function(data) {            
            var result=data.getReturnValue();  
            
            document.getElementById("msg").style.display = "Block";          
            component.find('BtnMail').set('v.disabled', true);
            component.set("v.disabledClass","disabledcls");             
            component.find('inputFName').set('v.disabled', true);
           	component.find('Contact').set('v.disabled', true);   
        });
        $A.enqueueAction(action);
    },
})