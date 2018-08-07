/**
 * @description: For sending Hot Transfer emails
 * @author: Sahitya
 * @date: 1/17/2018
 *
 * changelog:
 * 08/06/2018: Sahitya - Eliminated email from Bcc
 */
 
global class SendContactEmail implements Database.batchable<sObject> , Database.Stateful{

    private EmailTemplate emailTemp;
    global SendContactEmail(){
        emailTemp = [Select Id From EmailTemplate Where Name = 'Lead & Contact Template']; 
    }

    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select Id, Lastname, Firstname, Email From Contact WHERE (Id IN (select Ql_Banker__c from Lead WHERE RecordType.Name = \'Banker\' ) AND RecordType.Name = \'Banker\')'; 
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext bc, List<Contact> scope){
        system.debug('emailTemp 1------'+emailTemp);
        try{
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Contact con : scope) {
             if(emailTemp != null && con.Email != null && con.Email != '') {
                   Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                   email.setToAddresses(new List<String>{con.Email});
                   email.setTargetObjectId(con.Id);                     
                   email.setTemplateId(emailTemp.Id);
                   email.setTreatTargetObjectAsRecipient(true);        
                   emails.add(email);
                   system.debug('email------'+email);
             }  
         }
         Messaging.sendEmail(emails);
         }
         catch(exception ex){
             system.debug('Contact Email Exception'+ex);
         }
    }
   
    global void finish(Database.BatchableContext bc){}
}