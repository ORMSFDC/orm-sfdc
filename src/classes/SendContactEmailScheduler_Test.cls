@istest(SeeAllData=false)
class SendContactEmailScheduler_Test{

   static testmethod void test() {
        System.Test.startTest();
            Contact con = new Contact();
            con.Lastname = 'testing';
            con.Email = 'balasahityadeekonda@quickenloans.com';
          // con.recordtypeId = '012290000004a86';
            con.recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Banker').getRecordTypeId();
   
            con.Office_Phone__c = '1234567899';
            con.Title__c = 'QL Banker';
            insert con;


            // Schedule the test job
            SendContactEmailScheduler sh1 = new SendContactEmailScheduler ();
            String sch = '0 0 23 * * ?'; 
            system.schedule('SendContactEmailScheduler_test', sch, sh1); 

           // System.assertNullEquals(0, jobId);
            SendContactEmail sc =  new SendContactEmail();
       Database.executeBatch(sc, 200);
       sc.execute(null,[select id,Email from contact ]);

       System.Test.stopTest();
       
     
   }
}