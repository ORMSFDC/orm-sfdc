@isTest
private class CTIRequestDataTest{
    
    static testMethod void test() {
        
        CTIRequestData CRD=new CTIRequestData();
        CRD.AssignedTo='Admin User ';
        CRD.Duedate=Date.today();
        CRD.Subject='Test1';
        CRD.QLPropCategories='Technology';
        CRD.QLPropSubCategories='QLOS';
        CRD.Comments='Test';
        CRD.SubjectType='Call';
        
        CRD.CreateFollowUp_Task ='YES';
        CRD.FollowUp_AssignedTo='Admin User ';
        CRD.FollowUp_DueDate=Date.today();
        CRD.FollowUp_Subject='Test1';
        CRD.FollowUp_Status='Not Started';
        CRD.FollowUp_Comments='Test';
        CRD.FollowUp_Reminder=True;
        CRD.FollowUp_ReminderDatetime=Date.today()+5;
        CRD.FollowUp_Notes= 'Test'; 
    }
    
    
}