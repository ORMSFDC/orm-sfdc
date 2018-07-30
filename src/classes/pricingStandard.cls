global class pricingStandard implements Database.batchable<sObject> , Database.Stateful{

    private EmailTemplate emailTemp;
    global pricingStandard(){
        emailTemp = [Select Id From EmailTemplate Where Name = 'ORMS Standard Pricing']; 
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id, Lastname, Firstname, Email From Contact WHERE (Account.RecordType.Id = \'01239000000N6dy\' OR Account.RecordType.Id = \'01239000000EGZn\' OR Account.RecordType.Id = \'01239000000EGZo\') AND Account.Premier_partner__c = False AND Account.Name != \'Test Partner\' AND Email != null AND HasOptedOutOfEmail = False';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Contact> scope){           
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
            }       
        }
        Messaging.sendEmail(emails); 
         }catch(exception ex){}               
    }   
    global void finish(Database.BatchableContext BC){
    }
}