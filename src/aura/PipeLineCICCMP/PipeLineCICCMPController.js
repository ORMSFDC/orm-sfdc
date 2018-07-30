({
	AddFeeData : function(component, event, helper) {
        var feevaluevalidate=helper.validateAddFee(component, event, helper);
        if(feevaluevalidate==true)
        {
             component.set("v.showError",true);
        }
        else
        {
             component.set("v.showError",false);
        var Index=component.get("v.Count");
		 var fName=component.find("FeeName").get("v.value");
        var OAmount=component.find("OldVal").get("v.value");
        var NAmount=component.find("NewVal").get("v.value");
        var staticItem = { FeeName:fName,
                          OldAmount: OAmount,NewAmount:NAmount,FeeIndex:Index};
        var result=component.get("v.CICFeeData");
        //result.splice(0, 0, staticItem);
        result.push(staticItem);
        component.set("v.CICFeeData",result);
        component.find("FeeName").set("v.value","");
        component.find("OldVal").set("v.value",'');
        component.find("NewVal").set("v.value",'');
        component.set("v.Count",Index+1); 
        }
	},
      DeleteRow : function(component, event, helper) {   
        debugger;
        var id = event.currentTarget.id;        
        var listData=component.get("v.CICFeeData");        
        var index = listData.findIndex(function(o){
            return o.FeeIndex === parseInt(id);
        })
        if (index !== -1) listData.splice(index, 1);
        var DBCountIncremental=0;
        for(var i=0;i<listData.length;i++)
        { 
            DBCountIncremental=i+1;
            listData[i].FeeIndex=i+1;
            
        }
        component.set("v.Count", DBCountIncremental+1);      
        component.set("v.CICFeeData",listData);  
           }, 
    NoFeeChk: function(component, event, helper) {  
         var val=component.find('NFC').get('v.value'); 
        if(val==true)
        {
             component.find('FeeName').set('v.disabled', true);
            component.find('OldVal').set('v.disabled', true);
            component.find('NewVal').set('v.disabled', true);
              component.find('AddFee').set('v.disabled', true);
             component.set("v.disabledClass","disabledcls"); 
             //var adrcc = component.find("AddFee");
              //$A.util.addClass(adrcc, 'disabledcls');
        }
        else
        {
             component.find('FeeName').set('v.disabled', false);
            component.find('OldVal').set('v.disabled', false);
            component.find('NewVal').set('v.disabled', false);
             component.find('AddFee').set('v.disabled', false);
             component.set("v.disabledClass","btncls"); 
            // var adrcc = component.find("AddFee");
             // $A.util.removeClass(adrcc, 'disabledcls');
        }
    },
    
    AddCIC: function(component, event, helper) {  
         debugger;
     	var FeeChkValidation=helper.FeeCheckBoxValidation(component, event, helper);
        var changereqChkvalidation=helper.ChangeRequestCheckBoxValidation(component, event, helper);
        var desclamer=helper.validatedisclaimer(component, event, helper);
       //var datevalidation= helper.validateCICDate(component, event, helper);
        var Nofee=helper.FeeChangeValidation(component, event, helper);
        //alert('Nofee'+Nofee);
        if( FeeChkValidation==true ||changereqChkvalidation==true || desclamer==true || Nofee==true)
        {
              component.set("v.showError",true);
           
        }
        else
        {
              component.set("v.showError",false);
           helper.SAVECIC(component, event, helper); 
        }
    },
    CLOSECIC: function(component, event, helper) {
   
            var evt=$A.get("e.c:Event_CICSave_CloseModal");
            evt.setParams({"ModalValue":false});       
            evt.fire(); 
    }
        
      
})