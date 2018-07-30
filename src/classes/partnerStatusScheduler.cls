/**This class is used to schedule a Daily Partner status email**/

public class partnerStatusScheduler implements Schedulable {
    public void execute(SchedulableContext  context) {
        Messaging.sendEmail(generateEmails());
    }
    
    public List<Messaging.SingleEmailMessage> generateEmails() {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemp= [Select Id From EmailTemplate Where Name = 'PartnerStatusReport']; //soql query on template
        Contact contactTemp= [Select Id From Contact Where Lastname = 'testing' Limit 1]; //create a Business Individual in Production with Name: PartnerScheduler
        
            
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String> { 'greggsmith@onereverse.com', 'DannyMcGuffin@onereverse.com' }); //List of recepient Emails for Daily Report
        email.setTargetObjectId(contactTemp.Id); 
        email.setTemplateId(emailTemp.Id);
        email.setTreatTargetObjectAsRecipient(true);        
        emails.add(email);
        
        return emails;
    }
}