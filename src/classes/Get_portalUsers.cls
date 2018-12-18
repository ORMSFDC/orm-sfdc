/**
 * @description Get_portalUsers - This class is used to share the scenario with the portal user from backend calculator
 * @author GalaxE
 * 11/30/2018: Sahitya: SFDC-606 - This code was not updated when ScenarioExportutil got updated for PartnerID__c, there was an issue with blank loan processor in scenario package
 */
 
public class Get_portalUsers {

    @AuraEnabled
    Public Static list<user> get_portalUsers(){        
        return [select id,Name from user where ContactId !=null];
    }
    
    @AuraEnabled
    Public Static void shareto_portalUsers(String cid,String recId){       
        Scenario__c sn = [select id,OwnerId,PartnerId__c from Scenario__c where id=: recId];
        user u = [ select id from user where contactId=:cid];
        sn.OwnerId = u.id;
        sn.PartnerId__c = u.id; //SFDC_606
        update sn;
    }
        
    @AuraEnabled
    public static List < Account > fetchAccount(String searchKeyWord) {        
        System.debug('searchKeyWord '+searchKeyWord);
        String searchKey = searchKeyWord + '%';
        List <Account> returnList = new List < Account > ();
        try{
            System.debug('searchKey '+searchKey);  
            List <Account> lstOfAccount = [select id,Name from Account where Name LIKE: searchKey];            
            for (Account acc: lstOfAccount) {
                system.debug('__________>>>>>>>>>>><<<<<<<<<<<<<<<_________');
                system.debug(acc);
                returnList.add(acc);
            }
        }
        catch(exception e)
        {
            system.debug('fetchAccount--Exception---'+ e);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static List < Contact > fetchContact(String searchKeyWord,String AccId) {
        
        System.debug('searchKeyWord '+searchKeyWord);
        String searchKey = searchKeyWord + '%';
        List <Contact> returnList = new List < Contact > ();
        list<String> ContactIds = new list<String>();
        map<String,contact> cons = new map<String,Contact>();
        try{
            List <Contact> lstOfContact = [select id,Name from Contact where Name LIKE: searchKey and AccountId=:AccId];            
            for (Contact acc: lstOfContact) {
                system.debug('__________>>>>>>>>>>><<<<<<<<<<<<<<<_________');
                system.debug(acc);
                ContactIds.add(acc.id);
                cons.put(acc.id,acc);
            }            
            for(user u:[select id,ContactId from user where ContactId in:ContactIds]){
                returnList.add(cons.get(u.ContactId));
            }
        }
        catch(exception e)
        {}
        return returnList;
    }
}