//Trigger to update dates in Business Partners object
trigger UpdateDatesTrigger on Account (before update, before insert,After Update) 
{
    
    if(trigger.isUpdate)
    {   
        if (Trigger.isBefore) {
            UpdateDatesTriggerHandler updateDates = new UpdateDatesTriggerHandler();
            UpdateDates.updateDatesForPartner(Trigger.new, Trigger.oldMap);
            UpdateDates.AcocuntApproved(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isAfter) {
            UpdateDatesTriggerHandler AccountTriggerHandler = new UpdateDatesTriggerHandler();
            AccountTriggerHandler.AfterUpdate(Trigger.old[0],Trigger.new[0]);
        }
    }   
    
    else if (trigger.isInsert)
    {
        if (Trigger.isBefore) {
            UpdateDatesTriggerHandler updateDates = new UpdateDatesTriggerHandler();
            UpdateDates.updateDatesForPartner(Trigger.new);
        }
    }
}