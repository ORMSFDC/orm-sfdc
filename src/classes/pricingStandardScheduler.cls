public class pricingStandardScheduler implements Schedulable {
    public void execute(SchedulableContext  context) {
        Id batchJobId = Database.executeBatch(new pricingStandard(), 200);
    }    
}