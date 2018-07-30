trigger AccountExecutive on Account (before insert) {
    list<String> usersIds = new list<string>();
    for(Account acc:trigger.new){
    if(null!=acc.Account_Executive_Name__c){
        usersIds.add(acc.Account_Executive_Name__c);
        }
        
    }
    try{
    map<id,user> users = new map<id,user>([select id,email from user where id in :usersIds]);
    
     for(Account acc:trigger.new){
            acc.ORM_Account_Executive_Email__c = users.get(acc.Account_Executive_Name__c).Email;
    }
    
    }catch(exception ex){
    
    
    }
}