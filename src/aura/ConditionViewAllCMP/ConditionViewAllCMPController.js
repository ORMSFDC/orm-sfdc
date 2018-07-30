({
    navHome : function (component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Loan_New__c"
        });
        homeEvent.fire();
    }, 
    createRecord : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId":component.get("v.recordId")
        });
        navEvt.fire();
    },
    getAddModalValue: function(component, event, helper) {
        var boolVal = event.getParam("ModalValue");    
        component.set("v.showAddConditionPopup",boolVal);
    },
    getModalValue: function(component, event, helper) {
        var boolVal = event.getParam("ModalValue");    
        component.set("v.showEditConditionPopup",boolVal);
    },
    OpenAddConditionModal : function(component, event, helper) {
        component.set("v.showAddConditionPopup",true);
    },
    
    CloseAddConditionModal : function(component, event, helper) {
        component.set("v.showAddConditionPopup",false);
    },
    CloseHisConditionModal: function(component, event, helper) {
        component.set("v.showHistoryConditionPopup",false);
    },
    doAction : function(component, event, helper) {
        component.find("item_in_kit").SaveCondition();
        helper.PopulateCondition(component, event, helper) ;  
        helper.PopulateCount(component, event, helper) ;         
    },
    doActionEdit : function(component, event, helper) {
        component.find("Edit").SaveEditCondition();
        helper.PopulateCondition(component, event, helper) ;  
        helper.PopulateCount(component, event, helper) ; 
    },
    doInit: function(component, event, helper) {  
        helper.showSpinner(component) ;
        helper.LoanName(component, event, helper) ;
        helper.PopulateCondition(component, event, helper) ;  
        helper.PopulateCount(component, event, helper) ;  
    },  
    handleMenuSelect: function(component, event, helper) {        
        var menuValue = event.detail.menuItem.get("v.label");
        var title = event.detail.menuItem.get("v.title");        
        var selectedMenuItemValue = event.getParam("value");
        if(menuValue=='Edit')
        { 
            var id=selectedMenuItemValue;
            var conid=title;
            component.set("v.ConditioEditId",conid);
            component.set("v.ConditioRowId",id);
            component.set("v.showAddConditionPopup",false);            
            component.set("v.showEditConditionPopup",true);
            
        }
        else  if(menuValue=='View History')        {
            var id=selectedMenuItemValue;
            var conid=title;
            component.set("v.ConditioHisroryId",conid);
            component.set("v.ConditioRowId",id);
            component.set("v.showAddConditionPopup",false);
            component.set("v.showHistoryConditionPopup",true);
            component.set("v.showEditConditionPopup",false);
        }
        
    },
    CloseEditConditionModal : function(component, event, helper) {
        component.set("v.showEditConditionPopup",false);
    },
})