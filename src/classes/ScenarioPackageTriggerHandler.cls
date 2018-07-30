/** * File Name   : ScenarioPackageTriggerHandler.apxc
*     Description : Updating 'ORMS_Scenario_Packages__c' 
*					field in Business Partner inthe backend
*     Created     : 11/23/2017
*   * @author     : prsn
* */
public class ScenarioPackageTriggerHandler {
    public static void updateScenarioPackagePartnerFields(Map<Id, ClientInfo__c> newScenarioPackageMap) {
        Set<Id> accountIdSet = new Set<Id>();
        List<Account> partnerAccList = new List<Account>();
        List<ClientInfo__c> scenarioPackageList = [Select Id, PartnerId__r.Contact.AccountId From ClientInfo__c Where Id in: newScenarioPackageMap.keySet()];
        
        for(ClientInfo__c scenariopackage : scenarioPackageList) {
            accountIdSet.add(scenariopackage.PartnerId__r.Contact.AccountId);
        }
        
        List<ClientInfo__c> accountScenarioPackageList = [Select Id, PartnerId__r.Contact.AccountId From ClientInfo__c Where PartnerId__r.Contact.AccountId in:accountIdSet];
        Map<Id,List<ClientInfo__c>> accountScenarioPackageMap = new Map<Id,List<ClientInfo__c>>();
        
        for(ClientInfo__c scenarioPackage : accountScenariopackageList) {
            if(accountScenarioPackageMap.containsKey(scenarioPackage.PartnerId__r.Contact.AccountId)) {
                accountScenarioPackageMap.get(scenarioPackage.PartnerId__r.Contact.AccountId).add(scenarioPackage);
            }else {
                accountScenarioPackageMap.put(scenariopackage.PartnerId__r.Contact.AccountId, new List<ClientInfo__c>{scenarioPackage});
            }
        }
        for(ClientInfo__c scenarioPackage : scenarioPackageList ) {
            if(accountScenariopackageMap.containsKey(scenarioPackage.PartnerId__r.Contact.AccountId)) {
                List<ClientInfo__c> accScenarioPackageList = accountScenarioPackageMap.get(scenarioPackage.PartnerId__r.Contact.AccountId);
                if(scenarioPackage.PartnerId__r.Contact.AccountId != Null) {
                Account partnerAccount = new Account();
                partnerAccount.Id = scenarioPackage.PartnerId__r.Contact.AccountId;
                partnerAccount.ORMS_Scenario_Packages__c = accScenarioPackageList.size();
                partnerAccList.add(partnerAccount);
                    }
            }
        }
        //To Avoid Duplicate Id
        Set<Account> accountSet = new Set<Account>(partnerAccList);
        partnerAccList.clear();
        partnerAccList.addAll(accountSet);
        try{
            if(partnerAccList.size() > 0) {
                update partnerAccList;
            }
        } catch(Exception ex) {
            System.debug('Exeption Occured'+ex);
        }
    }
    
}