@IsTest
public with Sharing class CTIServiceProviderHelperControllerTest {

    @IsTest public static void IsStandardObjectTest(){
        Task objTask=new Task(TaskSubtype='Task',Status = 'Open',Priority = 'Normal',ActivityDate=System.today());
        insert objTask;
        Test.startTest();
        Boolean ReturnValue = CTIServiceProviderHelperController.IsStandardObject('Account');
        CTIServiceProviderHelperController.MakeTask();
        CTIServiceProviderHelperController.MakeFollowUpTask();
        List<String> ReturnTest = CTIServiceProviderHelperController.getselectOptions(objTask,'Status');
        Test.stopTest();
    }
}