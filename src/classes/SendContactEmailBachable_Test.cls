@istest(SeeAllData=true)
class SendContactEmailBachable_Test{

   static testmethod void test() {
        System.Test.startTest();
            Contact con = new Contact();
            con.Lastname = 'testing1';
            con.Email = 'balasahityadeekonda@quickenloans1.com';
            //con.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Banker').getRecordTypeId();
            con.recordtypeId = '01239000000EGVH';
            con.Office_Phone__c = '1234567899';
            con.title__c = 'QL Banker';
            insert con;


            // batch test job
            Id batchJobId = Database.executeBatch(new SendContactEmail(), 200);

           // System.assertNullEquals(0, jobId);
       System.Test.stopTest();

   }
}