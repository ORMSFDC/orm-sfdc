public class pricingWholesaleScheduler implements Schedulable {
    public void execute(SchedulableContext  context) {
        Id batchJobId = Database.executeBatch(new pricingWholesale(), 200);
    }    
}