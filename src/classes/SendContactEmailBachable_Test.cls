/**
 * @description: For sending Hot Transfer emails
 * @author: Sahitya
 * @date: 1/17/2018
 *
 */
@istest
class SendContactEmailBachable_Test{
        
   static testmethod void test() {  
   
       Profile p = [select Name from profile where Name = 'System Administrator'];
       
       User u = new User(Alias = 'standt1',Country='United States',Email='demo1@domain.com',EmailEncodingKey='UTF-8', 
                           LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,                               
                           TimeZoneSidKey='America/Los_Angeles', UserName='demo1@test.org');
       insert u;           
           
       system.runas(u){
            List<contact> con1 = new List<Contact>();
            for(Integer i=0 ;i <20;i++){
                Contact con = new Contact();
                con.Lastname = 'testing1'+i;
                con.Email = 'balasahityadeekonda@quickenloans1.com';
                con.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Banker').getRecordTypeId();                        
                con.Office_Phone__c = '1234567899';
                con.title__c = 'QL Banker';            
                con1.add(con);
            }        
            insert con1;
        
            List<Lead> lead1 = new List<Lead>();
            for(Integer j=0 ;j <20;j++){
                Lead l = new Lead();
                l.LastName = 'test';
                l.Company = 'QL';
                l.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Banker').getRecordTypeId();                        
                l.Status = 'New';
                l.Ql_Banker__c = con1[0].Id;
                lead1.add(l);        
            }
            insert lead1;
                      
           System.Test.startTest();
                SendContactEmail obj = new SendContactEmail();
                Id batchJobId = Database.executeBatch(obj, 10);
           System.Test.stopTest();   
       }   
   }   
}