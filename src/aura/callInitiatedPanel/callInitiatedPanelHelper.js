({
    // get call center settings, to get the information about the call provider
    // then use open CTI to screen pop to the record, and runApex() to make a call
    screenPopAndCall : function(cmp) {
         debugger;
        cmp.getEvent('getSettings').setParams({
            
            callback: function(settings) {
                sforce.opencti.screenPop({
                    type : sforce.opencti.SCREENPOP_TYPE.SOBJECT,
                    params : { recordId : cmp.get('v.recordId') },
                    callback : function(response) {
                        cmp.getEvent('editPanel').setParams({
                            label : 'Log a call : '+cmp.get('v.recordName')+' '+cmp.get('v.phone')+')'
                        }).fire();
                         debugger;
                        sforce.opencti.runApex({
                           
                            apexClass : 'CTIServiceProviderController',
                            methodName : 'getTaskDetails',
                            methodParams : 'RecordID=' + cmp.get('v.recordId') ,
                            callback : function(result) {
                                 debugger;
                                if (result.success) {
                                    var ResultResponse=JSON.parse(result.returnValue.runApex)
                                    var Task_ID=ResultResponse.TaskID;
                                    var PhoneNumber=cmp.get('v.phone');
                                    var ParentID=cmp.get('v.recordId');
                                    cmp.set("v.TaskID",Task_ID);
                                    
                                    var url = "ctiphone:?to="+PhoneNumber+"&system=ORMSLightning&salesforceId="+ParentID+"&TaskId="+Task_ID; 
                                    //alert(url);
                                    ctiWindow = window.open(url, 'cti', 'left=0,top=0,width=1px,height=1px,toolbar=0'); 
                                    setTimeout('ctiWindow.close();', 5000);
                                    
                                } else {
                                    throw new Error('Unable to make a call. Contact your admin.');
                                }
                            }
                        });
                    }
                })
            }
        }).fire();
        
    },
    //Update Task
    UpdateTask: function(cmp,event,helper,responsedata) {
        debugger;
        var requestdata=responsedata;
        var _TaskId=  cmp.get('v.TaskID')
        var _RecordID=  cmp.get('v.recordId')
        var action = cmp.get("c.UpdateTaskDetails");
        action.setParams({
            "TaskId"	: _TaskId,
            "RecordID"	: _RecordID,
            "TaskData"	: JSON.stringify(requestdata),
        });
        action.setCallback(this, function(data) {
            debugger;
            cmp.getEvent('Alert').setParams({
                messagealert: 'Call Ended',
                showhide:true,
            }).fire();
            cmp.getEvent('editPanel').setParams({
                label : 'Log a Call'
            }).fire();
            cmp.getEvent('renderPanel').setParams({
                type : 'c:phonePanel',
                attributes : { presence : 'Available' }
            }).fire();
        });
        $A.enqueueAction(action);
    },
    helperFun : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    getTodayDate: function(cmp) {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1; //January is 0!
        var yyyy = today.getFullYear();
        if(dd<10){
            dd='0'+dd;
        } 
        if(mm<10){
            mm='0'+mm;
        } 
        var today = yyyy+'-'+mm+'-'+dd;
        
        cmp.set('v.FollowUpDueDate', today);
        
        
        //cmp.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
    },
    followChange: function(cmp,event,helper) {
        debugger;
        var selChange= cmp.find('selFollowup').get('v.value');  
        //alert(selChange);
        if(selChange=="YES") 
        {
            var acc = cmp.find('followuppanel');
            $A.util.addClass(acc, 'slds-show');
            var note = cmp.find('notes');
            $A.util.addClass(note, 'slds-hide');
            var nofollowup = cmp.find('nofollowup');
            $A.util.removeClass(nofollowup, 'slds-hide');
            
        }
        else if(selChange=="NO")
        {
            
            var acc = cmp.find('followuppanel');
            $A.util.addClass(acc, 'slds-show');
            var note = cmp.find('notes');
            $A.util.removeClass(note, 'slds-hide');
            var nofollowup = cmp.find('nofollowup');
            $A.util.addClass(nofollowup, 'slds-hide');
            
            
        } 
            else if(selChange=="None")
            {
                var acc = cmp.find('followuppanel');
                $A.util.removeClass(acc, 'slds-show');
            }
    },
    getCurrentUserName: function(cmp) {
        var action = cmp.get("c.getUserName"); 
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                cmp.set("v.assigned", result);
            }
        });
        $A.enqueueAction(action);
    },    
    fetchStatusValues: function(cmp) {
        var action = cmp.get("c.getPickList"); 
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    var selected=false;
                    if(allValues[i]=='Open'){
                        selected=true;
                    }
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i],
                        selected:selected
                    });
                }
                cmp.set("v.StatusList", opts);
            }
        });
        $A.enqueueAction(action);
    }, 
     fetchSubjectTypeValues: function(cmp) {
        var action = cmp.get("c.getSubjectTypePickList"); 
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    var selected=false;
                    if(allValues[i]=='Call'){
                        selected=true;
                    }
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i],
                        selected:selected
                    });
                }
                cmp.set("v.SubjectTypeList", opts);
            }
        });
        $A.enqueueAction(action);
    }, 
   
    
    //Validate if create follow Up task is Yes
    Validate_FollowUp_IFYes:function(component, event, helper,followupduedateID,followCommentID) {
        
        var followupduedateID=followupduedateID;
        var followCommentID=followCommentID;
        var flagR=true;       
        var CommentinputCmp = component.find(followCommentID);      
        var Commentvalue = CommentinputCmp.get("v.value");
        if(typeof Commentvalue==='undefined' || Commentvalue=='' || Commentvalue==null)
        {
            CommentinputCmp.set("v.errors", [{ message: "Please enter Comment."  }]);                        
            flagR = false; 
        } 
        else{CommentinputCmp.set("v.errors", null);}
        //For Follow Up Duedate
        var inputCmp = component.find(followupduedateID);      
        var value = inputCmp.get("v.value");
        if(typeof value==='undefined' || value=='' || value==null)
        {
            inputCmp.set("v.errors", [{ message: "Please enter Due Date."  }]);                        
            flagR = false; 
        } else{
            var year=value.substring(0,4);  
            var month=value.substring(5,7);
            var day=value.substring(8,10);
            DOBValue=month+'/'+day+'/'+year;
            var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/ ;
            if(!(date_regex.test(DOBValue)))
            {
                inputCmp.set("v.errors", [{ message: "Please enter Due Date in MM/DD/YYYY format."  }]);                        
                flagR = false; 
            }
            else{
                
                var selectedDate = new Date(DOBValue),
                    todayDate   = new Date(),
                    diff  = new Date(selectedDate-todayDate),
                    days = (diff) / (1000 * 60 * 60 * 24);       
                if (days < -1) { 
                    inputCmp.set("v.errors", [{ message: "Due Date cannot be previous date." }]);   
                    flagR = false;                 
                } else {
                    inputCmp.set("v.errors", null);
                    //flagR = true; 
                } 
                
                
            }
        } 
        
        return flagR;
    },
    //Validate if create follow Up task is NO
    Validate_FollowUp_IFNO:function(component, event, helper,followCommentID) {
        var followCommentID=followCommentID;
        var flagR=true;       
        var CommentinputCmp = component.find(followCommentID);      
        var Commentvalue = CommentinputCmp.get("v.value");
        if(typeof Commentvalue==='undefined' || Commentvalue=='' || Commentvalue==null)
        {
            CommentinputCmp.set("v.errors", [{ message: "Please enter Notes."  }]);                        
            flagR = false; 
        } 
        else{CommentinputCmp.set("v.errors", null);}
        return flagR;
    },
    //Validate ReminderDatetime
    Validate_ReminderDatetime:function(component, event, helper,reminderdatetimeID) {
        debugger;
        var reminderdatetimeID=reminderdatetimeID;
        var flagR=true;       
        var inputCmp = component.find(reminderdatetimeID);      
        var value = inputCmp.get("v.value");
        if(typeof value==='undefined' || value=='' || value==null)
        {
            inputCmp.set("v.errors", [{ message: "Please enter Reminder Date and time."  }]);                        
            flagR = false; 
        } 
        else{ 
            debugger;
            var year=value.substring(0,4);  
            var month=value.substring(5,7);
            var day=value.substring(8,10);
            DOBValue=month+'/'+day+'/'+year;
            var date_regex = /(\d{4})-(\d{2})-(\d{2})T(\d{2})\:(\d{2})\:(\d{2})[.](\d{3})Z/ ;
            if(!(date_regex.test(value)))
            {
                inputCmp.set("v.errors", [{ message: "Please enter Remainder Date in correct format."  }]);                        
                flagR = false; 
            }
            else{
                
                var selectedDate = new Date(DOBValue),
                    todayDate   = new Date(),
                    diff  = new Date(selectedDate-todayDate),
                    days = (diff) / (1000 * 60 * 60 * 24);       
                if (days < -1) { 
                    inputCmp.set("v.errors", [{ message: "Due Date cannot be previous date." }]);   
                    flagR = false;                 
                } else {
                    inputCmp.set("v.errors", null);
                    //flagR = true; 
                } 
                
                
            }
        }
        return flagR;
    }
    
})