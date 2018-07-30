@isTest(SeeAllData=False)
public class DisplayTaskControllerTest{

    static testmethod void testTaskFun(){
        
        Task emailTask = new Task();
        emailTask.Type= 'Email';
        emailTask.Subject= 'Email: test';
        emailTask.OwnerId = UserInfo.getUserId();
        emailTask.Status = 'Open';
        insert emailTask;
        
        DisplayTaskController.getTaskList();
        DisplayTaskController.fetchTasks('ActiveDate', true);
        DisplayTaskController.getTaskStatus();
        
        DisplayTaskController.saveTaskStatus(emailTask.Id, 'Open');
    }    
}