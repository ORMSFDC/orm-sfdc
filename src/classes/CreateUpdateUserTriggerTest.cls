@isTest
public class CreateUpdateUserTriggerTest {

     @isTest
    public static void setUpData() {
        Id ApprovedRecortypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Approved Partners').getRecordTypeId();
       
        Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            Main_Phone__c='5414147852',
            Company_NMLS_ID__c = '1234',
            recordtypeid=ApprovedRecortypeId,
            Partner_Lead_Status__c='New');
        insert portalAccount;
        
       // Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Individual Leads').getRecordTypeId();
       Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
       
        Contact contact = new Contact(
            //username__c='ghfhagsd@hjgsd.com.org',
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other', 
            Email = 'Sam@gmail.com',
            Contact_NMLS__c = '12345',
            Source_Name__c='Michael',
            AccountId = portalAccount.Id,
        recordTypeId = RecortypeId);
        insert contact; 
         
        
       // Id RecortypeId1 = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Approved Individuals').getRecordTypeId();
        Id RecortypeId1 = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Partner Portal User').getRecordTypeId();
       
        Contact contact1 = new Contact(
            id = contact.Id,
        recordTypeId = RecortypeId1); 
            Update contact1;
        
        /*Test.startTest();
        CreateNewPortalUser.createUser(contact);
        CreateNewPortalUser.ActiveUser(contact1);
        Test.stopTest();*/
        Test.startTest();
        CreateNewPortalUser.createPortalUser(contact);
        CreateNewPortalUser.IsUserActive(contact.id);
        CreateNewPortalUser.MailtoORMOnOtherError('test','test');
        CreateNewPortalUser.UpdateUser(userinfo.getuserid());
        try{
        CreateNewPortalUser.UpdateProfile(userinfo.getuserid());
        }catch(exception ex){}
        
        CreateNewPortalUser.MailToORMWhenNoLicense('test','test');
        Test.stopTest();
    }
    
}