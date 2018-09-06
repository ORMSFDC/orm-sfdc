@istest
class pricingWholesale_Test{

   static testmethod void test() {
            Account acc = new Account();
            acc.Name='portalAccount';
            acc.Cell__c='1236547410';
            acc.Main_Phone__c='5414147852';
            acc.Company_NMLS_ID__c = '12565634';
            acc.Premier_partner__c = true;
            insert acc;
            
            Contact con = new Contact();
            con.Lastname = 'testting2';
            con.Email = 'testtt@test2.com';           
            con.Office_Phone__c = '1923456789';
            con.title__c = 'Processor';
            con.AccountId= acc.Id;
            con.HasOptedOutOfEmail  = false;
            insert con;

            // batch test job
            System.Test.startTest();
                Id batchJobId = Database.executeBatch(new pricingWholesale(), 1);
           System.Test.stopTest();
   }
}