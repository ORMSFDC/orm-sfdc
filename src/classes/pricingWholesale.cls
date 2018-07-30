global class pricingWholesale implements Database.batchable<sObject> , Database.Stateful{

    private EmailTemplate emailTemp;    
    global pricingWholesale(){
        emailTemp = [Select Id From EmailTemplate Where Name = 'ORMS Wholesale Pricing']; 
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id, Lastname, Firstname, Email From Contact WHERE Account.Premier_partner__c = True AND Account.Name != \'Test Partner\' AND Email != null AND HasOptedOutOfEmail = False';
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