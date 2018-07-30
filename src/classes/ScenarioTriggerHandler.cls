/** * File Name   : ScenarioTriggerHandler.apxc
*     Description : Sharing Scenario records and Updating 'ORMS_Saved_Scenarios__c' 
*                   field in Business Partner inthe backend
*     Created     : 11/18/2017
*   * @author     : prsn
* */
public class ScenarioTriggerHandler {
    public static void afterHandler(Map<Id,Scenario__c> oldScenarioMap, Map<Id,Scenario__c> newScenarioMap) {
        List<Scenario__c> scenarioList = [Select id, PartnerId__c, PartnerId__r.Contact.Related_Branch__c, PartnerId__r.ContactId, PartnerId__r.Contact.AccountId From Scenario__c where Id in: newScenarioMap.keySet() AND PartnerId__r.ContactId != null];
        set<Id> branchIdSet = new set<Id>();
        set<Id> accountIdSet = new set<Id>();
        
        for(Scenario__c scenario : scenarioList) {
            branchIdSet.add(scenario.PartnerId__r.Contact.Related_Branch__c);
            accountIdSet.add(scenario.PartnerId__r.Contact.AccountId);
        }
        
        List<Contact> bussinessIndividualList = [Select Id,Name,Related_Branch__c,Related_Branch__r.Name,AccountId From Contact Where Related_Branch__c in: branchIdSet OR AccountId in: accountIdSet];         
        
        Map<Id,User> userMap = BackendHierarchyUtility.getPartnerUserMap();
        
        List<Scenario__share> scenarioShareList = new List<Scenario__share>();      
        
        for(Scenario__c scenario : scenarioList) {
            for(Contact con : bussinessIndividualList) {
                if(scenario.PartnerId__r.Contact.Related_Branch__c == con.Related_Branch__c && userMap.containsKey(con.Id)) {
                    // scenario owner related user
                    User user = userMap.get(scenario.PartnerId__r.ContactId);
                    // user's in same branch
                    User roleUser = userMap.get(con.Id);
                    if(user.UserRole.Name.Contains('User') && !roleUser.UserRole.Name.Contains('User')) {
                        Scenario__share scenarioShare = new Scenario__share();
                        scenarioShare.ParentId = Scenario.Id;
                        scenarioShare.AccessLevel = 'Edit';
                        scenarioShare.UserOrGroupId = roleUser.Id;
                        if(roleUser.UserRole.Name.Contains('Manager')) {
                            scenarioShare.RowCause = Schema.Scenario__share.RowCause.Manager__c;
                        } else if(roleUser.UserRole.Name.Contains('Executive')) {
                            scenarioShare.RowCause = Schema.Scenario__share.RowCause.Executive__c;
                        }
                        scenarioShareList.add(scenarioShare);
                    }else {
                        if(user.UserRole.Name.Contains('Manager') && roleUser.UserRole.Name.Contains('Executive')) {
                            scenario__share scenarioShare = new scenario__share();
                            scenarioShare.ParentId = scenario.Id;
                            scenarioShare.AccessLevel = 'Edit';
                            scenarioShare.UserOrGroupId = roleUser.Id;
                            scenarioShare.RowCause = Schema.scenario__share.RowCause.Executive__c;
                            scenarioShareList.add(scenarioShare);
                        }
                    }
                }else {
                    if(scenario.PartnerId__r.Contact.AccountId == con.AccountId && userMap.containsKey(con.Id)) {
                        User roleUser = userMap.get(con.Id);
                        if(roleUser.UserRole.Name.Contains('Executive')) {
                            scenario__share scenarioShare = new scenario__share();
                            scenarioShare.ParentId = scenario.Id;
                            scenarioShare.AccessLevel = 'Edit';
                            scenarioShare.UserOrGroupId = roleUser.Id;
                            scenarioShare.RowCause = Schema.scenario__share.RowCause.Executive__c;
                            scenarioShareList.add(scenarioShare);
                        }
                    }
                }
            }
        }
            insert scenarioShareList;
    } 
    
    //updating ORMS_Saved_Scenarios__c field in the BackendEnd Bussiness Partner
    public static void updateScenarioPartnerFields(Map<Id, Scenario__c> newScenarioMap) {
        Set<Id> accountIdSet = new Set<Id>();
        List<Account> partnerAccList = new List<Account>();
        System.debug('New Scenario Map Key Set =' +newScenarioMap.keySet());
        
        List<Scenario__c> scenarioList = [Select Id, PartnerId__r.Contact.AccountId From Scenario__c Where Id in: newScenarioMap.keySet()];
        System.debug('Scenario List =' +scenarioList);
        System.debug('New Scenario Map = '+newScenarioMap);
        
        for(Scenario__c scenario : scenarioList) {
            accountIdSet.add(scenario.PartnerId__r.Contact.AccountId);
        }
        
        List<Scenario__c> accountScenarioList = [Select Id, PartnerId__r.Contact.AccountId From Scenario__c Where PartnerId__r.Contact.AccountId in:accountIdSet];
        Map<Id,List<Scenario__c>> accountScenarioMap = new Map<Id,List<Scenario__c>>();
        
        for(Scenario__c scenario : accountScenarioList) {
            if(accountScenarioMap.containsKey(scenario.PartnerId__r.Contact.AccountId)) {
                accountScenarioMap.get(scenario.PartnerId__r.Contact.AccountId).add(scenario);
            }else {
                accountScenarioMap.put(scenario.PartnerId__r.Contact.AccountId, new List<Scenario__c>{scenario});
            }
        }
        
        for(Scenario__c scenario : scenarioList ) {
            if(accountScenarioMap.containsKey(scenario.PartnerId__r.Contact.AccountId)) {
                List<Scenario__c> accScenarioList = accountScenarioMap.get(scenario.PartnerId__r.Contact.AccountId);
                if(scenario.PartnerId__r.Contact.AccountId != Null) {
                    Account partnerAccount = new Account();
                    partnerAccount.Id = scenario.PartnerId__r.Contact.AccountId;
                    partnerAccount.ORMS_Saved_Scenarios__c = accScenarioList.size();
                    partnerAccList.add(partnerAccount);
                }
            }
        }
        //To avoid Duplicate Id
        System.debug('Partner Account List='+partnerAccList);
        Set<Account> accountSet = new Set<Account>(partnerAccList);
        partnerAccList.clear();
        partnerAccList.addAll(accountSet);
        System.debug('Partner Account List='+partnerAccList);        
        try{
            if(partnerAccList.size() > 0) {
                update partnerAccList;
            }
        } catch(Exception ex) {
            System.debug('Exeption Occured'+ex);
        }
    }
}