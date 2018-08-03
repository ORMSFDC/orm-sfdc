trigger DailyProductRateTrigger on Daily_Product_Rate__c (after insert) {
    for (Daily_Product_Rate__c pr : Trigger.New) {
        system.debug('Daily Product rate trigger invoked for ID ' + pr.Id);
        String json = JSON.serialize(pr);
        system.debug('invoking DailyProductRateUpdateCallout.makeCallout()');
        DailyProductRateUpdateCallout.makeCallout(json);
    }
}