public class updateCountonAccount{


    public static void countUpdate(list<Scenario__c > oldRec,list<Scenario__c > newRec){
    
    try{
        user u = [select Contact.AccountId from user where id=:userinfo.getuserid()];
        
        Account acc = [select Request__c,ORMS_Number_of_Scenarios_Run__c from Account where id=:u.Contact.AccountId];
        //acc.
        if(oldRec[0].Request_Scenario_Package_Count__c != newRec[0].Request_Scenario_Package_Count__c){ acc.Request__c= null != acc.Request__c?acc.Request__c+1:1; update acc;
        }
        
        }catch(Exception ex){}
    }
}