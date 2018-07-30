@istest(SeeAllData=true)

class partnerStatusScheduler_Test{
   static testmethod void test(){
        System.Test.startTest();    
        
            Account a = new Account();
            a.Name = 'Test';
            a.partner_lead_status__c = 'New';
            a.Company_NMLS_ID__c = '12345';            
            insert a;
        
            Contact con = new Contact();
            con.Lastname = 'testing';
            con.email = 'sahitya.linga@hotmail.com';
            con.title__c = 'Loan Officer';
            con.username__c = 'sahitya.linga@hotmail.com';
            con.Office_Phone__c = '9999999999';
            con.cell__c = '9999999999';                  
            insert con;
                 
            partnerStatusScheduler sh1 = new partnerStatusScheduler();
            String sch = '0 0 23 * * ?'; 
            system.schedule('partnerStatusScheduler', sch, sh1); 
       
       System.Test.stopTest();
   }
}