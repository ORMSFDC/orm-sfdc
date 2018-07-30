trigger accounttriggerAE on Account (before update) {
    Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
    
     //If(profileName.Name=='System Administrator')
    If(profileName.Name=='Account Executive/CCS')
    {
        for (Account acc : Trigger.old){
            If(acc.Partner_Lead_Status__c != 'New'){
              acc.addError('You cannot Perform this operation!');  
                
            }
            
        }
    }
    

}