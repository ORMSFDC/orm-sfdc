/****Created this class to schedule Job for SendContactEmail batchable class******/

public class SendContactEmailScheduler implements Schedulable {
    public void execute(SchedulableContext  context) {
        Id batchJobId = Database.executeBatch(new SendContactEmail(), 200);
    }    
}