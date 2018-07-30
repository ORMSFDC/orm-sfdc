@istest(SeeAllData=true)
class pricingWholesale_Test{

   static testmethod void test() {
        System.Test.startTest();
            Contact con = new Contact();
            con.Lastname = 'testting2';
            con.Email = 'testtt@test2.com';           
            con.Office_Phone__c = '1923456789';
            con.title__c = 'Processor';
            insert con;

            // batch test job
            
            Id batchJobId = Database.executeBatch(new pricingWholesale(), 200);
        
       System.Test.stopTest();
   }
}

/*@isTest
private class pricingWholesale_Test{
    static testmethod void test(){
    
    String query = 'SELECT id, Name FROM Contact' + 'Where Id NOT IN (Select Id, Lastname, Firstname, Email From Contact WHERE Account.Premier_partner__c = True AND Account.Name != \'Test Partner\' AND Email != null AND HasOptedOutOfEmail = False)';
    Contact c = new Contact();
        c.Lastname = 'testing1';
        c.Email = 'testing99@test.com';           
        c.Office_Phone__c = '1234567899';
        c.Contact_NMLS__c = '99852';
        c.title__c = 'Processor';
        c.recordtypeId = '01239000000N6e1';
        insert c;
    
    contact[] con = new List<contact>(); 
    for(Integer i=0;i<0;i++){           
    contact co = new Contact(Lastname = 'testing1' +i,Email = 'testing99@test.com',Office_Phone__c = '1234567899',Contact_NMLS__c = '99852',title__c = 'Processor',recordtypeId = '01239000000N6e1');
    con.add(co);
    }
    insert con;
    
    Test.startTest();        
        Database.executeBatch(new pricingWholesale(), 200);
    Test.stopTest();
    
    Integer i = [Select COUNT() from Contact];
    system.assertEquals(i,1);        
    }
}*/