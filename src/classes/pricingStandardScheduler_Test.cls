@istest
class pricingStandardScheduler_Test{

   static testmethod void test() {
        System.Test.startTest();
            Contact con = new Contact();
            con.Lastname = 'testing1';
            con.Email = 'test@test.com';           
            con.Office_Phone__c = '1234567899';
            con.title__c = 'Processor';
            insert con;

            // Schedule the test job
            
            pricingStandardScheduler ps1 = new pricingStandardScheduler ();
            String pss = '0 0 23 * * ?'; 
            system.schedule('pricingStandardScheduler', pss, ps1); 
            pricingStandard ps =  new pricingStandard();
            try{
            Database.executeBatch(ps, 200);}catch(Exception ex){}
            ps.execute(null,[select id,Email from contact ]);
       System.Test.stopTest();
    }
}