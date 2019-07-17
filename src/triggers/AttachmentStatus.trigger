/**
 * @description AttachmentStatus
 * @date 06/21/17      
 * @author Ravi
 * @changelog: Sahitya: 02/06/19 - Do not send upload emails to PCS but create tasks for them
 */

trigger AttachmentStatus on Attachment(after insert) {
    Attachment att = trigger.New[0];
    string attachmentId = att.Id;

    if(Trigger.isInsert && Trigger.isAfter){     
            attachmentTriggerHandler.createRecordandEmail(attachmentId, (List<Attachment>)Trigger.new); 
    }
     System.debug('att--->'+att);    
    
}