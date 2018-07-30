/** * File Name   : UserTriggerHandler.apxc
*     Description : Used to share the loan records if the Role is added/edited
*     Created     : 11/06/2017
*     Copyright   :  
*   * @author     : Prsn
*   * ModifiedBy  : Nausad
* */

public class UserTriggerHandler {
    
    public static void handleAfterInsert(Map<Id,User> newUserMap) {
        Set<Id> businessIndividualIDSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> scenarioAccountIdSet = new Set<Id>();
        
        List<User> userList = [Select Id,IsPortalEnabled, Name, ContactId, Contact.AccountId, UserRoleId, isactive, (Select Id, Name From Scenarios__r) From User Where Id in: newUserMap.Keyset() AND isActive = true AND ContactId != Null];
        List<Scenario__c> scenarioList = new List<Scenario__c>();
        
        for(User user : userList) {
            businessIndividualIdSet.add(user.ContactId);
            scenarioAccountIdSet.add(user.Contact.AccountId);
        }
        
        scenarioList = [select id from Scenario__c where PartnerId__r.Contact.AccountId in: scenarioAccountIdSet];
        if(scenarioList.size() > 0) {
            BackendHierarchyFuture.updateSharingFuture(new Map<Id,Scenario__c>(scenarioList).keyset(),'Scenario__c');   
        }
        
        List<Contact> businessIndividualList = [Select Id,Name,AccountId from Contact where Id in: businessIndividualIDSet];
        for(Contact con : businessIndividualList) {
            accountIdSet.add(con.AccountId);
        }
        
        List<Account> accountList = [Select Id,Name,(Select Id,Name from Loans__r) from Account where Id in: accountIdSet];
        List<Loan_New__c> loanList = new List<Loan_New__c>();
        if(accountList.size() > 0) {
            for(Account acc : accountList) {
                if(acc.Loans__r.size() > 0) {
                    loanList.addAll(acc.Loans__r);
                }
            }
        }
        
        if(loanList.size() > 0 ) {
            BackendHierarchyFuture.updateSharingFuture((new Map<Id,Loan_New__c>(loanList)).keyset(), 'Loan_New__c');
        } 
        
		//added 
        List<User> UserData = [Select Id,IsPortalEnabled, Username,ContactId, UserRoleId,isactive
                               From User Where Id in: newUserMap.Keyset() AND ContactId != Null];
        for(User user : UserData) {
            string  UserName=[select Username__c from contact where id=:user.contactid].Username__c;
            if(user.ContactId != Null) {
                if(user.IsPortalEnabled==true && user.Username!=UserName)
                {
                    ContactUpdate(user.contactid,user.Username);
                }             
            }
        }
        
    }
    
    public static void handleAfterUpdate(Map<Id,User> newUserMap, Map<Id,User> oldUserMap) {
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> scenarioAccountIdSet = new Set<Id>();
        
        List<User> userList = [Select Id, Name, ContactId, Contact.AccountId, IsPortalEnabled, isactive, UserRoleId, (Select Id, Name From Scenarios__r) From User Where Id in: newUserMap.Keyset() AND isActive = true AND ContactId != Null];
        List<Scenario__c> scenarioList = new List<Scenario__c>();
        
        for(User user : userList) {
            if(user.ContactId != Null) {
                
                if(oldUserMap.get(user.Id).UserRoleId != user.UserRoleId) {
                    contactIdSet.add(user.ContactId);
                    userIdSet.add(user.Id);
                    
                    scenarioAccountIdSet.add(user.Contact.AccountId);                   
                }
            }
        }
        System.debug('userIdSet = '+userIdSet );
        System.debug('scenarioList = '+scenarioList);
        scenarioList = [select id from Scenario__c where PartnerId__r.Contact.AccountId in: scenarioAccountIdSet];
        if(scenarioList.size() > 0 || userIdSet.size() > 0) {
          BackendHierarchyFuture.updateDeleteSharingFuture(userIdSet,new Map<Id,Scenario__c>(scenarioList).keyset(),'Scenario__c');
        }
        
        //List<Loan_New__share> loanShareList = [Select Id from Loan_New__share where UserOrGroupId in: userIdSet AND (RowCause = 'Manager__c' OR RowCause = 'Executive__c')];
        // delete loanShareList;
        // LoanFuture.deleteLoanShare(UserIdSet);
        
        List<Contact> businessIndividualList = [Select Id,Name,AccountId from Contact where Id in: contactIdSet];
        for(Contact con : businessIndividualList) {
            accountIdSet.add(con.AccountId);
        }
        
        List<Account> accountList = [Select Id,Name,(Select Id,Name from Loans__r) from Account where Id in: accountIdSet];
        List<Loan_New__c> loanList = new List<Loan_New__c>();
        if(accountList.size() > 0) {
            for(Account acc : accountList) {
                if(acc.Loans__r.size() > 0) {
                    loanList.addAll(acc.Loans__r);
                }
            }
        }
        
        if(loanList.size() > 0 || userIdSet.size() > 0 ) {
           BackendHierarchyFuture.updateDeleteSharingFuture(userIdSet, (new Map<Id,Loan_New__c>(loanList)).keyset(),'Loan_New__c');
        }
        
    }  
    @future
    private static void ContactUpdate(string ContactID,string UserName )
    {
        Contact cnt=new Contact();
        cnt.id=ContactID;
        cnt.Username__c=UserName;   
        update cnt; 
    }
}