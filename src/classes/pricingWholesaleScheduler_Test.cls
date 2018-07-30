@istest
class pricingWholesaleScheduler_Test{

   static testmethod void test() {
        System.Test.startTest();              
            
            Account a = new Account();
            a.Name = 'pricingwholesale';
            a.Company_NMLS_ID__c = '55555';            
            a.recordtypeId = '01239000000EGZp';
            insert a;
                    
            Contact c = new Contact();
            c.Lastname = 'tewsting12';
            c.Email = 'test2@test2.com';           
            c.Office_Phone__c = '1224577899';
            c.Contact_NMLS__c = '998233';
            c.title__c = 'Processor';
            c.recordtypeId = '01239000000N6e1';
            insert c;

            // Schedule the test job
            pricingWholesaleScheduler pw1 = new pricingWholesaleScheduler();
            String pws = '0 0 23 * * ?'; 
            system.schedule('pricingWholesaleScheduler', pws, pw1); 
            
            pricingWholesale pw =  new pricingWholesale();
            try{
            Database.executeBatch(pw, 200);}catch(Exception ex){}
            pw.execute(null,[select id,Email from contact ]);
       System.Test.stopTest();
    }
}