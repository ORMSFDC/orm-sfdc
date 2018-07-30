trigger contacttriggerCR on Contact (before update) {
    Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
    If(profileName.Name=='Credit or Risk Analyst')
    {
        for (Contact con : Trigger.old){
            If(con.Individual_lead_Status__c == 'New')
            {for (Contact con1 : Trigger.new){
            
            if(con1.Individual_lead_Status__c == 'Denied' || con1.Individual_lead_Status__c == 'Approved')
            {
            con1.addError('You cannot Perform this operation!'); 
            }
            }
            
            }
             
            
        }
    }
    

}