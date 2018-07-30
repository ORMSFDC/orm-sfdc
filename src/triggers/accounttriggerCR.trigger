trigger accounttriggerCR on Account (before update) {
    Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
    if(profileName.Name=='Credit or Risk Analyst')
    
       // If(profileName.Name=='System Administrator')
    {
        for (Account acc : Trigger.old){
            If(acc.Partner_Lead_Status__c == 'New')
            {for (Account acc1 : Trigger.new){
            
            if(acc1.Partner_Lead_Status__c == 'Denied' || acc1.Partner_Lead_Status__c == 'Approved')
            {
            acc.addError('You cannot Perform this operation!'); 
            }
            }
            
            }
             
            
        }
    }
    

}