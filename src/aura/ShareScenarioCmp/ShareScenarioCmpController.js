({
	closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.show_sharing_popup", false);
   },
    doinit:function(component, event, helper){
        
      },
    onChange: function(cmp) {
       //  var dynamicCmp = cmp.find("InputSelectDynamic");
//alert();
      //   alert(cmp.get("v.selected_user"));

     },
    shareRec:function(component, event, helper) {
        var cid = component.get("v.selectedContactRecord.Id");
        var action = component.get("c.shareto_portalUsers");
       // alert(component.get("v.selected_record"));
        action.setParams({
            "cid":cid,
            "recId":component.get("v.selected_record")
        });
        action.setCallback(this,function(data){
            var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "message": "Scenario shared successfully"
    });
    toastEvent.fire();
              component.set("v.isShared",true);
            component.set("v.show_sharing_popup",false);
        });
        $A.enqueueAction(action);
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
       handleComponentEvent: function(component, event, helper) {        
        // get the selected Account record from the COMPONETN event      
        var selectedAccountGetFromEvent = event.getParam("accountByEvent"); 
           console.log(' selectedAccountGetFromEvent ',selectedAccountGetFromEvent.Name);
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
           component.set("v.serachContact",false);
    },
 	 clear: function(component, event, heplper) {  
                 component.set("v.serachContact",true);
   
        var txtidControl = component.find("secret");
        txtidControl.set("v.value", "");        
        var commentsControl = component.find("secret");
        var commentsControlvalue = commentsControl.get("v.value");
        // alert(commentsControlvalue);        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField");        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');        
        component.set("v.SearchKeyWord", null);
        component.set("v.listOfSearchRecords", null);
         component.set("v.showAlert", false);
        component.set("v.showError", false);
        if (commentsControlvalue == '') {
            var newselectedRecord = {
                'sobjectType': 'Account',
                'Name': ''
            };
            //resetting the Values in the form
            component.set("v.selectedRecord", newselectedRecord);          
        }
    },
     keyPressContactController: function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWordContact");
         var Accountid = component.find("secret").get("v.value");// '0012900000Ca50P';
        //alert(Accountid);
         if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchContactRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchContactHelper(component, event, getInputkeyWord,Accountid);
        } else {
            component.set("v.listOfSearchContactRecords", null);
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
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
       handleComponentEventContact: function(component, event, helper) {        
        // get the selected Account record from the COMPONETN event      
        var selectedContactGetFromEvent = event.getParam("contactByEvent"); 
        component.set("v.selectedContactRecord", selectedContactGetFromEvent);        
        var forclose = component.find("lookup-pill-contact");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');       
        var forclose = component.find("searchContactRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');        
        var lookUpTarget = component.find("lookupContactField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
           component.set("v.readytoShare",false);
      //     component.set("v.serachContact",false);
    },
 	 clearContact: function(component, event, heplper) {  
        var pillTarget = component.find("lookup-pill-contact");
        var lookUpTarget = component.find("lookupContactField");        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');        
        component.set("v.SearchKeyWordContact", null);
        component.set("v.listOfSearchContactRecords", null);
            var newselectedRecord = {
                'sobjectType': 'Contact',
                'Name': ''
            };
            //resetting the Values in the form
            component.set("v.selectedContactRecord", newselectedRecord);          
        
    }

})