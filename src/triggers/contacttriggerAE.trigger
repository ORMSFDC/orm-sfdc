trigger contacttriggerAE on Contact (before update) {
    Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
    If(profileName.Name=='Account Executive/CCS')
    {for (Contact con : Trigger.old){
            If(con.Individual_lead_Status__c != 'New'){
              con.addError('You cannot Perform this operation!');  
               
            }
            
        }
    }
  
}