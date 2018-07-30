global class ApexScheduler_PipelineLoanDeactivation Implements Schedulable {

    global void execute(SchedulableContext sc)
    {
     DeactivatePipelineLoan DC=new DeactivatePipelineLoan();
        Id batchId = Database.executeBatch(DC,100);
           
    }
}