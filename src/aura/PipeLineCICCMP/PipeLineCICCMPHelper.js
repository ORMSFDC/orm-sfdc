({
     validatedisclaimer:function(component, event, helper) {
          var finalResult=false;
          var desclamerval=component.find('RESPA').get('v.value');
        var desclamerCmp=component.find('RESPA');
        if(desclamerval !=true) 
        {
              finalResult = true;
             document.getElementById("desclamerError").innerHTML = 'Please accept the disclaimer before Submitting CIC.';
            //desclamerCmp.set("v.errors", [{ message: "Please accept the disclaimer before doing CIC." }]); 
        }
         else
         {
               document.getElementById("desclamerError").innerHTML = '';
         }
          return finalResult;
     },
    validateCICDate:function(component, event, helper) {
        debugger
        var finalResult=false;
        var CICDate = component.find("CICdate");
        var DateValue= CICDate.get("v.value");
        if ($A.util.isEmpty(DateValue))
        {
            
            finalResult = true;
            CICDate.set("v.errors", [{ message: "This is a required field." }]);           
        }
        else
        {
            var year=DateValue.substring(0,4);         
            var month=DateValue.substring(5,7);         
            var day=DateValue.substring(8,10); 
            DateValue=month+'/'+day+'/'+year;
            var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/;
            if(!(date_regex.test(DateValue)))
            {
                
                finalResult = true;
                CICDate.set("v.errors", [{ message: "Please enter date in correct format." }]); 
            }
            else
            {
                var currdate = new Date();
                var mydate = new Date(DateValue);
              
             
                var timeDiff = ( mydate.getTime()-currdate.getTime());
                var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                //alert('diffDays'+diffDays);
                if (diffDays >0 ||  diffDays<-2)
                {
                  //alert('bss');
                    finalResult = true;
                    CICDate.set("v.errors", [{ message: "The change in circumstance must be within two days of today."}]); 
                }
                else
                {
                   
                    CICDate.set("v.errors", null);
                }
               
            }
            
            
        }
         return finalResult;
    },
    FeeCheckBoxValidation:function(component, event, helper) {
        debugger;
         var finalResult=false;
         var AddNBSval=component.find('AddNBS').get('v.value');
         var ROFval=component.find('ROF').get('v.value');
         var TFRval=component.find('TFR').get('v.value');
         var ARBval=component.find('ARB').get('v.value');
         var AOGval=component.find('AOG').get('v.value');
         var ARval=component.find('AR').get('v.value');
         var OCTval=component.find('OCT').get('v.value');
         var ONTval=component.find('ONT').get('v.value');
         var Otherval=component.find('Other').get('v.value');
         var IICTval=component.find('IICT').get('v.value');
         var DescFeeVal=component.find('DescFee').get('v.value');
        var DescCmp=component.find('DescFee');
        
        if(AddNBSval==true||ROFval==true||TFRval==true||ARBval==true||AOGval==true||ARval==true||OCTval==true||ONTval==true||Otherval==true||IICTval==true)
        {
             if ($A.util.isEmpty(DescFeeVal))
        		{
                    
                     finalResult = true;
                	DescCmp.set("v.errors", [{ message: "This is a required field." }]); 
        		}
            else
            {
                if(DescFeeVal.length < 20)
                {
                   
                    finalResult = true;
                	DescCmp.set("v.errors", [{ message: "Please enter a minimum of 20 characters." }]); 
                }
                else
                {
                   
                    DescCmp.set("v.errors", null);
                }
            }
            
        }
        else
        {
           
            DescCmp.set("v.errors", null);
        }
         return finalResult;
        
    },
    validateAddFee:function(component, event, helper) {
         var finalResult=false;
        var FeeNameVal=component.find('FeeName').get('v.value');
        var FeenNameCmp=component.find('FeeName');
        var OldVal=component.find('OldVal').get('v.value');
        var OldCmp=component.find('OldVal');
        var NewVal=component.find('NewVal').get('v.value');
        var NewCmp=component.find('NewVal');
         if ($A.util.isEmpty(FeeNameVal))
        	{
                 finalResult = true;
                FeenNameCmp.set("v.errors", [{ message: "This is a required field." }]); 
          	}
        else
        {
             FeenNameCmp.set("v.errors", null);
        }
          if ($A.util.isEmpty(OldVal))
        	{
                 finalResult = true;
                OldCmp.set("v.errors", [{ message: "This is a required field." }]); 
          	}
        else
        {
             OldCmp.set("v.errors", null);
        }
          if ($A.util.isEmpty(NewVal))
        	{
                 finalResult = true;
                NewCmp.set("v.errors", [{ message: "This is a required field." }]); 
          	}
        else
        {
             NewCmp.set("v.errors", null);
        }
        return finalResult;
    },
    FeeChangeValidation:function(component, event, helper) {
         var finalResult=false;
         var Feeval=component.find('NFC').get('v.value');
         var FeeCmp=component.find('NFC');
        if(Feeval==true)
        {
              var CICDataFeeList=component.get("v.CICFeeData");
            if(CICDataFeeList=='')
            {
                //FeeCmp.set("v.errors", null);
                document.getElementById("FeeError").innerHTML = '';
            }
            else
            {
                 finalResult = true;
                document.getElementById("FeeError").innerHTML = 'Please either uncheck the No Fee Changes check box or remove the fee change.';
                 //FeeCmp.set("v.errors", [{ message: "" }]);  
                
            }
        }
        else
        {
            document.getElementById("FeeError").innerHTML = '';
        }
         return finalResult;
    },
   ChangeRequestCheckBoxValidation:function(component, event, helper) {
        debugger;
         var finalResult=false;
         var AddNBRval=component.find('AddNBR').get('v.value');     
         var CEval=component.find('CE').get('v.value');
         var CLOval=component.find('CLO').get('v.value');
         var CRPLval=component.find('CRPL').get('v.value');
         var BFCval=component.find('BFC').get('v.value');
         var Withdrawval=component.find('Withdraw').get('v.value');
         var OtherChangeval=component.find('OtherChange').get('v.value');        
         var DescFeeVal=component.find('DescLoanChange').get('v.value');
        var DescCmp=component.find('DescLoanChange');
        
        if(AddNBRval==true||CEval==true||CLOval==true||CRPLval==true||BFCval==true||Withdrawval==true||OtherChangeval==true)
        {
             if ($A.util.isEmpty(DescFeeVal))
        		{
                    
                     finalResult = true;
                	DescCmp.set("v.errors", [{ message: "This is a required field." }]); 
        		}
            else
            {
                if(DescFeeVal.length < 20)
                {
                    
                    finalResult = true;
                	DescCmp.set("v.errors", [{ message: "Please enter a minimum of 20 characters." }]); 
                }
                else
                {
                    
                    DescCmp.set("v.errors", null);
                }
            }
            
        }
        else
        {
            
            DescCmp.set("v.errors", null);
        }
         return finalResult;
        
    },
    SAVECIC: function(component, event, helper) {  
        
        
        var LoanId=component.get("v.LoanNumberId");
        var CICRESPONSEDATA=component.get("v.CICData");      
        var CICDataFeeList=component.get("v.CICFeeData");
        var action2 = component.get("c.SaveCICData"); 
        
        action2.setParams({
            
            CICFeeList: JSON.stringify(CICDataFeeList),
            CICDataValue: CICRESPONSEDATA ,
            LoanId:LoanId
            
        });
        action2.setCallback(this, function(data) {
             var toastEvent = $A.get("e.force:showToast");                
                toastEvent.setParams({                    
                    "title": "Success!",  
                    "type": "success",
                    "message": "Thank you for submitting a Change in Circumstance! Your Partner Care Specialist has been notified."                    
                });                
                toastEvent.fire(); 
            var result= data.getReturnValue(); 
            var evt=$A.get("e.c:Event_CICSave_CloseModal");
            evt.setParams({"ModalValue":false});       
            evt.fire();
        });
        $A.enqueueAction(action2);
    },
    
})