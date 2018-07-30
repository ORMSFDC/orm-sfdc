global class ApexScheduler_UserDeactivation Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
     DeactivateUserController DC=new DeactivateUserController();
        dc.DeactivateUser();       
    }
    
   
}