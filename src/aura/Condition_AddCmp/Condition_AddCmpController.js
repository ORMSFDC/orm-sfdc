({
    
    doInit: function(component, event, helper) {  
       // component.set("v.cssStyle", ".forceStyle .viewport.oneHeader.desktop {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
        debugger;
        var LoanId=component.get("v.LoanId");
        var action2 = component.get("c.getConditionCount");        
        action2.setParams({         
            LoanId:LoanId
        });
        action2.setCallback(this, function(data) {           
            var result= data.getReturnValue();            
            component.set("v.DBConditionCount",result+1); 
            component.set("v.ConditionCount",result+1);
        });
        $A.enqueueAction(action2);      
    }, 
    DescChange: function(component, event, helper) {
        var Comment=component.find('inputCondition');        
        Comment.set("v.errors", null);
        var Desc=component.find('DDl_Description');          
        Desc.set("v.errors", null);
        
        var inputCmp = component.find('DDl_Description');       
        var value = inputCmp.get("v.value");
        if(value=="")
        {      component.set("v.IsTextboxDisabled",true);
         component.find('inputCondition').set("v.value","");  
        }
        else{ component.set("v.IsTextboxDisabled",false);}
        if(value=="Driver's License for all clients")
        {            
            component.find('inputCondition').set("v.value","Please provide a legible copy of each client's driver's license or photo ID, including any non-borrowing spouses. Please note the following: You must provide clear, legible copies. All cards must be valid and current.");  
        }
        if(value=="Copy of Each Client's Social Security Card")
        {            
            component.find('inputCondition').set("v.value","Please provide a clear, legible copy of each client's Social Security card.");  
        }
        if(value=='Trust Agreement')
        {            
            component.find('inputCondition').set("v.value",'Please provide all pages of the executed and notarized trust agreement (including any and all amendments).');  
        }
        if(value=='Power of Attorney')
        {            
            component.find('inputCondition').set("v.value",'Please provide all pages of the executed and notarized Power of Attorney.');  
        }
        if(value=='Occupancy Status')
        {            
            component.find('inputCondition').set("v.value","Client to provide verbal information about current occupancy status. Provide us with the following information:  1.  How long have you resided in the subject property?  2.  Do you stay in any other homes throughout the year? If so, provide addresses for each and length of time spent in each 3.  Do you own or rent any other properties? If so, provide addresses for each and explanation for use of each.");
            
        }
        if(value=='Alternate Address Clarification')
        {            
            component.find('inputCondition').set("v.value","Client to provide explanation for all Alternate address(es) that exist in file.");                  
            
        }
        if(value=='Copy of Divorce Decree and/or Settlement Agreement')
        {            
            component.find('inputCondition').set("v.value","Please provide signed legal documentation explaining the terms of the divorce decree and/or settlement agreement. Please note the following: a copy of the signed final divorce decree or separation agreement with all pages must be included. No information on the documents can be altered. ");
        }
        if(value=='Client(s) to provide')
        {            
            component.find('inputCondition').set("v.value",'');  
        }
        if(value=='Please provide a copy of your current mortgage statement')
        {            
            component.find('inputCondition').set("v.value",'Please provide a copy of your current mortgage statement so we can verify if taxes and insurance are escrowed. The statement must include the property address. ');  
        }
        if(value=='Proof of assets in the amount needed for funds to close')
        {            
            component.find('inputCondition').set("v.value","Provide asset statements from the last 2 months with a previous ending balance; accounts must be available for withdrawal to be eligible. This amount of funds to close may change based on the appraised value and if you are paying off a current mortgage.");  
        }
        if(value=='Proof of Social Security Income')
        {            
            component.find('inputCondition').set("v.value","Please provide a copy of the most recent Social Security award letter for ^client^ as evidence of the income.");  
        }
        if(value=='Paystubs-30 days most recent')
        {            
            component.find('inputCondition').set("v.value","Please provide the most recent pay stub(s) showing a minimum of 30 days of year-to-date (YTD) earnings for ^who^.");  
        }
        if(value=='W-2 Form')
        {            
            component.find('inputCondition').set("v.value",'Please provide W-2 forms from  ^year(s)^  for  ^who^  from  ^employer^.');  
        }
        if(value=='Pension Award Letter')
        {            
            component.find('inputCondition').set("v.value",'Please provide the pension award letter for ^who^ evidencing $^amount^ per month in pension income.');  
        }
        if(value=='Self-Employed 2 years Tax Returns')
        {            
            component.find('inputCondition').set("v.value","Please provide ^client^'s most recent 2 years of business tax returns (1120s/1065s) and personal tax returns (1040s). A year-to-date profit and loss statement is also required if the documents are submitted more than 120 days after the fiscal year ends.");  
        }
        if(value=='2 Year Tax Return')
        {            
            component.find('inputCondition').set("v.value","Please provide your personal income tax returns (1040s), including all schedules, for ^1yr ago^ and ^2yrs ago^.");  
        }
        if(value=='Bank statements')
        {            
            component.find('inputCondition').set("v.value",'Please provide a ^# of mths^ of consecutive bank statements, including all pages, from ^assets^ account. ');  
        }
        if(value=='Utility Bill (Occupancy Clarification)')
        {            
            component.find('inputCondition').set("v.value","Please provide the most recent ______ months statements from your ______ company showing service at ______ so we can verify occupancy. Statements must include the mailing address and the service address.");  
        }
        if(value=='Electric Bills (Occupancy Clarification)')
        {            
            component.find('inputCondition').set("v.value","Please provide your most recent electric bill showing 12 months of usage for the following properties: ______ and ______. If the most recent statement does not show 12 months of usage, please provide 12 months of statements.");  
        }
        if(value=='Credit Report Inquiries Requiring Explanation')
        {            
            component.find('inputCondition').set("v.value",'');  
        }
        if(value=='Other')
        {            
            component.find('inputCondition').set("v.value",'');  
        }
        
        
    },
    
    AddCondition : function(component, event, helper) {
        var IsTrue=component.get("v.IsControlDisplay");
        if (IsTrue==false){
            document.getElementById('ControlDisplay').style.display = '';
            document.getElementById('ControlDisplay1').style.display = '';
            document.getElementById('ControlDisplay2').style.display = '';
            document.getElementById('ControlDisplay3').style.display = '';
            component.set("v.IsControlDisplay",true);
            var DBCount= component.get("v.DBConditionCount");
            var DefaultCount =component.get("v.ConditionCount");
            var DefaultCountnew =DefaultCount;
            if(DefaultCountnew!=DBCount)
            { 
                component.set("v.IsDeleteIconDisplay",true);
            }
        }
        else{
            
            
            var retvalidate=helper.validateCondition(component, event, helper);
            
            if(retvalidate==true)
            {
                
            }
            else
            {
                var Commentvalidate= helper.validateTextBoxCondition(component, event, helper);
                if(Commentvalidate==true)
                {
                    
                }
                else
                {
                    
                    var text=component.find("inputCondition").get("v.value");
                    var Index=component.find("ConditionIndex").get("v.value");
                    var DropDownValue=component.find("DDl_Description").get("v.value");
                    var staticItem = { Index:Index,
                                      DescText: text,DropDownValue:DropDownValue,Status:"Outstanding" };
                    var result=component.get("v.ConditionData");
                    //result.splice(0, 0, staticItem);
                    result.push(staticItem);
                    component.set("v.ConditionData",result);
                    component.find("DDl_Description").set("v.value","Select");
                    component.find("inputCondition").set("v.value",'');
                    component.set("v.ConditionCount",Index+1);
                    component.set("v.IsTextboxDisabled",true);
                    component.set("v.IsDeleteIconDisplay",true);
                }
            }
        }
        // var result1=component.get("v.ConditionData");
    },
    
    DeleteRow : function(component, event, helper) {   
        var DBCount= component.get("v.DBConditionCount");
        var DefaultCount =component.get("v.ConditionCount");
        var DefaultCountnew =DefaultCount-1;
        if(DefaultCountnew==DBCount)
        { 
            component.set("v.IsDeleteIconDisplay",false);
            var IsControlDisplay= component.set("v.IsControlDisplay",true);
            if(IsControlDisplay==false)
            { 
                component.set("v.IsControlDisplay",true);
                
            }
        }
        
        var id = event.currentTarget.id;        
        var listData=component.get("v.ConditionData");        
        var index = listData.findIndex(function(o){
            return o.Index === parseInt(id);
        })
        if (index !== -1) listData.splice(index, 1);
        var DBCount= component.get("v.DBConditionCount");
        DBCount= DBCount-1;
        var DBCountIncremental=DBCount;
        for(var i=0;i<listData.length;i++)
        { 
            DBCountIncremental=DBCount+i+1;
            listData[i].Index=DBCount+i+1;
            
        }
        component.set("v.ConditionCount", DBCountIncremental+1);
        
        
        component.set("v.ConditionData",listData);  
        //alert(id);
    }, 
    SaveCondition : function(component, event, helper) {
        var IsTextboxDisabled=component.get("v.IsTextboxDisabled");
        
        var DBCount= component.get("v.DBConditionCount");
        var DefaultCount =component.get("v.ConditionCount");
        var DefaultCountnew =DefaultCount;
        // alert('DBCount'+DBCount+'DefaultCount'+DefaultCount+'DefaultCountnew'+DefaultCountnew);
        if(DefaultCountnew==DBCount)
        { 
            
            var retvalidate=helper.validateCondition(component, event, helper);        
            if(retvalidate==true)
            { }
            else
            {
                var Commentvalidate= helper.validateTextBoxCondition(component, event, helper);
                if(Commentvalidate==true)
                {}
                else
                {            
                    helper.save(component, event, helper);
                }
            }
        }
        else{
            
            if(IsTextboxDisabled==true)
            {
                helper.saveWithoutvalidation(component, event, helper);
            }
            else{
                
                var retvalidate=helper.validateCondition(component, event, helper);        
                if(retvalidate==true)
                { }
                else
                {
                    var Commentvalidate= helper.validateTextBoxCondition(component, event, helper);
                    if(Commentvalidate==true)
                    {}
                    else
                    {            
                        helper.save(component, event, helper);
                    }
                }
            }
            
        }
    },
    hideControl : function(component, event, helper)
    {    
        component.set("v.IsDeleteIconDisplay",false);
        component.set("v.IsTextboxDisabled",true);
        component.set("v.IsControlDisplay",false);
        component.find('DDl_Description').set("v.value",'');
        component.find('inputCondition').set("v.value","");
        var Comment=component.find('inputCondition');        
        Comment.set("v.errors", null);
        var Desc=component.find('DDl_Description');          
        Desc.set("v.errors", null);
        
    },
    displaycontrol: function(component, event, helper)
    {  
        var IsTrue=component.get("v.IsControlDisplay");
        if (IsTrue==false){
            document.getElementById('ControlDisplay').style.display = 'none';
            document.getElementById('ControlDisplay1').style.display = 'none';
            document.getElementById('ControlDisplay2').style.display = 'none';
            document.getElementById('ControlDisplay3').style.display = 'none';
        }
        else{
            document.getElementById('ControlDisplay').style.display = '';
             document.getElementById('ControlDisplay1').style.display = '';
             document.getElementById('ControlDisplay2').style.display = '';
             document.getElementById('ControlDisplay3').style.display = '';
        }
        
    },
    displayDeleteIcon : function(component, event, helper)
    {  
        var IsTrue=component.get("v.IsDeleteIconDisplay");
        if (IsTrue==false){
            document.getElementById('deletecontrol').style.display = 'none';
        }
        else{
            document.getElementById('deletecontrol').style.display = 'block';
        }
        
    },
})