public class ContactFieldPopulator{



    public static void CreateContactFromClient(list<Client__c> Clients){
    
    list<contact> contacts = new list<contact>();
    for(Client__c cli:clients){
        if(cli.Primary_Client_for_the_Loan__c){
            Contact c = new Contact();
            c.Firstname = cli.First_Name__c;
            c.LastName= cli.Last_Name__c;
          //  c.Last_Name__c = 
          user u =  [select contactId,contact.AccountId from user where id=:userinfo.getuserId()];
          c.AccountId = u.contact.AccountId;
          c.Loan_Officer__c = u.contactId;
          c.MailingStreet = cli.Street_Address__c;
          c.MailingCity = cli.City__c;
          c.MailingState = cli.State__c;
          c.MailingPostalcode = cli.Zip__c;
          c.email = cli.Email_Optional__c;
          c.recordtypeid =   Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Client Portal User').getRecordTypeId();
  
            contacts.add(c);
        
        }
    
    }
    
    if(!contacts.isEmpty()){
    
        insert contacts ;
    }
    
    
    }
}