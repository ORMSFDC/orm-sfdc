public class CTIRequestData {
    public String AssignedTo{get;set;}
    public Date Duedate{get;set;}
    public String Subject{get;set;}
     public String SubjectType{get;set;}
    public String QLPropCategories{get;set;}
    public String QLPropSubCategories{get;set;}
    public String Comments{get;set;}
    
    public String CreateFollowUp_Task{get;set;} 
    public String FollowUp_AssignedTo{get;set;}
    public Date FollowUp_DueDate{get;set;}
    public String FollowUp_Subject{get;set;}
    public String FollowUp_Status{get;set;}
    public String FollowUp_Comments{get;set;}
    public boolean FollowUp_Reminder{get;set;}
    public Datetime FollowUp_ReminderDatetime{get;set;}
    public String FollowUp_Notes{get;set;}  
}