@IsTest(seeAllData = true)
public class PortalUserActiveStatusControllerTest {
    @isTest static void ActiveStatus() {
        Contact contactdat = new Contact();
            contactdat=[select id from contact where isdeleted=:false limit 1];
        /*Contact contact = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other',
            Email = 'Sam@gmail.com',
            Contact_NMLS__c = '12345',
            Source_Name__c='Michael',
            UserName__c = 'Test_Name@samply.com'
        );
        insert contact;  */
        Test.startTest();
        Apexpages.StandardController stdController = new Apexpages.StandardController(contactdat); 
        PortalUserActiveStatusController PortalUserActiveStatusControllerObj=new PortalUserActiveStatusController(stdController);
        Test.stopTest();
    }
}