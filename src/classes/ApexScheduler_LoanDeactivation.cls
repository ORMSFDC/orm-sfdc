global class ApexScheduler_LoanDeactivation Implements Schedulable 
{
 global void execute(SchedulableContext sc)
    {
     	DeactivateLoanController DC=new DeactivateLoanController();
        Id batchId = Database.executeBatch(DC,100);
           
    }
}