({
    // screen pop to the contact home, and use the call provider to make a call
    init : function(cmp, event, helper) {
        helper.screenPopAndCall(cmp);
        helper.getTodayDate(cmp);
        helper.helperFun(cmp,event,'articleOne')
        helper.helperFun(cmp,event,'articletwo')
        helper.getCurrentUserName(cmp);
        helper.fetchStatusValues(cmp);
        helper.fetchSubjectTypeValues(cmp);
    },
    
    
    // Update Task and Close Panel
    UpdateTaskAndClose : function(cmp, event, helper) {
        var SubjectVal=cmp.find('tsk_Subject').get('v.value');
        var CommentsVal=cmp.find('comments').get('v.value');
         var SubjectTypeVal=cmp.find('SubjectType').get('v.value');
        var CreateFollowUp_TaskVal =cmp.find('selFollowup').get('v.value');
        var FollowUp_DueDateVal=cmp.find('txtFollowDueDate').get('v.value');
        if(FollowUp_DueDateVal=="")
        {
            FollowUp_DueDateVal=null;
        }
        var FollowUp_SubjectVal=cmp.find('txtSubject').get('v.value');
        var FollowUp_StatusVal=cmp.find('Status').get('v.value');
        var FollowUp_CommentsVal=cmp.find('txtFollowupComments').get('v.value');
        var FollowUp_ReminderVal=cmp.find('chkReminder').get('v.value');
        var FollowUp_ReminderDatetimeVal=cmp.find('ReminderDateTime').get('v.value');
        var FollowUp_NotesVal=cmp.find('followupNotes').get('v.value');
        if(FollowUp_ReminderDatetimeVal=="")
        {
            FollowUp_ReminderDatetimeVal=null;
        }
        var IsCreateFollowUp_TaskVal_Validated=true;
        if(typeof CreateFollowUp_TaskVal==='undefined' || CreateFollowUp_TaskVal=='' || CreateFollowUp_TaskVal==null)
        {}else{
            if(CreateFollowUp_TaskVal=='YES')
            {
                IsCreateFollowUp_TaskVal_Validated=helper.Validate_FollowUp_IFYes(cmp,event,helper,'txtFollowDueDate','txtFollowupComments');
                
            }
            else if(CreateFollowUp_TaskVal=='NO')
            {
                IsCreateFollowUp_TaskVal_Validated=helper.Validate_FollowUp_IFNO(cmp,event,helper,'followupNotes');
                
            }
        }
        var IsFollowUp_ReminderDatetimeValidated=true;
        if(FollowUp_ReminderVal)
        {
            IsFollowUp_ReminderDatetimeValidated=helper.Validate_ReminderDatetime(cmp,event,helper,'ReminderDateTime');  
        }
        else{FollowUp_ReminderDatetimeVal=null}
        if(IsCreateFollowUp_TaskVal_Validated && IsFollowUp_ReminderDatetimeValidated)
        {
            cmp.set("v.showError", false); 
            var responsedata = {
                
                Subject						:	SubjectVal,
                SubjectType					:	SubjectTypeVal,
                Comments					:	CommentsVal,
                CreateFollowUp_Task 		:	CreateFollowUp_TaskVal,
                FollowUp_DueDate			:	FollowUp_DueDateVal,
                FollowUp_Subject			:	FollowUp_SubjectVal,
                FollowUp_Status				:	FollowUp_StatusVal,
                FollowUp_Comments			:	FollowUp_CommentsVal,
                FollowUp_Reminder			:	FollowUp_ReminderVal,
                FollowUp_ReminderDatetime	:	FollowUp_ReminderDatetimeVal,
                FollowUp_Notes				:	FollowUp_NotesVal,
            };
            var data=responsedata;
            
            helper.UpdateTask(cmp,event,helper,responsedata);
        }
        else{
            cmp.set("v.showError", true); 
        }
    },
    sectionOne : function(component, event, helper) {
        helper.helperFun(component,event,'articleOne');
    },
    sectiontwo : function(component, event, helper) {
        helper.helperFun(component,event,'articletwo');
    },
    followChange : function(cmp, event, helper) {
        helper.followChange(cmp,event,helper);
    },
    toggle : function(component, event, helper) {
        var toggleText = component.find("mySelectedDateTime");
        $A.util.toggleClass(toggleText, "slds-show");
    },
    
})