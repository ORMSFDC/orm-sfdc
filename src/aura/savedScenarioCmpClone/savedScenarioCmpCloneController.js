({    
    doInit: function(component, event, helper) {    
        helper.getCaseList(component);  
        helper.getSearchInstance(component); 
    },
    
    
    columnSort :function(component, event, helper){
        component.set('v.show_arrows',false);
        var currentColumnOrder = component.get("v."+event.target.id);
        // alert(event.target.id);
        var  nextOrder ;
        if(currentColumnOrder){
            nextOrder = false;
        }
        else{
            nextOrder = true;
        }
        //  alert(nextOrder);
        component.set("v."+event.target.id,nextOrder);
        component.set("v.sortColumn",event.target.id);
        var sortOrder = (nextOrder==false)?'ASC':'DESC';
        component.set("v.sort_order",sortOrder);
       // component.set("v.sortColumn",)
       // alert(sortOrder);
           var searchItem = component.get("v.searchValues");
          try{
          if(searchItem.DOB==""){
              searchItem.DOB = null;
          }
          }catch(err){
              
          }
         var sData =  JSON.stringify(searchItem);
          console.log('sData>> ',sData);
         
       if(searchItem.Address!='' ||  searchItem.Email!='' ||  searchItem.FirstName!='' || searchItem.LastName!='' ||   searchItem.Phone!='' || (searchItem.DOB!='' &&  searchItem.DOB!=null))
       {
           console.log('search pagination');
             helper.getCaseListBasedonSearch(component, event, helper);
       }else{
        
           console.log('Normal pagination');
         
                  helper.getCaseList_pagination(component, event, helper);  
    	
          }   
      
      //  helper.getCaseList_pagination(component, event, helper);
    },
    keyPressController: function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component, event, getInputkeyWord);
        } else {
            component.set("v.listOfSearchRecords", null);
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },    
    // function for clear the Record Selaction 
    clear: function(component, event, heplper) {
        
        
        var txtidControl = component.find("secret");
        txtidControl.set("v.value", "");
        
        var commentsControl = component.find("secret");
        var commentsControlvalue = commentsControl.get("v.value");
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField");        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');        
        component.set("v.SearchKeyWord", null);
        component.set("v.listOfSearchRecords", null);
        if (commentsControlvalue == '') {
            var newselectedRecord = {
                'sobjectType': 'Lead',
                'Id':'',
                'FiratName': '',
                'LastName': '',
                'Street': '',
                'State': '',
                'PostalCode': '',
                'Email': '',
                'Phone': ''
            };
            //resetting the Values in the form
            component.set("v.selectedRecord", newselectedRecord);
            var newscenarioRecord = {
                'sobjectType': 'scenario__c',
                'Id':null,
                'Monthly_Mortgage_Payment__c': null,
                'Current_Mortgage_Balance__c': null,
                'Current_Mortgage_Interest_Rate__c': null,
                'Estimated_home_value__c': null,
                'CreatedDate': null                
            };
            //resetting the Values in the form
            component.set("v.scenarios", newscenarioRecord);
            component.set("v.percentage",null);
            component.set("v.viewText",null);
            component.set("v.IsGraphDisplay",false);            
        }        
    },    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent: function(component, event, helper) {
        debugger;
        // get the selected Account record from the COMPONETN event      
        var selectedAccountGetFromEvent = event.getParam("accountByEvent");        
        component.set("v.selectedRecord", selectedAccountGetFromEvent);       
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');       
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');
        helper.PopulateScenariosBasedonClient(component, event, helper);        
    },
    // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner: function(component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible: false });
        evt.fire();
    },
    // automatically call when the component is waiting for a response to a server request.
    showSpinner: function(component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible: true });
        evt.fire();
    },
    GetScenarioId : function(component, event, helper) {           
        var id=event.target.id;
        component.set("v.Scenario_ID",id);
        component.set("v.IsGraphDisplay",false);
        component.set("v.IsGraphDisplay",true);
    },
    save_pdf : function(component, event, helper) {
        //alert();
        //   location.hash = "";
        //alert('>>>> '+location.hash);
        var spinner = component.find("print_Spinner");
        $A.util.addClass(spinner, "slds-show");
        if(location.hash != '#savePdf')
            location.hash = "savePdf";
        else
            location.hash = "Pdfsave";
        
    },
    print_pdf : function(component, event, helper) {
        if(location.hash != '#printPdf')
            location.hash = "printPdf";
        else
            location.hash = "Pdfprint"; 
        
    },
    //prsn
    printDocument: function(component, event, helper){
	var host = window.location.hostname;
        var frameSrc = 'https://' + host + '/apex/pdfSavedScenario?id=' + component.get('v.Scenario_ID');
        window.open(frameSrc, '_blank');        

    },
    
    draw :function(component, event, helper){
        
        //var spinner = component.find("mySpinner");
       // $A.util.toggleClass(spinner, "slds-show");
        
       // $('#sampleTable').DataTable().destroy();
        //   $('#sampleTable').DataTable().columns(1).search('Amanda').draw();
       // component.set('v.showAllTables',false);
       component.set("v.page",1);
        helper.getCaseListBasedonSearch(component);
        
        
    },
    
    reset_filters : function(component, event, helper){
        var sel =  component.get("v.searchValues");
        sel.FirstName= '';
        sel.DOB = '';
        sel.Email = '';
        sel.LastName = '';
        sel.Address = '';
        sel.LoanOriginatorFormatPhone = '';
        component.set("v.searchValues",sel);
             helper.getCaseList(component);  
   
       // helper.do_reset_filters(component,event,helper);
        // location.reload();
       //  $A.get('e.force:refreshView').fire();
    },
    LoanOriginatorFormatPhone: function(component, event, helper){
        //    alert(component.get("v.searchValues.Phone"));
        if(undefined != component.get("v.searchValues.Phone") && null != component.get("v.searchValues.Phone") && ''!= component.get("v.searchValues.Phone")){
            console.log('>>>>> ');
            var a = component.get("v.searchValues.Phone");  
            if(isNaN(a) && a.length < 10){
                component.set("v.searchValues.Phone",'');
            }
            if(a.length == 10){ 
                var rxp = new RegExp("^(\\d)\\1{9}$");
                
                var  isRegValid = rxp.test(a);
                if(isRegValid)
                {
                    component.set("v.searchValues.Phone",'');
                }else{
                    var s2 = (""+a).replace(/\D/g, '');
                    var m = s2.match(/^(\d{3})(\d{3})(\d{4})$/);    
                    var result= (!m) ? null : "(" + m[1] + ") " + m[2] + "-" + m[3];
                    //  alert(result);
                    component.set("v.searchValues.Phone",result);
                }
            }
        }
    },
    EmailValidation:function(component) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var flagR = false;
        var EmailInput = component.find("inputEmail");
        var EmailInputValue = EmailInput.get("v.value");
        if(!$A.util.isEmpty(EmailInputValue)&& !EmailInputValue.match(regExpEmailformat))
        {
            EmailInput.set("v.errors", [{ message:"Please enter valid email id."}]); 
            flagR=true;
        }
        else{
            EmailInput.set("v.errors", null);             
        }
        //  return flagR;
    },
    optionChanged:function(component, event, helper){
        //    alert(component.get("v.showLoan"));
        var lnId= component.get("v.showLoanId");
        //  alert("showLoanId "+component.get("v.ApplicationDate"));
        $A.createComponent( //SFDC - 360
            "c:StartNewLoanProductContainer",            
            {
                "ApplicationDate":component.get("v.ApplicationDate"),
                "LoanId":component.get("v.showLoanId"), 
                "fromPopup":true
            },
            function(newCmp){
                if (component.isValid()) {
                    //           alert();
                    component.set("v.body", newCmp);
                }
            }
        );
    },
    delete_senario:function(component,event,helper){
        component.set("v.senario_delete_popup",true); 
        
        helper.delete_sn(component,event,helper);
        
    },
    close:function(component,event,helper){
        component.set("v.senario_delete_popup",false); 
        
    },
    confirDelte:function(component,event,helper){
     
        helper.confir_Delte(component,event,helper);
    },
    confirDelteNew:function(component,event,helper){
        helper.sn_del(component,event,helper);
    },
   
     pageChange: function (component, event, helper) {
        var page = component.get("v.page") || 0;
        var direction = event.getParam("direction");
        if (/^\d+$/.test(direction)) {
            page = direction;
        } else {
            page = direction === "previous" ? (page - 1) : (page + 1);
        }
         
        component.set("v.page", page);
            var searchItem = component.get("v.searchValues");
          try{
          if(searchItem.DOB==""){
              searchItem.DOB = null;
          }
          }catch(err){
              
          }
         var sData =  JSON.stringify(searchItem);
          console.log('sData>> ',sData);
         
       if(searchItem.Address!='' ||  searchItem.Email!='' ||  searchItem.FirstName!='' || searchItem.LastName!='' ||   searchItem.Phone!='' || (searchItem.DOB!='' &&  searchItem.DOB!=null))
       {
           console.log('search pagination');
             helper.getCaseListBasedonSearch(component, event, helper);
       }else{
        
           console.log('Normal pagination');
         
                  helper.getCaseList_pagination(component, event, helper);  
    	
          }   
      
   //    helper.myAction_helper(component, event, helper);
    }
})