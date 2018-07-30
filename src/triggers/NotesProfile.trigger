trigger NotesProfile on Note__c (before insert) {
    
    if(trigger.isInsert){
      map<id,profile>ProfileIdandName  = new map<id,profile>();
      
            ProfileIdandName = new map<id,Profile>([select id,Name from Profile]);
    Note__c n = trigger.new[0];    
    n.User_Name__c = userinfo.getName();
    n.User_Profile__c  =ProfileIdandName.get(Userinfo.getProfileId()).Name;
    }
}