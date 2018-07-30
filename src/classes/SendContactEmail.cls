global class SendContactEmail implements Database.batchable<sObject> , Database.Stateful{

    private EmailTemplate emailTemp;
    global SendContactEmail(){
        emailTemp = [Select Id From EmailTemplate Where Name = 'Lead & Contact Template']; 
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
    //String  con_recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Banker').getRecordTypeId(); 
    //String  led_recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Banker').getRecordTypeId();    
        
        String query = 'Select Id, Lastname, Firstname, Email From Contact WHERE (Id IN (select Ql_Banker__c from Lead WHERE RecordTypeId = \'01239000000EGVI\' ) AND RecordTypeId = \'01239000000EGVH\'  )'; //QL_Banker__c field is reference to contact object
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        system.debug('emailTemp 1------'+emailTemp);
        try{
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Contact con : scope) {
             if(emailTemp != null && con.Email != null && con.Email != '') {
                   Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                   email.setToAddresses(new List<String>{con.Email}); //List of recepient Emails to whom email will be sent all contacts who has atleast one or more lead records
                   email.setTargetObjectId(con.Id); 
                   email.setBccAddresses(new String[] {
                       'balasahityadeekonda@quickenloans.com'
                   }); 
                   email.setTemplateId(emailTemp.Id);
                   email.setTreatTargetObjectAsRecipient(true);        
                   emails.add(email);
                   system.debug('email------'+email);
             }  
         }
         Messaging.sendEmail(emails);
         }
         catch(exception ex){
         
         }
    }
   
    global void finish(Database.BatchableContext BC){
    }
}