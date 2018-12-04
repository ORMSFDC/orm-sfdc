/**
 * @description: used for posting chatter activity on related acc from Opportunity and vice versa   
 * @author: Sahitya
 * @date: 04/17/2017
 *
 * changelog:
 * 12/04/2018: Sahitya - SFDC-613  
 */
trigger ChatterFeedAfterInsert on FeedItem (after insert) {
  Set<Id> parentIdSet = new Set<Id>();
    List<Opportunity> oppList = new List<Opportunity>();
    Map<Id, List<FeedItem>> parentToFeedMap = new Map<Id, List<FeedItem>>();
    List<Account> accList = new List<Account>();
    
    if(RecursiveTriggerHandler.isFirstTime){
        RecursiveTriggerHandler.isFirstTime = false;
    
        system.debug('------------');
        set<Id> accIdSet = new set<Id>();
        For(FeedItem item : Trigger.New) {
            parentIdSet.add(item.ParentId);
            if (parentToFeedMap.containsKey(item.ParentId)){
          parentToFeedMap.get(item.ParentId).add(item);
            } else {
                parentToFeedMap.put(item.ParentId, new  List<FeedItem> { item });
            }
        }
        system.debug('------------'+parentIdSet);
        List<FeedItem> itemInsertList=  new List<FeedItem>();
        
        oppList = [Select id, AccountId From Opportunity Where Id In :parentIdSet];
        system.debug('------------'+oppList);
        // SFDC-613
        accList = [select id, (select id, name from Opportunities Where Recordtype.Name = 'Partner Onboarding') from account Where Id In :parentIdSet];
        system.debug('------------'+accList);
        
        for(Account a : accList){
            for(Opportunity op : a.Opportunities){
                List<FeedItem> itemList=  new List<FeedItem>();
                if (parentToFeedMap.containsKey(a.Id)){
              itemList = parentToFeedMap.get(a.Id);
                    For(FeedItem fitem : itemList) {
                        FeedItem newItem = new FeedItem();
                        newItem = fitem.clone(false, true, false, false);
                        newItem.ParentId = op.Id;
                        itemInsertList.add(newItem);
                    }
                }
            }
        }
        
        For(Opportunity opp : oppList) {
            List<FeedItem> itemList=  new List<FeedItem>();
            if (parentToFeedMap.containsKey(opp.Id)){
          itemList = parentToFeedMap.get(opp.Id);
                For(FeedItem fitem : itemList) {
                    FeedItem newItem = new FeedItem();
                    newItem = fitem.clone(false, true, false, false);
                    newItem.ParentId = opp.AccountId;
                    itemInsertList.add(newItem);
                }
            }
        }
        if(itemInsertList.size() > 0) {
            insert itemInsertList;
        }
    }
}
