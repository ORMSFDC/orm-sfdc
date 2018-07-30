public class accountActivity{
    public Id accountId {get;set;}
    
    public Integer getAllActivities(){
        Integer taskCount = 0;
        Integer eventCount = 0;
        taskCount = [SELECT count() FROM Task WHERE Subject != Null AND (CreatedBy.Name = 'Josh Evink' OR CreatedBy.Name = 'Joe Rizzo' OR CreatedBy.Name = 'Raymond Kangas') ];
        eventCount = [SELECT count() FROM Event WHERE Subject != Null AND (CreatedBy.Name = 'Josh Evink' OR CreatedBy.Name = 'Joe Rizzo' OR CreatedBy.Name = 'Raymond Kangas') ];
        system.debug('all activities' +taskCount);    
        return (taskCount + eventCount);
    }
    
    
    public Integer getlast7DaysActivities() {
        
        Integer taskCount = 0;
        Integer eventCount = 0;
        taskCount = [SELECT count() FROM Task WHERE Subject != Null AND CreatedDate = LAST_WEEK AND (CreatedBy.Name = 'Josh Evink' OR CreatedBy.Name = 'Joe Rizzo' OR CreatedBy.Name = 'Raymond Kangas')];
        eventCount = [SELECT count() FROM Event WHERE Subject != Null AND CreatedDate = LAST_WEEK AND (CreatedBy.Name = 'Josh Evink' OR CreatedBy.Name = 'Joe Rizzo' OR CreatedBy.Name = 'Raymond Kangas')];
        return (taskCount + eventCount);
    }
    public Integer getlast30DaysActivities() {
        
        Integer taskCount = 0;
        Integer eventCount = 0;
        taskCount = [SELECT count() FROM Task WHERE Subject != Null AND CreatedDate = THIS_MONTH AND (CreatedBy.Name = 'Josh Evink' OR CreatedBy.Name = 'Joe Rizzo' OR CreatedBy.Name = 'Raymond Kangas')];
        eventCount = [SELECT count() FROM Event WHERE Subject != Null AND CreatedDate = THIS_MONTH AND (CreatedBy.Name = 'Josh Evink' OR CreatedBy.Name = 'Joe Rizzo' OR CreatedBy.Name = 'Raymond Kangas')];
        return (taskCount + eventCount);
    }      
}