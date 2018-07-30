@isTest(SeeAllData=False)
public class DisplayPCSTaskControllerTest{

    static testmethod void testTaskFun(){
        
        Task t = new Task();
        t.Type= 'Email';
        t.Subject= 'A Condition has been added to';
        t.OwnerId = UserInfo.getUserId();
        t.Status = 'Open';
        insert t;        
        
        DisplayPCSTaskController.fetchTasks('ActivityDate', true);
        DisplayPCSTaskController.fetchInitialTasks('ActivityDate', true);
        DisplayPCSTaskController.fetchFinalTasks('ActivityDate', true);
        DisplayPCSTaskController.fetchPriorityTasks('ActivityDate', true);
        DisplayPCSTaskController.fetchDocTasks('ActivityDate', true);
        DisplayPCSTaskController.fetchNotesTasks('ActivityDate', true);
        DisplayPCSTaskController.fetchConditionTasks('ActivityDate', true);
        DisplayPCSTaskController.fetchAgedTasks('ActivityDate', true);
        
        DisplayPCSTaskController.getTaskStatus();
        DisplayPCSTaskController.getInitialTaskStatus();
        DisplayPCSTaskController.getFinalTaskStatus();
        DisplayPCSTaskController.getPriorityTaskStatus();
        DisplayPCSTaskController.getDocTaskStatus();
        DisplayPCSTaskController.getNotesTaskStatus();
        DisplayPCSTaskController.getConditionTaskStatus();
        DisplayPCSTaskController.getAgedTaskStatus();        
        
        DisplayPCSTaskController.saveTaskStatus(t.Id, 'Open');
        DisplayPCSTaskController.saveInitialTaskStatus(t.Id, 'Open');
        DisplayPCSTaskController.saveFinalTaskStatus(t.Id, 'Open');
        DisplayPCSTaskController.savePriorityTaskStatus(t.Id, 'Open');
        DisplayPCSTaskController.saveDocTaskStatus(t.Id, 'Open');
        DisplayPCSTaskController.saveNotesTaskStatus(t.Id, 'Open');
        DisplayPCSTaskController.saveConditionTaskStatus(t.Id, 'Open');
        DisplayPCSTaskController.saveAgedTaskStatus(t.Id, 'Open');
        
        DisplayPCSTaskController.saveTaskStatus2(t.Id, 'Open');
        DisplayPCSTaskController.saveInitialTaskStatus2(t.Id, 'Open');
        DisplayPCSTaskController.saveFinalTaskStatus2(t.Id, 'Open');
        DisplayPCSTaskController.savePriorityTaskStatus2(t.Id, 'Open');
        DisplayPCSTaskController.saveDocTaskStatus2(t.Id, 'Open');
        DisplayPCSTaskController.saveNotesTaskStatus2(t.Id, 'Open');
        DisplayPCSTaskController.saveConditionTaskStatus2(t.Id, 'Open');
        DisplayPCSTaskController.saveAgedTaskStatus2(t.Id, 'Open');        
        
    }
    
}