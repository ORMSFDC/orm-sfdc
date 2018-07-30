@isTest()
private class ContactController_test {

    static testMethod void mainTest() {
    
    Contact c = new contact();
    c.firstname = 'test';
    c.LastName = 'last';
    c.email = 'test@gmail.com';
    c.Office_Phone__c = '1111111111';
    c.title__c = 'QL Banker';
    c.recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Banker').getRecordTypeId();
    insert c;
    
    Lead l = new Lead();
    l.lastName = 'asd';
    l.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Banker').getRecordTypeId();    
    l.QL_banker__c  = c.id;        
    l.transfer_date__c = Date.newInstance(2016, 12, 9);
    l.Company = 'QL';
    l.Status = 'New';
    
    insert l;
    
    ContactController classObject = new ContactController();
    List<Lead> leadlist = new  List<Lead>();
    List<Lead> leadList3 = new List<Lead>(); 
    classObject.contactId = c.Id;
    
    leadlist=  classObject.getleads();
    leadlist= classObject.getleads2();
    leadlist= classObject.getleads3();
    Integer transfer = classObject.getTransfer();
    Integer closed = classObject.getClosed();
    Integer folder = classObject.getFolder();
    Integer money = classObject.getClosedMoney();
    Integer transfer2 = classObject.getTransfer2();
    Integer closed2 = classObject.getClosed2();
    Integer folder2 = classObject.getFolder2();
    Integer money2 = classObject.getClosedMoney2();    
    ContactController.recordWrapper wrapper = new ContactController.recordWrapper(c.id); //to test wrapper class
        
    }
}