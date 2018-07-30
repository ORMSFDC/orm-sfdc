({
    //Client Search
    searchHelper: function(component, event, getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchAccount");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }                
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }            
        });
        // enqueue the Action  
        $A.enqueueAction(action);        
    },
    PopulateScenariosBasedonClient: function(component, event, helper) {     
        var ClientId =component.find("secret").get("v.value");             
        var action = component.get("c.getScenarioList");        
        action.setParams({
            ClientID: ClientId
        });
        action.setCallback(this, function(data) {
            var result= data.getReturnValue();
            component.set("v.percentage","%");
            component.set("v.viewText","View");
            component.set("v.scenarios",result);          
        });
        $A.enqueueAction(action); 
    },    
     getCaseList: function(component, event, helper) {
    var action = component.get("c.getScenarioList");        
      
        action.setCallback(this, function(data) {
            var result= data.getReturnValue();
            component.set("v.scenarios",result.Acc);  
            component.set("v.total", result.Count);
            component.set("v.showtable",true);
            component.set("v.show_pagination",true);
             
        });
   
    $A.enqueueAction(action);
  },
    getSearchInstance :function(component){
    	var action = component.get("c.get_searchInstance");        
      
        action.setCallback(this, function(data) {
            
            component.set("v.searchValues",data.getReturnValue());
        });    
 			   $A.enqueueAction(action);
        
    },
    
    
      getCaseListBasedonSearch: function(component, event, helper) {
    var action = component.get("c.getsearchScenarioList");        
      var searchItem = component.get("v.searchValues");
          try{
          if(searchItem.DOB==""){
              searchItem.DOB = null;
          }
          }catch(err){
              
          }
          var sData =  JSON.stringify(searchItem);
          console.log('sData ',sData);
              var ClientId =component.find("secret").get("v.value");             
    
         action.setParams({
              
              searchdata:sData,
             getsearchScenarioList:ClientId,
             pageNum:(component.get("v.page")-1)*10,
               sort_Column:component.get("v.sortColumn").replace('__r','__r.'),
              sortorder:component.get("v.sort_order")
          });
        action.setCallback(this, function(data) {
          //   component.set('v.showAllTables',true);
      
		//component.set('v.showAll',false);        
            var result= data.getReturnValue();
           console.log(result);
            component.set("v.scenarios",result.Acc);  
            component.set("v.total", result.Count);
            component.set("v.showtable",true);
            component.set("v.show_pagination",true);
             
    
     
        });
    $A.enqueueAction(action);
  },
    
    delete_sn:function(component,event,helper){
        
         console.log(event.target.dataset);
        
        if(event.target.dataset.isconverted =='false'){
            //delete the senario
            component.set("v.message_is", "Are you sure to delete this scenario");
           component.set("v.senario_delete",event.target.dataset.id);
            component.set("v.candelete",true);
        }else{
            //can't delete the senario
            component.set("v.message_is", "You cannot delete this scenario because it has already been converted.");
            component.set("v.candelete",false);
        }
    },
    
    confir_Delte:function(component,event,helper){
         var action= component.get("c.Senariodelete");
      console.log('action ',action);
        var del  = component.get("v.senario_delete");
     // alert('deleteid asdf 123 ASDF '+del);
        
     //   console.log('action ',action);
         action.setParams({
            sel_sn:del
        });
        
         action.setCallback(this, function(response) {

           component.set("v.senario_delete_popup",false); 
            //alert('deleted');
           // helper.getCaseList(component);
          var new_senarios = [];
             for (var i=0;i<component.get("v.scenarios").length-1;i++){
                 
                 if(component.get("v.scenarios")[i].Id != del){
                    new_senarios.push(component.get("v.scenarios")[i]);//.remove(); 
                     
                 }
             }
             
             component.set("v.scenarios",new_senarios);
              component.set("v.total", component.get("v.total")-1);
            component.set("v.showtable",true);
            component.set("v.show_pagination",true);
            // $A.get('e.force:refreshView').fire();
            
        });
        console.log('Enqueuing action');
        $A.enqueueAction(action);    
        console.log('Enqueuing action done');
       // $A.run();
    },
    do_reset_filters:function(component,event,helper){
       //    $('#sampleTable').DataTable().destroy();
     //   $('#sampleTable').DataTable().columns(1).search('Amanda').draw();
       component.set('v.showAllTables',false);
    //    var spinner = component.find("mySpinner");
    //    $A.util.removeClass(spinner, "slds-hide");
    //    $A.util.addClass(spinner, "slds-show");
        this.getCaseList(component, event, helper);
        component.set('v.showAllTables',true);
    },
      getCaseList_pagination: function(component, event, helper) {
    var action = component.get("c.getScenario_nextPage");        
          action.setParams({
              pageNumber:(component.get("v.page")-1)*10,
              sort_Column:component.get("v.sortColumn").replace('__r','__r.'),
              sortorder:component.get("v.sort_order")
          });
        action.setCallback(this, function(data) {
                 component.set("v.show_pagination",false);
   
            var result= data.getReturnValue();
            component.set("v.scenarios",result.Acc);  
            component.set("v.total", result.Count);
            component.set("v.showtable",true);
            component.set("v.show_pagination",true);
             
        });
   
    $A.enqueueAction(action);
  }
    
})