trigger CreateUpdateUser on Contact (after insert,After Update,before update) {
    if(trigger.isInsert && trigger.isAfter) {
        contact cnt1 =new contact();
        cnt1=trigger.new[0];    
        if(cnt1.Check_to_create_a_Prospective_User_Login__c==true)
        {
             CreateNewPortalUser.createUser(cnt1);
        }       
    }
    if( trigger.isUpdate  && trigger.isAfter) {
        contact NewCnt =new contact();
        NewCnt=trigger.new[0];
         contact OldCnt =new contact();
        OldCnt=trigger.old[0];
         Id IndividualLead_RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Individual Leads').getRecordTypeId();
        if(NewCnt.Check_to_create_a_Prospective_User_Login__c==true && OldCnt.Check_to_create_a_Prospective_User_Login__c==false 
           && IndividualLead_RecortypeId==NewCnt.RecordTypeId)
        {
             CreateNewPortalUser.createUser(NewCnt);
        }       
        CreateNewPortalUser.ActiveUser(NewCnt);        
    }
    if(trigger.isUpdate  && trigger.isBefore) {
        Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Approved Individuals').getRecordTypeId();
        Id AccountRecortypeId =Schema.SObjectType.account.getRecordTypeInfosByName().get('Approved Partners').getRecordTypeId();
        
        contact OldCnt =new contact();
        OldCnt=trigger.old[0];
        contact NewCnt =new contact();
        NewCnt=trigger.new[0];
        if(OldCnt.RecordtypeID!=NewCnt.RecordtypeID && NewCnt.RecordtypeID==RecortypeId)
        {
            Account Acc=[Select Name,RecordTypeID from Account where id=:NewCnt.AccountId];
            if(Acc.RecordTypeId==AccountRecortypeId)
            {
                NewCnt.Approved_Date__c=(System.now()).date();
            }
            else{
                NewCnt.addError('BUSINESS_PARTNER: The Business Partner,'+ Acc.Name +', has not yet been approved.');
            }
            
        }
        
    }
    
}