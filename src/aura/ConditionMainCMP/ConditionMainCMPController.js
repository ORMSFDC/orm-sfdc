({
      navigateToMyComponent : function(component, event, helper) {
    var evt = $A.get("e.force:navigateToComponent");
     evt.setParams({
        componentDef : "c:ConditionViewAllCMP",
        componentAttributes: {
            recordId : component.get("v.recordId")
        } 
    });
    evt.fire();
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
        // component.set("v.showAddConditionPopup",false);
        
    },
    doActionEdit : function(component, event, helper) {
        component.find("Edit").SaveEditCondition();
        helper.PopulateCondition(component, event, helper) ;  
        helper.PopulateCount(component, event, helper) ; 
        //component.set("v.showEditConditionPopup",false);
        
    },
    doInit: function(component, event, helper) {  
        
        
        helper.PopulateCondition(component, event, helper) ;  
        helper.PopulateCount(component, event, helper) ;  
    },  
    EditClick: function(component, event, helper) {
        //alert('dd');
        debugger;
        event.getSource().get("v.name")
        
        var id=event.currentTarget.id;
        alert(id);
        // var menuValue = event.detail.menuItem.get("v.label");
        //var title = event.detail.menuItem.get("v.title");
        
        //var selectedMenuItemValue = event.getParam("value");
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
        else  if(menuValue=='View History')
        {
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