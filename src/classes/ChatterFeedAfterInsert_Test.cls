@isTest
public class ChatterFeedAfterInsert_Test {
  static testMethod void unitTestInsert() {
        Account acc = new Account(Name = 'Test');
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Accountid = acc.Id  ;
        opp.Name = 'test';
        opp.StageName = 'Closed';
        opp.CloseDate = system.today();
        insert opp;
        FeedItem feed = new FeedItem (
          parentid = opp.id,
            type = 'ContentPost',
            Body = 'Hello'
        );
        insert feed;
    }
    
    static testMethod void unitTestAccInsert() {
        Account acc = new Account(Name = 'Test');
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Accountid = acc.Id  ;
        opp.Name = 'test';
        opp.StageName = 'Closed';
        opp.CloseDate = system.today();
        insert opp;
        
        FeedItem feed = new FeedItem (
          parentid = acc.id,
            type = 'ContentPost',
            Body = 'Hello'
        );
        insert feed;
    }
}