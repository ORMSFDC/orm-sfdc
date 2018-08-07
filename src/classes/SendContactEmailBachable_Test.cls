/**
 * @description: For sending Hot Transfer emails
 * @author: Sahitya
 * @date: 1/17/2018
 *
 */
@istest(SeeAllData=true)
class SendContactEmailBachable_Test{

   static testmethod void test() {                       
        Contact con = new Contact();            
        con.Lastname = 'testing1';
        con.Email = 'balasahityadeekonda@quickenloans1.com';
        con.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Banker').getRecordTypeId();                        
        con.Office_Phone__c = '1234567899';
        con.title__c = 'QL Banker';
        insert con; 

        System.Test.startTest();
        // batch test job
        Id batchJobId = Database.executeBatch(new SendContactEmail(), 200);  
        System.assertEquals(con.LastName, 'testing1');          
        System.Test.stopTest();
   }   
}