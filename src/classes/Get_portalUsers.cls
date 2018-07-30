public class Get_portalUsers {

    @AuraEnabled
    Public Static list<user> get_portalUsers(){
        
        return [select id,Name from user where ContactId !=null];
    }
    
      @AuraEnabled
    Public Static void shareto_portalUsers(String cid,String recId){
       // Scenario__Share SS = new Scenario__Share();
        Scenario__c sn = [select id,OwnerId from Scenario__c where id=: recId];
        user u = [ select id from user where contactId=:cid];
        sn.OwnerId = u.id;
        update sn;
       // return [select id,Name from user where ContactId !=null];
    }
        
    @AuraEnabled
    public static List < Account > fetchAccount(String searchKeyWord) {
        
        System.debug('searchKeyWord '+searchKeyWord);
        String searchKey = searchKeyWord + '%';
        List <Account> returnList = new List < Account > ();
        try{
           // List <Client__c> lstOfAccount = [select Name, Id, Last_Name__c, State__c, Zip__c, Email_Optional__c,PartnerID__c,Phone_Number__c,Street_Address__c,DOB__c from Client__c where Name LIKE: searchKey and is_Active__c=true];
         // Id Lead_rec_id = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Loan Lead').getRecordTypeId();
          //  system.debug(Lead_rec_id);and RecordTypeid=:Lead_rec_id
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
              //  returnList.add(acc);
                ContactIds.add(acc.id);
                cons.put(acc.id,acc);
            }
            
            for(user u:[select id,ContactId from user where ContactId in:ContactIds]){
                returnList.add(cons.get(u.ContactId));
            }
        }
        catch(exception e)
        {
         //   system.debug('fetchAccount--Exception---'+ e);
        }
        return returnList;
    }
}