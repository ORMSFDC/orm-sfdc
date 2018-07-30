/** *
*     Original comments header - not changed
*     File Name   : TriggerLoanStatusTrack.apxt
*     Description : calling TriggerLoanStatusTrackHandler to share the loan records
*     Modified    : 10/30/2017, prsn
*     Copyright   :  
*   * @author     :
* */

/**
 * @description TriggerLoanStatusTrack (Refactor Exercise)
 * @date 06/21/18
 * @author Mike Gill
 *
 * Legacy Issues with code
 * @TODO Move Line 147/149 into @future if required
 * @TODO Not Bulkified at all - Line 23/24 (entire class needs refactoring)
 * @TODO Move emails into PB
 *
 */


trigger TriggerLoanStatusTrack on Loan_New__c (After Update) {
    if(trigger.isAfter && trigger.isUpdate) {
       
        Loan_New__c oldvalue=trigger.old[0];
        Loan_New__c Newvalue=trigger.New[0];        
        string LoanId=Newvalue.Id;

        // MG/QDA Added to future
        /*
        if(!Newvalue.LoanCompleteFlag__c){
            SAL_ApexManagedSharingController.ShareLoanRecord(oldvalue,Newvalue); // MG/QDA Called via LoanSharingHandler
        }
        */

        // MG/QDA Added to future
        if(Newvalue.LoanCompleteFlag__c && !oldvalue.LoanCompleteFlag__c && (oldvalue.OwnerId!= Newvalue.OwnerId))
        {
            //SAL_ApexManagedSharingController.UpdateOwnerAfterLoanSubmit(LoanId,oldvalue,Newvalue); // MG/QDA Called via LoanSharingHandler
            if(Userinfo.getUserId()!=Newvalue.OwnerId)
            {
                User OwnerObj=[Select Name,Email from user where id=:Newvalue.OwnerId];
                MailSend.SendMail2Partnernew(Newvalue.Name,OwnerObj.name,OwnerObj.email);
                MailSend.SendMail2Partnernew(Newvalue.Name,UserInfo.getName(),UserInfo.getUserEmail());
                MailSend.SendMail2ORMnew(Newvalue.Name,OwnerObj.name,OwnerObj.email);
                
            }
            else{
                MailSend.SendMail2Partnernew(Newvalue.Name,UserInfo.getName(),UserInfo.getUserEmail());
                MailSend.SendMail2ORMnew(Newvalue.Name,UserInfo.getName(),UserInfo.getUserEmail()); 
            }
            
        }

        if(Newvalue.LoanCompleteFlag__c && !oldvalue.LoanCompleteFlag__c && !Newvalue.IsLoanCreatedByLoanProcessor__c)
        {
            if(Userinfo.getUserId()!=Newvalue.OwnerId)
            {
                
                User OwnerObj=[Select Name,Email from user where id=:Newvalue.OwnerId];
                //Mail to Owner
                MailSend.SendMail2Partnernew(Newvalue.Name,OwnerObj.name,OwnerObj.email);
                //Mail to application Submitter/CurrentUsrObj
                MailSend.SendMail2Partnernew(Newvalue.Name,UserInfo.getName(),UserInfo.getUserEmail());
                MailSend.SendMail2ORMnew(Newvalue.Name,OwnerObj.name,OwnerObj.email);
                
            }
            else{
                MailSend.SendMail2Partnernew(Newvalue.Name,UserInfo.getName(),UserInfo.getUserEmail());
                MailSend.SendMail2ORMnew(Newvalue.Name,UserInfo.getName(),UserInfo.getUserEmail());
            }
        }
    }    
    
  
    
    // trigger for updating loan fields in Bussiness partner
    if(trigger.isAfter && trigger.isUpdate)  {
      
            // added check if running user is Automated Process, to catch query exception against Profile
            if ( trigger.new[0].Loan_Processor__c != null ) {
                try {
                    Profile ProfileName = [select Name from profile where id = :userInfo.getProfileId()];
                    if ( ProfileName.name != 'ORM Partner' && ProfileName.name != 'ORM Partners' ) {
                        SAL_ApexManagedSharingController.DeleteSharedRecord( trigger.new[0].Id, 'Manual' );
                        SAL_ApexManagedSharingHelperController.InsertRecordsForSharing( trigger.new[0].Id, trigger.new[0].Loan_Processor__c, 'Manual' );
                    }
                }
                catch ( QueryException qe ) {}
            }
    }
    
}